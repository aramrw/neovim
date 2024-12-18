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
			-- For Windows 11: sometimes looks for the lsp in the wrong directory.
			-- solved by adding an absolute path to the language servers that fail regularly.
			local bin_path = "c:/users/arami/appData/local/nvim-data/mason/bin/"

			lspconfig.lua_ls.setup({
				capabilities = capabilities
				--				cmd = { bin_path .. "lua-language-server" },
				-- on_init = function(client)
				-- 	local path = client.workspace_folders[1].name
				-- 	if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
				-- 		return
				-- 	end
				--
				-- 	client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				-- 		runtime = {
				-- 			version = 'LuaJIT'
				-- 		},
				-- 		-- Make the server aware of Neovim runtime files
				-- 		workspace = {
				-- 			checkThirdParty = true,
				-- 			library = vim.api.nvim_get_runtime_file("", true)
				-- 		}
				-- 	})
				-- end,
				-- settings = {
				-- 	Lua = {}
				-- }
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
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
							-- useRustcErrorCode = { enable = true },
							styleLints = { enable = true },
							-- experimental = { enable = true },
						}
					},
				},
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
				--				cmd = {
				-- 					"clangd",
				-- 					"--background-index",
				-- 					"--clang-tidy",
				-- 					"--header-insertion=iwyu",
				-- 					"--completion-style=detailed",
				-- 					"--function-arg-placeholders",
				-- 					"--fallback-style=llvm",
				-- 					"--offset-encoding=utf-16",
				-- 				},
			})
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})
			lspconfig.emmet_language_server.setup({
				capabilities = capabilities,
				--				cmd = { bin_path .. 'emmet-language-server', '--stdio' },
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
				--				cmd = { bin_path .. 'vscode-json-language-server', '--stdio' },
			})
			lspconfig.html.setup({
				capabilities = capabilities,
				--				cmd = { bin_path .. 'vscode-html-language-server', '--stdio' },
			})
			lspconfig.taplo.setup({
				capabilities = capabilities,
				--				cmd = { bin_path .. 'taplo', 'lsp', 'stdio' },
			})
			-- lspconfig.pyright.setup({
			-- 	capabilities = capabilities,
			--			-- 	cmd = { bin_path .. 'pyright-langserver', '--stdio' },
			-- })
			-- 			lspconfig.pylsp.setup({
			-- 				capabilities = capabilities,
			-- 				-- on_attach = custom_attach,
			-- --				cmd = {
			-- 					bin_path ..
			-- 					'pylsp',
			-- 					-- '--stdio'
			-- 				},
			-- 				settings = {
			-- 					pylsp = {
			-- 						plugins = {
			-- 							-- formatter options
			-- 							black = { enabled = true },
			-- 							autopep8 = { enabled = false },
			-- 							yapf = { enabled = false },
			-- 							-- linter options
			-- 							pylint = { enabled = true, executable = "pylint" },
			-- 							pyflakes = { enabled = false },
			-- 							pycodestyle = { enabled = false },
			-- 							-- type checker
			-- 							pylsp_mypy = { enabled = true },
			-- 							-- auto-completion options
			-- 							jedi_completion = { fuzzy = true },
			-- 							-- import sorting
			-- 							pyls_isort = { enabled = true },
			-- 						},
			-- 					},
			-- 				},
			-- 				flags = {
			-- 					debounce_text_changes = 200,
			-- 				},
			-- 			})
			-- ### Keybinds
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set({ "n" }, "<leader>gf", vim.lsp.buf.format, {})
			vim.keymap.set("n", "<leader>gr", function()
				-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
				require('telescope.builtin').lsp_references()
			end, {})
		end,
	},
}
