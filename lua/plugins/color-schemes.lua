-- return {
-- 	"catppuccin/nvim",
-- 	lazy = false,
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

-- return {
-- 	"comfysage/evergarden",
-- 	name = "evergarden",
-- 	priority = 1000,
-- 	config = function()
-- 		config = require("evergarden").setup({
-- 			transparent_background = true,
-- 			contrast_dark = "hard", -- 'hard'|'medium'|'soft'
-- 			override_terminal = false,
-- 			style = {
-- 				tabline = { reverse = true, color = "green" },
-- 				search = { reverse = false, inc_reverse = true },
-- 				types = { italic = true },
-- 				keyword = { italic = true },
-- 				comment = { italic = false },
-- 			},
-- 			overrides = {}, -- add custom overrides
-- 		})
-- 		vim.cmd.colorscheme("evergarden")
-- 	end,
-- }

return {
	"rebelot/kanagawa.nvim",
	name = "kanagawa",
	priority = 1000,
	config = function()
		config = require("kanagawa").setup({
			theme = "wave", -- Load "wave" theme when 'background' option is not set
			background = { -- map the value of 'background' option to a theme
				dark = "dragon", -- try "dragon" !
				light = "lotus",
			},
		})
		vim.cmd.colorscheme("kanagawa")
	end,
}
