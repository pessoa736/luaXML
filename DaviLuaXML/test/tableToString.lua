--[[
    Testes do módulo tableToString.lua
]]


_G.log = _G.log or require("loglua")
local logTest = log.inSection("tableToString")

local tableToString = require("DaviLuaXML.tableToString")

logTest("=== TESTE: tableToString.lua ===")

-- Teste 1: Tabela simples
logTest("1. Tabela simples:")
local t1 = {a = 1, b = 2}
local str1 = tableToString(t1)
logTest("   entrada: {a = 1, b = 2}")
logTest("   saída:", str1:gsub("\n", " "))
assert(str1:find("a = 1"), "deveria conter 'a = 1'")
assert(str1:find("b = 2"), "deveria conter 'b = 2'")
logTest("   ✓ OK")

-- Teste 2: Tabela com string
logTest("2. Tabela com string:")
local t2 = {nome = "teste"}
local str2 = tableToString(t2)
logTest("   entrada: {nome = 'teste'}")
logTest("   saída:", str2:gsub("\n", " "))
assert(str2:find("'teste'"), "deveria conter string com aspas")
logTest("   ✓ OK")

-- Teste 3: Tabela aninhada
logTest("3. Tabela aninhada:")
local t3 = {outer = {inner = 1}}
local str3 = tableToString(t3)
logTest("   entrada: {outer = {inner = 1}}")
logTest("   saída:", str3:gsub("\n", " "))
assert(str3:find("inner"), "deveria conter tabela aninhada")
logTest("   ✓ OK")

-- Teste 4: Sem formatação (n = false)
logTest("4. Sem formatação (compacto):")
local t4 = {x = 10, y = 20}
local str4 = tableToString(t4, false)
logTest("   entrada: {x = 10, y = 20}")
logTest("   saída:", str4)
assert(not str4:find("\n"), "não deveria conter quebras de linha")
logTest("   ✓ OK")

-- Teste 5: Tabela vazia
logTest("5. Tabela vazia:")
local t5 = {}
local str5 = tableToString(t5)
logTest("   entrada: {}")
logTest("   saída:", str5:gsub("\n", ""))
assert(str5:find("{") and str5:find("}"), "deveria ter chaves")
logTest("   ✓ OK")

-- Teste 6: Booleanos
logTest("6. Tabela com booleanos:")
local t6 = {ativo = true, visivel = false}
local str6 = tableToString(t6)
logTest("   entrada: {ativo = true, visivel = false}")
logTest("   saída:", str6:gsub("\n", " "))
assert(str6:find("true"), "deveria conter 'true'")
assert(str6:find("false"), "deveria conter 'false'")
logTest("   ✓ OK")

logTest("=== TODOS OS TESTES PASSARAM ===")
log.show()
