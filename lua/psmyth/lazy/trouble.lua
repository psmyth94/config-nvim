return {
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup({
            icons = false,
        })
    end,
    keys = {
        {
            mode = "n",
            "<leader>tt",
            function()
                require("trouble").toggle()
            end
        },
        {
            mode = "n",
            "[t",
            function()
                require("trouble").next({ skip_groups = true, jump = true });
            end
        },

        {
            mode = "n",
            "]t",
            function()
                require("trouble").previous({ skip_groups = true, jump = true });
            end
        },
    }
}
