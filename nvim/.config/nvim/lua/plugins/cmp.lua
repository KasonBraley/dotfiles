return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
    },
    config = function()
      local cmp = require('cmp')

      local function toggle_autocomplete()
        local current_setting = cmp.get_config().completion.autocomplete
        if current_setting and #current_setting > 0 then
          cmp.setup({ completion = { autocomplete = false } })
          vim.notify('Autocomplete disabled')
        else
          cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
          vim.notify('Autocomplete enabled')
        end
      end

      vim.api.nvim_create_user_command('NvimCmpToggle', toggle_autocomplete, {})
      vim.keymap.set("n", "<Leader>tc", ":NvimCmpToggle<CR>", { noremap = true, silent = true })

      -- local lsp_types = require("cmp.types")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        completion = {
          autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        }),
        sources = {
          { name = "path" },
          {
            name = "nvim_lsp",
            max_item_count = 10,
            -- entry_filter = function(entry, _)
            --   local kind = lsp_types.lsp.CompletionItemKind[entry:get_kind()]
            --   -- remove Modules from completion options
            --   if kind == "Module" then
            --     return false
            --   end
            --   return true
            -- end
          },
          { name = "nvim_lsp_signature_help" },
          { name = "spell" },
        },
        enabled = function()
          -- disable completion in comments
          local context = require("cmp.config.context")
          return not context.in_treesitter_capture("comment") and
              not context.in_syntax_group("Comment")
        end,
      })
    end
  },
}
