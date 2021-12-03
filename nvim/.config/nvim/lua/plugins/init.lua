local packer = require("packer")
local util = require("packer.util")

packer.init({
  package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
})

local use = packer.use

packer.startup(function()
  -- Plugin Manager
  use({ "wbthomason/packer.nvim" })

  -------------------------------- LSP

  use({ "neovim/nvim-lspconfig" })

  use({
    "williamboman/nvim-lsp-installer",
    config = function()
      require("plugins.lspconfig")
    end,
  })
  -------------------------------- IDE Like Plugins
  use({
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    run = ":TSUpdate",
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

  -- use({ "KasonBraley/nvim-solarized-lua" })

  -- local theme development
  use({ "~/dev/lua/nvim-solarized-lua" })

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
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  })

  use({ "andymass/vim-matchup" })

  -- commenting
  use({
    {
      "numToStr/Comment.nvim",
      config = function()
        require("plugins.comment")
      end,
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
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
  })

  -------------------------------- Misc
  -- Markdown previewer
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  })

end)
