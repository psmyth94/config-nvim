return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
        "mfussenegger/nvim-dap",
        "williamboman/mason.nvim",
    },
    config = function()
        -- Configure nvim-dap
        local dap = require('dap')

        -- Set up debugpy for Python
        dap.adapters.python = {
            type = 'executable',
            command = 'python',
            args = { '-m', 'debugpy.adapter' },
        }

        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Launch file',
                program = '${file}', -- This configuration will launch the current file
                pythonPath = function()
                    local venv_path = os.getenv('VIRTUAL_ENV')
                    if venv_path then
                        return venv_path .. '/bin/python'
                    else
                        return '/usr/bin/python' -- Adjust to your system's Python path if needed
                    end
                end,
            },
        }

    end
}
