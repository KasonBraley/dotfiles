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
  vim.cmd("packadd packer.nvim")
end

return require("packer").startup(function(use)
  -- Plugin Manager
  use({ "wbthomason/packer.nvim" })

  -------------------------------- LSP

  use({ "neovim/nvim-lspconfig" })

  use({
    "williamboman/nvim-lsp-installer",
    config = function()
      require("lsp.installer")
    end,
  })
  -------------------------------- IDE Like Plugins
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        module = "nvim-treesitter-textobjects",
        after = "nvim-treesitter",
      },
    },
    event = "BufRead",
    config = function()
      require("plugins.treesitter")
    end,
  })

  use({ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" })

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
    "quick-lint/quick-lint-js",
    rtp = "plugin/vim/quick-lint-js.vim",
    tag = "0.5.0",
    opt = true,
  })

  -- formatting
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
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.nvimtree")
    end,
  })

  -- Debugging
  use({
    {
      "mfussenegger/nvim-dap",
      module = "dap",
    },
    {

      "rcarriga/nvim-dap-ui",
      -- module = "dapui",
      requires = "mfussenegger/nvim-dap",
      after = "nvim-dap",
      config = function()
        require("dapui").setup()
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      requires = "mfussenegger/nvim-dap",
    },
  })

  -------------------------------- UI
  -- statusline
  use({
    "hoob3rt/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("plugins.statusline")
    end,
  })

  -- color/theme related stuff

  use({ "KasonBraley/nvim-solarized-lua" })

  -- local theme development
  -- use({ "~/dev/lua/nvim-solarized-lua" })

  -- color highlighter
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  })

  use({
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugins.icons")
    end,
  })

  -- git stuff
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
    {
      "pwntester/octo.nvim",
      cmd = "Octo",
      config = function()
        require("octo").setup()
      end,
    },
    {
      "ThePrimeagen/git-worktree.nvim",
      config = function()
        require("git-worktree").setup()
      end,
    },
  })

  -------------------------------- Fuzzy Finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    wants = {
      "plenary.nvim",
      "telescope-fzy-native.nvim",
    },
    cmd = "Telescope",
    module = "telescope",
    config = function()
      require("plugins.telescope")
    end,
  })

  -------------------------------- Utils
  use({ "nvim-lua/popup.nvim" })

  use({
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({
        global_settings = {
          -- enter_on_sendcmd = true,
        },
      })
    end,
  })

  use({
    "windwp/nvim-autopairs",
    config = function()
      require("plugins.autopairs")
    end,
  })

  use({
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  })

  use({ "andymass/vim-matchup", event = { "BufRead" } })

  -- commenting
  use({
    {
      "numToStr/Comment.nvim",
      event = "BufRead",
      -- module = "Comment",
      config = function()
        require("plugins.comment")
      end,
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
    },
  })

  -- smooth scroll
  use({
    "karb94/neoscroll.nvim",
    config = function()
      require("plugins.others").neoscroll()
    end,
  })

  use({
    "machakann/vim-sandwich",
    event = { "BufRead" },
  })

  -------------------------------- Misc
  -- Markdown previewer
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
