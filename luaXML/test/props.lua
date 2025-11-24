local props = require("luaXML.props")

local input = { id = "btn1", class = "primary", disabled = true, count = 5 }
local s = props.tableToPropsString(input)
print("props string:", s)

local parsed = props.stringToPropsTable(s)
for k, v in pairs(parsed) do
    print("parsed", k, v, type(v))
end
