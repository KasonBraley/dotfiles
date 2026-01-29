return {
  "yorickpeterse/nvim-grey",

  {
    "kylechui/nvim-surround",
    version = "*", --  for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    'brianhuster/live-preview.nvim',
    dependencies = {
      -- You can choose one of the following pickers
      'nvim-telescope/telescope.nvim',
    },
  },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require('textcase').setup({})
    end
  },
}
