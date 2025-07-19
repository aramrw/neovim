return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- this is enabled by default
			automatic_enable = false,
			ensure_installed = { "lua_ls" },
		},
	},

	-- 3. nvim-lspconfig, with the critical addition.
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- This defines global LSP behavior (keymaps, etc.)
			local on_attach = function(client, bufnr)
				-- This on_attach will apply to lua_ls and any other non-Rust LSPs.
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)
			end
			-- Set up a global autocommand for the on_attach function.
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Ensure the attached LSP is not rust-analyzer before applying general keymaps
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					--
					on_attach(client, ev.buf)
				end,
			})
			require("lspconfig").clangd.setup({})
			require("lspconfig").rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						check = { command = "clippy" },
						cargo = {
							extraEnv = { RUSTUP_TOOLCHAIN = "nightly" },
							features = "all",
						},
						procMacro = { enable = true },
					},
				},
			})
			-- Now, manually set up the servers we DO want lspconfig to manage.
			require("lspconfig").lua_ls.setup({})
		end,
	},
}
