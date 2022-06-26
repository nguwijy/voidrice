-- n, v, i, t = mode names

local M = {}

M.general = {

   n = {
      -- save and quit all
      ["<leader>qa"] = { "<cmd> wqa <CR>", "﬚  save file and quit all" },
   },
}

M.tabufline = {

   n = {
      -- close buffer + hide terminal buffer
      ["<leader>qq"] = {
         function()
            require("core.utils").close_buffer()
         end,
         "   close buffer",
      },
   },
}

M.nvimtree = {

   n = {
      -- toggle
      ["<leader>n"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
   },
}

M.nvterm = {
   t = {
      -- toggle in terminal mode
      ["<leader>tt"] = {
         function()
            require("nvterm.terminal").toggle "float"
         end,
         "   toggle floating term",
      },

      ["<leader>th"] = {
         function()
            require("nvterm.terminal").toggle "horizontal"
         end,
         "   toggle horizontal term",
      },

      ["<leader>tv"] = {
         function()
            require("nvterm.terminal").toggle "vertical"
         end,
         "   toggle vertical term",
      },
   },

   n = {
      -- toggle in normal mode
      ["<leader>tt"] = {
         function()
            require("nvterm.terminal").toggle "float"
         end,
         "   toggle floating term",
      },

      ["<leader>th"] = {
         function()
            require("nvterm.terminal").toggle "horizontal"
         end,
         "   toggle horizontal term",
      },

      ["<leader>tv"] = {
         function()
            require("nvterm.terminal").toggle "vertical"
         end,
         "   toggle vertical term",
      },
   },
}

return M
