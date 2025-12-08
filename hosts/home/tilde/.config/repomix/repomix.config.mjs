import path from 'path';
import os from 'os';
import fs from 'fs';
import process from 'process';

// --- CONFIGURATION ---

const completelyIgnore = [
    '**/*.log', '**/*.lock', '**/node_modules/**',
    '**/.git/**', '**/dist/**', '**/coverage/**',
    '**/tmp/**', '**/.cache/**', '**/.DS_Store'
];

// Files to keep in tree, but strip content
const stripExts = [
    '.svg', '.png', '.jpg', '.jpeg', '.gif',
    '.ico', '.pdf', '.woff', '.woff2', '.ttf'
];

// --- PATH LOGIC ---

const args = process.argv.slice(2);
const targetArg = args.find(arg => !arg.startsWith('-'));
const cwd = process.cwd();
const absolutePath = targetArg ? path.resolve(cwd, targetArg) : cwd;

const homeDir = os.homedir();
let prettyPath = absolutePath;
if (prettyPath.startsWith(homeDir)) {
    prettyPath = prettyPath.replace(homeDir, '~');
}

// --- OUTPUT NAMING ---

const dynamicName = prettyPath
    .replace(/^\//, '')
    .replace(/[\/\s]+/g, '-') + '.xml';

const outputDir = path.join(homeDir, 'LLM/repomix');
const fullOutputPath = path.join(outputDir, dynamicName);

if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
}

// --- POST-PROCESSING HOOK ---

process.on('exit', () => {
    try {
        if (!fs.existsSync(fullOutputPath)) return;

        let content = fs.readFileSync(fullOutputPath, 'utf8');

        // 1. Define Explanatory Header
        const explanation = 
            'This file is a packed representation of the source code.\n' +
            'It allows AI to understand the structure and content.\n\n';

        // 2. Merge Path into Directory Structure
        // We find the opening tag and inject the Root path immediately after
        const openTag = '<directory_structure>';
        const injectedRoot = `${openTag}\nRoot: ${prettyPath}\n`;
        
        if (content.includes(openTag)) {
            content = content.replace(openTag, injectedRoot);
        }

        // 3. Prepend Explanation (only if not already there)
        if (!content.startsWith('This file')) {
            content = explanation + content;
        }

        // 4. Strip Binary/Image Content
        // Build regex parts separately to keep lines short
        const escDots = stripExts.map(e => e.replace('.', '\\.'));
        const extPattern = escDots.join('|');
        
        // Regex: <file path="...ext"> content </file>
        const startTag = `<file path="[^"]+(?:${extPattern})">`;
        const wildcard = '[\\s\\S]*?'; // Matches newlines too
        const endTag = '<\\/file>\\s*'; // Swallow trailing whitespace

        const regex = new RegExp(startTag + wildcard + endTag, 'gi');
        
        content = content.replace(regex, '');

        fs.writeFileSync(fullOutputPath, content);
        console.log(`\n✅ Processed: ${dynamicName}`);

    } catch (err) {
        console.error('Error post-processing:', err);
    }
});

// --- EXPORT ---

export default {
    output: {
        filePath: fullOutputPath,
        style: 'xml',
        fileSummary: false, // We provide our own summary
        // headerText is omitted intentionally
        removeEmptyLines: false,
        removeComments: false, 
    },
    ignore: {
        customPatterns: completelyIgnore,
        useGitignore: true,
        useDefaultPatterns: true,
    },
};
