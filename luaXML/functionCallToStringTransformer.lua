



local function fcst(element)
    local nChildrens = #element.children
    local childrens = "{"
    for idx, ch in ipairs(element.children) do
        childrens = childrens.."[".. idx .."] =" .. fcst(ch) .. ","
    end
    
    childrens = childrens .. "}"
 
    return element.tag .. "(" .. require("luaXML.tableToString")(element.props, false) ..",".. childrens .. ")"
end

return fcst