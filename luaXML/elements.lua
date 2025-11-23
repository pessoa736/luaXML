

local elements = setmetatable({
        createElement = function (s, ...) return s(...) end
    },
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
                    __tostring = require("luaXML.tableToString"),
                    __concat = function (a, b)
                        return tostring(a) .. tostring(b)
                    end
                }
            )
        end
    }
)

return elements

