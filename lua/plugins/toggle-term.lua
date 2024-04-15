return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		config = require("toggleterm").setup({
			open_mapping = [[<C-l>]],
			autochdir = true,
		})
		vim.keymap.set("n", "<leader>tt", ":2ToggleTerm<CR>", {})
	end,
}
