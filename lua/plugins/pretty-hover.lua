return {
	"Fildo7525/pretty_hover",
	lazy = false,
	priority = 1000,
	event = "LspAttach",
	opts = {},
	config = function()
		require("pretty_hover").setup({
			vim.keymap.set("n", "<S-k>", function()
				require("pretty_hover").hover()
			end, {})
		})
	end
}
