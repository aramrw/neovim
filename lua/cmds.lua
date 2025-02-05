local os = vim.loop.os_uname().sysname
local home = vim.env.HOME or vim.env.USERPROFILE
local nu = {
	default_config_dir = (os == "Darwin" and home .. "/Library/Application Support/nushell") or
			(os == "Linux" and home .. "/.config/nushell") or
			(os:match("Windows") and home .. "\\AppData\\Roaming\\nushell") or
			"<unknown os>"
}

-- Define command functions first
local function delete_shada_folder()
	local shada_path = vim.fn.stdpath('data') .. '/shada/'
	local stat = vim.loop.fs_stat(shada_path)
	if stat and stat.type == 'directory' then
		local cmd
		if vim.fn.has('win32') == 1 then
			cmd = 'powershell -Command "Remove-Item -Recurse -Force \'' .. shada_path .. '\'"'
		else
			cmd = 'rm -rf "' .. shada_path .. '"'
		end
		local ok, err = os.execute(cmd)
		if ok then
			print('Shada folder deleted @: ' .. shada_path)
		else
			print('Failed to delete shada folder: ' .. (err or 'unknown error'))
		end
	else
		print('Shada folder not found.')
	end
end

local function nu_open_config()
	local cmd = ""
	if (os == 'Windows_NT') then
		cmd = string.format('explorer "%s"', nu.default_config_dir:gsub('\\', '\\\\'))
	elseif (os == 'Darwin') then
		cmd = string.format('open "%s"', nu.default_config_dir)
	elseif (os == 'Linux') then
		cmd = string.format('xdg-open "%s"', nu.default_config_dir)
	else
		print("unknown os: %s", os)
	end
	vim.cmd(string.format([[!%s]], cmd))
end

local function nu_write_config()
	local path = nu.default_config_dir;

	local text = [[
# from neovim 🚀
$env.config = {
    show_banner: false,
    buffer_editor: "nvim",
    edit_mode: "vi"
}

$env.Path = ($env.Path | split row ';') | flatten

let os = sys host;
if ($os.long_os_version | str starts-with "MacOS") {
    $env.path = ($env.path | prepend "/opt/homebrew")
}
]]
	local file, err = io.open(path, "a")
	if not file then
		return nil, err
	end
	file:write(text)
	file:close()
	return true
end

-- Now build the commands table
local aramrw_commands = {
	Nvim = {
		DeleteShadaFolder = delete_shada_folder,
	},
	Nu = {
		AppendDefaultConfig = nu_write_config,
		OpenConfig = nu_open_config,
	},
}

-- Custom completion function for module and command names
local function aramrw_completion(arg_lead, cmd_line, cursor_pos)
	local args = vim.split(cmd_line, "%s+")
	if #args == 1 then
		-- Complete module names
		local modules = {}
		for mod, _ in pairs(aramrw_commands) do
			table.insert(modules, mod)
		end
		return modules
	elseif #args == 2 then
		-- Complete command names for the given module
		local module = args[2]
		local cmds = {}
		if aramrw_commands[module] then
			for cmd, _ in pairs(aramrw_commands[module]) do
				table.insert(cmds, cmd)
			end
		end
		return cmds
	else
		return {}
	end
end

local function command_handler(opts)
	local trimmed = vim.trim(opts.args)
	local parts = vim.split(trimmed, "%s+")
	if #parts < 2 then
		print("Usage: Aramrw <module> <command> [args...]")
		return
	end

	local module = parts[1]
	local cmd_name = parts[2]
	local args = {}
	for i = 3, #parts do
		table.insert(args, parts[i])
	end

	local module_table = aramrw_commands[module]
	if not module_table then
		print("Invalid module: " .. module)
		return
	end

	local command_func = module_table[cmd_name]
	if not command_func then
		print("Invalid command for module " .. module .. ": " .. cmd_name)
		return
	end

	local ok, err = pcall(command_func, table.unpack(args))
	if not ok then
		print("Error executing command: " .. err)
	end
end

vim.api.nvim_create_user_command('Aramrw', command_handler, {
	nargs = '+',
	complete = aramrw_completion,
	desc = 'Execute Aramrw commands'
})
