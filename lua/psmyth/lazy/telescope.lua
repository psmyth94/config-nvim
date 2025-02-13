return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		"theprimeagen/refactoring.nvim",
	},
	keys = {
		{
			mode = "n",
			"<leader>fw",
			"<cmd>Telescope live_grep<CR>",
			desc = "telescope live grep",
		},
		{
			mode = "n",
			"<leader>fb",
			"<cmd>Telescope buffers<CR>",
			desc = "telescope find buffers",
		},
		{
			mode = "n",
			"<leader>fh",
			"<cmd>Telescope help_tags<CR>",
			desc = "telescope help page",
		},
		{
			mode = "n",
			"<leader>ma",
			"<cmd>Telescope marks<CR>",
			desc = "telescope find marks",
		},
		{
			mode = "n",
			"<leader>fo",
			"<cmd>Telescope oldfiles<CR>",
			desc = "telescope find oldfiles",
		},
		{
			mode = "n",
			"<leader>fz",
			"<cmd>Telescope current_buffer_fuzzy_find<CR>",
			desc = "telescope find in current buffer",
		},
		{
			mode = "n",
			"<leader>cm",
			"<cmd>Telescope git_commits<CR>",
			desc = "telescope git commits",
		},
		{
			mode = "n",
			"<leader>gt",
			"<cmd>Telescope git_status<CR>",
			desc = "telescope git status",
		},
		{
			mode = "n",
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			desc = "telescope find files",
		},
		{
			mode = "n",
			"<leader>fa",
			"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
			desc = "telescope find all files",
		},
		{
			mode = "n",
			"<leader>fd",
			"<cmd>Telescope diagnostics<CR>",
			desc = "telescope diagnostics",
		},
		{
			mode = "n",
			"<leader>fr",
			"<cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
			desc = "telescope refactoring",
		},
		{
			mode = "n",
			"<leader>fr",
			function()
				require("telescope").extensions.refactoring.refactors()
			end,
			desc = "telescope refactoring",
		},
		{
			mode = "v",
			"<leader>fs",
			function()
				local function escape_for_telescope(text)
					-- escape \.*[]^$~\\<>()/
					return text:gsub("\\", "\\\\")
						:gsub("%.", "\\.")
						:gsub("%*", "\\*")
						:gsub("%[", "\\[")
						:gsub("%]", "\\]")
						:gsub("%^", "\\^")
						:gsub("%$", "\\$")
						:gsub("%~", "\\~")
						:gsub("\\", "\\\\")
						:gsub("<", "\\<")
						:gsub(">", "\\>")
						:gsub("%(", "\\(")
						:gsub("%)", "\\)")
						:gsub("/", "\\/")
						:gsub("\n", "")
						:gsub("\r", "")
				end

				vim.cmd("normal! y")
				local text = vim.fn.getreg('"')
				text = escape_for_telescope(text)
				require("telescope.builtin").live_grep({ default_text = text })
			end,
			desc = "telescope visual selection",
		},
		{
			mode = "n",
			"<leader>zz",
			function()
				require("zen-mode").setup({
					window = {
						width = 90,
						options = {},
					},
				})
				require("zen-mode").toggle()
				vim.wo.wrap = false
				vim.wo.number = true
				vim.wo.rnu = true
				ColorMyPencils()
			end,
			desc = "zen mode",
		},
	},
}
