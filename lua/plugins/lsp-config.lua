return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"tsserver",
					"rust_analyzer",
					"tailwindcss",
					"clangd",
					"emmet_language_server",
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
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
						diagnostics = {
							useRustcErrorCode = { enable = true },
							styleLints = { enable = true },
							experimental = { enable = true },
						}
					},
				},
			})
			require("lspconfig").clangd.setup({
				capabilities = capabilities,
				-- cmd = {
				-- 	"clangd",
				-- 	"--offset-encoding=utf-16",
				-- },
			})
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})
			lspconfig.emmet_language_server.setup({
				capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
						runtime = {
							version = 'LuaJIT'
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true)
						}
					})
				end,
				settings = {
					Lua = {}
				}
			})
			-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
