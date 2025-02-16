vim.uv = vim.uv or vim.loop

local M = {}

_G.psvim_docs = true

---@param opts? PSVimConfig
function M.setup(opts)
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
      error('Error cloning lazy.nvim:\n' .. out)
    end
  end ---@diagnostic disable-next-line: undefined-field
  vim.opt.rtp:prepend(lazypath)
  local PSVimConfig = require 'psvim.config'
  PSVimConfig.setup(opts)
  PSVimConfig.init()
  require('lazy').setup {
    spec = {
      { import = 'psvim.plugins' },
      { import = 'psvim.plugins.ai' },
      { import = 'psvim.plugins.lang' },
      { import = 'psvim.plugins.coding' },
      { import = 'psvim.plugins.git' },
      { import = 'psvim.plugins.dap' },
    },
    defaults = {
      -- By default, only PSVim plugins will be lazy-loaded. Your custom plugins will load during startup.
      -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { 'tokyonight', 'habamax' } },
    checker = {
      enabled = true, -- check for plugin updates periodically
      notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          'gzip',
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }
end

return M
