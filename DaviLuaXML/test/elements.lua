--[[
    Testes do módulo elements.lua
]]


_G.log = _G.log or require("loglua")
local logTest = log.inSection("elements")

local elements = require("DaviLuaXML.elements")

logTest("=== TESTE: elements.lua ===")

-- Teste 1: Criar elemento básico
logTest("1. Criar elemento básico:")
local el = elements("div", {class = "container"}, {"texto"})
logTest("   tag:", el.tag)
logTest("   props.class:", el.props.class)
logTest("   children[1]:", el.children[1])
assert(el.tag == "div", "tag deveria ser 'div'")
assert(el.props.class == "container", "props.class deveria ser 'container'")
assert(el.children[1] == "texto", "children[1] deveria ser 'texto'")
logTest("   ✓ OK")

-- Teste 2: Criar elemento sem props
logTest("2. Criar elemento sem props:")
local el2 = elements("span", nil, {"conteudo"})
logTest("   tag:", el2.tag)
logTest("   props:", el2.props)
assert(el2.tag == "span", "tag deveria ser 'span'")
assert(el2.props == nil, "props deveria ser nil")
logTest("   ✓ OK")

-- Teste 3: Criar elemento vazio
logTest("3. Criar elemento vazio:")
local el3 = elements("br", nil, {})
logTest("   tag:", el3.tag)
logTest("   children:", #el3.children)
assert(el3.tag == "br", "tag deveria ser 'br'")
assert(#el3.children == 0, "children deveria estar vazio")
logTest("   ✓ OK")

-- Teste 4: __tostring
logTest("4. Teste __tostring:")
local el4 = elements("p", {id = "teste"}, {"ola"})
local str = tostring(el4)
logTest("   resultado:", str:gsub("\n", " "):sub(1, 50) .. "...")
assert(str:find("tag") and str:find("p"), "__tostring deveria conter 'tag' e 'p'")
logTest("   ✓ OK")

-- Teste 5: __concat
logTest("5. Teste __concat:")
local el5 = elements("a", nil, {})
local concatenado = el5 .. " - extra"
logTest("   resultado:", concatenado:sub(1, 30) .. "...")
assert(type(concatenado) == "string", "concatenação deveria retornar string")
logTest("   ✓ OK")

-- Teste 6: createElement
logTest("6. Teste createElement:")
local el6 = elements:createElement("h1", {style = "color:red"}, {"titulo"})
logTest("   tag:", el6.tag)
assert(el6.tag == "h1", "createElement deveria criar elemento com tag 'h1'")
logTest("   ✓ OK")

logTest("=== TODOS OS TESTES PASSARAM ===")
log.show()
