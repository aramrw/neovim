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
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
						procMacro = {
							enable = true,
						},
					},
				},
			})
			require("lspconfig").clangd.setup({
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--offset-encoding=utf-16",
				},
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
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
