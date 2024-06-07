return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
    end,
    keys = {
        { mode = "n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>" },
        { mode = "v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>" },
    },
}
