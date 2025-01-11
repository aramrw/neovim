local colorscheme_file = vim.fn.stdpath('data') .. '/colorscheme'
-- plugin setup
local colorschemes = {
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			local lualine = require('lualine')
			-- Now don't forget to initialize lualine
			lualine.setup({})
		end
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 2000,
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
								bg_gutter = "#181515",
							},
						}
					}
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						WinSeparator = { fg = "#333333", bg = "#121212" },
						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					}
				end
			})
		end
	},
	{
		"ilof2/posterpole.nvim",
		config = function()
			require("posterpole").setup({
				transparent = true,
				colorless_bg = false,       -- grayscale or not
				dim_inactive = false,       -- highlight inactive splits
				brightness = 0,             -- negative numbers - darker, positive - lighter
				selected_tab_highlight = false, --highlight current selected tab
				fg_saturation = 0,          -- font saturation, gray colors become more brighter
				bg_saturation = 30,         -- background saturation
				colors = {
					posterpole = {},          -- { mainRed = "#550000" }
					posterpole_term = {},     -- { mainRed = 95 }
				},
			})
		end
	},
	{
		"ramojus/mellifluous.nvim",
		config = function()
			require("mellifluous").setup({
				-- invert bg shades for all colorsets
				color_overrides = {
					dark = {
						bg = function(bg)
							return bg:darkened(5)
						end,
					}
				},
			})
		end
	},
	{
		'sainnhe/gruvbox-material',
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = 'hard'
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_float_style = "dim"
		end,
	},
	{
		"slugbyte/lackluster.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"Mofiqul/vscode.nvim",
		config = function()
			require("vscode").setup({
				transparent = true,
			})
		end
	},
	{
		"vague2k/vague.nvim",
		lazy = false,
		config = function()
			require("vague").setup({
				style = {
					-- ... other opts
					-- Override colors
					colors = {
						floatBorder = "#242424", -- <-- here
						comment = "#646477", -- <-- and here
					},
				}
			})
		end
	},
	{
		"zenbones-theme/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		-- config = function()
		--     vim.g.zenbones_darken_comments = 45
		-- end
	},
}

local function extract_title(url)
	if (url) then
		for v in url:gmatch(".*/(.-)%.nvim$") do
			if (v) then
				return v;
			end
		end
	end
end

-- lualine themes map to editor themes.
local lualine_themes = {}
for i, scheme in ipairs(colorschemes) do
	-- dont add 'lualine' as a colorscheme
	if i ~= 1 then
		local name = extract_title(scheme[1])
		if name and name ~= "lualine" then
			lualine_themes[name] = "auto"
		end
	end
end

-- overwrite lualine_themes
-- lualine_themes["kanagawa"] = "gruvbox"
lualine_themes["kanagawa"] = "lackluster"
lualine_themes["vague"] = "lackluster"

-- write the selected color scheme to file
local function write_colorscheme(colorscheme)
	local f = io.open(colorscheme_file, "w")
	if f then
		f:write(colorscheme)
		f:close()
	end
end

-- read the last selected color scheme from file
local function read_colorscheme()
	local f = io.open(colorscheme_file, "r")
	if f then
		local colorscheme = f:read("*l")
		f:close()
		return colorscheme
	end
end

-- apply selected color scheme &
-- set corresponding lualine theme
local function apply_colorscheme(choice)
	vim.cmd.colorscheme(choice)
	write_colorscheme(choice)
	local lualine = require('lualine')
	if lualine then
		pcall(lualine.setup, {
			options = {
				theme = lualine_themes[choice]
			}
		})
	end
end

-- switch to the selected color scheme
local function select_colorscheme()
	local scheme_names = {}
	for i, scheme in ipairs(colorschemes) do
		-- dont add 'lualine' as a colorscheme
		if i ~= 1 then
			local name = extract_title(scheme[1])
			if name then
				table.insert(scheme_names, name)
			end
		end
	end
	vim.ui.select(scheme_names, {
		prompt = 'Select colorscheme:',
		format_item = function(item)
			return 'Colorscheme: ' .. item
		end,
	}, function(choice)
		if choice then
			apply_colorscheme(choice)
		end
	end)
end

-- read and set last selected color scheme on startup
local function persist_colorscheme()
	local last_colorscheme = read_colorscheme()
	if last_colorscheme then
		apply_colorscheme(last_colorscheme)
	end
end

vim.schedule(persist_colorscheme)
-- select and switch color schemes
vim.keymap.set('n', '<leader>cs', select_colorscheme, { noremap = true, silent = true })

return colorschemes
