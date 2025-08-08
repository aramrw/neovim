return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "left",
				width = 27,
			},
			commands = {
				delete = function(state)
					local path = state.tree:get_node().path
					vim.fn.system({ "trashy", vim.fn.fnameescape(path) })
					require("neo-tree.sources.manager").refresh(state.name)
				end,
			},
		})
		vim.keymap.set("n", "<C-n>", ":Neotree toggle reveal_force_cwd left<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
	end,
}
