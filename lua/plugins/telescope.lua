return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		-- Add the sorter as a dependency
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				'altermo/telescope-nucleo-sorter.nvim',
				-- make sure to have the build dependencies installed, e.g. cargo
				build = 'cargo build --release'
				-- on macOS, you may need below instead:
				-- build = 'cargo rustc --release -- -C link-arg=-undefined -C link-arg=dynamic_lookup',
			},
		},
		config = function()
			-- Load the nucleo extension
			require("telescope").load_extension("nucleo")

			require("telescope").setup({
				pickers = {
					colorscheme = {
						enable_preview = true
					},
					-- This is the only change to disable the preview for diagnostics
					diagnostics = {
						previewer = false,
					},
				},
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						vertical = {
							width = 0.9,
							height = 0.9,
							preview_height = 0.6,
							preview_cutoff = 0,
							wrap_results = true
						}
					},
				},
				-- The sorter is now configured automatically by the extension
				extensions = {
					-- You can remove the old entry from here
				}
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
			vim.keymap.set("n", "<C-h>", builtin.resume, {})
			vim.keymap.set("n", "<S-m>", builtin.diagnostics, {})
		end,
	},
	{
		"propet/colorscheme-persist.nvim",
		-- Required: Load on startup to set the colorscheme
		lazy = false,
		-- Required: call setup() function
		config = true,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>cs",
				function()
					require("colorscheme-persist").picker()
				end,
				mode = "n",
				desc = "Choose colorscheme",
			},
		},
		opts = {
		},
	}
}
