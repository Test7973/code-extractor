# Code Extractor

Extract code from any Git repository into a single text file - perfect for use with LLMs like Gemini, Claude, or GPT.

## What it does

Takes a Git repository URL and creates a single text file containing all the code you select. Perfect for:
- Analyzing code with AI tools
- Getting AI help with code reviews
- Understanding new codebases
- Documentation generation

## Available Versions

- `extractors/powershell/extract.ps1` - PowerShell version
- `extractors/python/extract.py` - Python version
- `extractors/javascript/extract.js` - Node.js version
- `extractors/web/index.html` - Web version (for browsers)

## Quick Start

### PowerShell Version
```powershell
.\extractors\powershell\extract.ps1 -repoUrl "https://github.com/test7973/code-extractor" -outputFile "output.txt"
```

### Python Version
```bash
python extractors/python/extract.py "https://github.com/test7973/code-extractor" "output.txt"
```

### Node.js Version
```bash
node extractors/javascript/extract.js "https://github.com/test7973/code-extractor" "output.txt"
```

### Web Version
Open `extractors/web/index.html` in your browser.

## Using with Gemini

1. Run the extractor to create your output file:
```bash
python extractors/python/extract.py "https://github.com/test7973/code-extractor" "output.txt"
```

2. Upload output.txt to Gemini

3. Ask questions like:
- "Analyze this codebase and explain its structure"
- "What are the main components?"
- "How could this code be improved?"

## How it works

1. You provide a repository URL
2. The tool clones the repo
3. For each file/folder, you choose:
   - `yes` - include this file
   - `no` - skip this file
   - `folder` - include all files in this folder
   - `skip-all` - skip everything else
4. Creates a formatted output file
5. Cleans up the cloned repo

## Need Help?

Open an issue on GitHub if you run into any problems!