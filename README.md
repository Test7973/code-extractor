# 🚀 GitHub Code Extractor – Get Your Code AI-Ready in Seconds!

## 🔥 Why Do You Need This?

Sometimes, you need to **analyze an entire codebase** using AI tools like **GPT, Claude, or Gemini**—but these models work best with **structured, clean input**.

Imagine you just discovered a popular GitHub repository and want AI to:
- 🔎 **Explain the project structure**
- 🛠️ **Suggest improvements**
- 📖 **Generate documentation**
- 🤖 **Help debug or refactor code**

Manually copying files? **Too slow.**  
Cloning the repo and reading every file? **Too painful.**  

💡 That’s where **Code Extractor** comes in.

---

## ⚡ What It Does

Code Extractor takes a **Git repository URL** and creates a **single text file** containing all the code you select.

- ✅ **Perfect for AI-based code analysis**
- ✅ **Lets you choose exactly which files to include**
- ✅ **Works with PowerShell, Python, Node.js, and even in your browser!**

---

## 📌 Supported Versions

- 🖥️ **PowerShell** – `extractors/powershell/extract.ps1`
- 🐍 **Python** – `extractors/python/extract.py`
- 🌐 **JavaScript (Node.js)** – `extractors/javascript/extract.js`
- 🌎 **Web Browser** – `extractors/web/index.html` (No installation required – *currently in development*)

---

## 🚀 Quick Start

### 🏁 Step 1: Clone the Code Extractor Repository

Before using Code Extractor, **clone this repository** on your local machine:

```bash
git clone https://github.com/Test7973/code-extractor.git
cd code-extractor
```

---

### 💻 Step 2: Run Your Preferred Version

Below are examples using the popular [axios/axios](https://github.com/axios/axios) repository as the target to extract and consolidate its code into a single text file.

---

#### **🔹 Windows CMD (via PowerShell)**

Open a PowerShell window and run:

```powershell
.\extractors\powershell\extract.ps1 -repoUrl "https://github.com/axios/axios.git" -outputFile "axios_code.txt"
```

*This command clones the axios repository, prompts you to select files/folders, and generates a clean, structured `axios_code.txt`.*

---

#### **🐧 Linux / macOS Terminal**

Open your terminal and run:

```bash
git clone https://github.com/Test7973/code-extractor.git
cd code-extractor
python3 extractors/python/extract.py "https://github.com/axios/axios.git" "axios_code.txt"
```

*The Python script clones the axios repository, lets you select the desired files, and outputs a single text file.*

---

#### **🐍 Python (Standalone Script)**

Integrate Code Extractor into your own Python workflow:

```python
import subprocess
import os

# Clone the Code Extractor repository (if not already cloned)
if not os.path.exists("code-extractor"):
    subprocess.run(["git", "clone", "https://github.com/Test7973/code-extractor.git"])

# Change directory to the Code Extractor folder
os.chdir("code-extractor")

# Run the Python extractor script on the axios repository
subprocess.run(["python3", "extractors/python/extract.py", "https://github.com/axios/axios.git", "axios_code.txt"])
```

*This standalone script automates the process, generating a consolidated `axios_code.txt` file from the axios repository.*

---

#### **🌟 Google Colab**

Run the following cell in a Colab notebook:

```python
# Step 1: Clone the Code Extractor repository
!git clone https://github.com/Test7973/code-extractor.git
%cd code-extractor

# Step 2: Use the Python extractor to process the axios repository
!python3 extractors/python/extract.py "https://github.com/axios/axios.git" "axios_code.txt"

# Step 3: Download the consolidated code file
from google.colab import files
files.download("axios_code.txt")
```

*This Colab example clones Code Extractor, processes the axios repository, and finally makes the output file available for download.*

---

#### **🌐 Node.js Version**

If you prefer JavaScript/Node.js, use the following:

```bash
git clone https://github.com/Test7973/code-extractor.git
cd code-extractor
node extractors/javascript/extract.js "https://github.com/axios/axios.git" "axios_code.txt"
```

*This command runs the Node.js script to extract and consolidate the code from the axios repository into `axios_code.txt`.*

---

## 🛠️ How It Works

1. **Clone the GitHub Repository**  
   The tool downloads the entire target repository to your machine (except in the web version).

2. **Interactive File Selection**  
   It prompts you to decide for each file or folder:
   - ✅ **yes** – Include this file
   - ❌ **no** – Skip this file
   - 📁 **folder** – Include all files in this folder
   - 🚀 **skip-all** – Skip everything else

3. **Generate a Single Text File**  
   All selected code is saved in a well-formatted output file (e.g., `axios_code.txt`).

4. **Clean Up Temporary Files**  
   After extraction, the script removes any temporary files to keep your system clean.

---

## 🧠 Using with AI

Once you have your consolidated file (e.g., `axios_code.txt`), you can upload it to any AI tool and ask:

- 🤖 _"Explain this codebase in simple terms."_
- 🛠️ _"What are the key components of this project?"_
- 🚀 _"How can I optimize this code?"_

**AI loves structured input.** Provide it with a well-organized text file and receive much better insights!

---

## 📩 Need Help?

If you encounter issues or have suggestions, please **open an issue** on our [GitHub repository](https://github.com/Test7973/code-extractor/). We’d love to hear your feedback and help you get the most out of Code Extractor.

---

🚀 **Get your code AI-ready in seconds with Code Extractor!** 🚀
