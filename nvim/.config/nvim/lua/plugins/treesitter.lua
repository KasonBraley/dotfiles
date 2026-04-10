local treesitter_langs = {
  "c",
  "lua",
  "vim",
  "vimdoc",
  "javascript",
  "html",
  "css",
  "typescript",
  "tsx",
  -- "json",
  "bash",
  "yaml",
  "dockerfile",
  "go",
  -- "hcl",
  -- "terraform",
  "markdown",
  "rust",
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
