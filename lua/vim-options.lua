local os = vim.loop.os_uname().sysname;

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

if (os == "Windows_NT") then
	vim.cmd("nnoremap <C-Right> :wincmd w<CR>")
	vim.cmd("nnoremap <C-Left> :wincmd W<CR>")
end


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

for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
	local default_diagnostic_handler = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, result, context, config)
		-- Check if error exists before accessing its properties
		if err and (err.code == -32802 or err.code == -32603) then
			return
		end
		return default_diagnostic_handler(err, result, context, config)
	end
end

local function open_diagnostics_if_exist()
	-- Get diagnostics for the current buffer
	local diagnostics = vim.diagnostic.get()

	-- Return early if there are no diagnostics
	if #diagnostics == 0 then
		return
	end

	-- Open a floating diagnostic window if there are diagnostics.
	-- We have removed the custom `format` function.
	vim.diagnostic.open_float(nil, {
		scope = "line",
		border = "rounded",
		relative = "editor",
	})
end

-- Your keymap remains the same
vim.keymap.set('n', '<CR>', open_diagnostics_if_exist, { noremap = true, silent = true, desc = "Show Diagnostics" })

-- remember last cursor position in files
vim.api.nvim_create_autocmd('BufRead', {
	callback = function(opts)
		vim.api.nvim_create_autocmd('BufWinEnter', {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
						not (ft:match('commit') and ft:match('rebase'))
						and last_known_line > 1
						and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], 'nx', false)
				end
			end,
		})
	end,
})

vim.api.nvim_create_autocmd('BufRead', {
	callback = function(opts)
		vim.api.nvim_create_autocmd('BufWinEnter', {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
						not (ft:match('commit') and ft:match('rebase'))
						and last_known_line > 1
						and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], 'nx', false)
				end
			end,
		})
	end,
})
