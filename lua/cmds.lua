local os = vim.loop.os_uname().sysname
local home = vim.env.HOME or vim.env.USERPROFILE
local nu = {
	default_config_dir = (os == "Darwin" and home .. "/Library/Application Support/nushell") or
			(os == "Linux" and home .. "/.config/nushell") or
			(os:match("Windows") and home .. "/AppData/Roaming/nushell") or
			"<unknown os>"
}

-- Helper function for displaying notifications
local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "Aramrw" })
end

-- Define command functions
local function delete_shada_folder()
	local shada_path = vim.fn.stdpath('data') .. '/shada/'
	local stat = vim.loop.fs_stat(shada_path)
	if not stat or stat.type ~= 'directory' then
		notify('Shada folder not found.')
		return true -- Indicate success (nothing to delete)
	end

	-- Fix: fs_rmdir in neovim doesn't accept the recursive option as a table
	-- Use vim.fn.delete instead which supports recursive deletion
	local success = vim.fn.delete(shada_path, 'rf')

	if success == 0 then
		notify('Shada folder deleted @: ' .. shada_path)
		return true
	else
		notify('Failed to delete shada folder: error code ' .. success, vim.log.levels.ERROR)
		return false
	end
end

local function open_path(newpath)
	local cmd = ""
	if (os == 'Windows_NT') then
		cmd = string.format('explorer "%s"', vim.fn.escape(newpath, '"'))
	elseif (os == 'Darwin') then
		cmd = string.format('open "%s"', vim.fn.escape(newpath, '"'))
	elseif (os == 'Linux') then
		cmd = string.format('xdg-open "%s"', vim.fn.escape(newpath, '"'))
		-- Add fallbacks for Linux
		local handle = io.popen('which gnome-open')
		if handle and handle:read() ~= nil then
			cmd = string.format('gnome-open "%s"', vim.fn.escape(newpath, '"'))
			handle:close()
		else
			handle = io.popen('which kde-open5')
			if handle and handle:read() ~= nil then
				cmd = string.format('kde-open5 "%s"', vim.fn.escape(newpath, '"'))
				handle:close()
			end
		end
	else
		notify("Unknown operating system: " .. os, vim.log.levels.WARN)
		return nil, "Unknown OS"
	end
	vim.cmd('!' .. cmd)
	return true
end

local function nvim_open_config()
	local cpath = "";
	local windows = home .. "\\appdata\\local\\nvim";
	local posix = home .. "/.config/nvim";
	if (os == 'Windows_NT') then
		cpath = windows;
	else
		cpath = posix;
	end
	open_path(cpath);
end

local function nu_write_config()
	local path = nu.default_config_dir
	local text_to_append = ""

	local file, err = io.open(path, "r")
	if not file then
		local file_create, err_create = io.open(path, "w")
		if not file_create then
			notify("Failed to create Nushell config file: " .. (err_create or "unknown error"), vim.log.levels.ERROR)
			return nil, err_create
		end
		file_create:write(text_to_append)
		file_create:close()
		notify("Nushell default config appended to: " .. path)
		return true
	else
		local content = file:read('a*')
		file:close()
		if content:find(text_to_append) then
			notify("Nushell default config already present.")
			return true
		end
	end

	local file_append, err_append = io.open(path, "a")
	if not file_append then
		notify("Failed to open Nushell config file for appending: " .. (err_append or "unknown error"), vim.log.levels.ERROR)
		return nil, err_append
	end
	file_append:write(text_to_append)
	file_append:close()
	notify("Nushell default config appended to: " .. path)
	return true
end

-- Command registry - using a more structured approach for better completion
local aramrw_commands = {
	nvim = {
		delshada = {
			func = delete_shada_folder,
			desc = "Delete the shada folder",
			params = {} -- No parameters needed
		},
		openconfig = {
			func = nvim_open_config,
			desc = "Open the Neovim Config Directory",
			params = {}
		}
	},
	nu = {
		appendconfig = {
			func = nu_write_config,
			desc = "Append default configuration to Nushell config file",
			params = { "--force", "--verbose" } -- Example parameters
		},
		openconfig = {
			func = nu_open_config,
			desc = "Open the Nushell configuration directory",
			params = {}
		},
	},
}

local function completion(lead, cmdline, cursorpos)
	-- Parse the command line to determine context
	local parts = vim.split(vim.trim(cmdline:sub(1, cursorpos)), "%s+")
	local cmd_parts_count = #parts

	-- Remove the command name from the parts count
	if parts[1] == "Aramrw" then
		cmd_parts_count = cmd_parts_count - 1
	end

	if cmd_parts_count == 0 or (cmd_parts_count == 1 and cursorpos == #cmdline) then
		-- Complete module names
		local modules = {}
		for module_name, _ in pairs(aramrw_commands) do
			if lead == "" or module_name:find("^" .. lead) then
				table.insert(modules, module_name)
			end
		end
		return modules
	elseif cmd_parts_count == 1 or (cmd_parts_count == 2 and cursorpos == #cmdline) then
		-- Complete commands for the specified module
		local module_name = parts[#parts - 1]:lower()
		local module = aramrw_commands[module_name]

		if not module then
			return {}
		end

		local commands = {}
		for cmd_name, _ in pairs(module) do
			if lead == "" or cmd_name:find("^" .. lead) then
				table.insert(commands, cmd_name)
			end
		end
		return commands
	elseif cmd_parts_count >= 2 or (cmd_parts_count == 3 and cursorpos == #cmdline) then
		-- Complete parameters for the specified command
		local module_name = parts[#parts - 2]:lower()
		local cmd_name = parts[#parts - 1]:lower()

		local module = aramrw_commands[module_name]
		if not module then return {} end

		local command = module[cmd_name]
		if not command then return {} end

		-- If the command has defined parameters, return them
		if command.params then
			local params = {}
			for _, param in ipairs(command.params) do
				if lead == "" or param:find("^" .. lead) then
					table.insert(params, param)
				end
			end
			return params
		end
	end

	return {}
end

-- Command handler with improved error messaging
local function command_handler(opts)
	local args = vim.split(vim.trim(opts.args), "%s+")

	if #args < 1 then
		local modules = vim.tbl_keys(aramrw_commands)
		table.sort(modules)
		notify("Usage: Aramrw <module> <command> [args...]", vim.log.levels.WARN)
		notify("Available modules: " .. table.concat(modules, ", "), vim.log.levels.INFO)
		return
	end

	local module_name = args[1]:lower()
	local module = aramrw_commands[module_name]

	if not module then
		notify("Invalid module: " .. module_name, vim.log.levels.ERROR)
		return
	end

	if #args < 2 then
		local commands = vim.tbl_keys(module)
		table.sort(commands)
		notify("Available commands for module '" .. module_name .. "': " .. table.concat(commands, ", "), vim.log.levels
			.INFO)
		return
	end

	local cmd_name = args[2]:lower()
	local command = module[cmd_name]

	if not command then
		local commands = vim.tbl_keys(module)
		table.sort(commands)
		notify("Invalid command: " .. cmd_name .. ". Available commands: " .. table.concat(commands, ", "),
			vim.log.levels.ERROR)
		return
	end

	-- Prepare command arguments
	local cmd_args = {}
	for i = 3, #args do
		table.insert(cmd_args, args[i])
	end

	-- Execute the command - FIXED HERE
	local ok, result = pcall(function() return command.func(unpack(cmd_args)) end)
	if not ok then
		notify("Error executing command: " .. tostring(result), vim.log.levels.ERROR)
	end
end

-- Register the command with vim
vim.api.nvim_create_user_command('Aramrw', command_handler, {
	nargs = '*',
	complete = completion,
	desc = 'Execute Aramrw commands'
})

-- Return the module for testing or extension
return {
	commands = aramrw_commands,
	notify = notify
}
