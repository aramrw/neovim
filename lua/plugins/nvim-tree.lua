return {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        setup = function()
            require("nvim-tree").setup({
                sort = { sorter = "case_sensitive" },
                view = { width = 30 },
                renderer = { group_empty = true },
                filters = { dotfiles = true },
								update_focused_file = { enable = true }
            })
        end,
			config = function() 
			vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', {})
			end,
    }
