--[[
    Testes do módulo parser.lua
    
    O parser converte tags XML em tabelas Lua com a estrutura:
    { tag = string, props = table, children = array }
]]

print("=== TESTE: parser.lua ===\n")

local parser = require("DaviLuaXML.parser")

local passed = 0
local failed = 0

local function test(name, fn)
    io.write(string.format("%d. %s:\n", passed + failed + 1, name))
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print("   ✓ OK\n")
    else
        failed = failed + 1
        print("   ✗ FALHOU: " .. tostring(err) .. "\n")
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
    assert(node.children[1] == 1, "children[1] deveria ser 1")
    assert(node.children[2] == 2, "children[2] deveria ser 2")
    assert(node.children[3] == 3, "children[3] deveria ser 3")
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
    assert(node.props.valor == 15, "valor deveria ser 15 (10+5)")
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
    assert(node.children[1] == 42, "deveria avaliar função e retornar 42")
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
    assert(node.children[1] == "string em chaves", "deveria preservar string")
end)

-- Teste 15: Whitespace é ignorado em conteúdo vazio
test("Tag vazia com whitespace", function()
    local node = parser("<div>   </div>")
    assert(node.tag == "div", "tag deveria ser 'div'")
    -- Pode ter children com whitespace ou estar vazio
end)

print(string.rep("=", 50))
print(string.format("Resultado: %d passaram, %d falharam", passed, failed))
print(string.rep("=", 50))

if failed > 0 then
    print("\n=== ALGUNS TESTES FALHARAM ===")
    os.exit(1)
else
    print("\n=== TODOS OS TESTES PASSARAM ===")
end