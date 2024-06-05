local opts = { noremap = true, silent = true }
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader><leader>", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>s", [[:%s/\v<<C-r><C-w>>//gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s",
    [[y:%s/\v<C-R>=escape(substitute(@", '\n', '', 'g'), '={}@\.*[]^$~\\<>()/')<CR>//g<Left><Left>]], { noremap = true })
vim.keymap.set("v", "<leader>S",
    [[y:%s/\v(<C-R>=escape(substitute(@", '\n', '', 'g'), '={}@\.*[]^$~\\<>()/')<CR>)/\1/g<Left><Left>]],
    { noremap = true })

-- for goml and nvim quick access
vim.keymap.set("n", "<leader>nv", "<cmd>Ex ~/.config/nvim<CR>")
vim.keymap.set("n", "<leader>cnv", "<cmd>cd ~/.config/nvim<CR>")
vim.keymap.set("n", "<leader>go", "<cmd>Ex ~/genomicsml<CR>")
vim.keymap.set("n", "<leader>cgo", "<cmd>cd ~/genomicsml<CR>")

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { noremap = true, desc = "general clear highlights" })

-- map("n", "<C-h>", "<C-w>h", { noremap = true, desc = "switch window left" })
-- map("n", "<C-l>", "<C-w>l", { noremap = true, desc = "switch window right" })
-- map("n", "<C-j>", "<C-w>j", { noremap = true, desc = "switch window down" })
-- map("n", "<C-k>", "<C-w>k", { noremap = true, desc = "switch window up" })


-- switch tmux panes
-- map("n", "<C-H>", "<cmd>lua require('tmux').move_left()<CR>", { noremap = true, desc = "move tmux left" })
-- map("n", "<C-L>", "<cmd>lua require('tmux').move_right()<CR>", { noremap = true, desc = "move tmux right" })
-- map("n", "<C-J>", "<cmd>lua require('tmux').move_bottom()<CR>", { noremap = true, desc = "move tmux down" })
-- map("n", "<C-k>", "<cmd>lua require('tmux').move_top()<CR>", { noremap = true, desc = "move tmux up" })
