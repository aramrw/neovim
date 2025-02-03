return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local os_info = vim.loop.os_uname()

		local options = {
			shell = "c:/users/arami/appdata/local/programs/nu/bin/nu.exe",
			shellcmdflag = '--stdin --no-newline -c',
			shellredir = "out+err> %s",
			shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record",
			shelltemp = false,
			shellxescape = "",
			shellxquote = "",
			shellquote = "",
		}

		for opt, val in pairs(options) do
			vim.opt[opt] = val
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
