-- Use the external module (uncomment if using separate file)
-- local neopyter_helpers = require('jupynium-cell-nav')

-- Or use embedded functions (current approach)
local neopyter_helpers = {}

-- Pattern to match cell markers
neopyter_helpers.cell_pattern = '^# %%%%'
neopyter_helpers.markdown_cell_pattern = '^# %%%% %[markdown%]'

-- Find next cell marker
neopyter_helpers.find_next_cell = function()
  local current_line = vim.fn.line '.'
  local last_line = vim.fn.line '$'

  for line = current_line + 1, last_line do
    local line_content = vim.fn.getline(line)
    if line_content:match(neopyter_helpers.cell_pattern) then
      return line
    end
  end
  return nil
end

-- Find previous cell marker
neopyter_helpers.find_previous_cell = function()
  local current_line = vim.fn.line '.'

  for line = current_line - 1, 1, -1 do
    local line_content = vim.fn.getline(line)
    if line_content:match(neopyter_helpers.cell_pattern) then
      return line
    end
  end
  return nil
end

-- Find current cell boundaries
neopyter_helpers.find_current_cell_boundaries = function()
  local current_line = vim.fn.line '.'
  local start_line = current_line
  local end_line = current_line
  local last_line = vim.fn.line '$'

  -- Find cell start
  for line = current_line, 1, -1 do
    local line_content = vim.fn.getline(line)
    if line_content:match(neopyter_helpers.cell_pattern) then
      start_line = line
      break
    end
  end

  -- Find cell end (line before next cell or end of file)
  for line = start_line + 1, last_line do
    local line_content = vim.fn.getline(line)
    if line_content:match(neopyter_helpers.cell_pattern) then
      end_line = line - 1
      break
    end
    end_line = line
  end

  return start_line, end_line
end

-- Jump to next cell
neopyter_helpers.jump_to_next_cell = function()
  local next_cell = neopyter_helpers.find_next_cell()
  if next_cell then
    vim.api.nvim_win_set_cursor(0, { next_cell, 0 })
  else
    vim.notify('No next cell found', vim.log.levels.INFO)
  end
end

-- Jump to previous cell
neopyter_helpers.jump_to_previous_cell = function()
  local prev_cell = neopyter_helpers.find_previous_cell()
  if prev_cell then
    vim.api.nvim_win_set_cursor(0, { prev_cell, 0 })
  else
    vim.notify('No previous cell found', vim.log.levels.INFO)
  end
end

-- Create new code cell below current cell
neopyter_helpers.create_code_cell_below = function()
  local _, end_line = neopyter_helpers.find_current_cell_boundaries()
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { '', '# %%', '' })
  vim.api.nvim_win_set_cursor(0, { end_line + 3, 0 })
end

-- Create new markdown cell below current cell
neopyter_helpers.create_markdown_cell_below = function()
  local _, end_line = neopyter_helpers.find_current_cell_boundaries()
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { '', '# %% [markdown]', '# ' })
  vim.api.nvim_win_set_cursor(0, { end_line + 3, 2 })
  -- Enter insert mode at the end of the line
  vim.cmd 'startinsert!'
end

-- Delete current cell
neopyter_helpers.delete_current_cell = function()
  local start_line, end_line = neopyter_helpers.find_current_cell_boundaries()

  -- Include empty line before next cell if it exists
  if end_line < vim.fn.line '$' and vim.fn.getline(end_line + 1) == '' then
    end_line = end_line + 1
  end

  -- Delete the lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})

  -- Move cursor to the beginning of next cell or previous cell
  local next_cell = neopyter_helpers.find_next_cell()
  if next_cell and next_cell <= vim.fn.line '$' then
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
  else
    local prev_cell = neopyter_helpers.find_previous_cell()
    if prev_cell then
      vim.api.nvim_win_set_cursor(0, { prev_cell, 0 })
    end
  end
end

-- Select current cell
neopyter_helpers.select_current_cell = function()
  local start_line, end_line = neopyter_helpers.find_current_cell_boundaries()

  -- Enter visual line mode
  vim.cmd 'normal! V'

  -- Move to start of cell
  vim.api.nvim_win_set_cursor(0, { start_line, 0 })

  -- Extend selection to end of cell
  vim.cmd 'normal! o'
  vim.api.nvim_win_set_cursor(0, { end_line, 0 })
end

-- Setup keybindings for notebook buffers
local setup_notebook_keybindings = function(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Jupyter sync and server
  vim.keymap.set('n', '<leader>js', '<cmd>Neopyter sync current<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync' }))
  vim.keymap.set('n', '<leader>jS', '<cmd>NeopyterStopSync<CR>', vim.tbl_extend('force', opts, { desc = 'Stop Jupyter Sync' }))
  vim.keymap.set('n', '<leader>jA', '<cmd>Neopyter connect 127.0.0.1:9001<CR>', vim.tbl_extend('force', opts, { desc = 'Start and Attach to Jupyter Server' }))

  vim.keymap.set({ 'n', 'v' }, '<leader>jj', function()
    vim.cmd 'Neopyter run current'
    neopyter_helpers.jump_to_next_cell()
  end, vim.tbl_extend('force', opts, { desc = 'Execute Selected Cells and Jump to Next' }))

  vim.keymap.set('n', '<leader>je', function()
    neopyter_helpers.select_current_cell()
    vim.cmd 'Neopyter run current'
    vim.cmd 'normal! '
  end, vim.tbl_extend('force', opts, { desc = 'Execute Current Cell' }))

  vim.keymap.set('n', '<leader>jE', '<cmd>Neopyter run all<CR>', vim.tbl_extend('force', opts, { desc = 'Execute All Cells' }))

  -- Cell operations
  vim.keymap.set(
    'n',
    '<leader>jC',
    '<cmd>Neopyter execute notebook:clear-all-cell-outputs<CR>',
    vim.tbl_extend('force', opts, { desc = 'Clear Outputs of All Cells' })
  )
  vim.keymap.set(
    'n',
    '<leader>jc',
    '<cmd>Neopyter execute notebook:clear-cell-output<CR>',
    vim.tbl_extend('force', opts, { desc = 'Clear Outputs of Selected Cells' })
  )
  vim.keymap.set('n', '<leader>jb', neopyter_helpers.create_code_cell_below, vim.tbl_extend('force', opts, { desc = 'Create New Code Cell Below' }))
  vim.keymap.set('n', '<leader>jm', neopyter_helpers.create_markdown_cell_below, vim.tbl_extend('force', opts, { desc = 'Create New Markdown Cell Below' }))
  vim.keymap.set('n', '<leader>jD', neopyter_helpers.delete_current_cell, vim.tbl_extend('force', opts, { desc = 'Delete Current Cell' }))
  vim.keymap.set('n', '<leader>jv', neopyter_helpers.select_current_cell, vim.tbl_extend('force', opts, { desc = 'Select Current Cell' }))

  -- Navigation
  vim.keymap.set('n', '<C-k>', neopyter_helpers.jump_to_previous_cell, vim.tbl_extend('force', opts, { desc = 'Jump to Previous Cell' }))
  vim.keymap.set('n', '<C-j>', neopyter_helpers.jump_to_next_cell, vim.tbl_extend('force', opts, { desc = 'Jump to Next Cell' }))

  -- Move cells
  vim.keymap.set('n', '<A-k>', '<cmd>Neopyter execute notebook:move-cell-up<CR>', vim.tbl_extend('force', opts, { desc = 'Move Cell Up' }))
  vim.keymap.set('n', '<A-j>', '<cmd>Neopyter execute notebook:move-cell-down<CR>', vim.tbl_extend('force', opts, { desc = 'Move Cell Down' }))

  -- Additional cell creation shortcuts
  vim.keymap.set('n', '<leader>ja', function()
    local line = vim.fn.line '.'
    vim.api.nvim_buf_set_lines(0, line - 1, line - 1, false, { '# %%', '' })
    vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
  end, vim.tbl_extend('force', opts, { desc = 'Insert Code Cell Above' }))

  vim.keymap.set('n', '<leader>jM', function()
    local line = vim.fn.line '.'
    vim.api.nvim_buf_set_lines(0, line - 1, line - 1, false, { '# %% [markdown]', '# ' })
    vim.api.nvim_win_set_cursor(0, { line + 1, 2 })
    vim.cmd 'startinsert!'
  end, vim.tbl_extend('force', opts, { desc = 'Insert Markdown Cell Above' }))
end

return {
  'SUSTech-data/neopyter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter', -- neopyter don't depend on `nvim-treesitter`, but does depend on treesitter parser of python
  },

  ---@type neopyter.Option
  opts = {
    mode = 'proxy',
    remote_address = '127.0.0.1:9001',
    file_pattern = { '*.ipynb' },
    parser = { trim_whitespace = true },
    on_attach = function(bufnr)
      setup_notebook_keybindings(bufnr)
    end,
  },
}
