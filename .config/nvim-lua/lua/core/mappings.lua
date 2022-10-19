-- n, v, i, t = mode names

local function termcodes(str)
   return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

-- <Left> is not accepted in the following format, we have to set it here
vim.api.nvim_set_keymap("n", "S", ":%s//g<Left><Left>", { noremap = true })

M.general = {

   n = {

      ["<ESC>"] = { "<cmd> noh <CR>", "  no highlight" },

      -- switch between windows
      ["<C-h>"] = { "<C-w>h", " window left" },
      ["<C-l>"] = { "<C-w>l", " window right" },
      ["<C-j>"] = { "<C-w>j", " window down" },
      ["<C-k>"] = { "<C-w>k", " window up" },

      -- open, save, and quit files
      ["<leader>qq"] = { "<cmd> wqa <CR>", "﬚  save file and quit all" },
      ["<leader>lo"] = { "<cmd> !opout <c-r>%<CR><CR>", "  open preview files" },
      ["<leader>lb"] = { "<cmd> vsp<space>$BIB<CR>", "  open bibliography file in split mode" },
      ["<leader>ww"] = { "<cmd> execute 'silent! write !sudo tee % >/dev/null' <bar> edit! <CR>", "﬚  save file with sudo privillege" },
      ["<leader>cd"] = { "<cmd> cd %:p:h <CR>", "  cd to the directory of current file" },
      ["<CR>"] = { "<cmd> VimwikiFollowLink <CR>", "  follow/create wiki link" },

      -- Copy all
      ["<C-c>"] = { "<cmd> %y+ <CR>", "  copy whole file" },

      ["<leader>tt"] = {
         function()
            require("base46").toggle_theme()
         end,

         "   toggle theme",
      },
   },

   t = {
      ["<C-x>"] = { termcodes "<C-\\><C-N>", "   escape terminal mode" },
   },
}

M.tabufline = {

   n = {
      -- cycle through buffers
      ["<TAB>"] = { "<cmd> Tbufnext <CR>", "  goto next buffer" },
      ["<S-Tab>"] = { "<cmd> Tbufprev <CR> ", "  goto prev buffer" },

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
   -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

   n = {
      ["<leader>jd"] = {
         function()
            vim.lsp.buf.definition()
         end,
         "   lsp definition",
      },

      ["<leader>jj"] = {
         function()
            vim.lsp.buf.hover()
         end,
         "   lsp hover",
      },

      ["<leader>jt"] = {
         function()
            vim.lsp.buf.type_definition()
         end,
         "   lsp definition type",
      },

      ["<leader>jn"] = {
         function()
            require("nvchad.ui.renamer").open()
         end,
         "   lsp rename",
      },

      ["<leader>jr"] = {
         function()
            vim.lsp.buf.references()
         end,
         "   lsp references",
      },

      ["<leader>j<S-Tab>"] = {
         function()
            vim.diagnostic.goto_prev()
         end,
         "   goto prev",
      },

      ["<leader>j<TAB>"] = {
         function()
            vim.diagnostic.goto_next()
         end,
         "   goto_next",
      },

      ["<leader>jl"] = {
         function()
            vim.diagnostic.setloclist()
         end,
         "   diagnostic setloclist",
      },
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
      -- find
      ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "  find files" },
      ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all" },
      ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "   live grep" },
      ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "  find buffers" },
      ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "  help page" },
      ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "   find oldfiles" },
      ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "   show keys" },
      ["<leader>ft"] = { "<cmd> Telescope terms <CR>", "   pick hidden term" },

      -- git
      ["<leader>gts"] = { "<cmd> Telescope git_stash <CR>", "   git check stash" },
      ["<leader>gtc"] = { "<cmd> Telescope git_commits <CR>", "   git check commits" },
      ["<leader>gtd"] = { "<cmd> Telescope git_status <CR>", "  git check diff" },
      ["<leader>gtp"] = { "<cmd> Gitsigns preview_hunk <CR>", "  git preview diff of this hunk" },
      ["<leader>gt<TAB>"] = { "<cmd> Gitsigns next_hunk <CR>", "  git go to next hunk" },
      ["<leader>gt<S-Tab>"] = { "<cmd> Gitsigns prev_hunk <CR>", "  git go to previous hunk" },

      -- theme switcher
      ["<leader>th"] = { "<cmd> Telescope themes <CR>", "   nvchad themes" },
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

      -- new terminal
      ["<C-n>"] = {
         function()
            require("nvterm.terminal").new "horizontal"
         end,
         "   new horizontal term",
      },
   },
}

M.whichkey = {
   n = {
      ["<leader>wK"] = {
         function()
            vim.cmd "WhichKey"
         end,
         "   which-key all keymaps",
      },
      ["<leader>wk"] = {
         function()
            local input = vim.fn.input "WhichKey: "
            vim.cmd("WhichKey " .. input)
         end,
         "   which-key query lookup",
      },
   },
}

M.blankline = {
   n = {
      ["<leader>bc"] = {
         function()
            local ok, start = require("indent_blankline.utils").get_current_context(
               vim.g.indent_blankline_context_patterns,
               vim.g.indent_blankline_use_treesitter_scope
            )

            if ok then
               vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
               vim.cmd [[normal! _]]
            end
         end,

         "  Jump to current_context",
      },
   },
}

return M
