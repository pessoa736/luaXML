--[[
    DaviLuaXML Errors
    ==============
    
    Módulo utilitário para formatação de mensagens de erro.
    Fornece funções para criar mensagens de erro informativas
    com contexto de linha e posição.
--]]

local M = {}

--- Conta o número da linha para uma posição no código.
--- @param code string Código fonte
--- @param pos number Posição no código
--- @return number Número da linha
--- @return number Coluna na linha
function M.getLineInfo(code, pos)
    local line = 1
    local lastNewline = 0
    
    for i = 1, pos do
        if code:sub(i, i) == "\n" then
            line = line + 1
            lastNewline = i
        end
    end
    
    local col = pos - lastNewline
    return line, col
end

--- Extrai uma linha específica do código.
--- @param code string Código fonte
--- @param lineNum number Número da linha
--- @return string Conteúdo da linha
function M.getLine(code, lineNum)
    local currentLine = 1
    local lineStart = 1
    
    for i = 1, #code do
        if currentLine == lineNum then
            local lineEnd = code:find("\n", i) or #code + 1
            return code:sub(i, lineEnd - 1)
        end
        if code:sub(i, i) == "\n" then
            currentLine = currentLine + 1
            lineStart = i + 1
        end
    end
    
    return ""
end

--- Formata uma mensagem de erro com contexto.
--- @param message string Mensagem de erro
--- @param code string|nil Código fonte (opcional)
--- @param pos number|nil Posição no código (opcional)
--- @param filename string|nil Nome do arquivo (opcional)
--- @return string Mensagem formatada
function M.format(message, code, pos, filename)
    local parts = { "[DaviLuaXML] " }
    
    if filename then
        table.insert(parts, filename .. ": ")
    end
    
    if code and pos then
        local line, col = M.getLineInfo(code, pos)
        table.insert(parts, string.format("linha %d, coluna %d: ", line, col))
    end
    
    table.insert(parts, message)
    
    -- Adicionar preview da linha se possível
    if code and pos then
        local line = M.getLineInfo(code, pos)
        local lineContent = M.getLine(code, line)
        if lineContent and lineContent ~= "" then
            table.insert(parts, "\n  > " .. lineContent:gsub("^%s+", ""))
        end
    end
    
    return table.concat(parts)
end

--- Cria erro de tag não fechada.
--- @param tagName string Nome da tag
--- @param code string|nil Código fonte
--- @param pos number|nil Posição da abertura
--- @param filename string|nil Nome do arquivo
--- @return string Mensagem de erro
function M.unclosedTag(tagName, code, pos, filename)
    return M.format(
        string.format("tag '<%s>' não foi fechada. Use '</%s>' para fechar.", tagName, tagName),
        code, pos, filename
    )
end

--- Cria erro de tag inválida.
--- @param code string|nil Código fonte
--- @param pos number|nil Posição
--- @param filename string|nil Nome do arquivo
--- @return string Mensagem de erro
function M.invalidTag(code, pos, filename)
    return M.format("tag de abertura inválida ou malformada", code, pos, filename)
end

--- Cria erro de atributo inválido.
--- @param attrName string Nome do atributo
--- @param code string|nil Código fonte
--- @param pos number|nil Posição
--- @param filename string|nil Nome do arquivo
--- @return string Mensagem de erro
function M.invalidAttribute(attrName, code, pos, filename)
    return M.format(
        string.format("atributo '%s' com valor inválido", attrName),
        code, pos, filename
    )
end

--- Cria erro de expressão inválida em chaves.
--- @param expr string Expressão
--- @param luaError string Erro do Lua
--- @param filename string|nil Nome do arquivo
--- @return string Mensagem de erro
function M.invalidExpression(expr, luaError, filename)
    local msg = string.format("expressão inválida '{%s}': %s", expr, luaError)
    return M.format(msg, nil, nil, filename)
end

--- Cria erro de compilação.
--- @param luaError string Erro do load()
--- @param filename string|nil Nome do arquivo
--- @return string Mensagem de erro
function M.compilationError(luaError, filename)
    return M.format("erro ao compilar código transformado: " .. luaError, nil, nil, filename)
end

--- Cria erro de execução.
--- @param luaError string Erro do pcall()
--- @param filename string|nil Nome do arquivo
--- @return string Mensagem de erro
function M.runtimeError(luaError, filename)
    return M.format("erro ao executar: " .. luaError, nil, nil, filename)
end

return M
