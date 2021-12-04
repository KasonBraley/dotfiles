local present, cmp = pcall(require, "cmp")
if not present then
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  completion = {
    -- default to disabled completion, toggled on/off via a mapping
    autocomplete = false,
    get_trigger_characters = function(trigger_characters)
      return vim.tbl_filter(function(char)
        return char ~= " "
      end, trigger_characters)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buff]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        spell = "[Spell]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          require("plugins.others").toggle_completion()
        else
          fallback()
        end
      end,
    }),
    ["<C-k>"] = cmp.mapping({
      require("plugins.others").toggle_completion(),
      i = function()
        if cmp.visible() then
          cmp.abort()
          require("plugins.others").toggle_completion()
        else
          cmp.complete()
          require("plugins.others").toggle_completion()
        end
      end,
    }),
  },
  sources = {
    { name = "path" },
    { name = "nvim_lsp", max_item_count = 7 },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 5 },
    { name = "spell" },
    { name = "cmp_git" },
  },
})

require("cmp_git").setup()
