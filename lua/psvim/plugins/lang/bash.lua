return {
  recommended = function()
    return PSVim.wants {
      ft = { 'sh', 'bash' },
      root = { '.bashrc', '.bash_profile', '.bash_logout', '.sh', '*.sh' },
    }
  end,
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'bash' } },
  },
  {
    'williamboman/mason.nvim',
    opts = { ensure_installed = { 'shellcheck', 'bashls' } },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
      },
    },
  },
}
