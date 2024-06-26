local M = {}
local api = vim.api

local merge_tb = vim.tbl_deep_extend

M.close_buffer = function(bufnr)
   if vim.bo.buftype == "terminal" then
      if vim.bo.buflisted then
         vim.bo.buflisted = false
         vim.cmd "enew"
      else
         vim.cmd "hide"
      end
      return
   end

   -- if file doesnt exist & its modified
   if vim.bo.modified then
      print "save the file!"
      return
   end

   bufnr = bufnr or api.nvim_get_current_buf()
   require("core.utils").tabuflinePrev()
   vim.cmd("bd" .. bufnr)
end

M.load_config = function()
   local config = require "core.default_config"
   config.mappings.disabled = nil
   return config
end

M.remove_default_keys = function()
   local user_mappings = {}
   local user_keys = {}
   local user_sections = vim.tbl_keys(user_mappings)

   -- push user_map keys in user_keys table
   for _, section in ipairs(user_sections) do
      user_keys = vim.tbl_deep_extend("force", user_keys, user_mappings[section])
   end

   local function disable_key(mode, keybind, mode_mapping)
      local keys_in_mode = vim.tbl_keys(user_keys[mode] or {})

      if vim.tbl_contains(keys_in_mode, keybind) then
         mode_mapping[keybind] = nil
      end
   end

   local default_mappings = require("core.default_config").mappings

   -- remove user_maps from default mapping table
   for _, section_mappings in pairs(default_mappings) do
      for mode, mode_mapping in pairs(section_mappings) do
         for keybind, _ in pairs(mode_mapping) do
            disable_key(mode, keybind, mode_mapping)
         end
      end
   end
end

M.load_mappings = function(mappings, mapping_opt)
   -- set mapping function with/without whichkey
   local map_func
   local whichkey_exists, wk = pcall(require, "which-key")

   if whichkey_exists then
      map_func = function(keybind, mapping_info, opts)
         wk.register({ [keybind] = mapping_info }, opts)
      end
   else
      map_func = function(keybind, mapping_info, opts)
         local mode = opts.mode
         opts.mode = nil
         vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
   end

   mappings = mappings or vim.deepcopy(M.load_config().mappings)
   mappings.lspconfig = nil

   for _, section_mappings in pairs(mappings) do
      -- skip mapping this as its mapppings are loaded in lspconfig
      for mode, mode_mappings in pairs(section_mappings) do
         for keybind, mapping_info in pairs(mode_mappings) do
            -- merge default + user opts

            local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
            local opts = merge_tb("force", default_opts, mapping_info.opts or {})

            if mapping_info.opts then
               mapping_info.opts = nil
            end

            map_func(keybind, mapping_info, opts)
         end
      end
   end
end

-- remove plugins defined in chadrc
M.remove_default_plugins = function(plugins)
   local removals = M.load_config().plugins.remove or {}

   if not vim.tbl_isempty(removals) then
      for _, plugin in pairs(removals) do
         plugins[plugin] = nil
      end
   end

   return plugins
end

-- merge default/user plugin tables
M.merge_plugins = function(default_plugins)
   local user_plugins = M.load_config().plugins.user

   -- merge default + user plugin table
   default_plugins = merge_tb("force", default_plugins, user_plugins)

   local final_table = {}

   for key, _ in pairs(default_plugins) do
      default_plugins[key][1] = key

      final_table[#final_table + 1] = default_plugins[key]
   end

   return final_table
end

M.load_override = function(default_table, plugin_name)
   local user_table = M.load_config().plugins.override[plugin_name]

   if type(user_table) == "function" then
      user_table = user_table()
   elseif type(user_table) == "table" then
      default_table = merge_tb("force", default_table, user_table)
   else
      default_table = default_table
   end

   return default_table
end

M.packer_sync = function(...)
   local git_exists, git = pcall(require, "nvchad.utils.git")
   local defaults_exists, defaults = pcall(require, "nvchad.utils.config")
   local packer_exists, packer = pcall(require, "packer")

   if git_exists and defaults_exists then
      local current_branch_name = git.get_current_branch_name()

      -- warn the user if we are on a snapshot branch
      if current_branch_name:match(defaults.snaps.base_snap_branch_name .. "(.+)" .. "$") then
         vim.api.nvim_echo({
            { "WARNING: You are trying to use ", "WarningMsg" },
            { "PackerSync" },
            {
               " on a NvChadSnapshot. This will cause issues if NvChad dependencies contain "
                  .. "any breaking changes! Plugin updates will not be included in this "
                  .. "snapshot, so they will be lost after switching between snapshots! Would "
                  .. "you still like to continue? [y/N]\n",
               "WarningMsg",
            },
         }, false, {})

         local ans = vim.trim(string.lower(vim.fn.input "-> "))

         if ans ~= "y" then
            return
         end
      end
   end

   if packer_exists then
      packer.sync(...)
   else
      error "Packer could not be loaded!"
   end
end

M.tabuflineNext = function()
   local bufs = vim.t.bufs or {}

   for i, v in ipairs(bufs) do
      if api.nvim_get_current_buf() == v then
         vim.cmd(i == #bufs and "b" .. bufs[1] or "b" .. bufs[i + 1])
         break
      end
   end
end

M.tabuflinePrev = function()
   local bufs = vim.t.bufs or {}

   for i, v in ipairs(bufs) do
      if api.nvim_get_current_buf() == v then
         vim.cmd(i == 1 and "b" .. bufs[#bufs] or "b" .. bufs[i - 1])
         break
      end
   end
end
-- closes tab + all of its buffers
M.tabuflineCloseTab = function()
   local bufs = vim.t.bufs or {}

   vim.cmd "tabclose"

   for _, buf in ipairs(bufs) do
      vim.cmd("bd" .. buf)
   end
end

return M
