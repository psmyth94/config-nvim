return {
  {
    'saghen/blink.cmp',
    enabled = false,
    optional = true,
  },
  -- Setup nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require 'cmp'
      local defaults = require 'cmp.config.default'()
      local auto_select = true
      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = 'menu,menuone,noinsert' .. (auto_select and '' or ',noselect'),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = PSVim.cmp.confirm { select = auto_select },
          ['<C-y>'] = PSVim.cmp.confirm { select = true },
          ['<S-CR>'] = PSVim.cmp.confirm { behavior = cmp.ConfirmBehavior.Replace }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-CR>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ['<tab>'] = function(fallback)
            return PSVim.cmp.map({ 'snippet_forward', 'ai_accept' }, fallback)()
          end,
        },
        sources = cmp.config.sources({
          { name = 'lazydev' },
          { name = 'nvim_lsp' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = function(entry, item)
            local icons = PSVim.config.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
              end
            end

            return item
          end,
        },
        experimental = {
          -- only show ghost text when we show ai completions
          ghost_text = vim.g.ai_cmp and {
            hl_group = 'CmpGhostText',
          } or false,
        },
        sorting = defaults.sorting,
      }
    end,
    main = 'psvim.util.cmp',
  },

  -- snippets
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'garymjr/nvim-snippets',
        opts = {
          friendly_snippets = true,
        },
        dependencies = { 'rafamadriz/friendly-snippets' },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          return PSVim.cmp.expand(item.body)
        end,
      }
      if PSVim.has 'nvim-snippets' then
        table.insert(opts.sources, { name = 'snippets' })
      end
    end,
  },
}
