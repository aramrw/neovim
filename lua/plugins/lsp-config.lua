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
					"tsserver",
					"tailwindcss",
					"clangd",
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
			local lspconfig = require("lspconfig")
			-- sometimes looks for the lsp in the wrong directory.
			-- solved by adding an absolute path to the language servers that fail regularly.
			local bin_path = "C:/Users/arami/AppData/Local/nvim-data/mason/bin/"
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				cmd = { bin_path .. "lua-language-server.cmd" },
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
							checkThirdParty = true,
							library = vim.api.nvim_get_runtime_file("", true)
						}
					})
				end,
				settings = {
					Lua = {}
				}
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				cmd = { "C:\\Users\\arami\\.rustup\\toolchains\\nightly-x86_64-pc-windows-msvc\\bin\\rust-analyzer.exe" },
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
						-- procMacro = {
						-- 	enable = true,
						-- },
						diagnostics = {
							useRustcErrorCode = { enable = true },
							styleLints = { enable = true },
							experimental = { enable = true },
						}
						-- cargo = {
						-- 	buildScripts = {
						-- 		enable = true,
						-- 	},
						-- },
						--  assist = {}
					},
				},
			})
			require("lspconfig").clangd.setup({
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					"--offset-encoding=utf-16",
				},
			})
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})
			lspconfig.emmet_language_server.setup({
				capabilities = capabilities,
				cmd = { bin_path .. 'emmet-language-server', '--stdio' },
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
				cmd = { bin_path .. 'vscode-json-language-server', '--stdio' },
			})
			lspconfig.taplo.setup({
				capabilities = capabilities,
				cmd = { bin_path .. 'taplo', 'lsp', 'stdio' },
			})
			-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
