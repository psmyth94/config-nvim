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
    opts = {
      jupytext = 'jupytext',
      format = 'py:percent',
      update = true,
      filetype = require('jupytext').get_filetype,
      new_template = require('jupytext').default_new_template(),
      sync_patterns = { '*.md', '*.py', '*.jl', '*.R', '*.Rmd', '*.qmd' },
      autosync = true,
      handle_url_schemes = false,
    },
  },
}
