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
        python_host = vim.g.python3_host_prog or 'python3',
        default_notebook_URL = 'localhost:8080/nbclassic',

        -- Specify Firefox binary path
        firefox_options = {
          binary_location = '/usr/bin/firefox',
        },

        -- jupyter command configuration
        jupyter_command = 'jupyter',
        notebook_dir = nil,
      }
    end,
  },
  'rcarriga/nvim-notify', -- optional
  'stevearc/dressing.nvim', -- optional, UI for :JupyniumKernelSelect
}
