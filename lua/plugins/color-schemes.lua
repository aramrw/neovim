local colorscheme_file = vim.fn.stdpath('data') .. '/colorscheme'

-- Define the available color schemes
local colorschemes = {
	"catppuccin",
	"evergarden",
	"kanagawa",
	"kanagawa-paper",
	"miasma",
	"gruvbox-material",
	"rose-pine",
	"nordic",
}

-- Lua Line themes to map to editor themes how I want
local lualine_themes = {
	["catppuccin"] = "auto",
	["evergarden"] = "auto",
	["kanagawa"] = "gruvbox",
	["kanagawa-paper"] = "auto",
	["miasma"] = "auto",
	["gruvbox-material"] = "auto",
	["rose-pine"] = "auto",
	["nordic"] = "auto",
}

-- Function to read the last selected color scheme from the file
local function read_colorscheme()
	local f = io.open(colorscheme_file, "r")
	if f then
		local colorscheme = f:read("*l")
		f:close()
		return colorscheme
	end
	return nil
end

-- Function to write the selected color scheme to the file
local function write_colorscheme(colorscheme)
	local f = io.open(colorscheme_file, "w")
	if f then
		f:write(colorscheme)
		f:close()
	end
end

-- Function to switch to the selected color scheme and set the corresponding lualine theme
local function select_colorscheme()
	vim.ui.select(colorschemes, {
		prompt = 'Select colorscheme:',
		format_item = function(item)
			return 'Colorscheme: ' .. item
		end,
	}, function(choice)
		if choice then
			vim.cmd.colorscheme(choice)
			write_colorscheme(choice)
			local lualine_theme = lualine_themes[choice]
			require('lualine').setup({
				options = {
					theme = lualine_theme
				}
			})
		end
	end)
end

-- Read and set the last selected color scheme on startup
local function persist_colorscheme()
	local last_colorscheme = read_colorscheme()
	if last_colorscheme then
		vim.cmd.colorscheme(last_colorscheme)
		local lualine_theme = lualine_themes[last_colorscheme]
		require('lualine').setup({
			options = {
				theme = lualine_theme
			}
		})
	end
end

vim.schedule(persist_colorscheme)

-- Keybind to select and switch color schemes (example: leader + cs)
vim.keymap.set('n', '<leader>cs', select_colorscheme, { noremap = true, silent = true })

-- Plugin setup
return {
	-- setup lua line
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			require('lualine').setup({
				-- options = {
				-- 	theme = 'auto'
				-- }
			})
		end
	},
	-- setup colorschemes
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				integrations = {
					neotree = true,
					nvimtree = false,
				}
			})
		end,
	},
	{
		"comfysage/evergarden",
		name = "evergarden",
		priority = 1000,
		config = function()
			require("evergarden").setup({
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
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				undercurl = true,
				commentStyle = { italic = true },
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				terminalColors = true,
				theme = "wave",
				background = {
					dark = "dragon",
					light = "lotus"
				},
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "#151515",
								dragonRed = "red"
							},
							-- syn = {
							-- 	operator = "#FF4B4B",
							-- 	preproc  = "#FF4B4B",
							-- 	special2 = "#FF4B4B",
							-- 	special3 = "#FF4B4B",
							-- }
						}
					}
				},
				overrides = function(colors)
					local theme = colors.theme
					local diagnostics = {
						["Error"] = "#E05A5A",
						["Warn"] = "#F8CD7D",
						["Info"] = "#7DC1F8",
						["Hint"] = "#8D99F6",
					}
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						WinSeparator = { fg = "#333333", bg = "#121212" },
						DiagnosticError = { fg = diagnostics.Error },
						DiagnosticFloatingError = { fg = diagnostics.Error },
						DiagnosticSignError = { fg = diagnostics.Error },

						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					}
				end
			})
		end
	},
	{
		"sho-87/kanagawa-paper.nvim",
		name = "kanagawa-paper",
		priority = 1000,
		config = function()
			require('kanagawa-paper').setup({
				background = { -- map the value of 'background' option to a theme
					dark = "dragon", -- try "dragon" !
					light = "lotus",
				},
				undercurl = true,
				transparent = true,
				gutter = false,
				-- dimInactive = true, -- disabled when transparent
				terminalColors = true,
				commentStyle = { italic = true },
				functionStyle = { italic = false },
				keywordStyle = { italic = false, bold = false },
				statementStyle = { italic = false, bold = false },
				typeStyle = { italic = false },
				colors = { theme = {}, palette = {} }, -- override default palette and theme colors
				overrides = function(colors)
					local theme = colors.theme
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },

						-- NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					}
				end
			})
		end,
	},
	{
		"xero/miasma.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme miasma")
		end,
	},
	{
		'sainnhe/gruvbox-material',
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_background = 'hard'
			vim.g.gruvbox_material_enable_italic = true
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,
				enable = {
					terminal = true,
					legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
					migrations = true,
				},
			})
		end,
	},
	{
		'AlexvZyl/nordic.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			local palette = require 'nordic.colors'
			require("nordic").setup({
				bright_border = true,
				reduced_blue = true,
				italic_comments = true,
				telescope = {
					style = "classic"
				},
				-- override = {
				-- 	Normal = {
				-- 		bg = palette.black0,
				-- 		undercurl = true,
				-- 	}
				-- }
			})
		end
	},
}
