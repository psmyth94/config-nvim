return {
    "theprimeagen/harpoon",
    config = function()
        require("harpoon").setup({})
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", function() mark.add_file() end)
        vim.keymap.set("n", "<C-e>", function() ui.toggle_quick_menu() end)

        vim.keymap.set("n", "<A-H>", function() ui.nav_file(1) end)
        vim.keymap.set("n", "<A-T>", function() ui.nav_file(2) end)
        vim.keymap.set("n", "<A-N>", function() ui.nav_file(3) end)
        vim.keymap.set("n", "<A-S>", function() ui.nav_file(4) end)
        vim.keymap.set("n", "<leader><A-H>", function() mark.set_current_at(1) end)
        vim.keymap.set("n", "<leader><A-T>", function() mark.set_current_at(2) end)
        vim.keymap.set("n", "<leader><A-N>", function() mark.set_current_at(3) end)
        vim.keymap.set("n", "<leader><A-S>", function() mark.set_current_at(4) end)
    end,
}
