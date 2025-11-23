
local function repeatTab(n)
  local str = ""
  for i = 1, n do
    str = str .. "\t"
  end
  return str
end

local function _tostring(s, n)
  local tab = n or 0
  local str = "{\n"
  local value
  for k, v in pairs(s) do
      value = v
      if type(value)=="table" then value = _tostring(value, tab+1) 
      elseif type(value)== "string" then value = "'"..value.."'" end
      str = str ..repeatTab(tab+1).. k .. " = " .. tostring(value) .. ",\n"
  end
  str = str.. repeatTab(tab) .. "}"
  return str
end

local tokenizer = setmetatable({},
    {
        __call=function(s, ...)
            local args = {...} 
            return setmetatable(
                {
                    tag = args[1],
                    props = args[2],
                    children = args[3],
                },
                {
                    __tostring = _tostring,
                    __concat = function (a, b)
                        return tostring(a) .. tostring(b)
                    end
                }
            )
        end
    }
)

return tokenizer

