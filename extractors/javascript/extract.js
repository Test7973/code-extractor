const fs = require('fs').promises;
const path = require('path');
const { execSync } = require('child_process');
const readline = require('readline');

class RepoExtractor {
    constructor(repoUrl, outputFile = 'output.txt') {
        this.repoUrl = repoUrl;
        this.outputFile = outputFile;
        this.repoName = repoUrl.split('/').pop().replace('.git', '');
        this.clonePath = path.join(process.cwd(), this.repoName);
        this.skipAll = false;
        
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    async cloneRepository() {
        console.log(`Starting to process repository: ${this.repoUrl}`);
        
        try {
            if (!fs.existsSync(this.clonePath)) {
                console.log(`Cloning repository to: ${this.clonePath}`);
                execSync(`git clone ${this.repoUrl} ${this.clonePath}`);
            } else {
                console.log(`Repository already exists at ${this.clonePath}. Pulling latest changes.`);
                execSync(`git -C ${this.clonePath} pull origin`);
            }
        } catch (error) {
            console.error('Failed to clone/pull repository:', error.message);
            process.exit(1);
        }
    }

    async shouldInclude(itemPath, itemType) {
        if (this.skipAll) return 'no';

        while (true) {
            try {
                const response = await new Promise(resolve => {
                    this.rl.question(
                        `Include this ${itemType}? (yes/no/folder/skip-all): ${itemPath}\n`,
                        answer => resolve(answer.toLowerCase())
                    );
                });

                if (['yes', 'no', 'folder', 'skip-all'].includes(response)) {
                    if (response === 'skip-all') {
                        this.skipAll = true;
                        return 'no';
                    }
                    return response;
                }
                
                console.log("Invalid response. Please enter 'yes', 'no', 'folder', or 'skip-all'.");
            } catch (error) {
                console.error('Error reading input:', error);
                return 'no';
            }
        }
    }

    getRelativePath(fullPath) {
        return path.relative(this.clonePath, fullPath);
    }

    async writeFileContent(filePath) {
        const relativePath = this.getRelativePath(filePath);
        
        try {
            const content = await fs.readFile(filePath, 'utf8');
            await fs.appendFile(
                this.outputFile,
                `----------  FILE: ${relativePath}  ----------\n${content}\n` +
                `----------  END FILE: ${relativePath}  ----------\n\n`
            );
        } catch (error) {
            console.warn(`Warning: Could not read ${relativePath} as text file`);
        }
    }

    async processFolder(folderPath) {
        if (this.skipAll) return;

        console.log(`Processing all files within folder ${folderPath}`);
        const processDir = async (dir) => {
            const entries = await fs.readdir(dir, { withFileTypes: true });
            
            for (const entry of entries) {
                const fullPath = path.join(dir, entry.name);
                if (entry.isFile() && fullPath !== __filename) {
                    console.log(`Appending file content: ${this.getRelativePath(fullPath)}`);
                    await this.writeFileContent(fullPath);
                } else if (entry.isDirectory()) {
                    await processDir(fullPath);
                }
            }
        };

        await processDir(folderPath);
    }

    async processItems(itemPath) {
        if (this.skipAll) return;

        const entries = await fs.readdir(itemPath, { withFileTypes: true });
        
        for (const entry of entries) {
            const fullPath = path.join(itemPath, entry.name);
            
            if (entry.isDirectory()) {
                const response = await this.shouldInclude(fullPath, "folder");
                if (response === 'yes') {
                    await this.processItems(fullPath);
                } else if (response === 'folder') {
                    await this.processFolder(fullPath);
                } else if (!this.skipAll) {
                    console.log(`Skipping folder: ${fullPath}`);
                }
            } else {
                if (await this.shouldInclude(fullPath, "file") === 'yes' && fullPath !== __filename) {
                    console.log(`Appending file content: ${this.getRelativePath(fullPath)}`);
                    await this.writeFileContent(fullPath);
                } else if (!this.skipAll) {
                    console.log(`Skipping file: ${fullPath}`);
                }
            }
        }
    }

    async cleanup() {
        console.log("Cleaning up cloned repository");
        await fs.rm(this.clonePath, { recursive: true, force: true });
        this.rl.close();
    }

    async run() {
        try {
            await this.cloneRepository();
            console.log("Starting interactive file selection...");
            await this.processItems(this.clonePath);
            console.log(`Finished. Check '${this.outputFile}'`);
        } catch (error) {
            console.error('Error during execution:', error);
        } finally {
            await this.cleanup();
        }
    }
}

if (require.main === module) {
    if (process.argv.length < 3) {
        console.log("Usage: node script.js <repo_url> [output_file]");
        process.exit(1);
    }

    const repoUrl = process.argv[2];
    const outputFile = process.argv[3] || "output.txt";

    const extractor = new RepoExtractor(repoUrl, outputFile);
    extractor.run();
}