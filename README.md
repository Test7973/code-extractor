

# 🚀 Github Code Extractor – Get Your Code AI-Ready in Seconds!  

## 🔥 Why Do You Need This?  

Sometimes, we need to **analyze an entire codebase** using AI tools like **GPT, Claude, or Gemini**—but these models work best with **structured, clean input.**  

Imagine you just found an interesting **GitHub repository** and want AI to:  
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

✅ **Perfect for AI-based code analysis**  
✅ **Lets you choose exactly which files to include**  
✅ **Works with PowerShell, Python, Node.js, and even in your browser!**  

---

## 📌 Supported Versions  

- 🖥️ **PowerShell** – `extractors/powershell/extract.ps1`  
- 🐍 **Python** – `extractors/python/extract.py`  
- 🌐 **JavaScript (Node.js)** – `extractors/javascript/extract.js`  
- 🌎 **Web Browser** – `extractors/web/index.html` (No installation required!)  

---

## 🚀 Quick Start  

### 🏁 Step 1: Clone the Repository  

Before using Code Extractor, **clone this repository** on your local machine:  

```bash
git clone https://github.com/Test7973/code-extractor.git
cd code-extractor
```

---

### 💻 Step 2: Run Your Preferred Version  

#### **🔹 PowerShell Version**  

```powershell
.\extractors\powershell\extract.ps1 -repoUrl "https://github.com/Test7973/code-extractor" -outputFile "output.txt"
```

✅ The script will:  
1. Clone the repo  
2. Ask which files/folders to include  
3. Generate a clean, structured output file  

---

#### **🐍 Python Version**  

```bash
python extractors/python/extract.py "https://github.com/Test7973/code-extractor" "output.txt"
```

Same process: **clone → choose files → generate output.**  

---

#### **🌐 Node.js Version**  

```bash
node extractors/javascript/extract.js "https://github.com/Test7973/code-extractor" "output.txt"
```

Just like the others, but in **JavaScript/Node.js!**  

---

#### **🌎 Web Version (No Installation Required!)**  (THIS ONE DONT WORK YET)

1. create index.html (copy the code from here )
2. Enter the **GitHub repository URL**  
3. Use the interactive interface to select files  
4. Download the final **output file**  

---

## 🛠️ How It Works  

### 1️⃣ Clone the GitHub Repository  
The tool downloads the entire repo to your machine (except in the web version).  

### 2️⃣ Interactive File Selection  
It asks you:  
✅ **yes** – Include this file  
❌ **no** – Skip this file  
📁 **folder** – Include all files in this folder  
🚀 **skip-all** – Skip everything else  

### 3️⃣ Generates a Single Text File  
All selected code is saved in a well-formatted **output.txt** file.  

### 4️⃣ Cleans Up Temporary Files  
The script removes cloned repo files to keep your system clean.  

---

## 🧠 Using with AI  

Now that you have **`output.txt`**, you can **upload it to any AI tool** and ask:  

🤖 _"Explain this codebase in simple terms."_  
🛠️ _"What are the key components of this project?"_  
🚀 _"How can I optimize this code?"_  

✨ **AI loves structured input.** Give it a well-organized text file, and you’ll get **way better answers!**  

---

## 📩 Need Help?  

If you have any issues or suggestions, **open an issue** on [GitHub](https://github.com/Test7973/code-extractor/). We’d love to hear your feedback!  

---

🚀 **Get your code AI-ready in seconds with Code Extractor!** 🚀  

