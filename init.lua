-- set up lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		-- latest stable release
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {
	rocks = {
		enabled = false,
		-- root = vim.fn.stdpath("data") .. "/lazy-rocks",
		-- server = "https://nvim-neorocks.github.io/rocks-binaries/",
		-- -- use hererocks to install luarocks?
		-- -- set to `nil` to use hererocks when luarocks is not found
		-- -- set to `true` to always use hererocks
		-- -- set to `false` to always use luarocks
		hererocks = nil,
	},
}

require("vim-options")
require("cmds")
require("lazy").setup("plugins", opts)
