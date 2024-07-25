return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = {
                "vimdoc", "javascript", "typescript", "c", "lua", "rust",
                "jsdoc", "bash", "python", "markdown", "markdown_inline",
                "cpp", "cuda", "go"
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enable = true
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = false, -- you can change this if you want.
                    goto_next_start = {
                        --- ... other keymaps
                        ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
                    },
                    goto_previous_start = {
                        --- ... other keymaps
                        ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
                    },
                },
                select = {
                    enable = true,
                    lookahead = true, -- you can change this if you want
                    keymaps = {
                        --- ... other keymaps
                        ["ib"] = { query = "@code_cell.inner", desc = "in block" },
                        ["ab"] = { query = "@code_cell.outer", desc = "around block" },
                    },
                },
                swap = { -- Swap only works with code blocks that are under the same
                    -- markdown header
                    enable = true,
                    swap_next = {
                        --- ... other keymap
                        ["<leader>sbl"] = "@code_cell.outer",
                    },
                    swap_previous = {
                        --- ... other keymap
                        ["<leader>sbh"] = "@code_cell.outer",
                    },
                },
            }
        })

        local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        treesitter_parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = {"src/parser.c", "src/scanner.c"},
                branch = "master",
            },
        }

        vim.treesitter.language.register("templ", "templ")
    end
}
