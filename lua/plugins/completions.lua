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
						-- Custom function to prioritize methods and values
						function(entry1, entry2)
							local kind1 = entry1:get_kind()
							local kind2 = entry2:get_kind()
							-- Prioritize methods and values
							local priority_kinds = {
								types.lsp.CompletionItemKind.Method,
								types.lsp.CompletionItemKind.Function,
								types.lsp.CompletionItemKind.Field,
								types.lsp.CompletionItemKind.Property,
								types.lsp.CompletionItemKind.Variable,
								types.lsp.CompletionItemKind.Constant,
							}
							local kind1_priority = vim.tbl_contains(priority_kinds, kind1) and 0 or 1
							local kind2_priority = vim.tbl_contains(priority_kinds, kind2) and 0 or 1
							-- Ensure snippets are always last
							if kind1 == types.lsp.CompletionItemKind.Snippet then return false end
							if kind2 == types.lsp.CompletionItemKind.Snippet then return true end
							if kind1_priority ~= kind2_priority then
								return kind1_priority < kind2_priority
							end
						end,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, item)
						local menu_icon = {
							nvim_lsp = "NLSP",
							nvim_lua = "NLUA",
							luasnip  = "LSNP",
							buffer   = "BUFF",
							path     = "PATH",
						}
						item.menu = menu_icon[entry.source.name]
						return item
					end,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
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
