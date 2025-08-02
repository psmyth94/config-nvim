return {
  {
    'goerz/jupytext.nvim',
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, 'jupytext')
        end,
      },
    },
    opts = {}, -- see Options
  },
}
