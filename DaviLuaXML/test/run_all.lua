#!/usr/bin/env lua
--[[
    Runner de testes para o projeto DaviLuaXML
    
    Executa todos os arquivos de teste e reporta os resultados.
    
    Uso:
        lua DaviLuaXML/test/run_all.lua
        
    Ou com cd para o diretório do projeto:
        cd /caminho/para/DaviLuaXML
        lua DaviLuaXML/test/run_all.lua
]]

print("╔══════════════════════════════════════════════════╗")
print("║          DaviLuaXML - Suite de Testes                ║")
print("╚══════════════════════════════════════════════════╝\n")

-- Configurar package.path para encontrar os módulos
local scriptPath = arg[0]
local projectRoot = scriptPath:match("(.+)/DaviLuaXML/test/run_all%.lua$") or "."
package.path = projectRoot .. "/?.lua;" .. projectRoot .. "/?/init.lua;" .. package.path

-- Lista de arquivos de teste
local testFiles = {
    "parser",
    "props",
    "elements",
    "errors",
    "tableToString",
    "transform",
    "fcst",
    "readFile",
    "core",
    "init",
    "help",
    "callFunction",
    "import_lx"
}

local results = {
    passed = {},
    failed = {},
    skipped = {}
}

-- Função para executar um teste
local function runTest(name)
    io.write(string.format("\n▶ Executando: %s.lua\n", name))
    io.write(string.rep("-", 50) .. "\n")
    
    local testPath = projectRoot .. "/DaviLuaXML/test/" .. name .. ".lua"
    
    -- Verificar se arquivo existe
    local f = io.open(testPath, "r")
    if not f then
        print("   ⚠ Arquivo não encontrado: " .. testPath)
        table.insert(results.skipped, name)
        return
    end
    f:close()
    
    -- Executar teste em um processo separado para isolamento
    local cmd = string.format(
        'cd "%s" && lua "%s" 2>&1',
        projectRoot,
        testPath
    )
    
    local handle = io.popen(cmd)
    if not handle then
        print("   ✗ Falha ao executar")
        table.insert(results.failed, {name = name, error = "Falha ao executar comando"})
        return
    end
    
    local output = handle:read("*a")
    local success, exitType, exitCode = handle:close()
    
    -- Mostrar saída
    print(output)
    
    -- Verificar resultado
    if success or (exitType == "exit" and exitCode == 0) then
        table.insert(results.passed, name)
    else
        table.insert(results.failed, {
            name = name, 
            error = string.format("Código de saída: %s", tostring(exitCode or "desconhecido"))
        })
    end
end

-- Executar todos os testes
for _, testName in ipairs(testFiles) do
    runTest(testName)
end

-- Relatório final
print("\n")
print("╔══════════════════════════════════════════════════╗")
print("║                   RESULTADO                      ║")
print("╚══════════════════════════════════════════════════╝\n")

print(string.format("✓ Passaram:  %d testes", #results.passed))
for _, name in ipairs(results.passed) do
    print(string.format("    • %s", name))
end

if #results.skipped > 0 then
    print(string.format("\n⚠ Pulados:   %d testes", #results.skipped))
    for _, name in ipairs(results.skipped) do
        print(string.format("    • %s", name))
    end
end

if #results.failed > 0 then
    print(string.format("\n✗ Falharam:  %d testes", #results.failed))
    for _, result in ipairs(results.failed) do
        print(string.format("    • %s: %s", result.name, result.error))
    end
end

print("\n" .. string.rep("═", 52))
print(string.format("Total: %d passaram, %d pulados, %d falharam",
    #results.passed, #results.skipped, #results.failed))
print(string.rep("═", 52))

-- Código de saída
if #results.failed > 0 then
    os.exit(1)
else
    os.exit(0)
end
