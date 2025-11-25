--[[
    Testes do módulo help.lua
    
    O módulo help fornece documentação sobre o uso do DaviLuaXML.
]]

print("=== TESTE: help.lua ===\n")

local help = require("DaviLuaXML.help")

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

-- Teste 1: Módulo carrega corretamente
test("Módulo carrega corretamente", function()
    assert(help ~= nil, "help não deveria ser nil")
    assert(type(help) == "table", "help deveria ser tabela")
end)

-- Teste 2: Possui tópicos
test("Possui tópicos de ajuda", function()
    assert(help.topics ~= nil, "topics não deveria ser nil")
    assert(help.topics.geral ~= nil, "tópico 'geral' deveria existir")
    assert(help.topics.sintaxe ~= nil, "tópico 'sintaxe' deveria existir")
    assert(help.topics.parser ~= nil, "tópico 'parser' deveria existir")
end)

-- Teste 3: Função list existe
test("Função list existe", function()
    assert(type(help.list) == "function", "list deveria ser função")
end)

-- Teste 4: Função show existe
test("Função show existe", function()
    assert(type(help.show) == "function", "show deveria ser função")
end)

-- Teste 5: Metatable permite chamar como função
test("Pode ser chamado como função", function()
    -- Capturar output
    local oldPrint = print
    local output = {}
    print = function(...) 
        table.insert(output, table.concat({...}, "\t"))
    end
    
    help("geral")
    
    print = oldPrint
    
    assert(#output > 0, "deveria produzir output")
    assert(output[1]:find("DaviLuaXML"), "output deveria mencionar DaviLuaXML")
end)

-- Teste 6: Tópico inexistente mostra lista
test("Tópico inexistente mostra lista", function()
    local oldPrint = print
    local output = {}
    print = function(...) 
        table.insert(output, table.concat({...}, "\t"))
    end
    
    help("topico_inexistente_xyz")
    
    print = oldPrint
    
    local found = false
    for _, line in ipairs(output) do
        if line:find("nao encontrado") or line:find("disponiveis") or line:find("Topico") then
            found = true
            break
        end
    end
    assert(found, "deveria indicar tópico não encontrado ou listar disponíveis")
end)

-- Teste 7: Tópico sem argumento mostra geral
test("Sem argumento mostra ajuda geral", function()
    local oldPrint = print
    local output = {}
    print = function(...) 
        table.insert(output, table.concat({...}, "\t"))
    end
    
    help()
    
    print = oldPrint
    
    assert(#output > 0, "deveria produzir output")
end)

-- Teste 8: Todos os tópicos principais existem
test("Todos os tópicos principais existem", function()
    local expected = {"geral", "sintaxe", "parser", "transform", "elements", "props", "errors", "core", "init"}
    for _, topic in ipairs(expected) do
        assert(help.topics[topic] ~= nil, "tópico '" .. topic .. "' deveria existir")
    end
end)

-- Teste 9: Tópicos contêm conteúdo
test("Tópicos contêm conteúdo", function()
    for name, content in pairs(help.topics) do
        assert(type(content) == "string", name .. " deveria ser string")
        assert(#content > 100, name .. " deveria ter conteúdo substancial")
    end
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
