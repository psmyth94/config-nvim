local M = {}

_G.PSVim = require 'psvim.util'
_G.PSVim.config = M

---@class PSVimConfig: PSVimOptions
local M = {}
M.buf = 0

PSVim.config = M

---@class PSVimOptions
local defaults = {
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  ---@type string|fun()
  colorscheme = function()
    require('tokyonight').load()
  end,
  -- load the default settings
  defaults = {
    autocmds = true, -- psvim.config.autocmds
    keymaps = true, -- psvim.config.keymaps
  },
  -- icons used by other plugins
  -- stylua: ignore
  icons = {
    misc = {
      dots = "󰇘",
    },
    ft = {
      octo = "",
    },
    dap = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = " ",
      BreakpointCondition = " ",
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = ".>",
    },
    diagnostics = {
      Error = " ",
      Warn  = " ",
      Hint  = " ",
      Info  = " ",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = "󱄽 ",
      String        = " ",
      Struct        = "󰆼 ",
      Supermaven    = " ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
    },
  },
  ---@type table<string, string[]|boolean>?
  kind_filter = {
    default = {
      'Class',
      'Constructor',
      'Enum',
      'Field',
      'Function',
      'Interface',
      'Method',
      'Module',
      'Namespace',
      'Package',
      'Property',
      'Struct',
      'Trait',
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      'Class',
      'Constructor',
      'Enum',
      'Field',
      'Function',
      'Interface',
      'Method',
      'Module',
      'Namespace',
      -- "Package", -- remove package since luals uses it for control flow structures
      'Property',
      'Struct',
      'Trait',
    },
  },
}
---@type PSVimOptions
local options
local lazy_clipboard

---@param opts? PSVimOptions
function M.setup(opts)
  options = vim.tbl_deep_extend('force', defaults, opts or {}) or {}

  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load 'autocmds'
  end

  local group = vim.api.nvim_create_augroup('PSVim', { clear = true })
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'VeryLazy',
    callback = function()
      if lazy_autocmds then
        M.load 'autocmds'
      end
      M.load 'keymaps'
      if lazy_clipboard ~= nil then
        vim.opt.clipboard = lazy_clipboard
      end

      PSVim.format.setup()
      PSVim.root.setup()

      vim.api.nvim_create_user_command('AllHealth', function()
        vim.cmd [[Lazy! load all]]
        vim.cmd [[checkhealth]]
      end, { desc = 'Load all plugins and run :checkhealth' })

      local health = require 'lazy.health'
      vim.list_extend(health.valid, {
        'recommended',
        'desc',
        'vscode',
      })
    end,
  })

  PSVim.track 'colorscheme'
  PSVim.try(function()
    if type(M.colorscheme) == 'function' then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = 'Could not load your colorscheme',
    on_error = function(msg)
      PSVim.error(msg)
      vim.cmd.colorscheme 'habamax'
    end,
  })
  PSVim.track()
end

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if M.kind_filter == false then
    return
  end
  if M.kind_filter[ft] == false then
    return
  end
  if type(M.kind_filter[ft]) == 'table' then
    return M.kind_filter[ft]
  end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(M.kind_filter) == 'table' and type(M.kind_filter.default) == 'table' and M.kind_filter.default or nil
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require('lazy.core.cache').find(mod)[1] then
      PSVim.try(function()
        require(mod)
      end, { msg = 'Failed loading ' .. mod })
    end
  end
  local pattern = 'PSVim' .. name:sub(1, 1):upper() .. name:sub(2)
  -- always load psvim, then user file
  if M.defaults[name] or name == 'options' then
    _load('psvim.config.' .. name)
    vim.api.nvim_exec_autocmds('User', { pattern = pattern .. 'Defaults', modeline = false })
  end
  _load('config.' .. name)
  if vim.bo.filetype == 'lazy' then
    -- HACK: PSVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd [[do VimResized]]
  end
  vim.api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true

  -- delay notifications till vim.notify was replaced or after 500ms
  PSVim.lazy_notify()

  -- load options here, before lazy init while sourcing plugin modules
  -- this is needed to make sure options will be correctly applied
  -- after installing missing plugins
  M.load 'options'
  -- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
  lazy_clipboard = vim.opt.clipboard

  if vim.fn.has 'wsl' == 1 then
    vim.g.clipboard = {
      name = 'win32yank-wsl',
      copy = {
        ['+'] = 'win32yank.exe -i --crlf',
        ['*'] = 'win32yank.exe -i --crlf',
      },
      paste = {
        ['+'] = 'win32yank.exe -o --lf',
        ['*'] = 'win32yank.exe -o --lf',
      },
      cache_enabled = true,
    }
  elseif vim.fn.executable 'xclip' == 0 then
    print "xclip not found, clipboard integration won't work"
  else
    vim.g.clipboard = {
      name = 'xclip',
      copy = {
        ['+'] = 'xclip -selection clipboard',
        ['*'] = 'xclip -selection primary',
      },
      paste = {
        ['+'] = 'xclip -selection clipboard -o',
        ['*'] = 'xclip -selection primary -o',
      },
      cache_enabled = true,
    }
  end

  vim.opt.clipboard = ''

  if vim.g.deprecation_warnings == false then
    vim.deprecate = function() end
  end

  PSVim.plugin.setup()
end

---@alias PSVimDefault {name: string, extra: string, enabled?: boolean, origin?: "global" | "default" | "extra" }

local default_extras ---@type table<string, PSVimDefault>

function M.get_defaults()
  if default_extras then
    return default_extras
  end
  -- keeping this bit incase I wanna change the defaults in the future
  ---@type table<string, PSVimDefault[]>
  local checks = {
    picker = {
      { name = 'snacks', extra = 'editor.snacks_picker' },
      { name = 'fzf', extra = 'editor.fzf' },
      { name = 'telescope', extra = 'editor.telescope' },
    },
    cmp = {
      { name = 'blink.cmp', extra = 'coding.blink', enabled = vim.fn.has 'nvim-0.10' == 1 },
      { name = 'nvim-cmp', extra = 'coding.nvim-cmp' },
    },
    -- will add more if I want to choose different defaults
  }

  default_extras = {}
  for name, check in pairs(checks) do
    local valid = {} ---@type string[]
    for _, extra in ipairs(check) do
      if extra.enabled ~= false then
        valid[#valid + 1] = extra.name
      end
    end
    local origin = 'default'
    local use = vim.g['psvim_' .. name]
    use = vim.tbl_contains(valid, use or 'auto') and use or nil
    origin = use and 'global' or origin
    for _, extra in ipairs(use and {} or check) do
      if extra.enabled ~= false and PSVim.has_extra(extra.extra) then
        use = extra.name
        break
      end
    end
    origin = use and 'extra' or origin
    use = use or valid[1]
    for _, extra in ipairs(check) do
      local import = 'psvim.plugins.' .. extra.extra
      extra = vim.deepcopy(extra)
      extra.enabled = extra.name == use
      if extra.enabled then
        extra.origin = origin
      end
      default_extras[import] = extra
    end
  end
  return default_extras
end

function M.wants(opts)
  if opts.ft then
    opts.ft = type(opts.ft) == 'string' and { opts.ft } or opts.ft
    for _, f in ipairs(opts.ft) do
      if vim.bo[M.buf].filetype == f then
        return true
      end
    end
  end
  if opts.root then
    opts.root = type(opts.root) == 'string' and { opts.root } or opts.root
    return #PSVim.root.detectors.pattern(M.buf, opts.root) > 0
  end
  return false
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options PSVimConfig
    return options[key]
  end,
})

return M
