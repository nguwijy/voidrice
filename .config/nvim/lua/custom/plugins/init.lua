return {
   ["ur4ltz/surround.nvim"] = {
     config = function()
        require"surround".setup {mappings_style = "surround"}
     end
   },
   ["tpope/vim-fugitive"] = {},
   ["vimwiki/vimwiki"] = {},
   ["lervag/vimtex"] = {},
   ["iamcco/markdown-preview.nvim"] = {
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
   },
}
