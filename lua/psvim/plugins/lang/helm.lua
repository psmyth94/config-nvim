return {
  recommended = function()
    return PSVim.wants {
      ft = 'helm',
      root = 'Chart.yaml',
    }
  end,

  { 'towolf/vim-helm', ft = 'helm' },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'helm' } },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        helm_ls = {},
      },
      setup = {
        yamlls = function()
          PSVim.lsp.on_attach(function(client, buffer)
            if vim.bo[buffer].filetype == 'helm' then
              vim.schedule(function()
                vim.cmd 'LspStop ++force yamlls'
              end)
            end
          end, 'yamlls')
        end,
      },
    },
  },
}
