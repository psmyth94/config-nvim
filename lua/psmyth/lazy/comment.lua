return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
        vim.keymap.set("n", "<leader>/", function()
            require("Comment.api").toggle.linewise.current()
        end, { noremap = true, desc = "comment toggle" })
        vim.keymap.set(
            "v",
            "<leader>/",
            "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
            { noremap = true, desc = "comment toggle" }
        )
    end,
}
