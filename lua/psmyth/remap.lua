local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
local map = vim.keymap.set
map("n", "<leader>pv", vim.cmd.Ex)

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- greatest remap ever
map("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map({ "n", "v" }, "<leader>d", [["_d]])

map("i", "<C-c>", "<Esc>")

map("n", "Q", "<nop>")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader><leader>", vim.lsp.buf.format)
map("n", "<leader>s", [[:%s/\v<<C-r><C-w>>//gI<Left><Left><Left>]])

-- for goml and nvim quick access
map("n", "<leader>nv", "<cmd>Ex ~/.config/nvim<CR>")
map("n", "<leader>cnv", "<cmd>cd ~/.config/nvim<CR>")
map("n", "<leader>go", "<cmd>Ex ~/genomicsml<CR>")
map("n", "<leader>cgo", "<cmd>cd ~/genomicsml<CR>")

-- DAP
map('n', '<F5>', ":lua require'dap'.continue()<CR>", opts)
map('n', '<F10>', ":lua require'dap'.step_over()<CR>", opts)
map('n', '<F11>', ":lua require'dap'.step_into()<CR>", opts)
map('n', '<F12>', ":lua require'dap'.step_out()<CR>", opts)
map('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", opts)
map('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
map('n', '<leader>lp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
map('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", opts)
map('n', '<leader>dl', ":lua require'dap'.run_last()<CR>", opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- NvChad maps
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<ESC>$a", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- commenting
map("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "comment toggle" })
map(
    "v",
    "<leader>/",
    "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    { desc = "comment toggle" }
)


-- Telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
    "n",
    "<leader>fa",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "telescope find all files" }
)

-- zenmode
vim.keymap.set("n", "<leader>zz", function()
    require("zen-mode").setup {
        window = {
            width = 90,
            options = {}
        },
    }
    require("zen-mode").toggle()
    vim.wo.wrap = false
    vim.wo.number = true
    vim.wo.rnu = true
    ColorMyPencils()
end)


vim.keymap.set("n", "<leader>zZ", function()
    require("zen-mode").setup {
        window = {
            width = 80,
            options = {}
        },
    }
    require("zen-mode").toggle()
    vim.wo.wrap = false
    vim.wo.number = false
    vim.wo.rnu = false
    vim.opt.colorcolumn = "0"
    ColorMyPencils()
end)

-- Fugitive
map('n', '<leader>gp', '<cmd>Git push origin<CR>', opts)

-- Harpoon
vim.keymap.set("n", "<leader>a", function() require("harpoon.mark").add_file() end)
vim.keymap.set("n", "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end)

vim.keymap.set("n", "<C-h>", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() require("harpoon.ui").nav_file(4) end)
vim.keymap.set("n", "<leader><C-h>", function() require("harpoon.mark").set_current_at(1) end)
vim.keymap.set("n", "<leader><C-t>", function() require("harpoon.mark").set_current_at(2) end)
vim.keymap.set("n", "<leader><C-n>", function() require("harpoon.mark").set_current_at(3) end)
vim.keymap.set("n", "<leader><C-s>", function() require("harpoon.mark").set_current_at(4) end)

-- Slime
-- some ipython specific mappings
local function slime_send(send_to_repl)
    local start_line = vim.fn.search('# %%', 'bnW')


    if start_line == 0 then
        start_line = 1
    end


    local end_line = vim.fn.search('# %%', 'nW')
    if end_line == 0 then
        end_line = vim.fn.line('$')
    else
        end_line = end_line - 1
    end


    if send_to_repl then
        vim.fn['slime#send_range'](start_line, end_line)
    end

    return end_line
end

vim.keymap.set('n', '<leader>cc', function()
    slime_send(true)
end, { noremap = true, silent = true })


vim.keymap.set('n', '<C-X>', function()
    local end_line = slime_send(true)

    if vim.fn.search('# %%', 'nW') == 0 then
        vim.cmd('$')
        vim.cmd('normal o# %%')
    else
        vim.cmd([[normal ]] .. end_line + 2 .. 'G')
    end
end, { noremap = true, silent = true })


vim.keymap.set('n', '<leader>nc', function()
    local end_line = slime_send(false)

    if vim.fn.search('# %%', 'nW') == 0 then
        vim.cmd('$')
        vim.cmd('normal o')
        vim.cmd('normal o# %%')
    else
        vim.cmd([[normal ]] .. end_line .. 'GO')
        vim.cmd([[normal O# %%]])
    end

    vim.cmd('normal j')
    vim.cmd('startinsert')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>rr', function()
    vim.fn['slime#send']('exit()\n')
    vim.fn['slime#send']('ipython\n')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ip', function()
    vim.fn['slime#send']('ipython\n')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>gm', function()
    --
    vim.fn['slime#send']('conda activate genomicsml\n')
end, { noremap = true, silent = true })
