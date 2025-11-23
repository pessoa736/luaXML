local tokenizer = require("luaXML.tokenizer")
local insert = table.insert

local function trim(str)
  return (str:match("^%s*(.-)%s*$") or "")
end

local function leading_spaces(str)
  local prefix = str:match("^(%s*)")
  return prefix and #prefix or 0
end

local function parseElement(code, globalStart)
    globalStart = globalStart or 1

    local leading = leading_spaces(code)
    code = trim(code)
    globalStart = globalStart + leading

    -- captura tag de abertura
    local startTagInit, startTagEnd, name, attrs, selfClosed = code:find("^<([%w_]+)%s*(.-)(/?)>")

    if not name then
        return nil, "Tag de abertura inválida"
    end


    -- nó base
    local node = {
        name = name,
        attrs = attrs ~= "" and attrs or nil,
        children = {}
    }

    local absoluteStart = globalStart + startTagInit - 1
    local absoluteEnd = globalStart + startTagEnd - 1

    -- se for <test .../>
    if selfClosed == "/" then
        return tokenizer(node.name, node.attrs, {}), absoluteStart, absoluteEnd
    end

    -- agora precisamos achar o fechamento correspondente
    local i = startTagEnd + 1
    local depth = 0
    local contentStart = i

    while true do
        -- acha próxima abertura ou fechamento
        local nextOpen = code:find("<"..name.."%f[^%w_][^/]", i)
        local nextClose = code:find("</"..name.."%s*>", i)

        if not nextClose then
            return nil, "Tag de fechamento não encontrada para: " .. name
        end

        if nextOpen and nextOpen < nextClose then
            depth = depth + 1
            i = nextOpen + 1
        else
            if depth > 0 then
                depth = depth - 1
                i = nextClose + 1
            else
                -- achamos o fechamento correspondente
                local rawContent = code:sub(contentStart, nextClose - 1)
            if trim(rawContent) ~= "" then
                local pos = 1
                local len = #rawContent
                
                while pos <= len do
                    local openStart = rawContent:find("<([%w_]+)", pos)
                    if not openStart then break end
            
                    -- achar fechamento da tag encontrada
                    local segment = rawContent:sub(openStart)
                    local childOffset = globalStart + contentStart + openStart - 2
                    local child = select(1, parseElement(segment, childOffset))
                
                    if not child then
                        -- caso seja texto puro
                        break
                    end
                    
                    insert(node.children, child)
            
                    -- avançar posição até depois da tag parseada
                    local _, endTagEnd = segment:find("</"..child.tag.."%s*>")
                    if not endTagEnd then
                        -- autocontenida tipo <test/>
                        local selfClose = segment:find("/>")
                        if not selfClose then break end
                            pos = openStart + selfClose
                        else
                            pos = openStart + endTagEnd
                        end
                    end
                end

                return tokenizer(node.name, node.attrs, node.children), absoluteStart, absoluteEnd
            end
        end
    end
end

local parser = setmetatable({}, {
  __call = function(_, code)
    return parseElement(code, 1)
  end
})

return parser
