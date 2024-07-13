return {
	"Fildo7525/pretty_hover",
	event = "LspAttach",
	opts = {},
	config = function()
		require("pretty_hover").setup({
			vim.keymap.set("n", "<S-k>", "<CMD>:lua require(\"pretty_hover\").hover()<cr>", {})
		})
	end
}
