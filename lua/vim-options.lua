-- set tab width to 2 instead of 4
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
-- set line numbers
vim.cmd("set number")
-- set smart case search
vim.cmd("set ignorecase")

-- dont automatically switch to the dir when a file gets opened
--vim.opt.autochdir = false

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
-- vim.cmd([[ autocmd VimEnter * Copilot disable ]])

-- relative line numbers
vim.wo.relativenumber = true

vim.cmd("nnoremap <C-Right> :wincmd w<CR>")
vim.cmd("nnoremap <C-Left> :wincmd W<CR>")

local function open_diagnostics_if_exist()
	-- Get diagnostics for the current buffer
	local diagnostics = vim.diagnostic.get()

	-- Return early if there are no diagnostics
	if #diagnostics == 0 then
		return
	end

	-- Open a floating diagnostic window if there are diagnostics
	vim.diagnostic.open_float(nil, {
		scope = "line",
		border = "rounded",
		relative = "editor",
		format = function(diagnostic)
			if diagnostic.source == 'rustc'
					and diagnostic.user_data.lsp.data ~= nil
			then
				return diagnostic.user_data.lsp.data.rendered
			else
				return diagnostic.message
			end
		end,
	})
end

-- Map a key to the diagnostics
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

-- vim.cmd([[
--   augroup remember_folds
--     autocmd!
--     au BufWinLeave ?* mkview 1
--     au BufWinEnter ?* silent! loadview 1
--   augroup END
-- ]])
