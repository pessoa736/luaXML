import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
    console.log('DaviLuaXML extension is now active!');

    // Register the formatter
    const formatter = vscode.languages.registerDocumentFormattingEditProvider('luaxml', {
        provideDocumentFormattingEdits(document: vscode.TextDocument): vscode.TextEdit[] {
            const config = vscode.workspace.getConfiguration('daviluaxml');
            const indentSize = config.get<number>('indentSize', 2);
            const useTabs = config.get<boolean>('useTabs', false);
            
            const edits: vscode.TextEdit[] = [];
            const text = document.getText();
            const formatted = formatLuaXML(text, indentSize, useTabs);
            
            const fullRange = new vscode.Range(
                document.positionAt(0),
                document.positionAt(text.length)
            );
            
            edits.push(vscode.TextEdit.replace(fullRange, formatted));
            return edits;
        }
    });

    // Register format command
    const formatCommand = vscode.commands.registerCommand('daviluaxml.formatDocument', () => {
        const editor = vscode.window.activeTextEditor;
        if (editor && editor.document.languageId === 'luaxml') {
            vscode.commands.executeCommand('editor.action.formatDocument');
        }
    });

    context.subscriptions.push(formatter, formatCommand);
}

/**
 * Format LuaXML code
 */
function formatLuaXML(text: string, indentSize: number, useTabs: boolean): string {
    const indent = useTabs ? '\t' : ' '.repeat(indentSize);
    const lines = text.split('\n');
    const result: string[] = [];
    let indentLevel = 0;
    
    // Keywords that increase indent
    const increaseIndentPatterns = [
        /\bfunction\b.*\)$/,
        /\bfunction\b.*\)\s*$/,
        /\bthen\s*$/,
        /\bdo\s*$/,
        /\belse\s*$/,
        /\belseif\b.*\bthen\s*$/,
        /\brepeat\s*$/,
        /^\s*<[a-zA-Z][^/>]*>\s*$/  // Opening XML tag
    ];
    
    // Keywords that decrease indent
    const decreaseIndentPatterns = [
        /^\s*end\b/,
        /^\s*else\b/,
        /^\s*elseif\b/,
        /^\s*until\b/,
        /^\s*<\/[a-zA-Z]/  // Closing XML tag
    ];
    
    // Self-closing patterns (no indent change)
    const selfClosingPattern = /\/>\s*$/;
    
    for (let i = 0; i < lines.length; i++) {
        let line = lines[i];
        const trimmedLine = line.trim();
        
        // Skip empty lines
        if (trimmedLine === '') {
            result.push('');
            continue;
        }
        
        // Check if we should decrease indent before this line
        let shouldDecreaseFirst = false;
        for (const pattern of decreaseIndentPatterns) {
            if (pattern.test(trimmedLine)) {
                shouldDecreaseFirst = true;
                break;
            }
        }
        
        if (shouldDecreaseFirst && indentLevel > 0) {
            indentLevel--;
        }
        
        // Apply current indent
        const indentedLine = indent.repeat(indentLevel) + trimmedLine;
        result.push(indentedLine);
        
        // Check if this line ends with self-closing tag
        if (selfClosingPattern.test(trimmedLine)) {
            continue;
        }
        
        // Check if we should increase indent after this line
        let shouldIncrease = false;
        for (const pattern of increaseIndentPatterns) {
            if (pattern.test(trimmedLine)) {
                shouldIncrease = true;
                break;
            }
        }
        
        if (shouldIncrease) {
            indentLevel++;
        }
    }
    
    return result.join('\n');
}

export function deactivate() {}
