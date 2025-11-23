local fcst = require("luaXML.functionCallToStringTransformer")
local elements = require("luaXML.elements")
local log = require("loglua")

local element = elements:createElement(
    "test",
    {istest = true},
    {elements:createElement(
        "test2",
        { skibidi_toilet = 2 },
        {}
    )}
)

log("element:", element)

log("function: ", fcst(element))


log.show()