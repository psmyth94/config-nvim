if psvim_docs then
  -- LSP Server to use for Python.
  -- Set to "basedpyright" to use basedpyright instead of pyright.
  vim.g.psvim_python_lsp = 'pyright'
  -- Set to "ruff_lsp" to use the old LSP implementation version.
  vim.g.psvim_python_ruff = 'ruff'
end

local lsp = vim.g.psvim_python_lsp or 'pyright'
local ruff = vim.g.psvim_python_ruff or 'ruff'

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
  recommended = function()
    return PSVim.wants {
      ft = 'python',
      root = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
      },
    }
  end,
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'ninja', 'rst' } },
  },
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft['python'] = opts.formatters_by_ft['python'] or {}
      table.insert(opts.formatters_by_ft['python'], 'ruff_format')
      -- opts.formatters_by_ft['py'] = opts.formatters_by_ft['py'] or {}
      -- table.insert(opts.formatters_by_ft['py'], 'ruff')
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ruff = {
          cmd_env = { RUFF_TRACE = 'messages' },
          init_options = {
            settings = {
              logLevel = 'error',
            },
          },
          keys = {
            {
              '<leader>co',
              PSVim.lsp.action['source.organizeImports'],
              desc = 'Organize Imports',
            },
          },
        },
        ruff_lsp = {
          keys = {
            {
              '<leader>co',
              PSVim.lsp.action['source.organizeImports'],
              desc = 'Organize Imports',
            },
          },
        },
      },
      setup = {
        [ruff] = function()
          PSVim.lsp.on_attach(function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end, ruff)
        end,
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      local servers = { 'pyright', 'basedpyright', 'ruff', 'ruff_lsp', ruff, lsp }
      for _, server in ipairs(servers) do
        opts.servers[server] = opts.servers[server] or {}
        opts.servers[server].enabled = server == lsp or server == ruff
      end
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-python',
    },
    config = function()
      require('neotest').setup { ---@diagnostic disable-line: missing-fields
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
            args = { '--log-level', 'DEBUG' },
            pytest_discovery = true,
            runner = 'pytest',
            python = get_python_path(),
          },
        },
      }
    end,
    keys = {
      { '<leader>tF', mode = 'n', "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = 'Debug File' },
      { '<leader>tL', mode = 'n', "<cmd>lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = 'Debug Last' },
      { '<leader>ta', mode = 'n', "<cmd>lua require('neotest').run.attach()<cr>", desc = 'Attach' },
      { '<leader>tf', mode = 'n', "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = 'File' },
      { '<leader>tl', mode = 'n', "<cmd>lua require('neotest').run.run_last()<cr>", desc = 'Last' },
      { '<leader>tn', mode = 'n', "<cmd>lua require('neotest').run.run()<cr>", desc = 'Nearest' },
      { '<leader>tN', mode = 'n', "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = 'Debug Nearest' },
      { '<leader>to', mode = 'n', "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = 'Output' },
      { '<leader>ts', mode = 'n', "<cmd>lua require('neotest').run.stop()<cr>", desc = 'Stop' },
      { '<leader>tr', mode = 'n', "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", desc = 'Run All' },
      { '<leader>tR', mode = 'n', "<cmd>lua require('neotest').run.run(vim.fn.getcwd(), {strategy = 'dap'})<cr>", desc = 'Debug Run All' },
      { '<leader>tO', mode = 'n', "<cmd>lua require('neotest').output.open()<cr>", desc = 'Open' },
      { '<leader>tT', mode = 'n', "<cmd>lua require('neotest').summary.open()<cr>", desc = 'Toggle' },
      { '<leader>tS', mode = 'n', "<cmd>lua require('neotest').summary.toggle()<cr>", desc = 'Summary' },
    },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      {
        'mason-org/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, 'debugpy')
        end,
      },
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
    },
    config = function()
      local dap_python = require 'dap-python'
      if vim.fn.has 'win32' == 1 then
        dap_python.setup(PSVim.get_pkg_path('debugpy', '/venv/Scripts/pythonw.exe'))
      else
        dap_python.setup(PSVim.get_pkg_path('debugpy', get_python_path()))
      end
      local dap = require 'dap'
      dap.adapters.lldb = {
        type = 'executable',
        command = 'lldb-dap',
        name = 'lldb',
      }
      dap.adapters.python = {
        type = 'executable',
        justMyCode = false,
        command = 'python',
        args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          justMyCode = false,
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            local venv_path = os.getenv 'VIRTUAL_ENV'
            local conda_path = os.getenv 'CONDA_PREFIX'

            if conda_path then
              return conda_path .. '/bin/python'
            elseif venv_path then
              return venv_path .. '/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }
    end,
  },

  {
    'linux-cultist/venv-selector.nvim',
    branch = 'regexp', -- Use this branch for the new version
    cmd = 'VenvSelect',
    enabled = function()
      return PSVim.has 'telescope.nvim'
    end,
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = 'python',
    keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv', ft = 'python' } },
  },

  {
    'hrsh7th/nvim-cmp',
    optional = true,
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, 'python')
    end,
  },
  -- Don't mess up DAP adapters provided by nvim-dap-python
  {
    'jay-babu/mason-nvim-dap.nvim',
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
}
