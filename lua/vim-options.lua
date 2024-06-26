-- set tab width to 2 instead of 4
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
-- set line numbers
vim.cmd("set number")
-- set smart case search
vim.cmd("set smartcase")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set leader to space
vim.g.mapleader = " "

-- enable 24-bit color
vim.opt.termguicolors = true

-- set <c-s> to save
vim.cmd("nnoremap <c-s> :w<cr>")

-- set <leader>bd to close buffer
vim.cmd("nnoremap <leader>bd :bd!<cr>")
vim.cmd("tnoremap <leader>bd <C-\\><C-n>:bd!<cr>")

-- disable copilot on startup
vim.cmd([[ autocmd VimEnter * Copilot disable ]])

-- relative line numbers
vim.wo.relativenumber = true

vim.cmd("nnoremap <C-Right> :wincmd w<CR>")
vim.cmd("nnoremap <C-Left> :wincmd W<CR>")
