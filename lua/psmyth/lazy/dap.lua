return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
        "mfussenegger/nvim-dap",
        {
            "theHamsta/nvim-dap-virtual-text",
            config = function()
                require("nvim-dap-virtual-text").setup {
                    commented = true,
                }
            end,
        },
        "rcarriga/nvim-dap-ui",
        "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
        require("mason-nvim-dap").setup({
            ensure_installed = { "python" },
            automatic_installation = true,
            -- automatic_setup = false,
            handlers = {}, -- sets up dap in the predefined manner
        })
        local dap, dapui = require "dap", require "dapui"
        dapui.setup {}

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        dap.adapters.lldb = {
            type = 'executable',
            command = 'lldb-dap',
            name = "lldb"
        }

        dap.configurations.cuda = {
            name = "Launch",
            type = "lldb",
            request = "launch",
            miDebuggerPath = "/usr/bin/cuda-gdb",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            externalConsole = false,
            cwd = '${workspaceFolder}',
            setupCommands = {
                {
                    text = '-enable-pretty-printing',
                    description = 'enable pretty printing',
                    ignoreFailures = false
                },
            },
        }

        dap.configurations.rust = {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            initCommands = function()
                local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

                local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

                local commands = {}
                local file = io.open(commands_file, 'r')
                if file then
                    for line in file:lines() do
                        table.insert(commands, line)
                    end
                    file:close()
                end
                table.insert(commands, 1, script_import)

                return commands
            end,
        }

        dap.configurations.cpp = {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
        }

        dap.configurations.c = dap.configurations.cpp

        -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md

        require('dap-go').setup()
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
                    local venv_path = os.getenv('VIRTUAL_ENV')
                    local conda_path = os.getenv('CONDA_PREFIX')

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
    keys = {
        { "<leader>dR", function() require("dap").run_to_cursor() end,                               desc = "Run to Cursor", },
        { "<leader>dE", function() require("dapui").eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
        { "<leader>dC", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
        { "<leader>dU", function() require("dapui").toggle() end,                                    desc = "Toggle UI", },
        { "<leader>db", function() require("dap").step_back() end,                                   desc = "Step Back", },
        { "<leader>dc", function() require("dap").continue() end,                                    desc = "Continue", },
        { "<leader>dd", function() require("dap").disconnect() end,                                  desc = "Disconnect", },
        { "<leader>de", function() require("dapui").eval() end,                                      mode = { "n", "v" },             desc = "Evaluate", },
        { "<leader>dg", function() require("dap").session() end,                                     desc = "Get Session", },
        { "<leader>dh", function() require("dap.ui.widgets").hover() end,                            desc = "Hover Variables", },
        { "<leader>dS", function() require("dap.ui.widgets").scopes() end,                           desc = "Scopes", },
        { "<leader>di", function() require("dap").step_into() end,                                   desc = "Step Into", },
        { "<leader>do", function() require("dap").step_over() end,                                   desc = "Step Over", },
        { "<leader>dp", function() require("dap").pause.toggle() end,                                desc = "Pause", },
        { "<leader>dq", function() require("dap").close() end,                                       desc = "Quit", },
        { "<leader>dr", function() require("dap").repl.toggle() end,                                 desc = "Toggle REPL", },
        { "<leader>ds", function() require("dap").continue() end,                                    desc = "Start", },
        { "<leader>dt", function() require("dap").toggle_breakpoint() end,                           desc = "Toggle Breakpoint", },
        { "<leader>dx", function() require("dap").terminate() end,                                   desc = "Terminate", },
        { "<leader>du", function() require("dap").step_out() end,                                    desc = "Step Out", },
    },
}
