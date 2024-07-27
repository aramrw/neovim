local colorscheme_file = vim.fn.stdpath('data') .. '/colorscheme'

-- Define the available color schemes
local colorschemes = {
	"kanagawa",
	"miasma",
	"gruvbox-material",
	"rose-pine",
	"lackluster",
}

-- Lua Line themes to map to editor themes how I want
local lualine_themes = {
	["kanagawa"] = "gruvbox",
	["miasma"] = "auto",
	["gruvbox-material"] = "auto",
	["rose-pine"] = "auto",
	["lackluster"] = "auto",
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

-- Keybind to select and switch color schemes
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
			vim.g.gruvbox_material_background = 'hard'
			vim.g.gruvbox_material_enable_italic = true
			-- vim.g.gruvbox_material_transparent_background = true
			vim.g.gruvbox_material_float_style = "dim"
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
		"slugbyte/lackluster.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- lackluster-hack, lackluster-mint, lackluster
			-- local lackluster = require("lackluster")
		end,
	}
}
