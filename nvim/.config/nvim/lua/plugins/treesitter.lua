local treesitter_langs = {
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
  "python",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "main",
    config = function()
      require("nvim-treesitter").install(treesitter_langs)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = treesitter_langs,
        callback = function() vim.treesitter.start() end,
      })
    end
  },
}
