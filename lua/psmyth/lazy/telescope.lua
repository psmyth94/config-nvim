return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep",
        "theprimeagen/refactoring.nvim",
    },

    config = function()
        require('telescope').setup({})
        vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>",
            { noremap = true, desc = "telescope live grep" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>",
            { noremap = true, desc = "telescope find buffers" })
        vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",
            { noremap = true, desc = "telescope help page" })
        vim.keymap.set("n", "<leader>ma", "<cmd>Telescope marks<CR>", { noremap = true, desc = "telescope find marks" })
        vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>",
            { noremap = true, desc = "telescope find oldfiles" })
        vim.keymap.set("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>",
            { noremap = true, desc = "telescope find in current buffer" })
        vim.keymap.set("n", "<leader>cm", "<cmd>Telescope git_commits<CR>",
            { noremap = true, desc = "telescope git commits" })
        vim.keymap.set("n", "<leader>gt", "<cmd>Telescope git_status<CR>",
            { noremap = true, desc = "telescope git status" })
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",
            { noremap = true, desc = "telescope find files" })
        vim.keymap.set(
            "n",
            "<leader>fa",
            "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
            { noremap = true, desc = "telescope find all files" }
        )
        vim.keymap.set({ "n", "x" }, "<leader>fr", function()
            require("telescope").extensions.refactoring.refactors()
        end, { noremap = true, desc = "telescope refactoring" })

        local function escape_for_telescope(text)
            -- escape \.*[]^$~\\<>()/
            return text:gsub("\\", "\\\\"):gsub("%.", "\\.")
                :gsub("%*", "\\*"):gsub("%[", "\\["):gsub("%]", "\\]")
                :gsub("%^", "\\^"):gsub("%$", "\\$"):gsub("%~", "\\~")
                :gsub("\\", "\\\\"):gsub("<", "\\<"):gsub(">", "\\>")
                :gsub("%(", "\\("):gsub("%)", "\\)"):gsub("/", "\\/")
                :gsub("\n", ""):gsub("\r", "")
        end

        vim.keymap.set("v", "<leader>fs", function()
            vim.cmd('normal! y')
            local text = vim.fn.getreg('"')
            text = escape_for_telescope(text)
            require('telescope.builtin').live_grep({ default_text = text })
        end, { noremap = true, silent = true })

        -- zenmode
        vim.keymap.set("n", "<leader>zz", function()
            require("zen-mode").setup {
                window = {
                    width = 90,
                    options = {}
                },
            }
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = true
            vim.wo.rnu = true
            ColorMyPencils()
        end)


        vim.keymap.set("n", "<leader>zZ", function()
            require("zen-mode").setup {
                window = {
                    width = 80,
                    options = {}
                },
            }
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = false
            vim.wo.rnu = false
            vim.opt.colorcolumn = "0"
            ColorMyPencils()
        end)
    end
}
