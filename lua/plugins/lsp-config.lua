return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "append",
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"jsonls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			local os_info = vim.loop.os_uname()

			local function get_cmd_config(server_name, additional_args)
				local is_windows = os_info.sysname:lower():find("windows") ~= nil
				local base_commands = {
					lua_ls = "lua-language-server",
					jsonls = "vscode-json-language-server",
					html = "vscode-html-language-server",
					taplo = "taplo",
				}

				if not is_windows or not base_commands[server_name] then
					return nil
				end

				local bin_path = "c:/users/arami/appData/local/nvim-data/mason/bin/"
				local command = base_commands[server_name]

				local cmd_parts = vim.split(command, " ")
				local executable = bin_path .. cmd_parts[1]
				table.remove(cmd_parts, 1)
				table.insert(cmd_parts, 1, executable)

				if additional_args and type(additional_args) == "table" then
					vim.list_extend(cmd_parts, additional_args)
				end

				return cmd_parts
			end

			local function setup_lsp(server_name, extra_config)
				local default_config = { capabilities = capabilities }
				local config = vim.tbl_deep_extend("force", default_config, extra_config or {})

				if not config.cmd then
					local cmd_config = get_cmd_config(server_name, config.cmd_args)
					if cmd_config then
						config.cmd = cmd_config
					end
				end

				lspconfig[server_name].setup(config)
			end

			setup_lsp("lua_ls")
			setup_lsp("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
						extraArgs = {
							"--",
							"--no-deps",
							"-Dclippy::correctness",
							"-Dclippy::complexity",
							"-Wclippy::perf",
							"-Wclippy::pedantic",
							"-Wclippy::all",
							"-Wclippy::cargo",
							"-Wclippy::nursery",
							"-Wclippy::style",
							"-Wclippy::suspicious",
						},
						procMacro = {
							enable = true,
						},
						diagnostics = {
							styleLints = { enable = true },
						},
					},
				},
			})

			setup_lsp("clangd")
			setup_lsp("tailwindcss")
			setup_lsp("emmet_language_server")
			setup_lsp("jsonls", {
				cmd_args = { "--stdio" }
			})
			setup_lsp("html")
			setup_lsp("taplo", {
				cmd_args = { "lsp", "stdio" },
			})

			-- Keybinds
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set({ "n" }, "<leader>gf", vim.lsp.buf.format, {})
			vim.keymap.set("n", "<leader>gr", function()
				require("telescope.builtin").lsp_references()
			end, {})
		end,
	},
}
