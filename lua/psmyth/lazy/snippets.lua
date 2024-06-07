return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",

        dependencies = { "rafamadriz/friendly-snippets" },

        config = function()
            require("luasnip").filetype_extend("javascript", { "jsdoc" })

            --- TODO: What is expand?
            vim.keymap.set({ "i" }, "<C-s>e", function() require("luasnip").expand() end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<C-s>;", function() require("luasnip").jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-s>,", function() require("luasnip").jump(-1) end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<C-E>", function()
                if require("luasnip").choice_active() then
                    require("luasnip").change_choice(1)
                end
            end, { silent = true })
        end,
    }
}
