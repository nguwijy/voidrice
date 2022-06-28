local opt = vim.opt
local g = vim.g
local config = require("core.utils").load_config()

g.nvchad_theme = config.ui.theme
g.toggle_theme_icon = "   "
g.transparency = config.ui.transparency
g.theme_switcher_loaded = false

-- use filetype.lua instead of filetype.vim
g.did_load_filetypes = 0
g.do_filetype_lua = 1

opt.laststatus = 3 -- global statusline
opt.statusline = config.ui.statusline.config
opt.showmode = false

opt.title = true
opt.clipboard = "unnamedplus"
opt.cul = true -- cursor line

-- Indenting
opt.tabstop = 4
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false
opt.relativenumber = true

-- vimwiki
g.vimwiki_list = {
    {
        path = '~/OneDrive/quick-drive/vimwiki',
        syntax = 'markdown',
        list_margin = 0,
        ext = '.md'
    }
}
g.vimwiki_ext2syntax = {
    ['.Rmd'] = 'markdown',
    ['.rmd'] = 'markdown',
    ['.md'] = 'markdown',
    ['.markdown'] = 'markdown',
    ['.mdown'] = 'markdown'
}
g.vimwiki_markdown_link_ext = 1
g.vimwiki_key_mappings = { ['links'] = 0 }

-- vimtex
g.vimtex_delim_toggle_mod_list = {
    {'\\left', '\\right'},
    {'\\bigl', '\\bigr'},
    {'\\Bigl', '\\Bigr'},
    {'\\biggl', '\\biggr'},
    {'\\Biggl', '\\Biggr'},
}
g.vimtex_view_method = 'zathura'

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 8
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

g.mapleader = " "
g.maplocalleader = " "

-- disable some builtin vim plugins
local default_plugins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   -- "netrw",
   -- "netrwPlugin",
   -- "netrwSettings",
   -- "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
   "python3_provider",
   "python_provider",
   "node_provider",
   "ruby_provider",
   "perl_provider",
   "tutor",
   "rplugin",
   "syntax",
   "synmenu",
   "optwin",
   "compiler",
   "bugreport",
   "ftplugin",
}

for _, plugin in pairs(default_plugins) do
   g["loaded_" .. plugin] = 1
end

-- set shada path
vim.schedule(function()
   vim.opt.shadafile = vim.fn.expand "$HOME" .. "/.local/share/nvim/shada/main.shada"
   vim.cmd [[ silent! rsh ]]
end)

-- load user options
config.options.user()
