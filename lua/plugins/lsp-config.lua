return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- 1. Setup Mason
		require("mason").setup()

		-- 2. Setup Mason-LSPConfig (v2.0 Syntax)
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"gopls",
				"taplo",
				"rust_analyzer",
			},
			-- NEW: 'handlers' is now a field inside setup(), not a separate function.
			handlers = {
				-- The default handler (applies to servers not listed below)
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,

				-- Custom handler for Lua
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						},
					})
				end,

				-- Custom handler for Rust
				["rust_analyzer"] = function()
					require("lspconfig").rust_analyzer.setup({
						settings = {
							["rust-analyzer"] = {
								cargo = {
									extraEnv = { RUSTUP_TOOLCHAIN = "nightly" },
									features = "all",
								},
								procMacro = { enable = true },
							},
						},
					})
				end,
			},
		})

		-- 3. Global Keymaps (LspAttach)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)
			end,
		})
	end,
}
