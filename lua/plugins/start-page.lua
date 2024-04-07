-- return {
--   "goolord/alpha-nvim",
--   dependencies = {
--     "nvim-tree/nvim-web-devicons",
--   },
--
--   config = function()
--     local alpha = require("alpha")
--     local dashboard = require("alpha.themes.startify")
--
--     dashboard.section.header.val = {
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                     ]],
--       [[       ████ ██████           █████      ██                     ]],
--       [[      ███████████             █████                             ]],
--       [[      █████████ ███████████████████ ███   ███████████   ]],
--       [[     █████████  ███    █████████████ █████ ██████████████   ]],
--       [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
--       [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
--       [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--     }
--
--     alpha.setup(dashboard.opts)
--   end,
-- }

return {
	"startup-nvim/startup.nvim",
	requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	config = function()
		require("startup").setup({ theme = "startify" })
		vim.g.startup_bookmarks = {
			["A"] = "f:/users/arami/programming/rust",
			["B"] = "c:/users/arami/appdata/local/nvim/lua",
		}
	end,
}
