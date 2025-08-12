local DOTCONFIG = vim.fn.stdpath("config")
local HOME = os.getenv("HOME")

local function file_exists(path)
	local f = io.open(path, "r")
	if f then f:close() return true end
	return false
end

vim.api.nvim_create_user_command("Aramrw", function(opts)
	local target = opts.args
	if target ~= "nu source" then return end

	local nvim_nu_config = DOTCONFIG .. "/dotfiles/nushell/config.nu"
	local actual_nu_config = HOME .. "/.config/nushell/config.nu"
	local actual_nu_dir = HOME .. "/.config/nushell"

	if not file_exists(nvim_nu_config) then
		print("config.nu not found @: " .. nvim_nu_config)
		return
	end

	-- Create dir if it doesn't exist
	if not file_exists(actual_nu_dir) then
		vim.fn.mkdir(actual_nu_dir, "p")
	end

	-- Backup current config.nu if it exists
	if file_exists(actual_nu_config) then
		local date = os.date("%Y-%m-%d_%H-%M-%S")
		local backup_path = actual_nu_config .. ".bak." .. date
		os.rename(actual_nu_config, backup_path)
		print("Backed up existing config.nu to: " .. backup_path)
	end

	-- Create the new config.nu pointing to the Neovim-managed one
	local f, err = io.open(actual_nu_config, "w")
	if not f then
		print("Failed to write: " .. err)
		return
	end

	f:write("source " .. nvim_nu_config .. "\n")
	f:close()

	print("Linked config.nu to Neovim dotfiles version.")
end, { nargs = 1 })

