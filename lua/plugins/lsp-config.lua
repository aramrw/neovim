return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup(
				{ PATH = "append" }
			)
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"tailwindcss",
					"emmet_language_server",
					"jsonls",
					"taplo",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local os_info = vim.loop.os_uname()
			local lspconfig = require("lspconfig")

			-- Function to get command configuration based on OS
			local function get_cmd_config(server_name)
				local is_windows = os_info.sysname:lower():find("windows") ~= nil
				local base_commands = {
					lua_ls = "lua-language-server",
					emmet_language_server = "emmet-language-server --stdio",
					jsonls = "vscode-json-language-server --stdio",
					html = "vscode-html-language-server --stdio",
					taplo = "taplo lsp stdio",
					-- pyright = "pyright-langserver --stdio",
					-- pylsp = "pylsp",
				}

				if not is_windows or not base_commands[server_name] then
					return nil
				end

				local bin_path = "c:/users/arami/appData/local/nvim-data/mason/bin/"
				return { bin_path .. base_commands[server_name] }
			end

			-- Helper function to setup LSP with conditional cmd
			local function setup_lsp(server_name, extra_config)
				local config = vim.tbl_deep_extend("force",
					{ capabilities = capabilities },
					extra_config or {}
				)

				local cmd_config = get_cmd_config(server_name)
				if cmd_config then
					config.cmd = cmd_config
				end

				lspconfig[server_name].setup(config)
			end

			-- Setup each LSP with the helper function
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
							"-Wclippy::nursery",
						},
						procMacro = {
							enable = true,
						},
						diagnostics = {
							styleLints = { enable = true },
						}
					},
				},
			})

			setup_lsp("clangd")
			setup_lsp("tailwindcss")
			setup_lsp("emmet_language_server")
			setup_lsp("jsonls")
			setup_lsp("html")
			setup_lsp("taplo")

			-- Keybinds
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set({ "n" }, "<leader>gf", vim.lsp.buf.format, {})
			vim.keymap.set("n", "<leader>gr", function()
				require('telescope.builtin').lsp_references()
			end, {})
		end,
	},
}
