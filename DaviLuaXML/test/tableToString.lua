--[[
    Testes do módulo tableToString.lua
]]

local tableToString = require("DaviLuaXML.tableToString")

print("=== TESTE: tableToString.lua ===\n")

-- Teste 1: Tabela simples
print("1. Tabela simples:")
local t1 = {a = 1, b = 2}
local str1 = tableToString(t1)
print("   entrada: {a = 1, b = 2}")
print("   saída:", str1:gsub("\n", " "))
assert(str1:find("a = 1"), "deveria conter 'a = 1'")
assert(str1:find("b = 2"), "deveria conter 'b = 2'")
print("   ✓ OK\n")

-- Teste 2: Tabela com string
print("2. Tabela com string:")
local t2 = {nome = "teste"}
local str2 = tableToString(t2)
print("   entrada: {nome = 'teste'}")
print("   saída:", str2:gsub("\n", " "))
assert(str2:find("'teste'"), "deveria conter string com aspas")
print("   ✓ OK\n")

-- Teste 3: Tabela aninhada
print("3. Tabela aninhada:")
local t3 = {outer = {inner = 1}}
local str3 = tableToString(t3)
print("   entrada: {outer = {inner = 1}}")
print("   saída:", str3:gsub("\n", " "))
assert(str3:find("inner"), "deveria conter tabela aninhada")
print("   ✓ OK\n")

-- Teste 4: Sem formatação (n = false)
print("4. Sem formatação (compacto):")
local t4 = {x = 10, y = 20}
local str4 = tableToString(t4, false)
print("   entrada: {x = 10, y = 20}")
print("   saída:", str4)
assert(not str4:find("\n"), "não deveria conter quebras de linha")
print("   ✓ OK\n")

-- Teste 5: Tabela vazia
print("5. Tabela vazia:")
local t5 = {}
local str5 = tableToString(t5)
print("   entrada: {}")
print("   saída:", str5:gsub("\n", ""))
assert(str5:find("{") and str5:find("}"), "deveria ter chaves")
print("   ✓ OK\n")

-- Teste 6: Booleanos
print("6. Tabela com booleanos:")
local t6 = {ativo = true, visivel = false}
local str6 = tableToString(t6)
print("   entrada: {ativo = true, visivel = false}")
print("   saída:", str6:gsub("\n", " "))
assert(str6:find("true"), "deveria conter 'true'")
assert(str6:find("false"), "deveria conter 'false'")
print("   ✓ OK\n")

print("=== TODOS OS TESTES PASSARAM ===")
