return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local plat = vim.loop.os_uname().sysname;

		local powershell_options = {
			shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
			shellcmdflag =
			"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
			shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
			shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
			shellquote = "",
			shellxquote = "",
		}

		if plat == "Windows_NT" then
			for option, value in pairs(powershell_options) do
				vim.opt[option] = value
			end
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
				width = 110,
				height = 35,
				zindex = 500,
			}
		})

		vim.keymap.set("n", "<leader>tt", ":2ToggleTerm<CR>", {})
	end,
}
