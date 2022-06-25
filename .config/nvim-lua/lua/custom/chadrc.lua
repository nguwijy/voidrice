-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
   theme = "onenord",
   theme_toggle = { "onenord", "onenord_light" },
}

M.mappings = require "custom.mappings"

M.options = {
   user = function()
       require("custom.options")
   end,
}
return M
