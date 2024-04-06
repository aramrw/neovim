return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	dependencies = {
		{ "github/copilot.lua" },  -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	config = function()
		require("CopilotChat").setup()
		-- Use a function for the keymapping
		vim.keymap.set("v", "<leader>mo", ":CopilotChat ", {})
		vim.keymap.set("n", "<leader>mo", ":CopilotChat ", {})
	end,
}
