--[[
    Testes do módulo parser.lua
    
    O parser converte tags XML em tabelas Lua com a estrutura:
    { tag = string, props = table, children = array }
]]


_G.log = _G.log or require("loglua")
local logTest = log.inSection("parser")

logTest("=== TESTE: parser.lua ===")

local parser = require("DaviLuaXML.parser")

local passed = 0
local failed = 0

local function test(name, fn)
    logTest(string.format("%d. %s:", passed + failed + 1, name))
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        logTest("   ✓ OK")
    else
        failed = failed + 1
        log.error("   ✗ FALHOU: " .. tostring(err))
    end
end

-- Teste 1: Tag self-closing simples
test("Tag self-closing simples", function()
    local node = parser("<div/>")
    assert(node.tag == "div", "tag deveria ser 'div'")
    assert(type(node.children) == "table", "children deveria ser tabela")
    assert(#node.children == 0, "children deveria estar vazio")
end)

-- Teste 2: Tag com atributos
test("Tag com atributos", function()
    local node = parser('<btn class="primary" id="btn1"/>')
    assert(node.tag == "btn", "tag deveria ser 'btn'")
    assert(node.props.class == "primary", "class deveria ser 'primary'")
    assert(node.props.id == "btn1", "id deveria ser 'btn1'")
end)

-- Teste 3: Tag com conteúdo texto
test("Tag com conteúdo texto", function()
    local node = parser("<p>Hello World</p>")
    assert(node.tag == "p", "tag deveria ser 'p'")
    assert(node.children[1] == "Hello World", "children[1] deveria ser 'Hello World'")
end)

-- Teste 4: Tags aninhadas
test("Tags aninhadas", function()
    local node = parser("<div><span>texto</span></div>")
    assert(node.tag == "div", "tag deveria ser 'div'")
    assert(type(node.children[1]) == "table", "children[1] deveria ser tabela")
    assert(node.children[1].tag == "span", "children[1].tag deveria ser 'span'")
    assert(node.children[1].children[1] == "texto", "texto aninhado incorreto")
end)

-- Teste 5: Múltiplos filhos
test("Múltiplos filhos", function()
    local node = parser("<ul><li>1</li><li>2</li><li>3</li></ul>")
    assert(node.tag == "ul", "tag deveria ser 'ul'")
    assert(#node.children == 3, "deveria ter 3 filhos")
    assert(node.children[1].tag == "li", "primeiro filho deveria ser 'li'")
    assert(node.children[2].tag == "li", "segundo filho deveria ser 'li'")
    assert(node.children[3].tag == "li", "terceiro filho deveria ser 'li'")
end)

-- Teste 6: Expressões em chaves
test("Expressões em chaves", function()
    local node = parser("<num>{1}{2}{3}</num>")
    assert(node.tag == "num", "tag deveria ser 'num'")
    -- Parser atualmente retorna wrappers para expressões: { __luaexpr = true, code = "..." }
    assert(type(node.children[1]) == "table" and node.children[1].__luaexpr,
        "children[1] deveria ser wrapper __luaexpr")
    assert(node.children[1].code == "1", "children[1].code deveria ser '1'")
    assert(type(node.children[2]) == "table" and node.children[2].__luaexpr,
        "children[2] deveria ser wrapper __luaexpr")
    assert(node.children[2].code == "2", "children[2].code deveria ser '2'")
    assert(type(node.children[3]) == "table" and node.children[3].__luaexpr,
        "children[3] deveria ser wrapper __luaexpr")
    assert(node.children[3].code == "3", "children[3].code deveria ser '3'")
end)

-- Teste 7: Tag com nome contendo ponto
test("Tag com nome contendo ponto", function()
    local node = parser('<html.div class="container"/>')
    assert(node.tag == "html.div", "tag deveria ser 'html.div'")
    assert(node.props.class == "container", "class deveria ser 'container'")
end)

-- Teste 8: Atributos com expressão Lua
test("Atributos com expressão Lua", function()
    local node = parser("<comp valor={10 + 5}/>")
    assert(node.tag == "comp", "tag deveria ser 'comp'")
    -- Atributos expressos em chaves são retornados como wrappers __luaexpr
    assert(type(node.props.valor) == "table" and node.props.valor.__luaexpr,
        "props.valor deveria ser wrapper __luaexpr")
    assert(node.props.valor.code == "10 + 5", "props.valor.code deveria ser '10 + 5'")
end)

-- Teste 9: Conteúdo misto (texto + tags)
test("Conteúdo misto (texto + tags)", function()
    local node = parser("<div>antes<span>meio</span>depois</div>")
    assert(node.tag == "div", "tag deveria ser 'div'")
    assert(#node.children >= 3, "deveria ter pelo menos 3 filhos")
end)

-- Teste 10: Tags aninhadas do mesmo nome
test("Tags aninhadas do mesmo nome", function()
    local node = parser("<div><div>inner</div></div>")
    assert(node.tag == "div", "tag externa deveria ser 'div'")
    assert(node.children[1].tag == "div", "tag interna deveria ser 'div'")
    assert(node.children[1].children[1] == "inner", "texto deveria ser 'inner'")
end)

-- Teste 11: Retorna posições de início e fim
test("Retorna posições de início e fim", function()
    local code = "  <tag/>  "
    local node, startPos, endPos = parser(code)
    assert(node ~= nil, "node não deveria ser nil")
    assert(startPos ~= nil, "startPos não deveria ser nil")
    assert(endPos ~= nil, "endPos não deveria ser nil")
    assert(startPos <= endPos, "startPos deveria ser <= endPos")
end)

-- Teste 12: Expressão complexa em chaves
test("Expressão complexa em chaves", function()
    local node = parser("<calc>{(function() return 42 end)()}</calc>")
    -- Parser retorna wrapper com código da expressão
    assert(type(node.children[1]) == "table" and node.children[1].__luaexpr,
        "children[1] deveria ser wrapper __luaexpr")
    assert(node.children[1].code == "(function() return 42 end)()",
        "children[1].code deveria conter a expressão da função")
end)

-- Teste 13: Múltiplos atributos e filhos
test("Múltiplos atributos e filhos", function()
    local node = parser([[<test pr="t">
        <test/>
        <test/>
        <html.a href="link.com"/>
        {1}
        {"test"}
        texto
    </test>]])
    
    assert(node.tag == "test", "tag deveria ser 'test'")
    assert(node.props.pr == "t", "pr deveria ser 't'")
    assert(#node.children >= 6, "deveria ter pelo menos 6 filhos")
end)

-- Teste 14: String em expressão
test("String em expressão", function()
    local node = parser('<div>{"string em chaves"}</div>')
    -- Strings em chaves são mantidas como código dentro do wrapper
    assert(type(node.children[1]) == "table" and node.children[1].__luaexpr,
        "children[1] deveria ser wrapper __luaexpr contendo a string")
    assert(node.children[1].code == '"string em chaves"',
        'children[1].code deveria ser "\"string em chaves\""')
end)

-- Teste 15: Whitespace é ignorado em conteúdo vazio
test("Tag vazia com whitespace", function()
    local node = parser("<div>   </div>")
    assert(node.tag == "div", "tag deveria ser 'div'")
    -- Pode ter children com whitespace ou estar vazio
end)

logTest(string.rep("=", 50))
logTest(string.format("Resultado: %d passaram, %d falharam", passed, failed))
logTest(string.rep("=", 50))

if failed > 0 then
    log.error("=== ALGUNS TESTES FALHARAM ===")
    log.show()
    os.exit(1)
else
    logTest("=== TODOS OS TESTES PASSARAM ===")
    log.show()
end