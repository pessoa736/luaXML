--[[
    DaviLuaXML Middleware
    =====================

    Pequeno gerenciador de middlewares para transformar/inspecionar
    `props` e `children` antes de serialização no transformer.

    API:
      - addProp(fn): registra um middleware para props. Assinatura: fn(value, ctx) -> newValue
      - addChild(fn): registra um middleware para children. Assinatura: fn(value, ctx) -> newValue
      - runProp(value, ctx): executa os middlewares de props em ordem
      - runChild(value, ctx): executa os middlewares de children em ordem
]]

local M = {
    _prop_middlewares = {},
    _child_middlewares = {},
}

function M.addProp(fn)
    table.insert(M._prop_middlewares, fn)
end

function M.addChild(fn)
    table.insert(M._child_middlewares, fn)
end

function M.runProp(value, ctx)
    local v = value
    for _, mw in ipairs(M._prop_middlewares) do
        local ok, res = pcall(mw, v, ctx)
        if ok and res ~= nil then
            v = res
        end
    end
    return v
end

function M.runChild(value, ctx)
    local v = value
    for _, mw in ipairs(M._child_middlewares) do
        local ok, res = pcall(mw, v, ctx)
        if ok and res ~= nil then
            v = res
        end
    end
    return v
end

return M
