return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "marilari88/neotest-vitest",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
        },
        config = function()
            local neotest = require("neotest")
            local get_python_path = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                local conda_path = os.getenv("CONDA_PREFIX")
                if conda_path then
                    return conda_path .. "/bin/python"
                elseif venv_path then
                    return venv_path .. "/bin/python"
                else
                    return "/usr/bin/python"
                end
            end
            neotest.setup({
                adapters = {
                    require("neotest-vitest"),
                    require("neotest-plenary").setup({
                        min_init = "./scripts/tests/minimal.vim",
                    }),
                    require("neotest-go"),
                    require("neotest-python") {
                        dap = {
                            request = "launch",
                            justMyCode = false,
                            console = "integratedTerminal",
                            subProcess = false,
                        },
                        pytest_discovery = true,
                        runner = "pytest",
                        python = get_python_path(),
                    },
                }
            })
        end,
        keys = {
            { "<leader>tF", mode = "n", "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
            { "<leader>tL", mode = "n", "<cmd>lua require('neotest').run.run_last({strategy = 'dap'})<cr>",                desc = "Debug Last" },
            { "<leader>ta", mode = "n", "<cmd>lua require('neotest').run.attach()<cr>",                                    desc = "Attach" },
            { "<leader>tf", mode = "n", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",                     desc = "File" },
            { "<leader>tl", mode = "n", "<cmd>lua require('neotest').run.run_last()<cr>",                                  desc = "Last" },
            { "<leader>tn", mode = "n", "<cmd>lua require('neotest').run.run()<cr>",                                       desc = "Nearest" },
            { "<leader>tN", mode = "n", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",                     desc = "Debug Nearest" },
            { "<leader>to", mode = "n", "<cmd>lua require('neotest').output.open({ enter = true })<cr>",                   desc = "Output" },
            { "<leader>ts", mode = "n", "<cmd>lua require('neotest').run.stop()<cr>",                                      desc = "Stop" },
            { "<leader>tS", mode = "n", "<cmd>lua require('neotest').summary.toggle()<cr>",                                desc = "Summary" },
        },
    }
}
