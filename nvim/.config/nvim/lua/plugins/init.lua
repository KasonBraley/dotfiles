local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.api.nvim_command("packadd packer.nvim")
end

return require("packer").startup(function(use)
  -- Plugin Manager
  use({ "wbthomason/packer.nvim" })

  use("lewis6991/impatient.nvim")

  use({
    { "neovim/nvim-lspconfig" },
    {
      "williamboman/nvim-lsp-installer",
      config = function()
        require("lsp.installer")
      end,
    },
  })

  use({
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("plugins.treesitter")
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-refactor",
      after = "nvim-treesitter",
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
    },
    {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
    },
  })

  use({ "rafamadriz/friendly-snippets" })

  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.cmp")
    end,
    requires = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "petertriho/cmp-git",
    },
  })

  use({
    "mhartington/formatter.nvim",
    cmd = "Format",
    config = function()
      require("plugins.format")
    end,
  })

  -- File tree
  use({
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("plugins.nvimtree")
    end,
  })

  -- statusline
  use({
    "hoob3rt/lualine.nvim",
    config = function()
      require("plugins.statusline")
    end,
  })

  -- color/theme related stuff

  use({ "KasonBraley/nvim-solarized-lua" })

  -- local theme development
  -- use({ "~/dev/lua/nvim-solarized-lua" })

  use({
    "norcalli/nvim-colorizer.lua",
    event = "Bufread",
    config = function()
      require("colorizer").setup()
    end,
  })

  -- git
  use({
    {
      "lewis6991/gitsigns.nvim",
      event = "Bufread",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("plugins.gitsigns")
      end,
    },
    {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("neogit").setup({})
      end,
    },
    { "ThePrimeagen/git-worktree.nvim" },
  })

  -- Fuzzy Finder
  use({
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("plugins.telescope")
      end,
    },
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  })

  use({ "nvim-lua/popup.nvim" })

  use({
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({
          global_settings = { mark_branch = true }
      })
    end,
  })

  use({ "andymass/vim-matchup", event = "BufRead" })

  use({
    {
      "numToStr/Comment.nvim",
      event = "BufRead",
      config = function()
        require("plugins.comment")
      end,
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
    },
  })

  use({ "machakann/vim-sandwich", event = "BufRead" })

  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  })

  use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
