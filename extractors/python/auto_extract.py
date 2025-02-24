import os
import subprocess
import shutil
from pathlib import Path
import sys
import fnmatch

class AutoRepoExtractor:
    def __init__(self, repo_url, output_file="output.txt"):
        self.repo_url = repo_url
        self.output_file = output_file
        self.repo_name = repo_url.split('/')[-1].replace('.git', '')
        self.clone_path = Path(os.getcwd()) / self.repo_name
        
        # File patterns to include (code files)
        self.include_patterns = [
            "*.py", "*.js", "*.jsx", "*.ts", "*.tsx", "*.java", "*.c", "*.cpp", "*.h", 
            "*.hpp", "*.cs", "*.go", "*.rb", "*.php", "*.swift", "*.kt", "*.rs", 
            "*.dart", "*.scala", "*.html", "*.css", "*.scss", "*.sql", "*.sh", 
            "*.json", "*.yaml", "*.yml", "*.toml", "*.xml", "Dockerfile", "Makefile"
        ]
        
        # Important context files to always include
        self.context_files = ["README.md", "README", "LICENSE", ".gitignore"]
        
        # Directories to exclude
        self.exclude_dirs = [
            "node_modules", "venv", "env", ".env", ".venv", "dist", "build", "target",
            ".git", "__pycache__", ".idea", ".vscode", "bin", "obj", "out", "coverage",
            "vendor", "deps", "third_party", "assets", "images", "img", "videos", 
            "fonts", "logs", "tmp", "temp"
        ]
        
        # File patterns to exclude
        self.exclude_patterns = [
            "*.min.js", "*.min.css", "*.log", "*.lock", "package-lock.json", 
            "*.png", "*.jpg", "*.jpeg", "*.gif", "*.ico", "*.svg", "*.bmp", 
            "*.ttf", "*.woff", "*.woff2", "*.eot", "*.pdf", "*.zip", "*.tar", 
            "*.gz", "*.rar", "*.exe", "*.dll", "*.so", "*.dylib", "*.jar", "*.war", 
            "*.ear", "*.class", "*.pyc", "*.pyo", "*.o", "*.a", "*.lib", "*.obj"
        ]

    def clone_repository(self):
        """Clone or update the repository."""
        print(f"Starting to process repository: {self.repo_url}")
        
        if not self.clone_path.exists():
            print(f"Cloning repository to: {self.clone_path}")
            result = subprocess.run(['git', 'clone', self.repo_url, str(self.clone_path)], 
                                 capture_output=True, text=True)
        else:
            print(f"Repository already exists at {self.clone_path}. Pulling latest changes.")
            result = subprocess.run(['git', '-C', str(self.clone_path), 'pull', 'origin'],
                                 capture_output=True, text=True)
        
        if result.returncode != 0:
            print("Failed to clone/pull repository:")
            print(result.stderr)
            sys.exit(1)

    def get_relative_path(self, full_path):
        """Get path relative to repository root."""
        return str(Path(full_path).relative_to(self.clone_path))

    def should_include_file(self, file_path):
        """Determine if a file should be included in the output."""
        # Get the file name and relative path
        file_name = file_path.name
        rel_path = self.get_relative_path(file_path)
        
        # Always include important context files from the root directory
        if file_path.parent == self.clone_path and file_name in self.context_files:
            return True
            
        # Check against exclude patterns
        for pattern in self.exclude_patterns:
            if fnmatch.fnmatch(file_name, pattern):
                return False
                
        # Check against include patterns
        for pattern in self.include_patterns:
            if fnmatch.fnmatch(file_name, pattern):
                return True
                
        # If none of the above conditions match, exclude the file
        return False

    def should_include_dir(self, dir_path):
        """Determine if a directory should be processed."""
        dir_name = dir_path.name
        
        # Check if the directory name is in the exclude list
        if dir_name in self.exclude_dirs:
            return False
            
        # Exclude hidden directories (starting with '.')
        if dir_name.startswith('.') and dir_name != '.github':
            return False
            
        return True

    def write_file_content(self, file_path):
        """Write file content to output file with headers."""
        relative_path = self.get_relative_path(file_path)
        
        with open(self.output_file, 'a', encoding='utf-8') as out:
            out.write(f"----------  FILE: {relative_path}  ----------\n")
            
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    out.write(f.read())
            except UnicodeDecodeError:
                print(f"Warning: Could not read {relative_path} as text file")
                out.write("[Binary file - content not included]\n")
            except Exception as e:
                print(f"Error reading {relative_path}: {str(e)}")
                out.write(f"[Error reading file: {str(e)}]\n")
                
            out.write(f"\n----------  END FILE: {relative_path}  ----------\n\n")

    def build_folder_structure(self):
        """Generate a representation of the folder structure."""
        print("Generating folder structure...")
        structure = []
        
        def process_dir(path, indent=0):
            items = sorted(list(path.iterdir()), key=lambda x: (x.is_file(), x.name))
            
            for item in items:
                if item.is_dir():
                    if self.should_include_dir(item):
                        rel_path = self.get_relative_path(item)
                        structure.append("  " * indent + f"📁 {item.name}/")
                        process_dir(item, indent + 1)
                else:
                    if self.should_include_file(item):
                        rel_path = self.get_relative_path(item)
                        structure.append("  " * indent + f"📄 {item.name}")
        
        process_dir(self.clone_path)
        return structure

    def extract_code(self):
        """Extract code files from the repository."""
        # Initialize or clear the output file
        with open(self.output_file, 'w', encoding='utf-8') as out:
            out.write(f"# Code extraction from: {self.repo_url}\n\n")
            
            # Write the folder structure
            out.write("# FOLDER STRUCTURE\n")
            structure = self.build_folder_structure()
            out.write("\n".join(structure))
            out.write("\n\n# FILES\n\n")
        
        file_count = 0
        
        def process_dir(path):
            nonlocal file_count
            
            for item in path.iterdir():
                if item.is_dir():
                    if self.should_include_dir(item):
                        process_dir(item)
                else:
                    if self.should_include_file(item):
                        print(f"Extracting: {self.get_relative_path(item)}")
                        self.write_file_content(item)
                        file_count += 1
        
        process_dir(self.clone_path)
        print(f"Extracted {file_count} files")
        
        # Add a summary at the end of the file
        with open(self.output_file, 'a', encoding='utf-8') as out:
            out.write(f"\n# SUMMARY\n")
            out.write(f"Repository: {self.repo_url}\n")
            out.write(f"Total files extracted: {file_count}\n")

    def cleanup(self):
        """Remove cloned repository."""
        print("Cleaning up cloned repository")
        shutil.rmtree(self.clone_path)

    def run(self):
        """Main execution flow."""
        try:
            self.clone_repository()
            print("Starting automatic code extraction...")
            self.extract_code()
            print(f"Finished. Check '{self.output_file}'")
        finally:
            self.cleanup()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python auto_extract.py <repo_url> [output_file]")
        sys.exit(1)
    
    repo_url = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "code_extract.txt"
    
    extractor = AutoRepoExtractor(repo_url, output_file)
    extractor.run()
