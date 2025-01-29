return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"jupytext",
				"debugpy",
				"codelldb",
				"stylua",
				"shfmt",
				-- "goimports",
				"xmlformatter",
				"yamlfmt",
				"sqlfluff",
			},
			auto_update = true,
			run_on_start = true,
		})
		require("mason-lspconfig").setup({
			auto_update = true,
			ensure_installed = {
				"lua_ls",
				"ruff",
				"pyright",
				-- "gopls",
				"bashls",
				-- "rust_analyzer",
				-- "r_language_server",
				"clangd",
				"dockerls",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["clangd"] = function()
					require("lspconfig").clangd.setup({
						capabilities = capabilities,
						filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
					})
				end,
				-- ["rust_analyzer"] = function() end, -- handled by rustaceanvim
				-- ["r_language_server"] = function()
				-- 	require("lspconfig").r_language_server.setup({
				-- 		capabilities = capabilities,
				-- 		cmd = {
				-- 			"R",
				-- 			"--vanilla",
				-- 			"--slave",
				-- 			"-e",
				-- 			"options(languageserver.formatting_style = function(options) { styler::tidyverse_style(strict=TRUE, indent_by=2)}); languageserver::run()",
				-- 		},
				-- 		filetypes = { "r" },
				-- 	})
				-- end,
				["bashls"] = function()
					require("lspconfig").bashls.setup({
						capabilities = capabilities,
						cmd = { "bash-language-server", "start" },
						filetypes = { "sh", "bash" },
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
				-- ["gopls"] = function()
				-- 	require("lspconfig").gopls.setup({
				-- 		capabilities = capabilities,
				-- 		settings = {
				-- 			gopls = {
				-- 				analyses = {
				-- 					unusedparams = true,
				-- 				},
				-- 				staticcheck = true,
				-- 			},
				-- 		},
				-- 	})
				-- end,
				["ruff"] = function()
					require("lspconfig").ruff.setup({
						on_attach = function(client, bufnr)
							if client.name == "ruff" then
								-- Disable hover in favor of Pyright
								client.server_capabilities.hoverProvider = false
							end

							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.code_action({
										context = {
											only = { "source.fixAll.ruff" },
										},
										apply = true,
									})
								end,
								group = vim.api.nvim_create_augroup("fixall_on_save_lsp", { clear = true }),
							})
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.code_action({
										context = {
											only = { "source.organizeImports.ruff" },
										},
										apply = true,
									})
								end,
								group = vim.api.nvim_create_augroup("fixall_on_save_lsp", { clear = true }),
							})
						end,
					})
				end,
				["pyright"] = function()
					require("lspconfig").pyright.setup({
						settings = {
							pyright = {
								-- Using Ruff's import organizer
								disableOrganizeImports = true,
							},
							python = {
								analysis = {
									-- Ignore all files for analysis to exclusively use Ruff for linting
									ignore = { "*" },
								},
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
