--[[
    DaviLuaXML Parser
    ==============
    
    Módulo responsável por transformar código com sintaxe XML em elementos Lua.
    
    FUNCIONALIDADE:
    ---------------
    Converte tags XML em tabelas Lua com a seguinte estrutura:
    {
        tag = "nome_da_tag",
        props = { atributo1 = valor1, ... },
        children = { filho1, filho2, ... }
    }
    
    EXEMPLOS DE CONVERSÃO:
    ----------------------
    
    1. Tag simples com atributo e texto:
       <h1 class="titulo"> test </h1>
       
       Resultado:
       {
           tag = "h1",
           props = { class = "titulo" },
           children = { "test" }
       }
    
    2. Tag com expressões Lua em chaves:
       <h1> {1} {2} </h1>
       
       Resultado:
       {
           tag = "h1",
           props = nil,
           children = { 1, 2 }
       }
    
    3. Tags aninhadas:
       <a href="link"> <h1> alt </h1> </a>
       
       Resultado:
       {
           tag = "a",
           props = { href = "link" },
           children = {
               {
                   tag = "h1",
                   props = nil,
                   children = { "alt" }
               }
           }
       }
    
    4. Tag self-closing:
       <img src="foto.png" />
       
       Resultado:
       {
           tag = "img",
           props = { src = "foto.png" },
           children = {}
       }
    
    TIPOS DE FILHOS SUPORTADOS:
    ---------------------------
    - Tags aninhadas (incluindo nomes com ponto, ex: <html.div />)
    - Expressões Lua entre chaves: {1 + 2}, {"texto"}, {variavel}
    - Texto puro
    
    TIPOS DE ATRIBUTOS SUPORTADOS:
    ------------------------------
    - String com aspas: attr="valor" ou attr='valor'
    - Expressão Lua: attr={expressao}
    - Valor sem aspas: attr=valor
    - Booleano implícito: attr (equivale a attr=true)
    
    USO:
    ----
    local parser = require("DaviLuaXML.parser")
    local elemento, inicio, fim = parser('<tag attr="valor">conteudo</tag>')
    
    NOTA:
    -----
    As tags não são tags HTML reais - elas chamam funções Lua definidas no código.
    Exemplo:
        function soma(props, children) return props.a + props.b end
        print(<soma a={2} b={3}/>)  -- imprime 5
    
    Tags reservadas do Lua (<const>, <close>) são ignoradas.
    
    RETORNO:
    --------
    - elemento: tabela com { tag, props, children }
    - inicio: posição inicial da tag no código original
    - fim: posição final da tag no código original
]]--






local elements = require("DaviLuaXML.elements") -- para criar os elementos
local insert = table.insert

--------------------------------------------------------------------------------
-- FUNÇÕES AUXILIARES
--------------------------------------------------------------------------------

--- Remove espaços em branco do início e fim de uma string.
--- @param str string String a ser processada
--- @return string String sem espaços nas extremidades
local function trim(str)
    return (str:match("^%s*(.-)%s*$") or "")
end

--- Conta quantos espaços em branco existem no início de uma string.
--- @param str string String a ser analisada
--- @return number Quantidade de espaços no início
local function leading_spaces(str)
    local prefix = str:match("^(%s*)")
    return prefix and #prefix or 0
end

--------------------------------------------------------------------------------
-- PARSER DE ATRIBUTOS
--------------------------------------------------------------------------------

--- Faz o parse de uma string de atributos XML.
--- Suporta:
---   - Strings com aspas duplas ou simples: attr="valor" ou attr='valor'
---   - Expressões Lua em chaves: attr={1 + 2}
---   - Valores sem aspas: attr=valor
---   - Atributos booleanos: attr (equivale a attr=true)
---
--- @param attrString string String contendo os atributos
--- @return table|nil Tabela de atributos ou nil se vazia
local function parseAttributes(attrString)
    attrString = attrString and trim(attrString) or ""
    if attrString == "" then
    return nil
end

local attrs = {}
local i, len = 1, #attrString

--- Avança o índice pulando espaços em branco
local function skipWhitespace()
    while i <= len and attrString:sub(i, i):match("%s") do
        i = i + 1
    end
end

--- Lê o nome de um atributo (aceita letras, números, hífen, underscore, dois-pontos e ponto)
--- @return string|nil Nome do atributo ou nil se não encontrado
local function readName()
    local start = i
    while i <= len and attrString:sub(i, i):match("[-%w_:.]") do
        i = i + 1
    end
    if start == i then
        return nil
    end
    return attrString:sub(start, i - 1)
end

--- Lê o valor de um atributo.
--- Suporta strings com aspas, expressões em chaves e valores simples.
--- @return any Valor do atributo (string, number, boolean, ou resultado de expressão Lua)
local function readValue()
    if i > len then
        return true
    end

    local ch = attrString:sub(i, i)

    -- Valor entre aspas (duplas ou simples)
    if ch == '"' or ch == "'" then
        local quote = ch
        i = i + 1
        local start = i
        while i <= len and attrString:sub(i, i) ~= quote do
            i = i + 1
        end
        local value = attrString:sub(start, i - 1)
        if attrString:sub(i, i) == quote then
            i = i + 1
        end
        return value

    -- Expressão Lua entre chaves
    elseif ch == '{' then
        i = i + 1
        local start = i
        local depth = 1
        while i <= len do
            local current = attrString:sub(i, i)
            if current == '{' then
                depth = depth + 1
            elseif current == '}' then
                depth = depth - 1
                if depth == 0 then
                    local value = attrString:sub(start, i - 1)
                    i = i + 1
                    return { __luaexpr=true, code=trim(value) }
                end
            end
            i = i + 1
        end
        -- Chave não fechada - retorna o que tiver
        return { __luaexpr=true, code=trim(attrString:sub(start))}

    -- Valor simples sem aspas (até próximo espaço)
    else
        local start = i
        while i <= len and not attrString:sub(i, i):match("%s") do
            i = i + 1
        end
        return attrString:sub(start, i - 1)
    end
end

-- Loop principal: lê pares nome=valor
while i <= len do
    skipWhitespace()
    if i > len then
        break
    end

    local name = readName()
    if not name then
        break
    end

    skipWhitespace()
    local value
    if attrString:sub(i, i) == '=' then
        i = i + 1
        skipWhitespace()
        value = readValue()
    else
        -- Atributo booleano (sem valor = true)
        value = true
    end

    attrs[name] = value
end

if next(attrs) == nil then
    return nil
end

return attrs

end

--------------------------------------------------------------------------------
-- PARSER DE ELEMENTOS
--------------------------------------------------------------------------------

--- Escapa caracteres especiais de pattern Lua em uma string.
--- @param s string String a ser escapada
--- @return string String com caracteres especiais escapados
local function escapePattern(s)
    return (s:gsub("(%W)", "%%%1"))
end

--- Faz o parse de um elemento XML completo.
--- Processa a tag de abertura, atributos, conteúdo interno (filhos) e tag de fechamento.
---
--- @param code string Código fonte contendo o elemento
--- @param globalStart number|nil Posição inicial no código original (padrão: 1)
--- @return table|nil Elemento parseado com { tag, props, children }
--- @return number|string Posição inicial absoluta ou mensagem de erro
--- @return number|nil Posição final absoluta
local function parseElement(code, globalStart)
    globalStart = globalStart or 1

    -- Ajustar para espaços iniciais
    local leading = leading_spaces(code)
    code = trim(code)
    globalStart = globalStart + leading

    -- Captura tag de abertura: <nome atributos /?>
    -- Suporta nomes com ponto (ex: html.div, React.Fragment)
    local startTagInit, startTagEnd, name, attrs, selfClosed = code:find("^<([%w_.]+)%s*(.-)(/?)>")

    if not name then
        return nil, "Tag de abertura inválida"
    end

    -- Ignorar tags reservadas do Lua usadas em sintaxe de variáveis
    if name == "const" or name == "close" then
        return nil, "Tag reservada Lua ignorada"
    end

    -- Criar nó base do elemento
    local node = {
        name = name,
        attrs = parseAttributes(attrs),
        children = {}
    }

    local absoluteStart = globalStart + startTagInit - 1
    local absoluteEnd = nil -- será determinado após encontrar fechamento

    -- Tag self-closing: <tag ... />
    if selfClosed == "/" then
        absoluteEnd = globalStart + startTagEnd - 1
        return elements:createElement(node.name, node.attrs, {}), absoluteStart, absoluteEnd
    end

    -- Buscar tag de fechamento correspondente
    local i = startTagEnd + 1
    local escapedName = escapePattern(name)
    local searchPos = i
    local contentStart = i
    local depth = 0 -- controle de profundidade para tags aninhadas de mesmo nome

    while true do
        -- Buscar próxima tag com mesmo nome (abertura ou fechamento)
        local s, e, slash, rest = code:find("<(/?)" .. escapedName .. "([^>]*)>", searchPos)
        if not s then
            return nil, "Tag de fechamento não encontrada para: " .. name
        end

        if slash == "/" then
            -- Tag de fechamento encontrada
            if depth == 0 then
                -- Fechamento correspondente ao elemento atual
                local rawContent = code:sub(contentStart, s - 1)
                absoluteEnd = globalStart + e - 1

                -- Processar conteúdo interno (filhos)
                if trim(rawContent) ~= "" then
                    local pos = 1
                    local len = #rawContent

                    while pos <= len do
                        -- Pular espaços em branco
                        local wsStart, wsEnd = rawContent:find("^%s+", pos)
                        if wsStart then
                            pos = wsEnd + 1
                            if pos > len then break end
                        end

                        -- CASO 1: Tag filha
                        if rawContent:sub(pos, pos) == "<" then
                            local segment = rawContent:sub(pos)
                            local childOffset = globalStart + contentStart + pos - 2
                            local child, childAbsStart, childAbsEnd = parseElement(segment, childOffset)

                            if child then
                                insert(node.children, child)

                                -- Calcular quantos caracteres consumir
                                local consumed = 0
                                if childAbsStart and childAbsEnd then
                                    consumed = childAbsEnd - childAbsStart + 1
                                else
                                    local sc = segment:find("/>")
                                    if sc then consumed = sc + 1 else break end
                                end

                                pos = pos + consumed
                            else
                                pos = pos + 1
                            end

                        -- CASO 2: Expressão Lua entre chaves {expr}
                        elseif rawContent:sub(pos, pos) == "{" then
                            local braceStart, braceEnd = rawContent:find("%b{}", pos)
                            if braceStart == pos and braceEnd then
                                local inner = rawContent:sub(braceStart + 1, braceEnd - 1)
                                inner = trim(inner)
                                if inner ~= "" then
                                  insert(node.children, {__luaexpr=true, code=inner})
                                end
                                pos = braceEnd + 1
                            else
                                pos = pos + 1
                            end

                        -- CASO 3: Texto puro
                        else
                            local nextSpecial = rawContent:find("[<{]", pos)
                            local textEnd = nextSpecial and (nextSpecial - 1) or len
                            local textContent = trim(rawContent:sub(pos, textEnd))
                            if textContent ~= "" then
                                insert(node.children, textContent)
                            end
                            pos = nextSpecial or (len + 1)
                        end
                    end
                end

                return elements:createElement(node.name, node.attrs, node.children), absoluteStart, absoluteEnd or (globalStart + startTagEnd - 1)
            else
                -- Fechamento de tag aninhada de mesmo nome
                depth = depth - 1
                searchPos = e + 1
            end
        else
            -- Tag de abertura encontrada (mesmo nome)
            -- Verificar se é self-closing
            if not rest:match("/%s*$") then
                depth = depth + 1
            end
            searchPos = e + 1
        end
    end
end

--------------------------------------------------------------------------------
-- EXPORTAÇÃO DO MÓDULO
--------------------------------------------------------------------------------

--- Parser principal.
--- Uso: parser(codigo) retorna elemento, posicao_inicio, posicao_fim
local parser = setmetatable({}, {
    __call = function(_, code)
        return parseElement(code, 1)
    end
})

return parser
