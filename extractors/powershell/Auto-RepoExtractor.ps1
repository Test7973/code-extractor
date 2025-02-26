# Auto-RepoExtractor.ps1
# PowerShell script to extract code from GitHub repositories into a plain text format for LLMs

# Function to get user input with validation
function Get-UserInput {
    param (
        [string]$prompt,
        [switch]$required
    )
    
    do {
        $input = Read-Host -Prompt $prompt
        if ($required -and [string]::IsNullOrWhiteSpace($input)) {
            Write-Host "This field is required. Please try again." -ForegroundColor Red
            $isValid = $false
        }
        else {
            $isValid = $true
        }
    } while (-not $isValid)
    
    return $input
}

class RepoExtractor {
    [string]$RepoUrl
    [string]$OutputFile
    [string]$RepoName
    [string]$ClonePath
    [string[]]$IncludePatterns
    [string[]]$ContextFiles
    [string[]]$ExcludeDirs
    [string[]]$ExcludePatterns

    RepoExtractor([string]$repoUrl, [string]$outputFile) {
        $this.RepoUrl = $repoUrl
        $this.OutputFile = $outputFile
        $this.RepoName = $repoUrl.Split('/')[-1].Replace('.git', '')
        $this.ClonePath = Join-Path -Path (Get-Location) -ChildPath $this.RepoName

        # File patterns to include (code files) - Including ASP.NET specific extensions
        $this.IncludePatterns = @(
            "*.py", "*.js", "*.jsx", "*.cshtml", "*.razor", "*.ts", "*.tsx", "*.java", "*.c", "*.cpp", "*.h", 
            "*.hpp", "*.cs", "*.go", "*.rb", "*.php", "*.swift", "*.kt", "*.rs", 
            "*.dart", "*.scala", "*.html", "*.css", "*.scss", "*.sql", "*.sh", 
            "*.json", "*.yaml", "*.yml", "*.toml", "*.xml", "Dockerfile", "Makefile",
            "*.csproj", "*.sln", "*.config", "web.config", "app.config", "*.vbhtml",
            "*.aspx", "*.ascx", "*.master", "*.ashx", "*.asax", "*.vb"
        )
        
        # Important context files to always include
        $this.ContextFiles = @("README.md", "README", "LICENSE", ".gitignore", "global.json", "nuget.config")
        
        # Directories to exclude
        $this.ExcludeDirs = @(
            "node_modules", "LICENSE", "venv", "env", ".env", ".venv", "dist", "build", "target",
            ".git", "__pycache__", ".idea", ".vscode", "bin", "obj", "out", "coverage",
            "vendor", "deps", "third_party", "assets", "images", "img", "videos", 
            "fonts", "logs", "tmp", "temp", "packages"
        )
        
        # File patterns to exclude
        $this.ExcludePatterns = @(
            "*.min.js", "*.min.css", "*.log", "*.lock", "package-lock.json", 
            "*.png", "*.jpg", "*.jpeg", "*.gif", "*.ico", "*.svg", "*.bmp", 
            "*.ttf", "*.woff", "*.woff2", "*.eot", "*.pdf", "*.zip", "*.tar", 
            "*.gz", "*.rar", "*.exe", "*.dll", "*.so", "*.dylib", "*.jar", "*.war", 
            "*.ear", "*.class", "*.pyc", "*.pyo", "*.o", "*.a", "*.lib", "*.obj"
        )
    }

    [void] CloneRepository() {
        Write-Host "Starting to process repository: $($this.RepoUrl)" -ForegroundColor Cyan
        
        if (-not (Test-Path -Path $this.ClonePath)) {
            Write-Host "Cloning repository to: $($this.ClonePath)" -ForegroundColor Yellow
            $cloneResult = git clone $this.RepoUrl $this.ClonePath 2>&1
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to clone repository:" -ForegroundColor Red
                Write-Host $cloneResult -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "Repository already exists at $($this.ClonePath). Pulling latest changes." -ForegroundColor Yellow
            Push-Location $this.ClonePath
            $pullResult = git pull origin 2>&1
            Pop-Location
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to pull repository:" -ForegroundColor Red
                Write-Host $pullResult -ForegroundColor Red
                exit 1
            }
        }
    }

    [string] GetRelativePath([string]$fullPath) {
        return $fullPath.Substring($this.ClonePath.Length + 1)
    }

    [bool] ShouldIncludeFile([string]$filePath) {
        $fileName = Split-Path -Path $filePath -Leaf
        $parent = Split-Path -Path $filePath -Parent
        
        # Always include important context files from the root directory
        if ($parent -eq $this.ClonePath -and $this.ContextFiles -contains $fileName) {
            return $true
        }
        
        # Check against exclude patterns
        foreach ($pattern in $this.ExcludePatterns) {
            if ($fileName -like $pattern) {
                return $false
            }
        }
        
        # Check against include patterns
        foreach ($pattern in $this.IncludePatterns) {
            if ($fileName -like $pattern) {
                return $true
            }
        }
        
        # If none of the above conditions match, exclude the file
        return $false
    }

    [bool] ShouldIncludeDir([string]$dirPath) {
        $dirName = Split-Path -Path $dirPath -Leaf
        
        # Check if the directory name is in the exclude list
        if ($this.ExcludeDirs -contains $dirName) {
            return $false
        }
        
        # Exclude hidden directories (starting with '.'), but include .github
        if ($dirName.StartsWith('.') -and $dirName -ne '.github') {
            return $false
        }
        
        return $true
    }

    [void] WriteFileContent([string]$filePath) {
        $relativePath = $this.GetRelativePath($filePath)
        
        Add-Content -Path $this.OutputFile -Value "----------  FILE: $relativePath  ----------" -Encoding UTF8
        
        try {
            $content = Get-Content -Path $filePath -Raw -ErrorAction Stop
            Add-Content -Path $this.OutputFile -Value $content -NoNewline -Encoding UTF8
        } catch {
            if ($_.Exception.Message -like "*Cannot process because the file contains a character that is invalid*") {
                Write-Host "Warning: Could not read $relativePath as text file" -ForegroundColor Yellow
                Add-Content -Path $this.OutputFile -Value "[Binary file - content not included]" -Encoding UTF8
            } else {
                Write-Host "Error reading $relativePath: $($_.Exception.Message)" -ForegroundColor Red
                Add-Content -Path $this.OutputFile -Value "[Error reading file: $($_.Exception.Message)]" -Encoding UTF8
            }
        }
        
        Add-Content -Path $this.OutputFile -Value "`n----------  END FILE: $relativePath  ----------`n" -Encoding UTF8
    }

    [string[]] BuildFolderStructure() {
        Write-Host "Generating folder structure..." -ForegroundColor Cyan
        $structure = @()
        
        function Process-Dir {
            param (
                [string]$path,
                [int]$indent = 0
            )
            
            $items = Get-ChildItem -Path $path | Sort-Object { $_.PSIsContainer }, Name
            
            foreach ($item in $items) {
                if ($item.PSIsContainer) {
                    if ($this.ShouldIncludeDir($item.FullName)) {
                        $structure += "  " * $indent + "📁 $($item.Name)/"
                        Process-Dir -path $item.FullName -indent ($indent + 1)
                    }
                } else {
                    if ($this.ShouldIncludeFile($item.FullName)) {
                        $structure += "  " * $indent + "📄 $($item.Name)"
                    }
                }
            }
            
            return $structure
        }
        
        return Process-Dir -path $this.ClonePath
    }

    [void] ExtractCode() {
        # Initialize or clear the output file
        Set-Content -Path $this.OutputFile -Value "# Code extraction from: $($this.RepoUrl)`n" -Encoding UTF8
        
        # Write the folder structure
        Add-Content -Path $this.OutputFile -Value "# FOLDER STRUCTURE`n" -Encoding UTF8
        $structure = $this.BuildFolderStructure()
        Add-Content -Path $this.OutputFile -Value ($structure -join "`n") -Encoding UTF8
        Add-Content -Path $this.OutputFile -Value "`n`n# FILES`n" -Encoding UTF8
        
        $fileCount = 0
        
        function Process-Dir {
            param (
                [string]$path
            )
            
            $items = Get-ChildItem -Path $path
            
            foreach ($item in $items) {
                if ($item.PSIsContainer) {
                    if ($this.ShouldIncludeDir($item.FullName)) {
                        Process-Dir -path $item.FullName
                    }
                } else {
                    if ($this.ShouldIncludeFile($item.FullName)) {
                        Write-Host "Extracting: $($this.GetRelativePath($item.FullName))" -ForegroundColor Green
                        $this.WriteFileContent($item.FullName)
                        $script:fileCount++
                    }
                }
            }
        }
        
        $script:fileCount = 0
        Process-Dir -path $this.ClonePath
        Write-Host "Extracted $script:fileCount files" -ForegroundColor Cyan
        
        # Add a summary at the end of the file
        Add-Content -Path $this.OutputFile -Value "`n# SUMMARY`n" -Encoding UTF8
        Add-Content -Path $this.OutputFile -Value "Repository: $($this.RepoUrl)" -Encoding UTF8
        Add-Content -Path $this.OutputFile -Value "Total files extracted: $script:fileCount" -Encoding UTF8
        
        # Add note about using with LLMs
        Add-Content -Path $this.OutputFile -Value "`n# LLM USAGE NOTE`n" -Encoding UTF8
        Add-Content -Path $this.OutputFile -Value "This file contains the code structure and content from the repository in a format suitable for ingestion by Large Language Models (LLMs)." -Encoding UTF8
        Add-Content -Path $this.OutputFile -Value "You can use this file as context when prompting an LLM about this codebase." -Encoding UTF8
    }

    [void] Cleanup() {
        Write-Host "Cleaning up cloned repository" -ForegroundColor Yellow
        Remove-Item -Path $this.ClonePath -Recurse -Force -ErrorAction SilentlyContinue
    }

    [void] Run() {
        try {
            $this.CloneRepository()
            Write-Host "Starting automatic code extraction for LLM context..." -ForegroundColor Green
            $this.ExtractCode()
            
            # Get file size and token estimation
            $fileInfo = Get-Item $this.OutputFile
            $fileSizeKB = [math]::Round($fileInfo.Length / 1KB, 2)
            $fileSizeMB = [math]::Round($fileInfo.Length / 1MB, 2)
            $estimatedTokens = [math]::Round($fileInfo.Length / 4, 0)  # Rough estimate: ~4 chars per token
            
            Write-Host "`nExtraction complete! Summary:" -ForegroundColor Cyan
            Write-Host "- Output file: $($this.OutputFile)" -ForegroundColor Green
            Write-Host "- File size: $fileSizeKB KB ($fileSizeMB MB)" -ForegroundColor Green
            Write-Host "- Files extracted: $script:fileCount" -ForegroundColor Green
            Write-Host "- Estimated tokens: $estimatedTokens" -ForegroundColor Green
            Write-Host "`nYou can now use this file as context for LLMs." -ForegroundColor Cyan
        }
        finally {
            $this.Cleanup()
        }
    }
}

# Main script execution
Clear-Host
Write-Host "===== Code Extractor for LLM Context =====" -ForegroundColor Cyan
Write-Host "This script creates a text file from a GitHub repository" -ForegroundColor Cyan
Write-Host "for use as context with Large Language Models" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Check if git is installed
try {
    $gitVersion = git --version
    Write-Host "Git detected: $gitVersion" -ForegroundColor Green
}
catch {
    Write-Host "Git is not installed or not in PATH. Please install Git and try again." -ForegroundColor Red
    exit 1
}

# Get repository URL
$repoUrl = Get-UserInput -prompt "Enter GitHub repository URL (e.g., https://github.com/username/repo)" -required

# Get output file name
$defaultOutput = "llm_context.txt"
$outputFile = Get-UserInput -prompt "Enter output file name (default: $defaultOutput)"

if ([string]::IsNullOrWhiteSpace($outputFile)) {
    $outputFile = $defaultOutput
}

# Create and run the extractor
$extractor = [RepoExtractor]::new($repoUrl, $outputFile)
$extractor.Run()

Write-Host "`nPress any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
