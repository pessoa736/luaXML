--[[
    Testes do módulo props.lua
    
    O módulo props converte entre tabelas Lua e strings de atributos XML.
]]

print("=== TESTE: props.lua ===\n")

local props = require("DaviLuaXML.props")

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

-- Teste 1: Tabela para string de props
test("tableToPropsString - básico", function()
    local input = { id = "btn1" }
    local s = props.tableToPropsString(input)
    assert(s:find('id="btn1"'), "deveria conter id=\"btn1\"")
end)

-- Teste 2: Múltiplos atributos
test("tableToPropsString - múltiplos atributos", function()
    local input = { id = "btn1", class = "primary" }
    local s = props.tableToPropsString(input)
    assert(s:find('id="btn1"'), "deveria conter id")
    assert(s:find('class="primary"'), "deveria conter class")
end)

-- Teste 3: Números são convertidos
test("tableToPropsString - números", function()
    local input = { count = 5 }
    local s = props.tableToPropsString(input)
    assert(s:find('count="5"'), "número deveria ser convertido para string")
end)

-- Teste 4: Booleanos são convertidos
test("tableToPropsString - booleanos", function()
    local input = { disabled = true }
    local s = props.tableToPropsString(input)
    assert(s:find('disabled="true"'), "booleano deveria ser convertido")
end)

-- Teste 5: String para tabela de props
test("stringToPropsTable - básico", function()
    local s = 'id="btn1"'
    local t = props.stringToPropsTable(s)
    assert(t.id == "btn1", "id deveria ser 'btn1'")
end)

-- Teste 6: Conversão de tipos
test("stringToPropsTable - conversão de tipos", function()
    local s = 'count="5" active="true" name="teste"'
    local t = props.stringToPropsTable(s)
    assert(t.count == 5, "count deveria ser número 5")
    assert(t.active == true, "active deveria ser booleano true")
    assert(t.name == "teste", "name deveria ser string 'teste'")
end)

-- Teste 7: Valores false
test("stringToPropsTable - false", function()
    local s = 'visible="false"'
    local t = props.stringToPropsTable(s)
    assert(t.visible == false, "visible deveria ser false")
end)

-- Teste 8: Round-trip (tabela -> string -> tabela)
test("Round-trip conversion", function()
    local original = { x = 10, y = 20, enabled = true }
    local s = props.tableToPropsString(original)
    local result = props.stringToPropsTable(s)
    assert(result.x == 10, "x deveria ser 10")
    assert(result.y == 20, "y deveria ser 20")
    assert(result.enabled == true, "enabled deveria ser true")
end)

-- Teste 9: Tabela vazia
test("tableToPropsString - tabela vazia", function()
    local s = props.tableToPropsString({})
    assert(s == "" or s:match("^%s*$"), "tabela vazia deveria gerar string vazia")
end)

-- Teste 10: String vazia
test("stringToPropsTable - string vazia", function()
    local t = props.stringToPropsTable("")
    assert(type(t) == "table", "deveria retornar tabela")
    assert(next(t) == nil, "tabela deveria estar vazia")
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