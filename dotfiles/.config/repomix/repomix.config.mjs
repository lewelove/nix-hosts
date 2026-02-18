import path from 'path';
import os from 'os';
import fs from 'fs';
import process from 'process';
import { fileURLToPath } from 'url';

// --- CONFIGURATION ---

const completelyIgnore = [

    '**/*.log', '**/*.lock', '**/node_modules/**',
    '**/.git/**', '**/dist/**', '**/coverage/**',
    '**/tmp/**', '**/.cache/**', '**/.DS_Store',
    '**/*.rmlock', '**/.direnv/**',

    '**/*.png', '**/*.jpg', '**/*.jpeg', '**/*.gif', 
    '**/*.ico', '**/*.woff', '**/*.woff2', '**/*.ttf',
    '**/*.svg', '**/*.pdf',

    '**/mpd/database',
    '**/mpd/sticker.sql',
    
    '**/lazy-lock.json'
];

const stripExts = [
];

// --- PATH LOGIC ---

const args = process.argv.slice(2);
const targetArg = args.find(arg => !arg.startsWith('-'));
const cwd = process.cwd();
const absolutePath = targetArg ? path.resolve(cwd, targetArg) : cwd;

const __filename = fileURLToPath(import.meta.url);
const configDir = path.dirname(__filename);

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
        let injectedTags = '';

        const rootPromptPath = path.join(absolutePath, 'system_prompt.txt');

        if (fs.existsSync(rootPromptPath)) {
            try {
                const promptContent = fs.readFileSync(rootPromptPath, 'utf8').trim();
                if (promptContent) {
                    injectedTags += `<system_prompt>\n${promptContent}\n</system_prompt>\n\n`;
                    console.log('   Found system_prompt.txt in target root.');
                }
            } catch (e) {
                console.warn('   Warning: Failed reading root system_prompt.txt:', e.message);
            }
        }

        try {
            const files = fs.readdirSync(configDir);
            const txtFiles = files.filter(file => file.endsWith('.txt'));

            for (const file of txtFiles) {
                const rawName = path.parse(file).name;
                const tagName = rawName.replace(/[^a-zA-Z0-9_]/g, '_');
                
                const filePath = path.join(configDir, file);
                const fileContent = fs.readFileSync(filePath, 'utf8').trim();
                
                if (fileContent) {
                    injectedTags += `<${tagName}>\n${fileContent}\n</${tagName}>\n\n`;
                }
            }
        } catch (e) {
            console.warn('Warning: Could not read external .txt files:', e.message);
        }

        const openTag = '<directory_structure>';
        const injectedRoot = `${openTag}\nRoot: ${prettyPath}\n`;
        
        if (content.includes(openTag)) {
            content = content.replace(openTag, injectedRoot);
        }

        content = injectedTags + content;

        const escDots = stripExts.map(e => e.replace('.', '\\.'));
        if (escDots.length > 0) {
            const extPattern = escDots.join('|');
            
            const startTag = `<file path="[^"]+(?:${extPattern})">`;
            const wildcard = '[\\s\\S]*?'; 
            const endTag = '<\\/file>\\s*'; 
    
            const regex = new RegExp(startTag + wildcard + endTag, 'gi');
            
            content = content.replace(regex, '');
        }

        fs.writeFileSync(fullOutputPath, content);
        console.log(`\nRepomixed: ${dynamicName}`);

    } catch (err) {
        console.error('Error post-processing:', err);
    }
});

// --- EXPORT ---

export default {
    output: {
        filePath: fullOutputPath,
        style: 'xml',
        fileSummary: false,
        removeEmptyLines: false,
        removeComments: false, 
    },
    ignore: {
        customPatterns: completelyIgnore,
        useGitignore: true,
        useDefaultPatterns: true,
    },
};
