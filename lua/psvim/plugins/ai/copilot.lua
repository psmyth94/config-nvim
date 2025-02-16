return {
  -- copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = '<M-]>',
          prev = '<M-[>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  -- add ai_accept action
  {
    'zbirenbaum/copilot.lua',
    opts = function()
      PSVim.cmp.actions.ai_accept = function()
        if require('copilot.suggestion').is_visible() then
          PSVim.create_undo()
          require('copilot.suggestion').accept()
          return true
        end
      end
    end,
  },

  -- lualine
  {
    'nvim-lualine/lualine.nvim',
    optional = true,
    event = 'VeryLazy',
    opts = function(_, opts)
      table.insert(
        opts.sections.lualine_x,
        2,
        PSVim.lualine.status(PSVim.config.icons.kinds.Copilot, function()
          local clients = package.loaded['copilot'] and PSVim.lsp.get_clients { name = 'copilot', bufnr = 0 } or {}
          if #clients > 0 then
            local status = require('copilot.api').status.data.status
            return (status == 'InProgress' and 'pending') or (status == 'Warning' and 'error') or 'ok'
          end
        end)
      )
    end,
  },

  {
    {
      'hrsh7th/nvim-cmp',
      optional = true,
      dependencies = { -- this will only be evaluated if nvim-cmp is enabled
        {
          'zbirenbaum/copilot-cmp',
          opts = {},
          config = function(_, opts)
            local copilot_cmp = require 'copilot_cmp'
            copilot_cmp.setup(opts)
            -- attach cmp source whenever copilot attaches
            -- fixes lazy-loading issues with the copilot cmp source
            PSVim.lsp.on_attach(function()
              copilot_cmp._on_insert_enter {}
            end, 'copilot')
          end,
          specs = {
            {
              'hrsh7th/nvim-cmp',
              optional = true,
              ---@param opts cmp.ConfigSchema
              opts = function(_, opts)
                opts.sources = opts.sources or {}
                table.insert(opts.sources, 1, {
                  name = 'copilot',
                  group_index = 1,
                  priority = 100,
                })
              end,
            },
          },
        },
      },
    },
  },
}
