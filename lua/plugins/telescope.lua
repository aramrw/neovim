return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
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
			extensions = {
				fzf = {
					fuzzy = true,              -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case",  -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				}
			}
		})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<C-p>", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
		-- vim.keymap.set("n", "<leader>fd", function()
		-- 	builtin.diagnostics({ bufnr = 0 })
		-- end)
		require('telescope').load_extension('fzf')
	end,
}
