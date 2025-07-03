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
			local lspkind_comparator = function(conf)
				local lsp_types = require("cmp.types").lsp
				return function(entry1, entry2)
					if entry1.source.name ~= "nvim_lsp" then
						if entry2.source.name == "nvim_lsp" then
							return false
						else
							return nil
						end
					end
					local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
					local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
					if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
						kind1 = "Parameter"
					end
					if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
						kind2 = "Parameter"
					end

					local priority1 = conf.kind_priority[kind1] or 0
					local priority2 = conf.kind_priority[kind2] or 0
					if priority1 == priority2 then
						return nil
					end
					return priority2 < priority1
				end
			end

			local label_comparator = function(entry1, entry2)
				return entry1.completion_item.label < entry2.completion_item.label
			end
			local types = require('cmp.types')
			cmp.setup({
				comparators = {
					lspkind_comparator({
						kind_priority = {
							Parameter = 14,
							Variable = 12,
							Field = 11,
							Property = 11,
							Constant = 10,
							Enum = 10,
							EnumMember = 10,
							Event = 10,
							Function = 10,
							Method = 10,
							Operator = 10,
							Reference = 10,
							Struct = 10,
							File = 8,
							Folder = 8,
							Class = 5,
							Color = 5,
							Module = 5,
							Keyword = 2,
							Constructor = 1,
							Interface = 1,
							Snippet = 0,
							Text = 1,
							TypeParameter = 1,
							Unit = 1,
							Value = 1,
						},
					}),
					label_comparator,
				},
				sorting = {
					-- comparators = {
					-- 	-- Existing comparators
					-- 	cmp.config.compare.offset,
					-- 	cmp.config.compare.exact,
					-- 	cmp.config.compare.score,
					-- 	-- Custom function to always deprioritize snippets
					-- 	function(entry1, entry2)
					-- 		local kind1 = entry1:get_kind()
					-- 		local kind2 = entry2:get_kind()
					--
					-- 		-- Ensure snippets are always last
					-- 		if kind1 == types.lsp.CompletionItemKind.Snippet and kind2 ~= types.lsp.CompletionItemKind.Snippet then
					-- 			return false
					-- 		elseif kind2 == types.lsp.CompletionItemKind.Snippet and kind1 ~= types.lsp.CompletionItemKind.Snippet then
					-- 			return true
					-- 		end
					--
					-- 		-- Prioritize specific kinds (like Field, Method, etc.)
					-- 		local priority_kinds = {
					-- 			types.lsp.CompletionItemKind.Field,
					-- 			types.lsp.CompletionItemKind.Property,
					-- 			types.lsp.CompletionItemKind.Function,
					-- 			types.lsp.CompletionItemKind.Variable,
					-- 			types.lsp.CompletionItemKind.Constant,
					-- 			types.lsp.CompletionItemKind.Method,
					-- 		}
					-- 		local kind1_priority = vim.tbl_contains(priority_kinds, kind1) and 0 or 1
					-- 		local kind2_priority = vim.tbl_contains(priority_kinds, kind2) and 0 or 1
					-- 		if kind1_priority ~= kind2_priority then
					-- 			return kind1_priority < kind2_priority
					-- 		end
					-- 	end,
					-- 	-- Remaining comparators
					-- 	cmp.config.compare.kind,
					-- 	cmp.config.compare.sort_text,
					-- 	cmp.config.compare.length,
					-- 	cmp.config.compare.order,
					-- },
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
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip",  priority = 750 },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
