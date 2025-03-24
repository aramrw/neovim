return {
	"akinsho/toggleterm.nvim",
	config = function()
		local os = vim.loop.os_uname().sysname;
		if (os == "Windows_NT") then
			vim.opt["shell"] = "cmd";
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
	end
}
