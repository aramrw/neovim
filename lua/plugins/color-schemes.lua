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
			overrides = function(colors)
				local theme = colors.theme
				return {
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },

					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
				}
			end,
		})
		vim.cmd.colorscheme("kanagawa")
	end,
}

-- return {
--   "xero/miasma.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd("colorscheme miasma")
--   end,
-- }

-- return {
-- 	'sainnhe/gruvbox-material',
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		-- Optionally configure and load the colorscheme
-- 		-- directly inside the plugin declaration.
-- 		vim.g.gruvbox_material_better_performance = 1
-- 		vim.g.gruvbox_material_background = 'hard'
-- 		vim.g.gruvbox_material_enable_italic = true
-- 		vim.cmd.colorscheme('gruvbox-material')
-- 	end
-- }
