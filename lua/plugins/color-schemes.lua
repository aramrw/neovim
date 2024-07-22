local colorscheme_file = vim.fn.stdpath('data') .. '/colorscheme'

-- Define the available color schemes
local colorschemes = {
	"catppuccin",
	"evergarden",
	"kanagawa",
	"kanagawa-paper",
	"miasma",
	"gruvbox-material",
}

-- Lua Line themes to map to editor themes how I want
local lualine_themes = {
	["catppuccin"] = "auto",
	["evergarden"] = "auto",
	["kanagawa"] = "gruvbox",
	["kanagawa-paper"] = "auto",
	["miasma"] = "auto",
	["gruvbox-material"] = "auto",
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
			-- Initial colorscheme setup, if needed
		end,
	},
	{
		"comfysage/evergarden",
		name = "evergarden",
		priority = 1000,
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
		end,
	},
	{
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
		end,
	},
	"sho-87/kanagawa-paper.nvim",
	name = "kanagawa-paper",
	priority = 1000,
	config = function()
		require('kanagawa-paper').setup({
			undercurl = true,
			transparent = false,
			gutter = false,
			-- disabled when transparent
			dimInactive = true,
			terminalColors = true,
			commentStyle = { italic = true },
			functionStyle = { italic = false },
			keywordStyle = { italic = false, bold = false },
			statementStyle = { italic = false, bold = false },
			typeStyle = { italic = false },
			-- override default palette and theme colors
			colors = { theme = {}, palette = {} },
			-- override highlight groups
			overrides = function()
				return {}
			end,
		})
	end,
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

}
