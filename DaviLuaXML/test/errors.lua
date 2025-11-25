--[[
    Testes do módulo errors.lua
]]

local errors = require("DaviLuaXML.errors")

print("=== TESTE: errors.lua ===\n")

-- Teste 1: getLineInfo
print("1. Teste getLineInfo:")
local code = "linha1\nlinha2\nlinha3"
local line, col = errors.getLineInfo(code, 10) -- posição na linha 2
print("   código:", code:gsub("\n", "\\n"))
print("   posição 10 -> linha:", line, "coluna:", col)
assert(line == 2, "deveria ser linha 2")
print("   ✓ OK\n")

-- Teste 2: getLine
print("2. Teste getLine:")
local linha2 = errors.getLine(code, 2)
print("   linha 2:", linha2)
assert(linha2 == "linha2", "deveria retornar 'linha2'")
print("   ✓ OK\n")

-- Teste 3: format básico
print("3. Teste format básico:")
local msg = errors.format("erro de teste")
print("   mensagem:", msg)
assert(msg:find("%[DaviLuaXML%]"), "deveria conter [DaviLuaXML]")
print("   ✓ OK\n")

-- Teste 4: format com arquivo
print("4. Teste format com arquivo:")
local msg2 = errors.format("erro de teste", nil, nil, "arquivo.lx")
print("   mensagem:", msg2)
assert(msg2:find("arquivo.lx"), "deveria conter nome do arquivo")
print("   ✓ OK\n")

-- Teste 5: format com posição
print("5. Teste format com código e posição:")
local codigo = "local x = <tag>\nconteudo\n</tag>"
local msg3 = errors.format("tag inválida", codigo, 11, "teste.lx")
print("   mensagem:", msg3)
assert(msg3:find("linha"), "deveria conter 'linha'")
print("   ✓ OK\n")

-- Teste 6: unclosedTag
print("6. Teste unclosedTag:")
local msg4 = errors.unclosedTag("div", codigo, 11, "teste.lx")
print("   mensagem:", msg4)
assert(msg4:find("div"), "deveria conter nome da tag")
assert(msg4:find("</div>"), "deveria sugerir fechamento")
print("   ✓ OK\n")

-- Teste 7: invalidTag
print("7. Teste invalidTag:")
local msg5 = errors.invalidTag(codigo, 1, "teste.lx")
print("   mensagem:", msg5)
assert(msg5:find("inválida") or msg5:find("malformada"), "deveria indicar tag inválida")
print("   ✓ OK\n")

-- Teste 8: compilationError
print("8. Teste compilationError:")
local msg6 = errors.compilationError("unexpected symbol", "teste.lx")
print("   mensagem:", msg6)
assert(msg6:find("compilar"), "deveria mencionar compilação")
print("   ✓ OK\n")

-- Teste 9: runtimeError
print("9. Teste runtimeError:")
local msg7 = errors.runtimeError("nil value", "teste.lx")
print("   mensagem:", msg7)
assert(msg7:find("executar"), "deveria mencionar execução")
print("   ✓ OK\n")

print("=== TODOS OS TESTES PASSARAM ===")
