return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        php = { "pint" },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
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
