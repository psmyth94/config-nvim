require("psmyth.set")
require("psmyth.remap")
require("psmyth.lazy_init")

vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/envs/genomicsml/bin/python")

local augroup = vim.api.nvim_create_augroup
local psmythGroup = augroup("psmyth", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = psmythGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = psmythGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, opts)
	end,
})

vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.clipboard = "unnamedplus"
if vim.fn.executable("xclip") == 0 then
	print("xclip not found, clipboard integration won't work")
else
	vim.g.clipboard = {
		name = "xclip",
		copy = {
			["+"] = "xclip -selection clipboard",
			["*"] = "xclip -selection primary",
		},
		paste = {
			["+"] = "xclip -selection clipboard -o",
			["*"] = "xclip -selection primary -o",
		},
		cache_enabled = true,
	}
end

vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>", { noremap = true, desc = "quickfix prev" })
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>", { noremap = true, desc = "quickfix next" })

vim.keymap.set("n", "<leader>fd", function()
	-- Utility function to trim strings
	local function trim(s)
		return s:match("^%s*(.-)%s*$")
	end

	-- Utility function to split lines based on textwidth
	local function split_lines(str, indent)
		local tw = vim.opt.textwidth:get()
		local splitted_lines = {}
		local line = indent

		for word in str:gmatch("%S+") do
			if #line + #word + 1 <= tw then
				line = line .. word .. " "
			else
				table.insert(splitted_lines, line)
				line = indent .. word .. " "
			end
		end
		table.insert(splitted_lines, line)
		return splitted_lines
	end

	-- Function to format Python docstrings
	local function format_python_docstring()
		local start_line = vim.fn.search('"""', "bnW")
		local end_line = vim.fn.search('"""', "nW") - 1
		local sections = {
			"args",
			"arguments",
			"attributes",
			"example",
			"examples",
			"note",
			"notes",
			"raises",
			"references",
			"returns",
			"yields",
			"methods",
			"members",
			"other",
			"param",
			"params",
			"parameters",
			"props",
			"properties",
		}

		local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

		local function is_section(str)
			for _, section in ipairs(sections) do
				if str:lower() == section then
					return true
				end
			end
			return false
		end

		local parsed = { main = { None = { "" } } }
		local current_section = "main"
		local current_subsection = nil
		local section_keys = { "main" }
		local subsection_keys = {}

		local base_indent = nil
		local par_num = 1

		for _, line in ipairs(lines) do
			if base_indent == nil then
				base_indent = line:match("^%s*"):len()
			end
			local clean_line = trim(line)
			if clean_line == "" then
				par_num = par_num + 1
			else
				if clean_line:match("^%s*.+:") then
					par_num = 1
					local section = trim(clean_line:match("^%s*(.+):%s*"))
					if is_section(section) then
						current_section = section
						table.insert(section_keys, section)
						current_subsection = nil
						if not parsed[current_section] then
							parsed[current_section] = {}
						end
					else
						if not subsection_keys[current_section] then
							subsection_keys[current_section] = {}
						end
						table.insert(subsection_keys[current_section], section)
						current_subsection = section
						if not parsed[current_section][current_subsection] then
							parsed[current_section][current_subsection] = { "" }
						end
						local description = trim(clean_line:match("^%s*.+:%s*(.*)"))
						if description then
							parsed[current_section][current_subsection][1] = parsed[current_section][current_subsection][1]
								.. description
								.. " "
						end
					end
				elseif current_subsection then
					if #parsed[current_section][current_subsection] < par_num then
						parsed[current_section][current_subsection][par_num] = ""
					end
					parsed[current_section][current_subsection][par_num] = parsed[current_section][current_subsection][par_num]
						.. clean_line
						.. " "
				else
					current_subsection = "None"
					if parsed[current_section]["None"] == nil then
						parsed[current_section]["None"] = { "" }
					elseif #parsed[current_section]["None"] < par_num then
						parsed[current_section]["None"][par_num] = ""
					end
					if subsection_keys[current_section] == nil then
						subsection_keys[current_section] = { "None" }
					end
					parsed[current_section]["None"][par_num] = parsed[current_section]["None"][par_num]
						.. clean_line
						.. " "
				end
			end
		end

		local new_lines = {}
		local indent_count = 4
		for _, section in ipairs(section_keys) do
			local subsections = parsed[section]
			if section == "main" then
				for i, desc in ipairs(subsections["None"]) do
					desc = trim(desc)
					if #desc > 0 then
						if i > 1 then
							table.insert(new_lines, "")
						end
						local cleaned_description = split_lines(desc, string.rep(" ", base_indent))
						for _, line in ipairs(cleaned_description) do
							table.insert(new_lines, line)
						end
					end
				end
			else
				table.insert(new_lines, "")
				table.insert(new_lines, string.rep(" ", base_indent) .. section .. ":")
				for _, subsection in pairs(subsection_keys[section]) do
					local description = subsections[subsection]
					subsection = trim(subsection)
					if subsection == "None" then
						for i, desc in ipairs(description) do
							desc = trim(desc)
							if #desc > 0 then
								if i > 1 then
									table.insert(new_lines, "")
								end
								local cleaned_description =
									split_lines(desc, string.rep(" ", base_indent + indent_count))
								for _, line in ipairs(cleaned_description) do
									table.insert(new_lines, line)
								end
							end
						end
					else
						local parsed_subsection = string.rep(" ", base_indent + indent_count) .. subsection .. ":"
						if
							#description == 1
							and #parsed_subsection + 1 + #description[1] <= vim.opt.textwidth:get()
						then
							table.insert(new_lines, parsed_subsection .. " " .. trim(description[1]))
						else
							table.insert(new_lines, parsed_subsection)
							for i, desc in ipairs(description) do
								desc = trim(desc)
								if #desc > 0 then
									if i > 1 then
										table.insert(new_lines, "")
									end
									local cleaned_description =
										split_lines(desc, string.rep(" ", base_indent + indent_count * 2))
									for _, line in ipairs(cleaned_description) do
										table.insert(new_lines, line)
									end
								end
							end
						end
					end
				end
			end
		end
		table.insert(new_lines, "")
		vim.api.nvim_buf_set_text(0, start_line, 0, end_line, 0, new_lines)
	end

	-- Function to format generic text (non-Python)
	local function format_generic_text()
		local start_line = 0
		local end_line = vim.fn.line("$") - 1

		-- Ensure that start_line and end_line are within valid range
		local total_lines = vim.api.nvim_buf_line_count(0)
		if end_line >= total_lines then
			end_line = total_lines - 1
		end
		local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

		local base_indent = nil
		local new_lines = {}
		local current_par = ""

		local indent = nil
		local skip = false
		for _, line in ipairs(lines) do
			local clean_line = trim(line)
			if base_indent == nil then
				base_indent = line:match("^%s*"):len()
			end
			indent = string.rep(" ", base_indent)
			if skip then
				if clean_line:match("```") then
					skip = false
				end
				table.insert(new_lines, line)
				base_indent = nil
			elseif clean_line == "" then
				if current_par ~= "" then
					local cleaned = split_lines(current_par, indent)
					for _, cline in ipairs(cleaned) do
						table.insert(new_lines, cline)
					end
					current_par = ""
					table.insert(new_lines, "") -- Preserve paragraph break
				else
					table.insert(new_lines, "") -- Multiple empty lines
				end
				base_indent = nil
			elseif clean_line:match("```") then
				skip = true
				if current_par ~= "" then
					local cleaned = split_lines(current_par, indent)
					for _, cline in ipairs(cleaned) do
						table.insert(new_lines, cline)
					end
					current_par = ""
				end
				table.insert(new_lines, line)
				base_indent = nil
			else
				if current_par ~= "" then
					current_par = current_par .. " " .. clean_line
				else
					current_par = clean_line
				end
			end
		end

		-- Add the last paragraph if any
		if current_par ~= "" then
			local cleaned = split_lines(current_par, indent)
			for _, cline in ipairs(cleaned) do
				table.insert(new_lines, cline)
			end
		end
		table.insert(new_lines, "")

		vim.api.nvim_buf_set_text(0, start_line, 0, end_line, 0, new_lines)
	end

	if vim.bo.filetype == "python" then
		format_python_docstring()
	else
		format_generic_text()
	end
end, { noremap = true, desc = "format docstring" })

vim.keymap.set("n", "<leader>iq", function()
	local qflist = vim.fn.getqflist()
	local prompt = vim.fn.input("Import statement: ")
	local one_by_one = vim.fn.input("One by one? (y/n): ")
	local prev_file_name = nil
	for buffnr, qf in ipairs(qflist) do
		local continue = "y"
		-- use the buffnr to get the file path
		local file_path = vim.fn.bufname(qf.bufnr)
		if file_path ~= nil and file_path ~= prev_file_name then
			vim.cmd("cc " .. qf.bufnr)
			if one_by_one == "y" then
				-- jump to buffnr in quickfix
				vim.cmd("norm gg")
				continue = vim.fn.input("Continue (" .. file_path .. ")? (y/n): ")
			end
			if continue == "y" or continue == "" then
				local file_content = vim.fn.readfile(file_path)
				if prev_file_name ~= file_path then
					table.insert(file_content, 1, prompt)
					vim.fn.writefile(file_content, file_path)
					prev_file_name = file_path
					vim.lsp.buf.code_action({
						context = {
							only = { "source.organizeImports.ruff" },
						},
						apply = true,
					})
					if one_by_one == "y" then
						vim.fn.input("Press Enter to continue")
					end
				end
			end
		end
		prev_file_name = file_path
	end
end, { noremap = true, desc = "import quickfix" })
