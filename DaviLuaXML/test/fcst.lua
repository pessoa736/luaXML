--[[
    Testes do módulo functionCallToStringTransformer.lua (fcst)
]]

local fcst = require("DaviLuaXML.functionCallToStringTransformer")

print("=== TESTE: functionCallToStringTransformer.lua ===\n")

-- Teste 1: Elemento simples sem props e children
print("1. Elemento simples vazio:")
local el1 = {tag = "br", props = {}, children = {}}
local str1 = fcst(el1)
print("   entrada: {tag='br', props={}, children={}}")
print("   saída:", str1)
assert(str1:find("br%("), "deveria começar com 'br('")
assert(str1:find("%)$"), "deveria terminar com ')'")
print("   ✓ OK\n")

-- Teste 2: Elemento com props
print("2. Elemento com props:")
local el2 = {tag = "div", props = {class = "container"}, children = {}}
local str2 = fcst(el2)
print("   entrada: {tag='div', props={class='container'}, children={}}")
print("   saída:", str2)
assert(str2:find("div%("), "deveria começar com 'div('")
assert(str2:find("class"), "deveria conter 'class'")
print("   ✓ OK\n")

-- Teste 3: Elemento com children string
print("3. Elemento com children string:")
local el3 = {tag = "p", props = {}, children = {"texto aqui"}}
local str3 = fcst(el3)
print("   entrada: {tag='p', props={}, children={'texto aqui'}}")
print("   saída:", str3)
assert(str3:find("'texto aqui'"), "deveria conter string com aspas")
print("   ✓ OK\n")

-- Teste 4: Elemento com children número
print("4. Elemento com children número:")
local el4 = {tag = "num", props = {}, children = {42}}
local str4 = fcst(el4)
print("   entrada: {tag='num', props={}, children={42}}")
print("   saída:", str4)
assert(str4:find("42"), "deveria conter número 42")
print("   ✓ OK\n")

-- Teste 5: Elemento com children aninhado
print("5. Elemento com children aninhado:")
local el5 = {
    tag = "div", 
    props = {}, 
    children = {
        {tag = "span", props = {}, children = {"inner"}}
    }
}
local str5 = fcst(el5)
print("   entrada: div com span aninhado")
print("   saída:", str5)
assert(str5:find("div%("), "deveria conter 'div('")
assert(str5:find("span%("), "deveria conter 'span(' aninhado")
print("   ✓ OK\n")

-- Teste 6: Elemento com múltiplos children
print("6. Elemento com múltiplos children:")
local el6 = {tag = "lista", props = {}, children = {1, 2, 3, "fim"}}
local str6 = fcst(el6)
print("   entrada: {tag='lista', props={}, children={1, 2, 3, 'fim'}}")
print("   saída:", str6)
assert(str6:find("%[1%]"), "deveria conter índice [1]")
assert(str6:find("%[4%]"), "deveria conter índice [4]")
print("   ✓ OK\n")

-- Teste 7: Props nil
print("7. Elemento com props nil:")
local el7 = {tag = "vazio", props = nil, children = {}}
local str7 = fcst(el7)
print("   entrada: {tag='vazio', props=nil, children={}}")
print("   saída:", str7)
assert(str7:find("vazio%("), "deveria funcionar com props nil")
print("   ✓ OK\n")

print("=== TODOS OS TESTES PASSARAM ===")
