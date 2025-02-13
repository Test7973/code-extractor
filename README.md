

```bash
git clone https://github.com/Test7973/code-extractor.git
cd code-extractor/extractors/powershell
powershell -ExecutionPolicy Bypass -File extract.ps1 -repoUrl "https://github.com/axios/axios.git" -outputFile "axios_code.txt"
```

**Note:** Ensure you have PowerShell installed and properly configured on your system. The `-ExecutionPolicy Bypass` flag allows the script to run without execution policy restrictions, which is necessary for some environments.

For more detailed instructions and alternative methods, please refer to the sections below.

---

# 🚀 GitHub Code Extractor – Get Your Code AI-Ready in Seconds!

## 🔥 Why Do You Need This?

In the era of AI-driven development, efficiently analyzing entire codebases is crucial. **Code Extractor** streamlines this process by consolidating selected code into a single, structured text file, making it ideal for AI tools like **GPT, Claude, or Gemini**.

**Use Cases:**

- 🔎 **Project Structure Analysis:** Understand the architecture of new repositories.
- 🛠️ **Code Optimization:** Receive AI-driven suggestions for improvements.
- 📖 **Documentation Generation:** Automatically create comprehensive documentation.
- 🤖 **Debugging and Refactoring:** Leverage AI to identify and fix issues.

Traditional methods like manual copying or reading through cloned repositories are time-consuming and cumbersome. **Code Extractor** offers a swift and user-friendly alternative.

---

## ⚡ Key Features

- **Selective Extraction:** Choose specific files or directories to include.
- **Multi-Platform Support:** Available in PowerShell, Python, Node.js, and a web-based version.
- **AI-Friendly Output:** Generates a clean, consolidated text file suitable for AI analysis.

---

## 📌 Supported Versions

- 🖥️ **PowerShell:** `extractors/powershell/extract.ps1`
- 🐍 **Python:** `extractors/python/extract.py`
- 🌐 **JavaScript (Node.js):** `extractors/javascript/extract.js`
- 🌎 **Web Browser:** `extractors/web/index.html` (*currently in development*)

---

## 🚀 Quick Start Guide

### 🏁 Step 1: Clone the Code Extractor Repository

Begin by cloning the repository to your local machine:

```bash
git clone https://github.com/Test7973/code-extractor.git
cd code-extractor
```

---

### 💻 Step 2: Run Your Preferred Version

Below are instructions for using different versions of Code Extractor, using the [axios/axios](https://github.com/axios/axios) repository as an example.

---

#### **🔹 Windows (PowerShell)**

Open PowerShell and execute:

```powershell
.\extractors\powershell\extract.ps1 -repoUrl "https://github.com/axios/axios.git" -outputFile "axios_code.txt"
```

*This command clones the axios repository, allows you to select files or directories, and generates a structured `axios_code.txt` file.*

---

#### **🐧 Linux / macOS (Python)**

In your terminal, run:

```bash
python3 extractors/python/extract.py "https://github.com/axios/axios.git" "axios_code.txt"
```

*The Python script clones the axios repository, prompts for file selection, and outputs a consolidated text file.*

---

#### **🌐 Node.js**

For a JavaScript-based approach:

```bash
node extractors/javascript/extract.js "https://github.com/axios/axios.git" "axios_code.txt"
```

*This command uses the Node.js script to extract and consolidate code from the axios repository into `axios_code.txt`.*

---

#### **🌟 Google Colab**

To use Code Extractor in Google Colab:

```python
# Clone the Code Extractor repository
!git clone https://github.com/Test7973/code-extractor.git
%cd code-extractor

# Use the Python extractor to process the axios repository
!python3 extractors/python/extract.py "https://github.com/axios/axios.git" "axios_code.txt"

# Download the consolidated code file
from google.colab import files
files.download("axios_code.txt")
```

*This Colab script processes the axios repository and provides the output file for download.*

---

## 🛠️ How It Works

1. **Clone the Repository:** Downloads the specified GitHub repository to your local machine.
2. **Interactive Selection:** Prompts you to choose which files or directories to include:
   - ✅ **yes** – Include this file
   - ❌ **no** – Skip this file
   - 📁 **folder** – Include all files in this folder
   - 🚀 **skip-all** – Skip all remaining items
3. **Generate Output:** Compiles the selected code into a single, well-formatted text file (e.g., `axios_code.txt`).
4. **Clean Up:** Removes temporary files to maintain a tidy workspace.

---

## 🧠 Integrating with AI Tools

Once you have your consolidated file, you can utilize AI tools to:

- 🤖 **Explain the Codebase:** Get simplified explanations of complex code.
- 🛠️ **Identify Key Components:** Highlight essential parts of the project.
- 🚀 **Suggest Optimizations:** Receive recommendations for performance improvements.

Providing AI models with structured input enhances the quality of insights and suggestions.

---

## 📩 Need Assistance?

If you encounter any issues or have suggestions, please **open an issue** on our [GitHub repository](https://github.com/Test7973/code-extractor/). We value your feedback and are here to help you maximize the benefits of Code Extractor.

---

🚀 **Streamline your code analysis with Code Extractor!** 🚀

