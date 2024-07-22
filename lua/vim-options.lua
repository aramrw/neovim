-- set tab width to 2 instead of 4
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
-- set line numbers
vim.cmd("set number")
-- set smart case search
vim.cmd("set ignorecase")

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

-- Function to check if there are diagnostics and open the float if they exist
local function open_diagnostics_if_exist()
	-- If we find a floating window, close it.
	local found_float = false
	local diagnostics = vim.diagnostic.get()
	if #diagnostics > 0 then
		vim.diagnostic.open_float(nil, {
			scope = "line",  -- or "line"
			border = "rounded", -- or "single", "double", "shadow", "none"
			relative = "editor"
		})
	end
end

-- Map a key to the function
vim.keymap.set('n', '<Enter>', open_diagnostics_if_exist, { noremap = true, silent = true })

local options = {
	smartindent = true,
	splitbelow = true,
	splitright = true,
	signcolumn = "yes",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- hightlight yank
vim.cmd [[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]]

vim.cmd([[
  " Remap <C-Insert> to copy to system clipboard
  nnoremap <C-Insert> "+y
  vnoremap <C-Insert> "+y
  " Remap <S-Insert> to paste from system clipboard
  nnoremap <S-Insert> "+p
  inoremap <S-Insert> <C-R>+
]])

vim.cmd([[
  augroup remember_folds
    autocmd!
    au BufWinLeave ?* mkview 1
    au BufWinEnter ?* silent! loadview 1
  augroup END
]])
