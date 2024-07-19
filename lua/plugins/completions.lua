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

      cmp.setup({
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
