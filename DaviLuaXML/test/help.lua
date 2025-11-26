--[[
    Testes do módulo help.lua
    
    O módulo help fornece documentação sobre o uso do DaviLuaXML.
    Suporta múltiplos idiomas: en, pt, es.
]]


_G.log = _G.log or require("loglua")
local logTest = log.inSection("tests")

logTest("=== TESTE: help.lua ===\n")

local help = require("DaviLuaXML.help")

local passed = 0
local failed = 0

local function test(name, fn)
    logTest(string.format("%d. %s:", passed + failed + 1, name))
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        logTest("   ✓ OK\n")
    else
        failed = failed + 1
        logTest("   ✗ FALHOU: " .. tostring(err) .. "\n")
    end
end

-- Teste 1: Módulo carrega corretamente
test("Módulo carrega corretamente", function()
    assert(help ~= nil, "help não deveria ser nil")
    assert(type(help) == "table", "help deveria ser tabela")
end)

-- Teste 2: Possui tópicos em inglês
test("Possui tópicos em inglês", function()
    assert(help.en ~= nil, "help.en não deveria ser nil")
    assert(help.en.general ~= nil, "tópico 'general' deveria existir")
    assert(help.en.syntax ~= nil, "tópico 'syntax' deveria existir")
    assert(help.en.parser ~= nil, "tópico 'parser' deveria existir")
end)

-- Teste 3: Possui tópicos em português
test("Possui tópicos em português", function()
    assert(help.pt ~= nil, "help.pt não deveria ser nil")
    assert(help.pt.geral ~= nil, "tópico 'geral' deveria existir")
    assert(help.pt.sintaxe ~= nil, "tópico 'sintaxe' deveria existir")
end)

-- Teste 4: Possui tópicos em espanhol
test("Possui tópicos em espanhol", function()
    assert(help.es ~= nil, "help.es não deveria ser nil")
    assert(help.es.general ~= nil, "tópico 'general' deveria existir")
    assert(help.es.sintaxis ~= nil, "tópico 'sintaxis' deveria existir")
end)

-- Teste 5: Função list existe
test("Função list existe", function()
    assert(type(help.list) == "function", "list deveria ser função")
end)

-- Teste 6: Função show existe
test("Função show existe", function()
    assert(type(help.show) == "function", "show deveria ser função")
end)

-- Teste 7: Função lang existe
test("Função lang existe", function()
    assert(type(help.lang) == "function", "lang deveria ser função")
end)

-- Teste 8: Metatable permite chamar como função
test("Pode ser chamado como função", function()
    -- Capturar output
    local oldPrint = print
    local output = {}
    ---@diagnostic disable-next-line: duplicate-set-field
    print = function(...) 
        table.insert(output, table.concat({...}, "\t"))
    end
    
    help("general")
    
    print = oldPrint
    
    assert(#output > 0, "deveria produzir output")
    assert(output[1]:find("DaviLuaXML"), "output deveria mencionar DaviLuaXML")
end)

-- Teste 9: Mudar idioma funciona
test("Mudar idioma funciona", function()
    local ok = help.lang("pt")
    assert(ok == true, "lang('pt') deveria retornar true")
    assert(help.currentLang == "pt", "currentLang deveria ser 'pt'")
    
    ok = help.lang("es")
    assert(ok == true, "lang('es') deveria retornar true")
    assert(help.currentLang == "es", "currentLang deveria ser 'es'")
    
    ok = help.lang("en")
    assert(ok == true, "lang('en') deveria retornar true")
    assert(help.currentLang == "en", "currentLang deveria ser 'en'")
end)

-- Teste 10: Idioma inválido retorna erro
test("Idioma inválido retorna erro", function()
    local ok, err = help.lang("invalid")
    assert(ok == false, "lang('invalid') deveria retornar false")
    assert(err ~= nil, "deveria retornar mensagem de erro")
end)

-- Teste 11: Tópico inexistente mostra lista
test("Tópico inexistente mostra lista", function()
    local oldPrint = print
    local output = {}
    ---@diagnostic disable-next-line: duplicate-set-field
    print = function(...) 
        table.insert(output, table.concat({...}, "\t"))
    end
    
    help("topico_inexistente_xyz")
    
    print = oldPrint
    
    local found = false
    for _, line in ipairs(output) do
        if line:find("not found") or line:find("nao encontrado") or line:find("no encontrado") then
            found = true
            break
        end
    end
    assert(found, "deveria indicar tópico não encontrado")
end)

-- Teste 12: Todos os tópicos principais existem em inglês
test("Todos os tópicos principais existem em inglês", function()
    local expected = {"general", "syntax", "parser", "transform", "elements", "props", "errors", "core", "init"}
    for _, topic in ipairs(expected) do
        assert(help.en[topic] ~= nil, "tópico '" .. topic .. "' deveria existir em inglês")
    end
end)

-- Teste 13: Tópicos contêm conteúdo
test("Tópicos contêm conteúdo", function()
    for name, content in pairs(help.en) do
        assert(type(content) == "string", name .. " deveria ser string")
        assert(#content > 100, name .. " deveria ter conteúdo substancial")
    end
end)

logTest(string.rep("=", 50))
logTest(string.format("Resultado: %d passaram, %d falharam", passed, failed))
logTest(string.rep("=", 50))

if failed > 0 then
    logTest("\n=== ALGUNS TESTES FALHARAM ===")
    log.show("tests")
    os.exit(1)
else
    logTest("\n=== TODOS OS TESTES PASSARAM ===")
    log.show("tests")
end
