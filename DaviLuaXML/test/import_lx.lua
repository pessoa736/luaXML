--[[
    Testes de importação de arquivos .lx via require
    
    Testa a integração completa do loader DaviLuaXML com o sistema require do Lua.
]]

print("=== TESTE: import_lx.lua ===\n")

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

-- Registrar o loader DaviLuaXML
test("Registrar loader DaviLuaXML", function()
    require("DaviLuaXML")
    -- Se não der erro, passou
    print("   loader registrado com sucesso")
end)

-- Teste: Carregar arquivo .lx via require
test("Carregar arquivo .lx via require", function()
    -- Limpar cache se existir
    package.loaded["DaviLuaXML.test.lx.1"] = nil
    
    -- Capturar output do arquivo
    local oldPrint = print
    local outputs = {}
    print = function(...)
        local args = {...}
        table.insert(outputs, table.concat(args, "\t"))
        oldPrint(...)
    end
    
    -- Carregar o arquivo
    require("DaviLuaXML.test.lx.1")
    
    -- Restaurar print
    print = oldPrint
    
    -- Verificar que executou (deve imprimir algo)
    assert(#outputs > 0, "arquivo deveria produzir output")
end)

-- Teste: Arquivo .lx pode ser recarregado
test("Recarregar arquivo .lx", function()
    package.loaded["DaviLuaXML.test.lx.1"] = nil
    
    local ok1 = pcall(require, "DaviLuaXML.test.lx.1")
    assert(ok1, "primeira carga deveria funcionar")
    
    -- Segunda chamada deve usar cache
    local ok2 = pcall(require, "DaviLuaXML.test.lx.1")
    assert(ok2, "segunda carga deveria funcionar (do cache)")
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