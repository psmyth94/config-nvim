return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader><leader>",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			python = { "ruff_format" },
			lua = { "stylua" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			vue = { "prettierd" },
			css = { "prettierd" },
			cs = { "uncrustify" },
			go = { "goimports", "gofmt" },
			bash = { "shfmt" },
			yaml = { "yamlfmt" },
			xml = { "xmlformat" },
			markdown = { "prettierd", "injected" },
			json = { "jq" },
			rust = { "rustfmt", lsp_format = "fallback" },
			sql = { "sqlfluff" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 500 },
		formatters = {
			injected = {
				options = {
					-- Set to true to ignore errors
					ignore_errors = true,
					-- Map of treesitter language to file extension
					-- A temporary file name with this extension will be generated during formatting
					-- because some formatters care about the filename.
					lang_to_ext = {
						bash = "sh",
						python = "py",
						latex = "tex",
						markdown = "md",
						rust = "rs",
						javascript = "js",
						typescript = "ts",
						r = "r",
						sql = "sql",
						cs = "cs",
					},
				},
			},
		},
	},
	init = function()
		-- Set formatexpr for additional integration
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	dependencies = {
		{ "pamoller/xmlformatter" },
		{ "uncrustify/uncrustify" },
	},
}
