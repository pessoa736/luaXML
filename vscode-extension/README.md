# DaviLuaXML - VS Code Extension

🌐 [English](#english) | [Português](#português) | [Español](#español)

---

## English

Syntax highlighting and formatting support for `.lx` files (LuaXML - Lua with XML/JSX-like syntax).

### Features

- ✨ **Syntax Highlighting** - Full color support for:
  - Lua keywords, functions, and operators
  - XML/JSX tags (including namespaced tags like `<html.div>`)
  - XML attributes and values
  - Embedded Lua expressions in attributes `{expression}`
  - Comments and strings

- 📐 **Code Formatting** - Automatic indentation for:
  - Lua control structures (`if`, `function`, `for`, etc.)
  - XML tags (opening/closing)

- ⚙️ **Language Configuration**:
  - Auto-closing brackets and tags
  - Comment toggling (`--` and `--[[ ]]`)
  - Code folding

### Installation

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "DaviLuaXML"
4. Click Install

Or install from VSIX:
```bash
code --install-extension daviluaxml-0.1.0.vsix
```

### Usage

Simply open any `.lx` file and the extension will automatically activate.

To format a document:
- Use `Shift+Alt+F` (or `Shift+Option+F` on Mac)
- Or right-click and select "Format Document"

### Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `daviluaxml.indentSize` | `2` | Number of spaces for indentation |
| `daviluaxml.useTabs` | `false` | Use tabs instead of spaces |

---

## Português

Suporte a syntax highlighting e formatação para arquivos `.lx` (LuaXML - Lua com sintaxe XML/JSX).

### Funcionalidades

- ✨ **Syntax Highlighting** - Cores para:
  - Keywords, funções e operadores Lua
  - Tags XML/JSX (incluindo tags com namespace como `<html.div>`)
  - Atributos e valores XML
  - Expressões Lua em atributos `{expressao}`
  - Comentários e strings

- 📐 **Formatação de Código** - Indentação automática para:
  - Estruturas de controle Lua (`if`, `function`, `for`, etc.)
  - Tags XML (abertura/fechamento)

- ⚙️ **Configuração de Linguagem**:
  - Auto-fechamento de brackets e tags
  - Toggle de comentários (`--` e `--[[ ]]`)
  - Code folding

### Instalação

1. Abra o VS Code
2. Vá em Extensões (Ctrl+Shift+X)
3. Pesquise por "DaviLuaXML"
4. Clique em Instalar

Ou instale via VSIX:
```bash
code --install-extension daviluaxml-0.1.0.vsix
```

### Uso

Simplesmente abra qualquer arquivo `.lx` e a extensão será ativada automaticamente.

Para formatar um documento:
- Use `Shift+Alt+F` (ou `Shift+Option+F` no Mac)
- Ou clique com botão direito e selecione "Format Document"

### Configurações

| Configuração | Padrão | Descrição |
|--------------|--------|-----------|
| `daviluaxml.indentSize` | `2` | Número de espaços para indentação |
| `daviluaxml.useTabs` | `false` | Usar tabs ao invés de espaços |

---

## Español

Soporte de syntax highlighting y formateo para archivos `.lx` (LuaXML - Lua con sintaxis XML/JSX).

### Características

- ✨ **Syntax Highlighting** - Colores para:
  - Keywords, funciones y operadores Lua
  - Tags XML/JSX (incluyendo tags con namespace como `<html.div>`)
  - Atributos y valores XML
  - Expresiones Lua en atributos `{expresion}`
  - Comentarios y strings

- 📐 **Formateo de Código** - Indentación automática para:
  - Estructuras de control Lua (`if`, `function`, `for`, etc.)
  - Tags XML (apertura/cierre)

- ⚙️ **Configuración de Lenguaje**:
  - Auto-cierre de brackets y tags
  - Toggle de comentarios (`--` y `--[[ ]]`)
  - Code folding

### Instalación

1. Abre VS Code
2. Ve a Extensiones (Ctrl+Shift+X)
3. Busca "DaviLuaXML"
4. Haz clic en Instalar

O instala vía VSIX:
```bash
code --install-extension daviluaxml-0.1.0.vsix
```

### Uso

Simplemente abre cualquier archivo `.lx` y la extensión se activará automáticamente.

Para formatear un documento:
- Usa `Shift+Alt+F` (o `Shift+Option+F` en Mac)
- O haz clic derecho y selecciona "Format Document"

### Configuraciones

| Configuración | Por defecto | Descripción |
|---------------|-------------|-------------|
| `daviluaxml.indentSize` | `2` | Número de espacios para indentación |
| `daviluaxml.useTabs` | `false` | Usar tabs en lugar de espacios |

---

## License

MIT - See [LICENSE](../LICENSE)
