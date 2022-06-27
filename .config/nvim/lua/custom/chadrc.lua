-- Just an example, supposed to be placed in /lua/custom/
local autocmd = vim.api.nvim_create_autocmd
local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
   theme = "onenord",
   theme_toggle = { "onenord", "onenord_light" },
}

M.mappings = require "custom.mappings"
-- <Left> is not accepted in custom.mappings, we have to set it here
vim.api.nvim_set_keymap("n", "S", ":%s//g<Left><Left>", { noremap = true })

M.options = {
   user = function()
       require("custom.options")
       -- enable netrw that was disabled in core.options for opening url in browser
       local enable_providers = {
         "netrw",
         "netrwPlugin",
         "netrwSettings",
         "netrwFileHandlers",
       }
       for _, plugin in pairs(enable_providers) do
         vim.g["loaded_" .. plugin] = nil
         -- vim.g["loaded_" .. plugin] = 0
         vim.cmd("runtime " .. plugin)
       end
   end,
}

local nvimtree_list = {
   { key = "d",         action = "cut"},
   { key = "D",         action = "remove"},
   { key = "c",         action = "copy_name"},
   { key = "<C-c>",     action = "copy_absolute_path"},
   { key = "y",         action = "copy"},
   { key = "n",         action = "create"},
   { key = "<C-r>",     action = "refresh"},
   { key = "<C-s>",     action = "split"},
}

M.plugins = {
   -- for overriding existing plugins in core
   override = {
      ["kyazdani42/nvim-tree.lua"] = {
         view = {
            mappings = {
               list = nvimtree_list
            }
         },
      },
   },

   -- for lspconfig
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },

   -- for new plugins
   user = require "custom.plugins",
}

-- silently convert saved vimwiki md files into html files using build-notes
autocmd("BufWritePost", {
   pattern = "*/vimwiki/*md",
   callback = function()
      vim.cmd "silent! !build-notes %:p"
   end,
})

-- automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd("VimLeave", {
   pattern = "*.tex",
   callback = function()
      vim.cmd "!texclear %"
   end,
})

-- automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd("BufWritePre", {
   pattern = "*",
   callback = function()
      vim.cmd "%s/\\s\\+$//e"
   end,
})
autocmd("BufWritePre", {
   pattern = "*",
   callback = function()
      vim.cmd "%s/\\n\\+\\%$//e"
   end,
})

return M
