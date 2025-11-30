local middleware = require("DaviLuaXML.middleware")

local function serializePropValue(v)
    if type(v) == "table" and v.__luaexpr then
        return v.code
    elseif type(v) == "string" then
        local s = tostring(v):gsub("'", "\\'")
        return "'" .. s .. "'"
    elseif type(v) == "number" or type(v) == "boolean" then
        return tostring(v)
    elseif type(v) == "table" then
        local parts = {}
        for k, val in pairs(v) do
            local key = type(k) == "string" and k or ("[" .. k .. "]")
            table.insert(parts, key .. " = " .. serializePropValue(val))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else
        return tostring(v)
    end
end

local fcst

local function serializeChild(ch)
    if type(ch) == "table" and ch.__luaexpr then
        return ch.code
    elseif type(ch) == "table" and ch.tag then
        return fcst(ch)
    elseif type(ch) == "string" then
        local s = tostring(ch):gsub("'", "\\'")
        return "'" .. s .. "'"
    else
        return tostring(ch)
    end
end

local function propsToString(props, element)
    if not props or next(props) == nil then return "{}" end
    local parts = {}
    for k, v in pairs(props) do
        local key = tostring(k)
        local ctx = { key = k, tag = (element and (element.tag or element.name)), props = props }
        local newv = middleware.runProp(v, ctx)
        table.insert(parts, key .. " = " .. serializePropValue(newv))
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end

local function childrenToString(children, element)
    if not children or #children == 0 then return "{}" end
    local parts = {}
    for i = 1, #children do
        local ctx = { index = i, tag = (element and (element.tag or element.name)), parent = element }
        local newch = middleware.runChild(children[i], ctx)
        local val = serializeChild(newch)
        table.insert(parts, "[" .. i .. "] = " .. val)
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

fcst = function(element)
    local tag = element.tag or element.name or "unknown"
    local props = element.props or element.attrs or {}
    local children = element.children or {}

    local propsStr = propsToString(props, element)
    local childrenStr = childrenToString(children, element)

    return tag .. "(" .. propsStr .. ", " .. childrenStr .. ")"
end

return fcst
-- DaviLuaXML Function Call to String Transformer (fcst)
--
-- Converte um elemento parseado em uma string de chamada de função Lua.
-- Trata wrappers de expressão (`{ __luaexpr = true, code = "..." }`) como código cru.

local middleware = require("DaviLuaXML.middleware")

local function serializePropValue(v)
    if type(v) == "table" and v.__luaexpr then
        return v.code
    elseif type(v) == "string" then
        -- usar aspas simples no formato esperado pelos testes; escapar aspas simples internas
        local s = tostring(v):gsub("'", "\\'")
        return "'" .. s .. "'"
    elseif type(v) == "number" or type(v) == "boolean" then
        return tostring(v)
    elseif type(v) == "table" then
        local parts = {}
        for k, val in pairs(v) do
            local key = type(k) == "string" and k or ("[" .. k .. "]")
            table.insert(parts, key .. " = " .. serializePropValue(val))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else
        return tostring(v)
    end
end

local fcst -- ficará definida depois para suportar recursão

local function serializeChild(ch)
    if type(ch) == "table" and ch.__luaexpr then
        return ch.code
    elseif type(ch) == "table" and ch.tag then
        return fcst(ch)
    elseif type(ch) == "string" then
        local s = tostring(ch):gsub("'", "\\'")
        return "'" .. s .. "'"
    else
        return tostring(ch)
    end
end

local function propsToString(props, element)
    if not props or next(props) == nil then return "{}" end
    local parts = {}
    for k, v in pairs(props) do
        local key = tostring(k)
        local ctx = { key = k, tag = (element and (element.tag or element.name)), props = props }
        local newv = middleware.runProp(v, ctx)
        table.insert(parts, key .. " = " .. serializePropValue(newv))
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end

local function childrenToString(children, element)
    if not children or #children == 0 then return "{}" end
    local parts = {}
    for i = 1, #children do
        local ctx = { index = i, tag = (element and (element.tag or element.name)), parent = element }
        local newch = middleware.runChild(children[i], ctx)
        local val = serializeChild(newch)
        table.insert(parts, "[" .. i .. "] = " .. val)
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

fcst = function(element)
    local tag = element.tag or element.name or "unknown"
    local props = element.props or element.attrs or {}
    local children = element.children or {}

    local propsStr = propsToString(props, element)
    local childrenStr = childrenToString(children, element)

    return tag .. "(" .. propsStr .. ", " .. childrenStr .. ")"
end

return fcst
-- DaviLuaXML Function Call to String Transformer (fcst)
--
-- Converte um elemento parseado em uma string de chamada de função Lua.
-- Trata wrappers de expressão (`{ __luaexpr = true, code = "..." }`) como código cru.

local middleware = require("DaviLuaXML.middleware")

local function serializePropValue(v)
    if type(v) == "table" and v.__luaexpr then
        return v.code
    elseif type(v) == "string" then
        -- usar aspas simples no formato esperado pelos testes; escapar aspas simples internas
        local s = tostring(v):gsub("'", "\\'")
        return "'" .. s .. "'"
    elseif type(v) == "number" or type(v) == "boolean" then
        return tostring(v)
    elseif type(v) == "table" then
        local parts = {}
        for k, val in pairs(v) do
            local key = type(k) == "string" and k or ("[" .. k .. "]")
            table.insert(parts, key .. " = " .. serializePropValue(val))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else
        return tostring(v)
    end
end

local fcst -- ficará definida depois para suportar recursão

local function serializeChild(ch)
    if type(ch) == "table" and ch.__luaexpr then
        return ch.code
    elseif type(ch) == "table" and ch.tag then
        return fcst(ch)
    elseif type(ch) == "string" then
        local s = tostring(ch):gsub("'", "\\'")
        return "'" .. s .. "'"
    else
        return tostring(ch)
    end
end

local function propsToString(props, element)
    if not props or next(props) == nil then return "{}" end
    local parts = {}
    for k, v in pairs(props) do
        local key = tostring(k)
        local ctx = { key = k, tag = (element and (element.tag or element.name)), props = props }
        local newv = middleware.runProp(v, ctx)
        table.insert(parts, key .. " = " .. serializePropValue(newv))
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end

local function childrenToString(children, element)
    if not children or #children == 0 then return "{}" end
    local parts = {}
    for i = 1, #children do
        local ctx = { index = i, tag = (element and (element.tag or element.name)), parent = element }
        local newch = middleware.runChild(children[i], ctx)
        local val = serializeChild(newch)
        table.insert(parts, "[" .. i .. "] = " .. val)
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

fcst = function(element)
    local tag = element.tag or element.name or "unknown"
    local props = element.props or element.attrs or {}
    local children = element.children or {}

    local propsStr = propsToString(props, element)
    local childrenStr = childrenToString(children, element)

    return tag .. "(" .. propsStr .. ", " .. childrenStr .. ")"
end

return fcst
--[[
    DaviLuaXML Function Call to String Transformer (fcst)
    ==================================================

    Converte um elemento parseado em uma string de chamada de função Lua.

    Esta implementação trata wrappers de expressão gerados pelo parser
    -- DaviLuaXML Function Call to String Transformer (fcst)
    --
    -- Converte um elemento parseado em uma string de chamada de função Lua.
    -- Trata wrappers de expressão (`{ __luaexpr = true, code = "..." }`) como código cru.

    local fcst -- será definida abaixo
    local middleware = require("DaviLuaXML.middleware")

    local function serializePropValue(v)
        if type(v) == "table" and v.__luaexpr then
            return v.code
        elseif type(v) == "string" then
            --[[
                DaviLuaXML Function Call to String Transformer (fcst)
                ==================================================

                Converte um elemento parseado em uma string de chamada de função Lua.

                Esta implementação trata wrappers de expressão gerados pelo parser
                (`{ __luaexpr = true, code = "..." }`) como código cru: a string
                `code` é passada adiante sem aspas para ser avaliada apenas quando o
                código transformado for executado.
            ]]

            local fcst -- será definida abaixo

            local function serializePropValue(v)
                if type(v) == "table" and v.__luaexpr then
                    return v.code
                elseif type(v) == "string" then
                    return string.format("%q", v)
                elseif type(v) == "number" or type(v) == "boolean" then
                    return tostring(v)
                elseif type(v) == "table" then
                    local parts = {}
                    for k, val in pairs(v) do
                        local key = type(k) == "string" and k or ("[" .. k .. "]")
                        table.insert(parts, key .. " = " .. serializePropValue(val))
                    end
                    return "{" .. table.concat(parts, ", ") .. "}"
                else
                    return tostring(v)
                end
            end

            local function serializeChild(ch)
                if type(ch) == "table" and ch.__luaexpr then
                    return ch.code
                elseif type(ch) == "table" and ch.tag then
                    return fcst(ch)
                elseif type(ch) == "string" then
                    -- usar aspas simples no formato esperado pelos testes; escapar aspas simples internas
                    local s = tostring(ch):gsub("'", "\\'")
                    return "'" .. s .. "'"
                else
                    return tostring(ch)
                end
            end

            local function propsToString(props, element)
                if not props or next(props) == nil then return "{}" end
                local parts = {}
                for k, v in pairs(props) do
                    local key = tostring(k)
                    -- permitir middlewares transformarem o valor antes da serialização
                    local ctx = { key = k, tag = (element and (element.tag or element.name)), props = props }
                    local newv = middleware.runProp(v, ctx)
                    table.insert(parts, key .. " = " .. serializePropValue(newv))
                end
                return "{" .. table.concat(parts, ", ") .. "}"
            end

            local function childrenToString(children, element)
                if not children or #children == 0 then return "{}" end
                local parts = {}
                for i = 1, #children do
                    local ctx = { index = i, tag = (element and (element.tag or element.name)), parent = element }
                    local newch = middleware.runChild(children[i], ctx)
                    local val = serializeChild(newch)
                    table.insert(parts, "[" .. i .. "] = " .. val)
                end
                return "{" .. table.concat(parts, ",") .. "}"
            end

            fcst = function(element)
                local tag = element.tag or element.name or "unknown"
                local props = element.props or element.attrs or {}
                local children = element.children or {}

                local propsStr = propsToString(props, element)
                local childrenStr = childrenToString(children, element)

                return tag .. "(" .. propsStr .. ", " .. childrenStr .. ")"
            end

            return fcst