

local function repeatTab(n)
  local str = ""
  for i = 1, n do
    str = str .. "\t"
  end
  return str
end

local function _tostring(s, n)
    local usetabs = function(_) if n == false then return "" else return repeatTab(_) end end
    local useBreakLine = function() if n == false then return "" else return "\n" end end
    
    local tab = n or 0
    local str = "{"..useBreakLine()
    local value
    
    for k, v in pairs(s) do
        value = v
        if type(value)=="table" then value = _tostring(value, tab+1) 
        elseif type(value)== "string" then value = "'"..value.."'" end
        str = str .. usetabs(tab+1) .. k .. " = " .. tostring(value) .. "," .. useBreakLine()
    end
    
    str = str.. usetabs(tab) .. "}"
    return str
end

return _tostring