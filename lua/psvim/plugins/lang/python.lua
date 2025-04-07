if psvim_docs then
  -- LSP Server to use for Python.
  -- Set to "basedpyright" to use basedpyright instead of pyright.
  vim.g.psvim_python_lsp = 'pyright'
  -- Set to "ruff_lsp" to use the old LSP implementation version.
  vim.g.psvim_python_ruff = 'ruff'
end

local lsp = vim.g.psvim_python_lsp or 'pyright'
local ruff = vim.g.psvim_python_ruff or 'ruff'

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
    optional = true,
    dependencies = {
      'nvim-neotest/neotest-python',
    },
    opts = {
      adapters = {
        ['neotest-python'] = {
          -- Extra arguments for nvim-dap configuration
          -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
          dap = { justMyCode = false },
          -- Command line arguments for runner
          -- Can also be a function to return dynamic values
          args = { '--log-level', 'DEBUG' },
          -- Runner to use. Will use pytest if available by default.
          -- Can be a function to return dynamic value.
          runner = 'pytest',
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = true,
        },
      },
    },
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
    optional = true,
    dependencies = {
      'mfussenegger/nvim-dap-python',
      {
        'williamboman/mason.nvim',
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
      config = function()
        -- fix: E5108: Error executing lua .../Local/nvim-data/lazy/nvim-dap-ui/lua/dapui/controls.lua:14: attempt to index local 'element' (a nil value)
        -- see: https://github.com/rcarriga/nvim-dap-ui/issues/279#issuecomment-1596258077
        require('dapui').setup()
        -- uses the debugpy installation by mason
        local debugpyPythonPath = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python3'
        require('dap-python').setup(debugpyPythonPath, {}) ---@diagnostic disable-line: missing-fields
      end,
    },
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
