param (
    [string]$repoUrl,
    [string]$outputFile = "output.txt"
)

Write-Host "Starting interactive script to extract code from repository: $repoUrl"

# 1. Determine Repo Name
$repoName = $repoUrl -replace "^.*\/([^/]+)$",'$1'
$repoName = $repoName -replace ".git$",""

# 2. Clone the Repository
$clonePath = "$PSScriptRoot\$repoName"
if (-not (Test-Path $clonePath)) {
    Write-Host "Cloning repository to: $clonePath"
    git clone $repoUrl $clonePath
}
else {
    Write-Host "Repository already cloned to $clonePath. Pulling latest changes."
    git -C $clonePath pull origin
}

if ($LastExitCode -ne 0) {
    Write-Host "Failed to clone the repository, exiting..."
    return
}

# Function to check if the user wants to include a folder or file
function ShouldInclude {
    param (
        [string]$itemPath,
        [string]$itemType
    )

    while ($true) {
        Write-Host "Include this $itemType? (yes/no/folder/skip-all): $itemPath"
        $response = Read-Host
        switch ($response.ToLower()) {
            "yes" { return "yes" }
            "no" { return "no" }
            "folder" { return "folder" }
            "skip-all" {
                Write-Host "Skipping all remaining files and folders"
                $global:skipAll = $true
                return "no"
            }
            default { Write-Host "Invalid response. Please enter 'yes', 'no', 'folder', or 'skip-all'." }
        }
        if ($global:skipAll) {
            return "no"
        }
    }
}

# Function to get relative path from repository root
function Get-RelativePath {
    param (
        [string]$fullPath,
        [string]$basePath
    )
    return $fullPath.Substring($basePath.Length + 1)
}

# 3. Recursively process folders and files
$global:skipAll = $false
function ProcessItems {
    param (
        [string]$path
    )

    if ($global:skipAll) {
        return
    }

    foreach ($item in Get-ChildItem -Path $path -Force) {
        if ($item.PSIsContainer) {  # If it's a directory (folder)
            $response = ShouldInclude -itemPath $item.FullName -itemType "folder"
            switch ($response) {
                "yes" { ProcessItems -path $item.FullName }  # Recursively process the folder
                "folder" { ProcessFolder -path $item.FullName }
                "no" {
                    if (-not $global:skipAll) {
                        Write-Host "Skipping folder: $($item.FullName)"
                    }
                }
            }
        }
        else { # If it's a file
            $response = ShouldInclude -itemPath $item.FullName -itemType "file"
            if ($response -eq "yes") {
                if ($item.FullName -ne $MyInvocation.MyCommand.Definition) {
                    $relativePath = Get-RelativePath -fullPath $item.FullName -basePath $clonePath
                    Write-Host "Appending file content: $relativePath"
                    "----------  FILE: $relativePath  ----------" | Out-File $outputFile -Append -Encoding UTF8
                    Get-Content $item.FullName | Out-File $outputFile -Append -Encoding UTF8
                    "----------  END FILE: $relativePath  ----------" | Out-File $outputFile -Append -Encoding UTF8
                    "" | Out-File $outputFile -Append -Encoding UTF8  # Add blank line between files
                }
            }
            else {
                if (-not $global:skipAll) {
                    Write-Host "Skipping file: $($item.FullName)"
                }
            }
        }
    }
}

function ProcessFolder {
    param (
        [string]$path
    )

    if ($global:skipAll) {
        return
    }
    Write-Host "Processing all files within folder $path"
    foreach ($item in Get-ChildItem -Path $path -Recurse -File -Force) {
        if ($item.FullName -ne $MyInvocation.MyCommand.Definition) {
            $relativePath = Get-RelativePath -fullPath $item.FullName -basePath $clonePath
            Write-Host "Appending file content: $relativePath"
            "----------  FILE: $relativePath  ----------" | Out-File $outputFile -Append -Encoding UTF8
            Get-Content $item.FullName | Out-File $outputFile -Append -Encoding UTF8
            "----------  END FILE: $relativePath  ----------" | Out-File $outputFile -Append -Encoding UTF8
            "" | Out-File $outputFile -Append -Encoding UTF8  # Add blank line between files
        }
    }
}

# Start processing at the root of the cloned repository
Write-Host "Starting interactive file selection..."
ProcessItems -path $clonePath

Write-Host "Finished. Check '$outputFile'."

# 5. Remove cloned directory
Write-Host "Deleting cloned repo"
Remove-Item $clonePath -Recurse -Force
Write-Host "Cleaned up cloned repo"