local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
    [[y:%s/\v<C-R>=substitute(escape(@", '`&.*+?()[]{}|\^$#=!:/-><@%'), '\n', '\\n', 'g')<CR>/\1/g<Left><Left>]],
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
