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
    branch = "0.5-compat",
    config = function()
      require("plugins.treesitter")
    end,
  })

  use({
    "nvim-treesitter/nvim-treesitter-refactor",
  })

  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "0.5-compat",
  })

  use({ "nvim-treesitter/playground" })

  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("plugins.luasnip")
    end,
  })

  use({ "rafamadriz/friendly-snippets" })

  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.cmp")
    end,
    requires = {
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
    config = function()
      require("plugins.format")
    end,
  })

  -- File tree
  use({
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.nvimtree")
    end,
  })

  -- Debugging
  use({
    "mfussenegger/nvim-dap",
  })

  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  })

  use({ "theHamsta/nvim-dap-virtual-text", requires = { "mfussenegger/nvim-dap" } })

  use({
    "Pocco81/DAPInstall.nvim",
    config = function()
      require("plugins.dapInstall")
    end,
  })

  -------------------------------- UI
  use({
    "lukas-reineke/indent-blankline.nvim",
    setup = function()
      require("plugins.others").blankline()
    end,
  })

  -- statusline
  use({
    "hoob3rt/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("plugins.statusline")
    end,
  })

  -- color/theme related stuff
  use({ "folke/tokyonight.nvim" })

  -- color highlighter
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("plugins.others").colorizer()
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
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins.gitsigns")
    end,
  })

  use({
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup({})
    end,
  })

  use({
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup()
    end,
  })

  use({
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("git-worktree").setup()
    end,
  })

  -------------------------------- Fuzzy Finder
  use({
    "nvim-telescope/telescope.nvim",
    config = function()
      require("plugins.telescope")
    end,
  })

  use({ "nvim-lua/plenary.nvim" })
  use({ "nvim-telescope/telescope-fzy-native.nvim" })

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
    "numToStr/Comment.nvim",
    config = function()
      require("plugins.comment")
    end,
  })

  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
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
  use({ "iamcco/markdown-preview.nvim" })

  -- vim game
  use({ "ThePrimeagen/vim-be-good" })
end)
