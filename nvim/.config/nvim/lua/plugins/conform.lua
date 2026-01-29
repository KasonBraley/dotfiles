return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        html = { "prettier", stop_after_first = true },
        css = { "prettier", stop_after_first = true },
        json = { "prettier", stop_after_first = true },
        yaml = { "prettier", stop_after_first = true },
        markdown = { "prettier", stop_after_first = true },
        php = { "pint" },
        java = { "google-java-format" },
        python = {
          "ruff_fix", -- To fix auto-fixable lint errors.
          "ruff_format", -- To run the Ruff formatter.
          "ruff_organize_imports", -- To organize the imports.
        },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
}
