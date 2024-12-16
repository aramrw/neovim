return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local powershell_options = {
			shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
			shellcmdflag =
			"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
			shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
			shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
			shellquote = "",
			shellxquote = "",
		}

		for option, value in pairs(powershell_options) do
			vim.opt[option] = value
		end
		require("toggleterm").setup({
			open_mapping = [[<C-l>]],
			autochdir = true,
			auto_scroll = false,
			direction = "float",
			shading_facto = "-50",
			-- shading_ratio = '',
			float_opts = {
				border = "curved",
				title_pos = "center",
				zindex = 500,
			}
		})
		vim.keymap.set("n", "<leader>tt", ":2ToggleTerm<CR>", {})
	end,
}

-- uncomment this if on linux/wsl
-- and then comment out the above return block

-- return {
-- 	"akinsho/toggleterm.nvim",
-- 	version = "*",
-- 	config = function()
-- 		config = require("toggleterm").setup({
-- 			open_mapping = [[<C-l>]],
-- 			autochdir = true,
-- 		})
-- 		vim.keymap.set("n", "<leader>tt", ":2ToggleTerm<CR>", {})
-- 	end,
-- }
