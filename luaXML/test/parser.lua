local tokenizer = require("luaXML.tokenizer")
local parser = require("luaXML.parser")


local gmatch = string.gmatch
local sub = string.sub
local find = string.find
local insert = table.insert
local unpack = table.unpack

local function parseElement(code)
  -- remove espaços no início
  code = code:match("^%s*(.-)%s*$")

  -- captura tag de abertura
  local startTagInit, startTagEnd, name, attrs, selfClosed =
    code:find("^<([%w_]+)%s*(.-)(/?)>")

  if not name then
    return nil, "Tag de abertura inválida"
  end

  -- nó base
  local node = {
    name = name,
    attrs = attrs ~= "" and attrs or nil,
    children = {}
  }

  -- se for <test .../>
  if selfClosed == "/" then
    return tokenizer(node.name, node.attrs, {})
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
        local content = code:sub(contentStart, nextClose - 1)

        -- tenta parsear filhos
        content = content:match("^%s*(.-)%s*$")
        if content ~= "" then
          
          local pos = 1
          local len = #content
          
          while pos <= len do
            local openStart, openEnd = content:find("<([%w_]+)", pos)
            if not openStart then break end
          
            -- achar fechamento da tag encontrada
            local segment = content:sub(openStart)
            local child, err = parseElement(segment)
          
            if not child then
              -- caso seja texto puro
              break
            end
          
            table.insert(node.children, child)
          
            -- avançar posição até depois da tag parseada
            -- para isso, precisamos descobrir onde ela termina
            local _, endTagEnd = segment:find("</"..child.tag.."%s*>")
            if not endTagEnd then
              -- autocontenida tipo <test/>
              local selfClose = segment:find("/>")
              pos = openStart + selfClose
            else
              pos = openStart + endTagEnd
            end
          end
        end

        return tokenizer(node.name, node.attrs, node.children)
      end
    end
  end
end


local test = [[
  <test pr=t>
    <test/>
    <test/>
  </test>]]
local result = parseElement(test)

print(result)