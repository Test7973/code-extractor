import os
import subprocess
import shutil
from pathlib import Path
import sys

class RepoExtractor:
    def __init__(self, repo_url, output_file="output.txt"):
        self.repo_url = repo_url
        self.output_file = output_file
        self.repo_name = repo_url.split('/')[-1].replace('.git', '')
        self.clone_path = Path(os.getcwd()) / self.repo_name
        self.skip_all = False

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

    def should_include(self, item_path, item_type):
        """Ask user whether to include an item."""
        while True and not self.skip_all:
            response = input(f"Include this {item_type}? (yes/no/folder/skip-all): {item_path}\n").lower()
            
            if response in ['yes', 'no', 'folder', 'skip-all']:
                if response == 'skip-all':
                    self.skip_all = True
                    return 'no'
                return response
            
            print("Invalid response. Please enter 'yes', 'no', 'folder', or 'skip-all'.")
        
        return 'no'

    def get_relative_path(self, full_path):
        """Get path relative to repository root."""
        return str(Path(full_path).relative_to(self.clone_path))

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
                
            out.write(f"\n----------  END FILE: {relative_path}  ----------\n\n")

    def process_folder(self, path):
        """Process all files in a folder recursively."""
        if self.skip_all:
            return
            
        print(f"Processing all files within folder {path}")
        for root, _, files in os.walk(path):
            for file in files:
                file_path = Path(root) / file
                if file_path != Path(__file__):
                    print(f"Appending file content: {self.get_relative_path(file_path)}")
                    self.write_file_content(file_path)

    def process_items(self, path):
        """Recursively process folders and files."""
        if self.skip_all:
            return
            
        for item in Path(path).iterdir():
            if item.is_dir():
                response = self.should_include(item, "folder")
                if response == 'yes':
                    self.process_items(item)
                elif response == 'folder':
                    self.process_folder(item)
                elif not self.skip_all:
                    print(f"Skipping folder: {item}")
            else:
                if self.should_include(item, "file") == 'yes' and item != Path(__file__):
                    print(f"Appending file content: {self.get_relative_path(item)}")
                    self.write_file_content(item)
                elif not self.skip_all:
                    print(f"Skipping file: {item}")

    def cleanup(self):
        """Remove cloned repository."""
        print("Cleaning up cloned repository")
        shutil.rmtree(self.clone_path)

    def run(self):
        """Main execution flow."""
        try:
            self.clone_repository()
            print("Starting interactive file selection...")
            self.process_items(self.clone_path)
            print(f"Finished. Check '{self.output_file}'")
        finally:
            self.cleanup()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <repo_url> [output_file]")
        sys.exit(1)
    
    repo_url = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "output.txt"
    
    extractor = RepoExtractor(repo_url, output_file)
    extractor.run()