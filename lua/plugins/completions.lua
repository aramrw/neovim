return {
	{
		"hrsh7th/cmp-nvim-lsp"
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			local types = require('cmp.types')
			cmp.setup({
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						function(entry1, entry2)
							local kind1 = entry1:get_kind()
							kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
							local kind2 = entry2:get_kind()
							kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
							if kind1 ~= kind2 then
								if kind1 == types.lsp.CompletionItemKind.Snippet then
									return false
								end
								if kind2 == types.lsp.CompletionItemKind.Snippet then
									return true
								end
								local diff = kind1 - kind2
								if diff < 0 then
									return true
								elseif diff > 0 then
									return false
								end
							end
						end,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				formatting = {
					fields = { "abbr", "menu", "kind" },
					format = function(entry, item)
						-- Define menu shorthand for different completion sources.
						local menu_icon = {
							nvim_lsp = "NLSP",
							nvim_lua = "NLUA",
							luasnip  = "LSNP",
							buffer   = "BUFF",
							path     = "PATH",
						}
						-- Set the menu "icon" to the shorthand for each completion source.
						item.menu = menu_icon[entry.source.name]

						-- Set the fixed width of the completion menu to 60 characters.
						-- fixed_width = 20

						-- Set 'fixed_width' to false if not provided.
						fixed_width = fixed_width or false

						-- Get the completion entry text shown in the completion window.
						local content = item.abbr

						-- Set the fixed completion window width.
						if fixed_width then
							vim.o.pumwidth = fixed_width
						end

						-- Get the width of the current window.
						local win_width = vim.api.nvim_win_get_width(0)

						-- Set the max content width based on either: 'fixed_width'
						-- or a percentage of the window width, in this case 20%.
						-- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
						local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

						-- Truncate the completion entry text if it's longer than the
						-- max content width. We subtract 3 from the max content width
						-- to account for the "..." that will be appended to it.
						if #content > max_content_width then
							item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
						else
							item.abbr = content .. (" "):rep(max_content_width - #content)
						end
						return item
					end,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
						-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
