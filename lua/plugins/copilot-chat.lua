return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	dependencies = {
		{ "github/copilot.vim" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	config = function()
		require("CopilotChat").setup({
			context = "buffers",
			window = {
				layout = "float",
				height = 0.8,
				width = 0.8,
			},
		})

		-- Use a function for the keymapping
		vim.keymap.set("v", "<leader>mo", ":CopilotChat ", {})
		vim.keymap.set("n", "<leader>mo", ":CopilotChat ", {})
		vim.keymap.set("n", "<leader>mc", ":CopilotChatToggle<CR>", {})
		vim.keymap.set("n", "<leader>mr", ":CopilotChatReset<CR>", {})
	end,
}
