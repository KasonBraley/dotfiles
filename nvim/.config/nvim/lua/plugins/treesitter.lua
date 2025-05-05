return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "java",
          "html",
          "css",
          "typescript",
          "tsx",
          -- "json",
          "bash",
          "yaml",
          "dockerfile",
          "go",
          "hcl",
          "terraform",
          "markdown",
          "rust",
          -- php ts extension currently causes silent panics. very annoying. can't grep in codebases with
          -- telescope due to this, it just crashes neovim.
          -- https://github.com/tree-sitter/tree-sitter-php/issues/238
          -- "php",
          "proto",
          "templ",
          "zig",
        },
        indent = {
          enable = false,
          disable = { "yaml" },
        },
        highlight = {
          enable = true,
          disable = function(_, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end,
        },
      })
    end
  },
}
