return {
  { -- NotebookNavigator Nvim: Navigate jupyter notebook in neovim
    'IniyanKanmani/notebook-navigator.nvim',

    dependencies = {
      'IniyanKanmani/jupytext.nvim',
      'SUSTech-data/neopyter',
      'benlubas/molten-nvim',
      'echasnovski/mini.ai',
      'echasnovski/mini.hipatterns',
    },

    lazy = true,

    event = { 'BufReadCmd *.ipynb', 'BufNewFile *.ipynb' },

    opts = {
      cell_markers = {
        python = '# %%',
      },
      activate_hydra_keys = nil,
      show_hydra_hint = false,
      repl_provider = 'molten',
      syntax_highlight = false,
      cell_highlight_group = 'Folded',
    },

    config = function(_, opts)
      local nn = require 'notebook-navigator'
      nn.setup(opts)

      local check_neopyter_buffers = function(bufnr)
        for _, nr in ipairs(vim.g.neopyter_buffers) do
          if nr == bufnr then
            return true
          end
          return false
        end
      end

      local neopyter_leader = '<leader>j'

      vim.keymap.set('n', neopyter_leader .. 'k', function()
        nn.move_cell 'u'
      end, { desc = 'Move cell up' })

      vim.keymap.set('n', neopyter_leader .. 'j', function()
        nn.move_cell 'd'
      end, { desc = 'Move cell down' })

      vim.keymap.set('n', neopyter_leader .. 'e', function()
        if vim.g.current_jupyter_repl == 0 then
          nn.run_cell()
        elseif vim.g.current_jupyter_repl == 1 then
          local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          if neo then
            vim.cmd 'Neopyter run current'
          end
          -- elseif vim.g.current_jupyter_repl == 2 then
          --   nn.run_cell()
          --
          --   local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          --   if neo then
          --     vim.cmd 'Neopyter run current'
          --   end
        end
      end, { desc = 'Run current cell' })

      vim.keymap.set('n', neopyter_leader .. 'j', function()
        if vim.g.current_jupyter_repl == 0 then
          nn.run_and_move()
        elseif vim.g.current_jupyter_repl == 1 then
          local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          if neo then
            vim.cmd 'Neopyter run current'
            nn.move_cell 'd'
          end
          -- elseif vim.g.current_jupyter_repl == 2 then
          --   local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          --   if neo then
          --     vim.cmd 'Neopyter run current'
          --   end
          --
          --   nn.run_and_move()
        end
      end, { desc = 'Run and move to next cell' })

      vim.keymap.set({ 'n', 'v' }, '<C-k>', function()
        if vim.g.current_jupyter_repl == 0 then
          nn.move_cell 'u'
        elseif vim.g.current_jupyter_repl == 1 then
          local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          if neo then
            nn.move_cell 'u'
          end
        end
      end, { desc = 'Jump to Previous Cell' })
      vim.keymap.set({ 'n', 'v' }, '<C-j>', function()
        if vim.g.current_jupyter_repl == 0 then
          nn.move_cell 'd'
        elseif vim.g.current_jupyter_repl == 1 then
          local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          if neo then
            nn.move_cell 'd'
          end
        end
      end, { desc = 'Jump to Next Cell' })

      vim.keymap.set('n', neopyter_leader .. 'rr', function()
        if vim.g.current_jupyter_repl == 0 then
          nn.run_all_cells()
        elseif vim.g.current_jupyter_repl == 1 then
          local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          if neo then
            vim.cmd 'Neopyter run all'
            vim.cmd 'normal G'
          end
          -- elseif vim.g.current_jupyter_repl == 2 then
          --   nn.run_all_cells()
          --
          --   local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          --   if neo then
          --     vim.cmd 'Neopyter run all'
          --   end
        end
      end, { desc = 'Run all cells' })

      vim.keymap.set('n', neopyter_leader .. 'ra', function()
        if vim.g.current_jupyter_repl == 0 then
          nn.run_cells_above()
        elseif vim.g.current_jupyter_repl == 1 then
          local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          if neo then
            vim.cmd 'Neopyter run allAbove'
          end
          -- elseif vim.g.current_jupyter_repl == 2 then
          --   nn.run_cells_above()
          --
          --   local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          --   if neo then
          --     vim.cmd 'Neopyter run allAbove'
          --   end
        end
      end, { desc = 'Run above cells' })

      vim.keymap.set('n', neopyter_leader .. 'rb', function()
        if vim.g.current_jupyter_repl == 0 then
          nn.run_cells_below()
        elseif vim.g.current_jupyter_repl == 1 then
          local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          if neo then
            vim.cmd 'Neopyter run allBelow'
            vim.cmd 'normal G'
          end
          -- elseif vim.g.current_jupyter_repl == 2 then
          --   nn.run_cells_below()
          --
          --   local neo = check_neopyter_buffers(vim.api.nvim_get_current_buf())
          --   if neo then
          --     vim.cmd 'Neopyter run allBelow'
          --   end
        end
      end, { desc = 'Run current and below cells' })

      vim.keymap.set('n', neopyter_leader .. 's', function()
        nn.split_cell()
      end, { desc = 'Split cell at line' })

      vim.keymap.set('n', neopyter_leader .. 'm', function()
        nn.merge_cell 'd'
      end, { desc = 'Merge with cell below' })

      vim.keymap.set('n', neopyter_leader .. 'M', function()
        nn.merge_cell 'u'
      end, { desc = 'Merge with cell above' })

      vim.keymap.set('n', neopyter_leader .. 'sk', function()
        nn.swap_cell 'u'
      end, { desc = 'Swap with cell above' })

      vim.keymap.set('n', neopyter_leader .. 'sj', function()
        nn.swap_cell 'd'
      end, { desc = 'Swap with cell below' })

      vim.keymap.set('n', neopyter_leader .. 'cc', function()
        nn.comment_cell()
      end, { desc = 'Comment current cell' })

      vim.keymap.set('n', neopyter_leader .. 'o', function()
        nn.add_cell_below()
      end, { desc = 'Add cell below' })

      vim.keymap.set('n', neopyter_leader .. 'O', function()
        nn.add_cell_above()
      end, { desc = 'Add cell above' })

      vim.keymap.set('n', neopyter_leader .. 't', function()
        nn.add_text_cell_below()
      end, { desc = 'Add text cell below' })

      vim.keymap.set('n', neopyter_leader .. 'T', function()
        nn.add_text_cell_above()
      end, { desc = 'Add text cell below' })

      vim.keymap.set('n', neopyter_leader .. 'T', function()
        nn.add_text_cell_above()
      end, { desc = 'Add text cell below' })

      vim.keymap.set('n', neopyter_leader .. 'cy', function()
        nn.convert_to_code_cell()
      end, { desc = 'Convert to code cell' })

      vim.keymap.set('n', neopyter_leader .. 'cm', function()
        nn.convert_to_markdown_cell()
      end, { desc = 'Convert to markdown cell' })

      vim.keymap.set('n', neopyter_leader .. 'va', function()
        nn.visually_select_cell 'a'
      end, { desc = 'Visually select contents around cell' })

      vim.keymap.set('n', neopyter_leader .. 'vi', function()
        nn.visually_select_cell 'i'
      end, { desc = 'Visually select contents inside cell' })

      vim.keymap.set('n', neopyter_leader .. 'ca', function()
        nn.change_cell 'a'
      end, { desc = 'Change contents around cell' })

      vim.keymap.set('n', neopyter_leader .. 'ci', function()
        nn.change_cell 'i'
      end, { desc = 'Change contents inside cell' })

      vim.keymap.set('n', neopyter_leader .. 'da', function()
        nn.delete_cell 'a'
      end, { desc = 'Delete contents around cell' })

      vim.keymap.set('n', neopyter_leader .. 'di', function()
        nn.delete_cell 'i'
      end, { desc = 'Delete contents inside cell' })

      local create_molten_autocmds = function()
        vim.api.nvim_create_augroup('Molten-Import', { clear = true })
        vim.api.nvim_create_autocmd('BufReadPost', {
          group = 'Molten-Import',
          pattern = '*.ipynb',
          callback = function()
            pcall(vim.cmd, 'MoltenImportOutput')
          end,
        })

        vim.api.nvim_create_augroup('Molten-Export', { clear = true })
        vim.api.nvim_create_autocmd('User', {
          group = 'Molten-Export',
          pattern = 'JupytextBufWritePost',
          callback = function()
            pcall(vim.cmd, 'MoltenExportOutput!')
          end,
        })

        vim.api.nvim_create_augroup('Molten-Quit', { clear = true })
        vim.api.nvim_create_autocmd('QuitPre', {
          group = 'Molten-Quit',
          pattern = '*.ipynb',
          callback = function()
            vim.cmd 'MoltenExportOutput!'
          end,
        })
      end

      local create_neopyter_autocmds = function()
        vim.api.nvim_create_augroup('Neopyter-Save', { clear = true })
        vim.api.nvim_create_autocmd('BufWriteCmd', {
          group = 'Neopyter-Save',
          pattern = '*.ipynb',
          callback = function(bufargs)
            if vim.g.current_jupyter_repl == 1 then
              vim.api.nvim_set_option_value('modified', false, { buf = bufargs.buf })

              vim.cmd 'Neopyter sync current'
              vim.defer_fn(function()
                local ok, _ = pcall(vim.cmd, 'Neopyter execute docmanager:save')
                if ok then
                  vim.notify('Saved ' .. bufargs.file .. ' with neopyter.nvim in jupyterlab', vim.log.levels.INFO)
                else
                  vim.notify('Not Saved ' .. bufargs.file .. ' with neopyter.nvim in jupyterlab', vim.log.levels.ERROR)
                end
              end, 500)
            end
          end,
        })
      end

      local cycle_jupyter_repl = function(is_initial)
        if vim.g.current_jupyter_repl == 0 then
          vim.notify('Using Molten.nvim as repl', vim.log.levels.INFO)

          create_molten_autocmds()
          if not is_initial then
            vim.api.nvim_del_augroup_by_name 'Neopyter-Save'
            pcall(vim.cmd, 'MoltenImportOutput')
          end
        elseif vim.g.current_jupyter_repl == 1 then
          vim.notify('Using Neopyter as repl', vim.log.levels.INFO)

          create_neopyter_autocmds()

          if not is_initial then
            vim.api.nvim_del_augroup_by_name 'Molten-Import'
            vim.api.nvim_del_augroup_by_name 'Molten-Export'
            vim.api.nvim_del_augroup_by_name 'Molten-Quit'
            pcall(vim.cmd, 'Neopyter sync current')
            pcall(vim.cmd, 'Neopyter execute docmanager:reload')
          end
        end
      end

      -- 0: Molten
      -- 1: Neopyter
      vim.g.current_jupyter_repl = 1
      cycle_jupyter_repl(true)

      vim.keymap.set('n', '<leader>jcp', function()
        local current_jupyter_repl = (vim.g.current_jupyter_repl + 1) % 2
        vim.g.current_jupyter_repl = current_jupyter_repl

        cycle_jupyter_repl(false)
      end, { desc = 'Cycle between jupyter repls' })

      -- Mini AI
      local ai = require 'mini.ai'
      local ai_opts = require('lazy.core.config').plugins['mini.ai'].opts() or {}

      ai_opts.custom_textobjects = vim.tbl_extend('force', ai_opts.custom_textobjects or {}, {
        j = nn.miniai_spec,
      })

      ---@diagnostic disable-next-line: param-type-mismatch
      ai.setup(ai_opts)

      -- Mini HiPatterns
      local hipatterns = require 'mini.hipatterns'
      local hipatterns_opts = require('lazy.core.config').plugins['mini.hipatterns'].opts or {}

      hipatterns_opts.highlighters = vim.tbl_extend('force', hipatterns_opts.highlighters or {}, {
        cells = nn.minihipatterns_spec,
      })

      ---@diagnostic disable-next-line: param-type-mismatch
      hipatterns.setup(hipatterns_opts)
    end,
  },

  { -- Jupytext Nvim: covnert .ipynb to its equvalient .py
    'IniyanKanmani/jupytext.nvim',

    lazy = false,

    opts = {
      jupytext = 'jupytext',
      format = 'py:percent',
      update = true,
      autosync = true,
      sync_patterns = { '*.md', '*.py', '*.jl', '*.R', '*.Rmd', '*.qmd' },
      handle_url_schemes = false,
      async_write = true,
    },
  },

  { -- Neopyter: Sync Neovim with Jupyter Lab
    'SUSTech-data/neopyter',

    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'AbaoFromCUG/websocket.nvim', -- for mode='direct'
    },

    lazy = true,

    opts = {
      mode = 'direct',
      auto_connect = true,
      auto_attach = true,
      remote_address = '127.0.0.1:9001',
      file_pattern = { '*.ju.*', '*.ipynb' },
      on_attach = function(bufnr)
        local bufs = vim.g.neopyter_buffers or {}
        table.insert(bufs, bufnr)
        vim.g.neopyter_buffers = bufs
      end,
      jupyter = {
        auto_activate_file = true,
        partial_sync = false,
        scroll = {
          enable = true,
          align = 'smart',
        },
      },
      highlight = {
        enable = false,
        mode = 'separator',
      },
      textobject = {
        enable = false,
        queries = { 'cellseparator', 'cellcontent', 'cell' },
      },
      parser = {
        python = {},
        trim_whitespace = true,
      },
      injection = {
        enable = true,
      },
    },
    config = function(_, opts)
      local neopyter = require 'neopyter'
      neopyter.setup(opts)
      local navigator_leader = '<leader>j'
      vim.keymap.set('n', navigator_leader .. 'nc', function()
        vim.cmd 'Neopyter sync current'
      end, { desc = 'Sync current buffer with Neopyter' })

      vim.keymap.set('n', navigator_leader .. 'nk', function()
        vim.cmd 'Neopyter kernel restart'
      end, { desc = 'Restart Neopyter kernel' })

      vim.keymap.set('n', navigator_leader .. 'ns', function()
        vim.cmd 'Neopyter execute docmanager:save'
      end, { desc = 'Save Neopyter notebook' })

      vim.keymap.set('n', navigator_leader .. 'nr', function()
        vim.cmd 'Neopyter execute docmanager:reload'
      end, { desc = 'Reload Neopyter notebook from disk' })
    end,
  },
}
