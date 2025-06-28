return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				-- Ensures Mason's bin directory is added to Neovim's PATH
				PATH = "append",
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp")
					.default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local lspconfig = require("lspconfig")

			-- Default LSP setup function
			local function setup_lsp(server_name, extra_config)
				local default_config = {
					capabilities = capabilities,
				}
				local config = vim.tbl_deep_extend("force", default_config, extra_config or {})
				lspconfig[server_name].setup(config)
			end

			-- Setup handlers for Mason-installed servers
			require("mason-lspconfig").setup_handlers({
				-- Default handler for most servers
				function(server_name)
					setup_lsp(server_name)
				end,
				-- Specific configuration for rust_analyzer
				["rust_analyzer"] = function()
					setup_lsp("rust_analyzer", {
						settings = {
							["rust-analyzer"] = {
								check = {
									command = "clippy",
								},
								cargo = {
									extraEnv = {
										RUSTUP_TOOLCHAIN = "nightly",
									},
									features = "all",
								},
								buildScripts = {
									enable = true,
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
				end,
				-- Additional server-specific configurations can be added here
			})

			-- Keybindings for LSP functionality
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
			vim.keymap.set("n", "<leader>gr", function()
				vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
					border = "rounded",
				})
				require("telescope.builtin").lsp_references()
			end, {})
		end,
	},
}
