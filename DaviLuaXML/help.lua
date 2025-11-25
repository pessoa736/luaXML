--[[
    DaviLuaXML Help
    ===========
    
    Modulo de ajuda que fornece documentacao sobre o uso do DaviLuaXML.
    
    USO:
    ----
    local help = require("DaviLuaXML.help")
    help()           -- Exibe ajuda geral
    help("parser")   -- Exibe ajuda do modulo parser
    help.list()      -- Lista todos os topicos disponiveis
]]

local help = {}

--------------------------------------------------------------------------------
-- TEXTOS DE AJUDA
--------------------------------------------------------------------------------

help.topics = {}

help.topics.geral = [=[
======================================================================
                          DaviLuaXML - Ajuda                              
======================================================================

DaviLuaXML e uma biblioteca que permite usar sintaxe XML dentro de codigo Lua.
As tags XML sao transformadas em chamadas de funcao Lua.

INICIO RAPIDO:
--------------
    -- 1. Carregue o DaviLuaXML no inicio do programa
    require("DaviLuaXML")
    
    -- 2. Agora voce pode usar require() com arquivos .lx
    local App = require("meu_componente")  -- carrega meu_componente.lx

EXEMPLO BASICO:
---------------
    -- arquivo: app.lx
    local function Botao(props, children)
        return string.format('<button class="%s">%s</button>', 
            props.class or "", 
            children[1] or "")
    end
    
    local html = <Botao class="primary">Clique aqui</Botao>
    print(html)  -- <button class="primary">Clique aqui</button>

TOPICOS DISPONIVEIS:
--------------------
Use help("topico") para mais informacoes:
    - geral      - Esta pagina
    - sintaxe    - Sintaxe XML suportada
    - parser     - Modulo de parsing
    - transform  - Modulo de transformacao
    - elements   - Criacao de elementos
    - props      - Manipulacao de propriedades
    - errors     - Sistema de erros
    - core       - Carregamento de arquivos
    - init       - Sistema de require

Digite: require("DaviLuaXML.help").list() para listar todos os topicos.
]=]

help.topics.sintaxe = [=[
======================================================================
                       DaviLuaXML - Sintaxe XML                           
======================================================================

TAGS BASICAS:
-------------
    -- Tag self-closing (sem conteudo)
    <MinhaTag/>
    
    -- Tag com conteudo
    <MinhaTag>conteudo aqui</MinhaTag>
    
    -- Tags aninhadas
    <Pai>
        <Filho>texto</Filho>
    </Pai>

ATRIBUTOS:
----------
    -- Strings
    <Tag nome="valor"/>
    
    -- Sem aspas (valores simples)
    <Tag ativo=true count=5/>
    
    -- Expressoes Lua em chaves
    <Tag valor={10 + 5} lista={minhaTabela}/>

EXPRESSOES EM CONTEUDO:
-----------------------
    -- Expressoes Lua dentro de tags
    <Tag>{variavel}</Tag>
    <Tag>{1 + 2 + 3}</Tag>
    <Tag>{"string"}</Tag>
    
    -- Multiplas expressoes
    <Lista>{item1}{item2}{item3}</Lista>

NOMES COM PONTO:
----------------
    -- Acesso a modulos/namespaces
    <html.div class="container"/>
    <ui.Button onClick={handler}/>

TRANSFORMACAO:
--------------
    -- O codigo XML e transformado em chamadas de funcao:
    <Tag prop="valor">texto</Tag>
    
    -- Vira:
    Tag({prop = 'valor'}, {[1] = 'texto'})
    
    -- A funcao recebe: (props, children)
]=]

help.topics.parser = [=[
======================================================================
                         DaviLuaXML - Parser                              
======================================================================

O modulo parser converte strings XML em tabelas Lua.

USO:
----
    local parser = require("DaviLuaXML.parser")
    local node, startPos, endPos = parser(codigo)

PARAMETROS:
-----------
    codigo (string)  - Codigo contendo uma tag XML

RETORNO:
--------
    node (table)     - Tabela representando o elemento:
                       { tag = string, props = table, children = array }
    startPos (number)- Posicao inicial da tag no codigo
    endPos (number)  - Posicao final da tag no codigo

EXEMPLO:
--------
    local parser = require("DaviLuaXML.parser")
    
    local node = parser('<div class="container"><span>texto</span></div>')
    
    print(node.tag)              -- "div"
    print(node.props.class)      -- "container"
    print(node.children[1].tag)  -- "span"
    print(node.children[1].children[1])  -- "texto"

ESTRUTURA DO NODE:
------------------
    {
        tag = "div",
        props = {
            class = "container"
        },
        children = {
            [1] = {
                tag = "span",
                props = {},
                children = { "texto" }
            }
        }
    }
]=]

help.topics.transform = [==[
======================================================================
                        DaviLuaXML - Transform                            
======================================================================

O modulo transform converte codigo Lua+XML em codigo Lua puro.

USO:
----
    local transform = require("DaviLuaXML.transform").transform
    local resultado, erro = transform(codigo, arquivo)

PARAMETROS:
-----------
    codigo (string)   - Codigo Lua contendo tags XML
    arquivo (string)  - Nome do arquivo (opcional, para mensagens de erro)

RETORNO:
--------
    resultado (string) - Codigo Lua transformado (ou nil se erro)
    erro (string)      - Mensagem de erro (ou nil se sucesso)

EXEMPLO:
--------
    local transform = require("DaviLuaXML.transform").transform
    
    local codigo = [[
        local function Comp(props)
            return props.x * 2
        end
        local resultado = <Comp x={21}/>
    ]]
    
    local lua_puro = transform(codigo)
    print(lua_puro)

NOTAS:
------
    - Tags reservadas do Lua (const, close) sao preservadas
    - Multiplas tags podem existir no mesmo codigo
    - Expressoes em {} sao avaliadas durante a transformacao
]==]

help.topics.elements = [=[
======================================================================
                        DaviLuaXML - Elements                             
======================================================================

O modulo elements fornece funcoes para criar elementos programaticamente.

USO:
----
    local elements = require("DaviLuaXML.elements")
    local el = elements:createElement(tag, props, children)

PARAMETROS:
-----------
    tag (string)      - Nome da tag
    props (table)     - Tabela de propriedades (pode ser nil)
    children (array)  - Array de filhos (strings, numeros ou outros elementos)

RETORNO:
--------
    element (table)   - Elemento com metatable configurada

EXEMPLO:
--------
    local elements = require("DaviLuaXML.elements")
    
    local botao = elements:createElement(
        "button",
        { class = "primary", disabled = false },
        { "Clique aqui" }
    )
    
    print(botao.tag)           -- "button"
    print(botao.props.class)   -- "primary"
    print(botao.children[1])   -- "Clique aqui"

METATABLE:
----------
    - __tostring: Converte elemento para string (tableToString)
    - __concat: Permite concatenar elementos com ..
]=]

help.topics.props = [=[
======================================================================
                          DaviLuaXML - Props                              
======================================================================

O modulo props converte entre tabelas Lua e strings de atributos XML.

FUNCOES:
--------

tableToPropsString(tabela)
    Converte uma tabela Lua em string de atributos XML.
    
    local props = require("DaviLuaXML.props")
    local s = props.tableToPropsString({ id = "btn1", count = 5 })
    print(s)  -- 'id="btn1" count="5"'

stringToPropsTable(string)
    Converte uma string de atributos XML em tabela Lua.
    Faz conversao automatica de tipos (number, boolean).
    
    local props = require("DaviLuaXML.props")
    local t = props.stringToPropsTable('count="5" active="true"')
    print(t.count)   -- 5 (number)
    print(t.active)  -- true (boolean)

CONVERSAO DE TIPOS:
-------------------
    String para Tabela:
    - "123"   vira 123 (number)
    - "true"  vira true (boolean)
    - "false" vira false (boolean)
    - "texto" continua "texto" (string)
]=]

help.topics.errors = [=[
======================================================================
                         DaviLuaXML - Errors                              
======================================================================

O modulo errors formata mensagens de erro com contexto.

USO:
----
    local errors = require("DaviLuaXML.errors")

FUNCOES:
--------

errors.format(msg, arquivo, codigo, posicao)
    Formata uma mensagem de erro generica.
    
errors.unclosedTag(tag, arquivo, codigo, posicao)
    Erro para tag nao fechada.
    
errors.invalidTag(arquivo, codigo, posicao)
    Erro para tag invalida/malformada.
    
errors.compilationError(arquivo, luaError)
    Erro de compilacao do codigo transformado.
    
errors.runtimeError(arquivo, luaError)
    Erro de execucao do codigo.

errors.getLineInfo(codigo, posicao)
    Retorna numero da linha e coluna para uma posicao.
    
errors.getLine(codigo, numeroLinha)
    Retorna o texto de uma linha especifica.

EXEMPLO:
--------
    local errors = require("DaviLuaXML.errors")
    
    local linha, coluna = errors.getLineInfo("abc\ndef\nghi", 6)
    print(linha, coluna)  -- 2, 2
    
    local msg = errors.unclosedTag("div", "app.lx", codigo, 10)
    -- [DaviLuaXML] app.lx: linha 1, coluna 10: tag 'div' nao foi fechada...
]=]

help.topics.core = [=[
======================================================================
                          DaviLuaXML - Core                               
======================================================================

O modulo core carrega e executa arquivos .lx diretamente.

USO:
----
    local core = require("DaviLuaXML.core")
    local resultado, erro = core(caminho)

PARAMETROS:
-----------
    caminho (string) - Caminho para o arquivo .lx

RETORNO:
--------
    resultado (string) - Codigo transformado (ou nil se erro)
    erro (string)      - Mensagem de erro (ou nil se sucesso)

EXEMPLO:
--------
    local core = require("DaviLuaXML.core")
    
    -- Executa o arquivo e retorna o codigo transformado
    local codigo, err = core("meu_app.lx")
    
    if err then
        print("Erro:", err)
    else
        print("Executado com sucesso!")
    end

PROCESSO:
---------
    1. Le o arquivo do disco
    2. Transforma XML para Lua
    3. Compila o codigo Lua
    4. Executa o codigo
    5. Retorna o codigo transformado ou erro
]=]

help.topics.init = [=[
======================================================================
                          DaviLuaXML - Init                               
======================================================================

O modulo init registra um searcher customizado para require().

USO:
----
    require("DaviLuaXML")  -- ou require("DaviLuaXML.init")
    
    -- Agora voce pode carregar arquivos .lx com require()
    local App = require("meu_componente")

FUNCIONAMENTO:
--------------
    1. Adiciona um searcher em package.searchers
    2. Quando require() e chamado, procura por arquivo .lx
    3. Se encontrar, transforma o codigo e retorna o chunk

EXEMPLO:
--------
    -- main.lua
    require("DaviLuaXML")
    
    local config = require("config")      -- carrega config.lx
    local App = require("components.App") -- carrega components/App.lx

ESTRUTURA DE PROJETO:
---------------------
    projeto/
        main.lua          -- require("DaviLuaXML") aqui
        config.lx
        components/
            App.lx
            Button.lx

NOTAS:
------
    - O searcher usa package.path trocando .lua por .lx
    - Funciona com caminhos com ponto (a.b.c vira a/b/c.lx)
    - O modulo carregado fica em package.loaded normalmente
]=]

--------------------------------------------------------------------------------
-- FUNCOES
--------------------------------------------------------------------------------

--- Lista todos os topicos de ajuda disponiveis.
function help.list()
    print("\nTopicos de ajuda disponiveis:")
    print(string.rep("-", 40))
    local topics = {}
    for name in pairs(help.topics) do
        table.insert(topics, name)
    end
    table.sort(topics)
    for _, name in ipairs(topics) do
        print("  - " .. name)
    end
    print(string.rep("-", 40))
    print('Use: require("DaviLuaXML.help")("topico")')
    print("")
end

--- Exibe a ajuda de um topico especifico.
--- @param topic string|nil Nome do topico (nil para ajuda geral)
function help.show(topic)
    topic = topic or "geral"
    local text = help.topics[topic]
    if text then
        print(text)
    else
        print(string.format("\n[DaviLuaXML] Topico '%s' nao encontrado.\n", topic))
        help.list()
    end
end

--------------------------------------------------------------------------------
-- METATABLE
--------------------------------------------------------------------------------

setmetatable(help, {
    __call = function(_, topic)
        help.show(topic)
    end
})

return help
