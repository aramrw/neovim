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
			-- Removed `ensure_installed` because the goal is to install LSPs manually with Mason.
			-- After installing any LSP, it will just work after restarting Neovim.
			require("mason-lspconfig").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Get installed LSPs via mason
			local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/"
			print(mason_bin_path);

			-- Diagnostics:
			-- 1. Unused local `lsp_cmds`. [unused-local]
			-- You can use `lsp_cmds` if you need to loop through installed LSPs for specific tasks.
			-- Currently it's unused, so it's safe to remove or keep as needed for custom use cases.
			local lsp_cmds = (function()
				local map = {}
				for _, filename in ipairs(vim.fn.readdir(mason_bin_path)) do
					local exe = mason_bin_path .. filename
					map[filename] = exe
				end
				if next(map) == nil then
					return nil
				end
				return map
			end)()

			-- Default LSP setup function
			local function setup_lsp(server_name, extra_config)
				local default_config = {
					capabilities = capabilities,
				}
				local config = vim.tbl_deep_extend("force", default_config, extra_config or {})
				lspconfig[server_name].setup(config)
			end

			-- CHANGE THIS: Loop through `lsp_cmds` instead of `ensure_installed`.
			-- You no longer need to worry about `ensure_installed` because you'll manually install LSPs with Mason.
			-- Simply loop through `lsp_cmds` to find installed servers and set them up.
			require("mason-lspconfig").setup_handlers({
				-- For most servers, just use the default setup
				function(server_name)
					setup_lsp(server_name)
				end,
				-- Add specific config for a server
				["rust_analyzer"] = function()
					setup_lsp("rust_analyzer", {
						settings = {
							["rust-analyzer"] = {
								check = {
									command = "clippy",
								},
								-- cargo = {
								-- 	extraEnv = {
								-- 		RUSTUP_TOOLCHAIN = "nightly",
								-- 	},
								-- },
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
				end,

				-- Even though this is commented out, the `lua_ls` server should still be installed by Mason.
				-- If you want to add specific configuration for it, you can uncomment and modify below:
				-- ["lua_ls"] = function()
				-- 	setup_lsp("lua_ls", {
				-- 		cmd_args = { "--stdio" },
				-- 	})
				-- end,
				-- You can add more specific server setups as needed here.
			})

			-- Keybinds for LSP functionality
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set({ "n" }, "<leader>gf", vim.lsp.buf.format, {})
			vim.keymap.set("n", "<leader>gr", function()
				vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
					border = "rounded",
				})
				require("telescope.builtin").lsp_references()
			end, {})
		end,
	},
}
