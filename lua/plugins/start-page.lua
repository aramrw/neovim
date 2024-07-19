return {
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	config = function()
		require('dashboard').setup {
			theme = 'hyper',
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{ desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
					{
						icon = ' ',
						icon_hl = '@variable',
						desc = 'Programming Files',
						group = 'Label',
						action = 'cd f:\\programming\\rust | Neotree toggle',
						key = 'A',
					},
					{
						icon = ' ',
						icon_hl = '@variable',
						desc = 'Lua Files',
						group = 'Label',
						action = 'cd c:\\users\\arami\\appdata\\local\\nvim | Neotree toggle',
						key = 'B',
					},
					-- {
					-- 	desc = ' Apps',
					-- 	group = 'DiagnosticHint',
					-- 	action = 'Telescope app',
					-- 	key = 'a',
					-- },
					-- {
					-- 	desc = ' dotfiles',
					-- 	group = 'Number',
					-- 	action = 'Telescope dotfiles',
					-- 	key = 'd',
					-- },
				},
			}, }
	end,
	dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
