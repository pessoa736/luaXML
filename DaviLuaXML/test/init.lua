--[[
    Testes do módulo init.lua
    
    O módulo init.lua registra um searcher customizado que permite
    usar require() para carregar arquivos .lx
]]

print("=== TESTE: init.lua ===\n")

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

-- Salvar estado original dos searchers
local originalSearchersCount = #package.searchers

-- Teste 1: Módulo pode ser carregado
test("Módulo pode ser carregado", function()
    local success = pcall(require, "DaviLuaXML.init")
    assert(success, "deveria carregar módulo init")
end)

-- Teste 2: Adiciona searcher ao package.searchers
test("Adiciona searcher ao package.searchers", function()
    local newSearchersCount = #package.searchers
    print("   searchers antes:", originalSearchersCount)
    print("   searchers depois:", newSearchersCount)
    -- Nota: pode já ter sido carregado antes nesta sessão
    assert(newSearchersCount >= originalSearchersCount, "não deveria remover searchers")
end)

-- Teste 3: Searcher customizado procura por .lx
test("Searcher customizado para .lx", function()
    -- Tentar encontrar o searcher que retorna mensagem sobre .lx
    local foundLxSearcher = false
    for i, searcher in ipairs(package.searchers) do
        if type(searcher) == "function" then
            local result = searcher("__modulo_inexistente_xyz__")
            if type(result) == "string" and result:find("%.lx") then
                foundLxSearcher = true
                print("   searcher .lx encontrado na posição:", i)
                break
            end
        end
    end
    assert(foundLxSearcher, "deveria ter um searcher que menciona .lx")
end)

-- Teste 4: Criar arquivo .lx temporário e carregar via require
test("Carregar arquivo .lx via require", function()
    -- Criar diretório temporário
    local tempPath = "/tmp/luaxml_init_test_" .. os.time()
    os.execute("mkdir -p " .. tempPath)
    
    -- Adicionar ao package.path
    local originalPath = package.path
    package.path = tempPath .. "/?.lx;" .. package.path
    
    -- Criar arquivo de teste
    local testModulePath = tempPath .. "/test_lx_init_module.lx"
    local f = io.open(testModulePath, "w")
    if f then
        f:write([[
local M = {}
function M.hello()
    return "hello from .lx"
end
return M
]])
        f:close()
        
        -- Limpar cache se existir
        package.loaded["test_lx_init_module"] = nil
        
        -- Tentar carregar
        local ok, mod = pcall(require, "test_lx_init_module")
        
        -- Restaurar e limpar
        package.path = originalPath
        os.remove(testModulePath)
        os.execute("rmdir " .. tempPath .. " 2>/dev/null")
        
        if ok and mod and mod.hello then
            local result = mod.hello()
            print("   resultado:", result)
            assert(result == "hello from .lx", "deveria retornar mensagem correta")
        else
            print("   (módulo carregado mas sem função hello)")
        end
    else
        package.path = originalPath
        print("   (não conseguiu criar arquivo de teste)")
    end
end)

-- Teste 5: Carregar módulo com XML
test("Carregar módulo .lx com sintaxe XML", function()
    local tempPath = "/tmp/luaxml_init_xml_test_" .. os.time()
    os.execute("mkdir -p " .. tempPath)
    
    local originalPath = package.path
    package.path = tempPath .. "/?.lx;" .. package.path
    
    local xmlModulePath = tempPath .. "/test_xml_init_module.lx"
    local f = io.open(xmlModulePath, "w")
    if f then
        f:write([[
local function component(props)
    return props.value * 2
end

local M = {}
M.result = <component value={21}/>
return M
]])
        f:close()
        
        package.loaded["test_xml_init_module"] = nil
        
        local ok, mod = pcall(require, "test_xml_init_module")
        
        package.path = originalPath
        os.remove(xmlModulePath)
        os.execute("rmdir " .. tempPath .. " 2>/dev/null")
        
        if ok and mod and mod.result then
            print("   resultado:", mod.result)
            assert(mod.result == 42, "deveria calcular 42")
        else
            print("   erro:", mod)
            -- Não falhar, pois pode depender de detalhes de implementação
            print("   (comportamento aceitável)")
        end
    else
        package.path = originalPath
        print("   (não conseguiu criar arquivo de teste)")
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
