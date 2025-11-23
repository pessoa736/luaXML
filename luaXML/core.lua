local parser = require("luaXML.parser")
local readFile = require("luaXML.readFile")
local fcst = require("luaXML.functionCallToStringTransformer")

return function(file)
    local code = readFile(file)
    local firstTagStart = code:find("<[%w_]+")
    if not firstTagStart then
        return code, "Nenhuma tag encontrada"
    end

    local element, relStart, relEnd = parser(code:sub(firstTagStart))
    if not element then
        return nil, relStart
    end

    -- localizar toda a tag (auto-fechada ou com fechamento) para substituição
    local openStart, openEnd, tagName, attrs, selfClosed = code:find("<([%w_]+)%s*(.-)(/?)>", firstTagStart)
    if not openStart then
        return nil, "Falha ao localizar abertura da tag"
    end
    local tagEnd
    if selfClosed == "/" then
        tagEnd = openEnd
    else
        local closeStart, closeEnd = code:find("</" .. tagName .. "%s*>", openEnd + 1)
        if not closeEnd then
            return nil, "Fechamento da tag não encontrado"
        end
        tagEnd = closeEnd
    end

    local callStr = fcst(element)
    local transformed = code:sub(1, openStart - 1) .. callStr .. code:sub(tagEnd + 1)

    -- executar código transformado
    local chunk, loadErr = load(transformed, file)
    if not chunk then
        return nil, "Erro ao compilar código transformado: " .. tostring(loadErr)
    end
    local ok, runErr = pcall(chunk)
    if not ok then
        return nil, "Erro ao executar código transformado: " .. tostring(runErr)
    end

    return transformed
end