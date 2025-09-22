-- Use the external module (uncomment if using separate file)
-- local jupynium_helpers = require('jupynium-cell-nav')

-- Or use embedded functions (current approach)
local jupynium_helpers = {}

-- Pattern to match cell markers
jupynium_helpers.cell_pattern = '^# %%%%'
jupynium_helpers.markdown_cell_pattern = '^# %%%% %[markdown%]'

-- Find next cell marker
jupynium_helpers.find_next_cell = function()
  local current_line = vim.fn.line '.'
  local last_line = vim.fn.line '$'

  for line = current_line + 1, last_line do
    local line_content = vim.fn.getline(line)
    if line_content:match(jupynium_helpers.cell_pattern) then
      return line
    end
  end
  return nil
end

-- Find previous cell marker
jupynium_helpers.find_previous_cell = function()
  local current_line = vim.fn.line '.'

  for line = current_line - 1, 1, -1 do
    local line_content = vim.fn.getline(line)
    if line_content:match(jupynium_helpers.cell_pattern) then
      return line
    end
  end
  return nil
end

-- Find current cell boundaries
jupynium_helpers.find_current_cell_boundaries = function()
  local current_line = vim.fn.line '.'
  local start_line = current_line
  local end_line = current_line
  local last_line = vim.fn.line '$'

  -- Find cell start
  for line = current_line, 1, -1 do
    local line_content = vim.fn.getline(line)
    if line_content:match(jupynium_helpers.cell_pattern) then
      start_line = line
      break
    end
  end

  -- Find cell end (line before next cell or end of file)
  for line = start_line + 1, last_line do
    local line_content = vim.fn.getline(line)
    if line_content:match(jupynium_helpers.cell_pattern) then
      end_line = line - 1
      break
    end
    end_line = line
  end

  return start_line, end_line
end

-- Jump to next cell
jupynium_helpers.jump_to_next_cell = function()
  local next_cell = jupynium_helpers.find_next_cell()
  if next_cell then
    vim.api.nvim_win_set_cursor(0, { next_cell, 0 })
  else
    vim.notify('No next cell found', vim.log.levels.INFO)
  end
end

-- Jump to previous cell
jupynium_helpers.jump_to_previous_cell = function()
  local prev_cell = jupynium_helpers.find_previous_cell()
  if prev_cell then
    vim.api.nvim_win_set_cursor(0, { prev_cell, 0 })
  else
    vim.notify('No previous cell found', vim.log.levels.INFO)
  end
end

-- Create new code cell below current cell
jupynium_helpers.create_code_cell_below = function()
  local _, end_line = jupynium_helpers.find_current_cell_boundaries()
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { '', '# %%', '' })
  vim.api.nvim_win_set_cursor(0, { end_line + 3, 0 })
end

-- Create new markdown cell below current cell
jupynium_helpers.create_markdown_cell_below = function()
  local _, end_line = jupynium_helpers.find_current_cell_boundaries()
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { '', '# %% [markdown]', '# ' })
  vim.api.nvim_win_set_cursor(0, { end_line + 3, 2 })
  -- Enter insert mode at the end of the line
  vim.cmd 'startinsert!'
end

-- Delete current cell
jupynium_helpers.delete_current_cell = function()
  local start_line, end_line = jupynium_helpers.find_current_cell_boundaries()

  -- Include empty line before next cell if it exists
  if end_line < vim.fn.line '$' and vim.fn.getline(end_line + 1) == '' then
    end_line = end_line + 1
  end

  -- Delete the lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})

  -- Move cursor to the beginning of next cell or previous cell
  local next_cell = jupynium_helpers.find_next_cell()
  if next_cell and next_cell <= vim.fn.line '$' then
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
  else
    local prev_cell = jupynium_helpers.find_previous_cell()
    if prev_cell then
      vim.api.nvim_win_set_cursor(0, { prev_cell, 0 })
    end
  end
end

-- Select current cell
jupynium_helpers.select_current_cell = function()
  local start_line, end_line = jupynium_helpers.find_current_cell_boundaries()

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
  vim.keymap.set('n', '<leader>jst', '<cmd>JupyniumStartSync<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync' }))
  vim.keymap.set('n', '<leader>js1', '<cmd>JupyniumStartSync 1<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 1' }))
  vim.keymap.set('n', '<leader>js2', '<cmd>JupyniumStartSync 2<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 2' }))
  vim.keymap.set('n', '<leader>js3', '<cmd>JupyniumStartSync 3<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 3' }))
  vim.keymap.set('n', '<leader>js4', '<cmd>JupyniumStartSync 4<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 4' }))
  vim.keymap.set('n', '<leader>js5', '<cmd>JupyniumStartSync 5<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 5' }))
  vim.keymap.set('n', '<leader>js6', '<cmd>JupyniumStartSync 6<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 6' }))
  vim.keymap.set('n', '<leader>js7', '<cmd>JupyniumStartSync 7<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 7' }))
  vim.keymap.set('n', '<leader>js8', '<cmd>JupyniumStartSync 8<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 8' }))
  vim.keymap.set('n', '<leader>js9', '<cmd>JupyniumStartSync 9<CR>', vim.tbl_extend('force', opts, { desc = 'Start Jupyter Sync on Tab 9' }))
  vim.keymap.set('n', '<leader>jS', '<cmd>JupyniumStopSync<CR>', vim.tbl_extend('force', opts, { desc = 'Stop Jupyter Sync' }))
  vim.keymap.set('n', '<leader>jA', '<cmd>JupyniumStartAndAttachToServer<CR>', vim.tbl_extend('force', opts, { desc = 'Start and Attach to Jupyter Server' }))
  vim.keymap.set('n', '<leader>jk', '<cmd>JupyniumKernelSelect<CR>', vim.tbl_extend('force', opts, { desc = 'Select Jupyter Kernel' }))
  vim.keymap.set(
    'n',
    '<leader>jr',
    '<cmd>JupyniumStopSync<CR><CMD>JupyniumStartAndAttachToServer<CR><CMD>JupyniumStartSync 2<CR>y<CR>',
    vim.tbl_extend('force', opts, { desc = 'Select Jupyter Kernel' })
  )

  vim.keymap.set({ 'n', 'v' }, '<leader>jj', function()
    vim.cmd 'JupyniumExecuteSelectedCells'
    jupynium_helpers.jump_to_next_cell()
  end, vim.tbl_extend('force', opts, { desc = 'Execute Selected Cells and Jump to Next' }))

  vim.keymap.set('n', '<leader>je', function()
    jupynium_helpers.select_current_cell()
    vim.cmd 'JupyniumExecuteSelectedCells'
    vim.cmd 'normal! '
  end, vim.tbl_extend('force', opts, { desc = 'Execute Current Cell' }))

  vim.keymap.set('n', '<leader>jE', function()
    -- Select all cells and execute
    vim.cmd 'normal! ggVG'
    vim.cmd 'JupyniumExecuteSelectedCells'
    vim.cmd 'normal! '
  end, vim.tbl_extend('force', opts, { desc = 'Execute All Cells' }))

  -- Cell operations
  vim.keymap.set('n', '<leader>jC', ':JupyniumClearSelectedCellsOutputs<CR>', vim.tbl_extend('force', opts, { desc = 'Clear Outputs of Selected Cells' }))
  vim.keymap.set('n', '<leader>jb', jupynium_helpers.create_code_cell_below, vim.tbl_extend('force', opts, { desc = 'Create New Code Cell Below' }))
  vim.keymap.set('n', '<leader>jm', jupynium_helpers.create_markdown_cell_below, vim.tbl_extend('force', opts, { desc = 'Create New Markdown Cell Below' }))
  vim.keymap.set('n', '<leader>jD', jupynium_helpers.delete_current_cell, vim.tbl_extend('force', opts, { desc = 'Delete Current Cell' }))
  vim.keymap.set('n', '<leader>jv', jupynium_helpers.select_current_cell, vim.tbl_extend('force', opts, { desc = 'Select Current Cell' }))

  -- Navigation
  vim.keymap.set('n', '<C-k>', jupynium_helpers.jump_to_previous_cell, vim.tbl_extend('force', opts, { desc = 'Jump to Previous Cell' }))
  vim.keymap.set('n', '<C-j>', jupynium_helpers.jump_to_next_cell, vim.tbl_extend('force', opts, { desc = 'Jump to Next Cell' }))

  -- Kernel operations
  vim.keymap.set('n', '<leader>K', ':JupyniumKernelHover<CR>', vim.tbl_extend('force', opts, { desc = 'Show Kernel Info' }))
  vim.keymap.set('n', '<leader>jR', ':JupyniumKernelRestart<CR>', vim.tbl_extend('force', opts, { desc = 'Restart Jupyter Kernel' }))
  vim.keymap.set('n', '<leader>jI', ':JupyniumKernelInterrupt<CR>', vim.tbl_extend('force', opts, { desc = 'Interrupt Jupyter Kernel' }))

  -- Other operations
  vim.keymap.set('n', '<leader>jt', '<cmd>JupyniumToggleSelectedCellsOutputsScroll<CR>', vim.tbl_extend('force', opts, { desc = 'Toggle Output Scroll' }))
  vim.keymap.set('n', '<leader>jd', '<cmd>JupyniumDownloadIpynb<CR>', vim.tbl_extend('force', opts, { desc = 'Download as .ipynb' }))
  vim.keymap.set('n', '<leader>jw', '<cmd>JupyniumSaveIpynb<CR>', vim.tbl_extend('force', opts, { desc = 'Save as .ipynb' }))

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

-- Get Python path
local get_python_path = function()
  local venv_path = os.getenv 'VIRTUAL_ENV'
  local conda_path = os.getenv 'CONDA_PREFIX'
  if venv_path then
    return venv_path .. '/bin/python'
  elseif conda_path then
    return conda_path .. '/bin/python'
  else
    return '/usr/bin/python'
  end
end

return {
  {
    'kiyoon/jupynium.nvim',
    build = 'uv pip install . --python=' .. get_python_path(),
    config = function()
      require('jupynium').setup {
        jupynium_file_pattern = { '*.ipynb' },
        auto_close_tab = false,
        auto_download_ipynb = false,
        python_host = vim.g.python3_host_prog or 'python3',
        default_notebook_URL = '127.0.0.1:8888/nbclassic',
        firefox_options = {
          binary_location = '/usr/bin/firefox',
        },
        jupyter_command = 'jupyter',
        notebook_dir = nil,
        use_default_keybindings = false,
        textobjects = {
          use_default_keybindings = false,
        },
      }

      -- Create autocmd group for notebook-specific settings
      local augroup = vim.api.nvim_create_augroup('JupyniumNotebook', { clear = true })

      -- Set up keybindings only for .ipynb files and jupytext buffers
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'BufEnter' }, {
        group = augroup,
        pattern = '*.ipynb',
        callback = function(args)
          -- Wait a moment for jupytext to process the file
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              setup_notebook_keybindings(args.buf)

              -- Set buffer-local options
              vim.bo[args.buf].commentstring = '# %s'

              -- Set window-local options for folding
              local wins = vim.fn.win_findbuf(args.buf)
              for _, win in ipairs(wins) do
                if vim.api.nvim_win_is_valid(win) then
                  vim.wo[win].foldmethod = 'expr'
                  vim.wo[win].foldexpr = 'getline(v:lnum)=~"^# %%%%" ? ">1" : "="'
                end
              end
            end
          end)
        end,
      })

      -- Also set up keybindings when Jupynium is attached
      vim.api.nvim_create_autocmd('User', {
        group = augroup,
        pattern = 'JupyniumAttached',
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          setup_notebook_keybindings(bufnr)
        end,
      })
    end,
    -- Lazy load when opening Python files
    ft = { 'python' },
  },
  'rcarriga/nvim-notify', -- optional
  'stevearc/dressing.nvim', -- optional, UI for :JupyniumKernelSelect
}
