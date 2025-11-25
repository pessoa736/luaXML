--[[
    Testes do módulo transform.lua
]]

local transform = require("DaviLuaXML.transform").transform

print("=== TESTE: transform.lua ===\n")

-- Teste 1: Tag self-closing simples
print("1. Tag self-closing simples:")
local code1 = "<teste/>"
local result1 = transform(code1)
print("   entrada:", code1)
print("   saída:", result1)
assert(result1:find("teste%("), "deveria conter chamada de função 'teste('")
print("   ✓ OK\n")

-- Teste 2: Tag com atributos
print("2. Tag com atributos:")
local code2 = '<btn class="primary"/>'
local result2 = transform(code2)
print("   entrada:", code2)
print("   saída:", result2)
assert(result2:find("class"), "deveria conter atributo 'class'")
assert(result2:find("primary"), "deveria conter valor 'primary'")
print("   ✓ OK\n")

-- Teste 3: Tag com conteúdo texto
print("3. Tag com conteúdo texto:")
local code3 = "<p>ola mundo</p>"
local result3 = transform(code3)
print("   entrada:", code3)
print("   saída:", result3)
assert(result3:find("p%("), "deveria conter chamada 'p('")
assert(result3:find("ola mundo"), "deveria conter texto")
print("   ✓ OK\n")

-- Teste 4: Tag com expressão em chaves
print("4. Tag com expressão em chaves:")
local code4 = "<soma>{1}{2}{3}</soma>"
local result4 = transform(code4)
print("   entrada:", code4)
print("   saída:", result4)
assert(result4:find("1"), "deveria conter valor 1")
assert(result4:find("2"), "deveria conter valor 2")
assert(result4:find("3"), "deveria conter valor 3")
print("   ✓ OK\n")

-- Teste 5: Tags aninhadas
print("5. Tags aninhadas:")
local code5 = "<div><span>texto</span></div>"
local result5 = transform(code5)
print("   entrada:", code5)
print("   saída:", result5)
assert(result5:find("div%("), "deveria conter 'div('")
assert(result5:find("span%("), "deveria conter 'span('")
print("   ✓ OK\n")

-- Teste 6: Código misto (Lua + XML)
print("6. Código misto (Lua + XML):")
local code6 = "local x = 1\n<tag/>\nprint(x)"
local result6 = transform(code6)
print("   entrada:", code6:gsub("\n", "\\n"))
print("   saída:", result6:gsub("\n", "\\n"))
assert(result6:find("local x = 1"), "deveria manter código Lua")
assert(result6:find("tag%("), "deveria transformar tag")
assert(result6:find("print%(x%)"), "deveria manter print")
print("   ✓ OK\n")

-- Teste 7: Ignorar tags reservadas Lua
print("7. Ignorar tags reservadas Lua (<const>, <close>):")
local code7 = "local x <const> = 10"
local result7 = transform(code7)
print("   entrada:", code7)
print("   saída:", result7)
assert(result7 == code7, "deveria manter código inalterado")
print("   ✓ OK\n")

-- Teste 8: Tag com nome contendo ponto
print("8. Tag com nome contendo ponto:")
local code8 = '<html.div class="x"/>'
local result8 = transform(code8)
print("   entrada:", code8)
print("   saída:", result8)
assert(result8:find("html%.div%("), "deveria conter 'html.div('")
print("   ✓ OK\n")

-- Teste 9: Atributo com expressão
print("9. Atributo com expressão Lua:")
local code9 = "<comp valor={10 + 5}/>"
local result9 = transform(code9)
print("   entrada:", code9)
print("   saída:", result9)
assert(result9:find("valor"), "deveria conter atributo 'valor'")
print("   ✓ OK\n")

print("=== TODOS OS TESTES PASSARAM ===")
