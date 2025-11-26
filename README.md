# DaviLuaXML

Sintaxe XML para Lua - escreva XML diretamente no seu código Lua, similar ao JSX no JavaScript.

## Instalação

```bash
luarocks install daviluaxml
```

## Uso Básico

```lua
-- Registrar o loader para arquivos .lx
require("DaviLuaXML")

-- Agora você pode usar require() com arquivos .lx
local App = require("meu_componente")
```

### Exemplo de arquivo .lx

```lua
-- componente.lx
local function Botao(props, children)
    return string.format('<button class="%s">%s</button>', 
        props.class, 
        children[1]
    )
end

local function App()
    return <div class="container">
        <h1>Olá Mundo!</h1>
        <Botao class="primary">Clique aqui</Botao>
    </div>
end

return App
```

## Sintaxe XML

### Tags simples

```lua
<div/>                          -- Tag self-closing
<p>texto</p>                    -- Tag com conteúdo
```

### Atributos

```lua
<btn class="primary"/>          -- String
<input value={variavel}/>       -- Expressão Lua
<comp enabled/>                 -- Booleano (true)
```

### Expressões em chaves

```lua
<soma>{1}{2}{3}</soma>          -- Múltiplos valores
<p>{nome .. " " .. sobrenome}</p>  -- Expressões Lua
```

### Tags aninhadas

```lua
<div>
    <span>texto</span>
    <ul>
        <li>item 1</li>
        <li>item 2</li>
    </ul>
</div>
```

## API

### require("DaviLuaXML")

Registra o loader para arquivos `.lx`. Após isso, `require()` funciona com arquivos `.lx`.

### require("DaviLuaXML.core")

```lua
local lx = require("DaviLuaXML.core")
local resultado, erro = lx("arquivo.lx")
```

Executa diretamente um arquivo `.lx` pelo caminho.

### require("DaviLuaXML.help")

```lua
local help = require("DaviLuaXML.help")
help()              -- Ajuda geral
help("sintaxe")     -- Tópico específico
help.list()         -- Listar tópicos
```

## Logging (Debug)

DaviLuaXML usa [loglua](https://github.com/pessoa736/loglua) para logging. Os logs ficam na seção `XMLRuntime`:

```lua
require("DaviLuaXML")
require("meu_modulo")

-- Ver logs de debug
log.show("XMLRuntime")
```

## Módulos

| Módulo | Descrição |
|--------|-----------|
| `init` | Registra o searcher para require() |
| `core` | Executa arquivos .lx diretamente |
| `parser` | Faz parse de tags XML |
| `transform` | Transforma XML em Lua |
| `elements` | Cria elementos (tabelas) |
| `props` | Processa atributos |
| `errors` | Formatação de erros |
| `help` | Sistema de ajuda |

## Testes

```bash
lua DaviLuaXML/test/run_all.lua
```

## Licença

MIT
