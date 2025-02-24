**Quick Auto Extraction in Colab:**

```python
# Clone the Code Extractor repository
!git clone https://github.com/Test7973/code-extractor.git
%cd code-extractor

# Run the auto extraction script for fully automated processing
!python3 extractors/python/auto_extract.py "https://github.com/axios/axios.git" "axios_code.txt"

# Download the consolidated code file
from google.colab import files
files.download("axios_code.txt")
```

---

# 🚀 GitHub Code Extractor – Get Your Code AI-Ready in Seconds!

## 🔥 Why Do You Need This?

In the era of AI-driven development, efficiently analyzing entire codebases is crucial. **Code Extractor** streamlines this process by consolidating selected code into a single, structured text file—perfect for AI tools like **GPT, Claude, or Gemini**.

**Use Cases:**

- 🔎 **Project Structure Analysis:** Understand the architecture of new repositories.
- 🛠️ **Code Optimization:** Receive AI-driven suggestions for improvements.
- 📖 **Documentation Generation:** Automatically create comprehensive documentation.
- 🤖 **Debugging and Refactoring:** Leverage AI to identify and fix issues.

---

## ⚡ Key Features

- **Selective Extraction:** Only include files relevant to your analysis.
- **Multi-Platform Support:** PowerShell, Python, Node.js, and a web version.
- **AI-Friendly Output:** Produces a clean, consolidated text file for seamless AI ingestion.

---

## 📌 Supported Versions

- 🖥️ **PowerShell:** `extractors/powershell/extract.ps1`
- 🐍 **Python (Manual Extraction):** `extractors/python/extract.py`
- 🐍 **Python (Auto Repo Extractor):** `extractors/python/auto_extract.py`
- 🌐 **JavaScript (Node.js):** `extractors/javascript/extract.js`
- 🌎 **Web Browser:** `extractors/web/index.html` (*currently in development*)

---

## 🚀 Quick Start Guide

### 🏁 Step 1: Clone the Code Extractor Repository

```bash
git clone https://github.com/Test7973/code-extractor.git
cd code-extractor
```

### 💻 Step 2: Run Your Preferred Version

#### **🔹 Windows (PowerShell)**

Open PowerShell and execute:

```powershell
.\extractors\powershell\extract.ps1 -repoUrl "https://github.com/axios/axios.git" -outputFile "axios_code.txt"
```

#### **🐧 Linux / macOS (Python Manual Extraction)**

In your terminal, run:

```bash
python3 extractors/python/extract.py "https://github.com/axios/axios.git" "axios_code.txt"
```

#### **🐍 Python: Auto Repo Extractor**

This new script automates the entire process: it clones (or updates) the repository, selectively extracts code files based on defined inclusion/exclusion patterns, generates a consolidated output with a detailed folder structure and summary, and cleans up the cloned repository afterward.

**Usage:**

```bash
python3 extractors/python/auto_extract.py "https://github.com/axios/axios.git" "axios_code.txt"
```

*Example:*  
Running the above command processes the axios repository, outputs the consolidated code to `axios_code.txt`, and removes the temporary clone afterward.

#### **🌐 Node.js**

For a JavaScript-based approach:

```bash
node extractors/javascript/extract.js "https://github.com/axios/axios.git" "axios_code.txt"
```

#### **🌟 Google Colab**

You can also leverage Code Extractor in Google Colab. Both the manual and auto extraction methods are supported:

**Manual Extraction in Colab:**

```python
# Clone the Code Extractor repository
!git clone https://github.com/Test7973/code-extractor.git
%cd code-extractor

# Use the Python manual extractor to process the axios repository
!python3 extractors/python/extract.py "https://github.com/axios/axios.git" "axios_code.txt"

# Download the consolidated code file
from google.colab import files
files.download("axios_code.txt")
```

**Auto Extraction in Colab:**

```python
# Clone the Code Extractor repository
!git clone https://github.com/Test7973/code-extractor.git
%cd code-extractor

# Run the auto extraction script for fully automated processing
!python3 extractors/python/auto_extract.py "https://github.com/axios/axios.git" "axios_code.txt"

# Download the consolidated code file
from google.colab import files
files.download("axios_code.txt")
```

---

## 🛠️ How It Works

1. **Clone or Update the Repository:**  
   Downloads the target repository to your local machine (or pulls the latest changes if it already exists).

2. **Selective File Extraction:**  
   Scans the repository, including only code files (and essential context files like `README.md`, etc.) while excluding non-code assets and directories (e.g., `node_modules`, `.git`, images).

3. **Generate Output File:**  
   Compiles the folder structure and file contents into a single, well-formatted text file with clear file headers and a summary at the end.

4. **Clean Up:**  
   Automatically removes the cloned repository once the extraction is complete.

---

## 🧠 Integrating with AI Tools

Once you have your consolidated file, feed it into your AI tool of choice to:
- 🤖 **Explain the Codebase:** Obtain simplified explanations of complex projects.
- 🛠️ **Highlight Key Components:** Identify the most critical parts of your code.
- 🚀 **Suggest Optimizations:** Receive actionable recommendations for performance improvements.

---

## 📩 Need Assistance?

For any issues or suggestions, please open an issue on our [GitHub repository](https://github.com/Test7973/code-extractor/). We value your feedback and are committed to continuously improving Code Extractor.

---

🚀 **Streamline your code analysis with Code Extractor!** 🚀

