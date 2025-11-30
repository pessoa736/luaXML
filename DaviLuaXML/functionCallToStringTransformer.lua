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

            local function propsToString(props)
                if not props or next(props) == nil then return "{}" end
                local parts = {}
                for k, v in pairs(props) do
                    local key = tostring(k)
                    table.insert(parts, key .. " = " .. serializePropValue(v))
                end
                return "{" .. table.concat(parts, ", ") .. "}"
            end

            local function childrenToString(children)
                if not children or #children == 0 then return "{}" end
                local parts = {}
                for i = 1, #children do
                    local val = serializeChild(children[i])
                    table.insert(parts, "[" .. i .. "] = " .. val)
                end
                return "{" .. table.concat(parts, ",") .. "}"
            end

            fcst = function(element)
                local tag = element.tag or element.name or "unknown"
                local props = element.props or element.attrs or {}
                local children = element.children or {}

                local propsStr = propsToString(props)
                local childrenStr = childrenToString(children)

                return tag .. "(" .. propsStr .. ", " .. childrenStr .. ")"
            end

            return fcst