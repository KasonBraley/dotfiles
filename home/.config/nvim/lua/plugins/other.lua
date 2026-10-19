return {
  {
    "kylechui/nvim-surround",
    version = "*", --  for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    'brianhuster/live-preview.nvim',
    dependencies = {
      -- You can choose one of the following pickers
      'nvim-telescope/telescope.nvim',
    },
  },
}
