--[[
    Testes do módulo elements.lua
]]

local elements = require("DaviLuaXML.elements")

print("=== TESTE: elements.lua ===\n")

-- Teste 1: Criar elemento básico
print("1. Criar elemento básico:")
local el = elements("div", {class = "container"}, {"texto"})
print("   tag:", el.tag)
print("   props.class:", el.props.class)
print("   children[1]:", el.children[1])
assert(el.tag == "div", "tag deveria ser 'div'")
assert(el.props.class == "container", "props.class deveria ser 'container'")
assert(el.children[1] == "texto", "children[1] deveria ser 'texto'")
print("   ✓ OK\n")

-- Teste 2: Criar elemento sem props
print("2. Criar elemento sem props:")
local el2 = elements("span", nil, {"conteudo"})
print("   tag:", el2.tag)
print("   props:", el2.props)
assert(el2.tag == "span", "tag deveria ser 'span'")
assert(el2.props == nil, "props deveria ser nil")
print("   ✓ OK\n")

-- Teste 3: Criar elemento vazio
print("3. Criar elemento vazio:")
local el3 = elements("br", nil, {})
print("   tag:", el3.tag)
print("   children:", #el3.children)
assert(el3.tag == "br", "tag deveria ser 'br'")
assert(#el3.children == 0, "children deveria estar vazio")
print("   ✓ OK\n")

-- Teste 4: __tostring
print("4. Teste __tostring:")
local el4 = elements("p", {id = "teste"}, {"ola"})
local str = tostring(el4)
print("   resultado:", str:gsub("\n", " "):sub(1, 50) .. "...")
assert(str:find("tag") and str:find("p"), "__tostring deveria conter 'tag' e 'p'")
print("   ✓ OK\n")

-- Teste 5: __concat
print("5. Teste __concat:")
local el5 = elements("a", nil, {})
local concatenado = el5 .. " - extra"
print("   resultado:", concatenado:sub(1, 30) .. "...")
assert(type(concatenado) == "string", "concatenação deveria retornar string")
print("   ✓ OK\n")

-- Teste 6: createElement
print("6. Teste createElement:")
local el6 = elements:createElement("h1", {style = "color:red"}, {"titulo"})
print("   tag:", el6.tag)
assert(el6.tag == "h1", "createElement deveria criar elemento com tag 'h1'")
print("   ✓ OK\n")

print("=== TODOS OS TESTES PASSARAM ===")
