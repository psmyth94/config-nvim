return {
    "theprimeagen/harpoon",
    config = function()
        require("harpoon").setup({})
    end,
    keys = {
        { mode = "n", "<leader>a",     function() require("harpoon.mark").add_file() end },
        { mode = "n", "<C-e>",         function() require("harpoon.ui").toggle_quick_menu() end },
        { mode = "n", "<C-h>",         function() require("harpoon.ui").nav_file(1) end },
        { mode = "n", "<C-t>",         function() require("harpoon.ui").nav_file(2) end },
        { mode = "n", "<C-n>",         function() require("harpoon.ui").nav_file(3) end },
        { mode = "n", "<C-s>",         function() require("harpoon.ui").nav_file(4) end },
        { mode = "n", "<leader><C-h>", function() require("harpoon.mark").set_current_at(1) end },
        { mode = "n", "<leader><C-t>", function() require("harpoon.mark").set_current_at(2) end },
        { mode = "n", "<leader><C-n>", function() require("harpoon.mark").set_current_at(3) end },
        { mode = "n", "<leader><C-s>", function() require("harpoon.mark").set_current_at(4) end },
    },
}
