local present, nvimtree = pcall(require, "nvim-tree")

if not present then
   return
end

require("base46").load_highlight "nvimtree"

local options = {
   filters = {
      dotfiles = false,
   },
   disable_netrw = true,
   hijack_netrw = true,
   open_on_setup = false,
   ignore_ft_on_setup = { "alpha" },
   hijack_cursor = true,
   hijack_unnamed_buffer_when_opening = false,
   update_cwd = true,
   update_focused_file = {
      enable = true,
      update_cwd = false,
   },
   view = {
      side = "left",
      width = 25,
      hide_root_folder = true,
      mappings = {
         list = {
            { key = "d",         action = "cut"},
            { key = "D",         action = "remove"},
            { key = "c",         action = "copy_name"},
            { key = "<C-c>",     action = "copy_absolute_path"},
            { key = "y",         action = "copy"},
            { key = "n",         action = "create"},
            { key = "<C-r>",     action = "refresh"},
            { key = "<C-s>",     action = "split"},
         }
      }
   },
   git = {
      enable = false,
      ignore = true,
   },
   actions = {
      open_file = {
         resize_window = true,
      },
   },
   renderer = {
      highlight_git = false,
      highlight_opened_files = "none",

      indent_markers = {
         enable = false,
      },

      icons = {
         show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
         },

         glyphs = {
            default = "",
            symlink = "",
            folder = {
               default = "",
               empty = "",
               empty_open = "",
               open = "",
               symlink = "",
               symlink_open = "",
               arrow_open = "",
               arrow_closed = "",
            },
            git = {
               unstaged = "✗",
               staged = "✓",
               unmerged = "",
               renamed = "➜",
               untracked = "★",
               deleted = "",
               ignored = "◌",
            },
         },
      },
   },
}

-- check for any override
options = require("core.utils").load_override(options, "kyazdani42/nvim-tree.lua")

nvimtree.setup(options)
