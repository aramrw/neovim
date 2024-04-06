-- return {
-- 	"catppuccin/nvim",
-- 	lazy = false,
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

return {
	"comfysage/evergarden",
	name = "evergarden",
	config = function()
		config = require("evergarden").setup({
			transparent_background = true,
			contrast_dark = "hard", -- 'hard'|'medium'|'soft'
			override_terminal = false,
			style = {
				tabline = { reverse = true, color = "green" },
				search = { reverse = false, inc_reverse = true },
				types = { italic = true },
				keyword = { italic = true },
				comment = { italic = false },
			},
			overrides = {}, -- add custom overrides
		})
		vim.cmd.colorscheme("evergarden")
	end,
}
