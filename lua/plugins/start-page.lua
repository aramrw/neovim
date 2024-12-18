local current_platform = vim.loop.os_uname().sysname;

local os_config_action = function()
	if current_platform == "Linux" then
		return 'cd | cd .config/nvim | Neotree toggle'
	else
		if current_platform == "Windows" then
			return 'cd c:\\users\\arami\\appdata\\local\\nvim | Neotree toggle'
		end
	end
end

local os_dev_folder_action = function()
	if current_platform == "Linux" then
		return 'cd | cd .home/dev | Neotree toggle'
	else
		if current_platform == "Windows" then
			return 'cd f:\\programming | Neotree toggle'
		end
	end
end


return {
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	config = function()
		local os_config_action_path = os_config_action();
		local os_dev_folder_action_path = os_dev_folder_action();
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
						action = os_dev_folder_action_path,
						key = 'A',
					},
					{
						icon = ' ',
						icon_hl = '@variable',
						desc = 'Lua Files',
						group = 'Label',
						action = os_config_action_path,
						key = 'B',
					},
				},
			}, }
	end,
	dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
