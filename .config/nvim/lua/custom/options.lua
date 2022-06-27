local opt = vim.opt
local g = vim.g

-- set local leader
g.maplocalleader = " "

-- Numbers
opt.relativenumber = true

-- Indenting
opt.shiftwidth = 4
opt.tabstop = 4

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

-- vimwiki
g.vimtex_delim_toggle_mod_list = {
    {'\\left', '\\right'},
    {'\\bigl', '\\bigr'},
    {'\\Bigl', '\\Bigr'},
    {'\\biggl', '\\biggr'},
    {'\\Biggl', '\\Biggr'},
}
g.vimtex_view_method = 'zathura'
