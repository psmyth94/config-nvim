-- Some plugins need to be imported before others
local prios = {
  ['psvim.plugins.dap.core'] = 1,
  ['psvim.plugins.coding.nvim-cmp'] = 2,
  ['psvim.plugins.lang.typescript'] = 5,
  ['psvim.plugins.coding.blink'] = 5,
  ['psvim.plugins.formatting.prettier'] = 10,
  -- default core extra priority is 20
  -- default priority is 50
  ['psvim.plugins.ai.copilot'] = 100,
}

local imports = {
  -- ## dap ##
  'psvim.plugins.dap.core',
  'psvim.plugins.dap.nlua',
  -- ## coding ##
  'psvim.plugins.coding.core',
  'psvim.plugins.coding.blink', -- its either blink or nvim-cmp
  'psvim.plugins.coding.yank',
  -- 'psvim.plugins.coding.nvim-cmp',
  -- ## ai ##
  'psvim.plugins.ai.copilot',
  'psvim.plugins.ai.copilot-chat',
  -- ## lang ##
  'psvim.plugins.lang.ansible',
  'psvim.plugins.lang.sql',
  'psvim.plugins.lang.python',
  'psvim.plugins.lang.terraform',
  'psvim.plugins.lang.rust',
  'psvim.plugins.lang.typescript',
  -- ## git ##
  'psvim.plugins.git.fugitive',
  -- ## editor ##
  'psvim.plugins.editor.snacks_picker',
}

for _, name in ipairs(imports) do
  prios[name] = prios[name] or 20
end

---@type string[]
imports = PSVim.dedup(imports)

local version = vim.version()
local v = version.major .. '_' .. version.minor

local compat = { '0_9' }

PSVim.plugin.save_core()
if vim.tbl_contains(compat, v) then
  table.insert(imports, 1, 'psvim.plugins.compat.nvim-' .. v)
end

table.sort(imports, function(a, b)
  local pa = prios[a] or 50
  local pb = prios[b] or 50
  if pa == pb then
    return a < b
  end
  return pa < pb
end)

---@param extra string
return vim.tbl_map(function(extra)
  return { import = extra }
end, imports)
