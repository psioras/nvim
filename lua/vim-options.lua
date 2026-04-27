vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Open terminal with Space + Enter at the right side of nvim panel
vim.api.nvim_set_keymap("n", "<Leader><CR>", ":bel vnew term://zsh<CR><C-w>80|<CR>", { noremap = true })
-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

--Faster Save , Save and Quit, Force Quit:

--Save file with Space + s
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Close current window (Space + w)
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Close window" })

vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>")
vim.wo.number = true
