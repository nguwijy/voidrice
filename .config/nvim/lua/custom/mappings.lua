-- n, v, i, t = mode names
local M = {}

M.general = {

   n = {
      ["<leader>qq"] = { "<cmd> wqa <CR>", "﬚  save file and quit all" },
      ["<leader>lo"] = { "<cmd> !opout <c-r>%<CR><CR>", "  open preview files" },
      ["<leader>lb"] = { "<cmd> vsp<space>$BIB<CR>", "  open bibliography file in split mode" },
      ["<leader>ww"] = { "<cmd> execute 'silent! write !sudo tee % >/dev/null' <bar> edit! <CR>", "﬚  save file with sudo privillege" },
      ["<leader>cd"] = { "<cmd> cd %:p:h <CR>", "  cd to the directory of current file" },
      ["<CR>"] = { "<cmd> VimwikiFollowLink <CR>", "  follow/create wiki link" },
   },
}

M.tabufline = {

   n = {
      -- close buffer + hide terminal buffer
      ["<C-x>"] = {
         function()
            require("core.utils").close_buffer()
         end,
         "   close buffer",
      },
   },
}

M.lspconfig = {
   n = {
      ["<leader>lf"] = { "<cmd> TexlabForward <CR>", "   texlab forward search" },
   },
}

M.nvimtree = {
   n = {
      -- toggle
      ["<leader>n"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
   },
}

M.telescope = {
   n = {
      -- git
      ["<leader>gts"] = { "<cmd> Telescope git_stash <CR>", "   git check stash" },
      ["<leader>gtc"] = { "<cmd> Telescope git_commits <CR>", "   git check commits" },
      ["<leader>gtd"] = { "<cmd> Telescope git_status <CR>", "  git check diff" },
      ["<leader>gtp"] = { "<cmd> Gitsigns preview_hunk <CR>", "  git preview diff of this hunk" },
      ["<leader>gt<TAB>"] = { "<cmd> Gitsigns next_hunk <CR>", "  git go to next hunk" },
      ["<leader>gt<S-Tab>"] = { "<cmd> Gitsigns prev_hunk <CR>", "  git go to previous hunk" },
   },
}

M.nvterm = {
   t = {
      -- toggle in terminal mode
      ["<C-t>"] = {
         function()
            require("nvterm.terminal").toggle "horizontal"
         end,
         "   toggle horizontal term",
      },
   },

   n = {
      -- toggle in normal mode
      ["<C-t>"] = {
         function()
            require("nvterm.terminal").toggle "horizontal"
         end,
         "   toggle horizontal term",
      },
   },
}

return M
