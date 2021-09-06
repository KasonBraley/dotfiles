local packer = require "packer"
local util = require "packer.util"

packer.init {
  package_root = util.join_paths(vim.fn.stdpath "data", "site", "pack"),
}

local use = packer.use

packer.startup(function()
  -- Plugin Manager
  use { "wbthomason/packer.nvim" }

  -------------------------------- LSP

  use {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.lspconfig"
    end,
  }

  use { "kabouzeid/nvim-lspinstall" }

  use {
    "onsails/lspkind-nvim",
    config = function()
      require("plugins.others").lspkind()
    end,
  }

  use {
    "jasonrhansen/lspsaga.nvim",
    branch = "finder-preview-fixes",
    config = function()
      require("lspsaga").init_lsp_saga {
        finder_action_keys = {
          open = "o",
          vsplit = "<C-v>",
          split = "<C-x>",
          quit = "q",
          scroll_down = "<C-f>",
          scroll_up = "<C-b>",
        },
      }
    end,
  }

  -------------------------------- IDE Like Plugins
  use {
    "nvim-treesitter/nvim-treesitter",
    branch = "0.5-compat",
    config = function()
      require "plugins.treesitter"
    end,
  }

  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
  }

  use {
    "romgrk/nvim-treesitter-context",
  }

  use {
    "nvim-treesitter/nvim-treesitter-refactor",
  }

  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "0.5-compat",
  }

  use { "nvim-treesitter/playground" }

  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require "plugins.luasnip"
    end,
  }

  use { "rafamadriz/friendly-snippets" }

  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require "plugins.cmp"
    end,
    requires = {
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "f3fora/cmp-spell",
    },
  }

  -- diagnostics
  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").config {}
      require("lspconfig")["null-ls"].setup {}
    end,
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  }

  use {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
  }

  -- formatting
  use {
    "mhartington/formatter.nvim",
    config = function()
      require "plugins.format"
    end,
  }

  -- File tree
  use {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require "plugins.nvimtree"
    end,
  }

  -- Debugging
  use {
    "mfussenegger/nvim-dap",
  }

  use {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  }

  use { "theHamsta/nvim-dap-virtual-text", requires = { "mfussenegger/nvim-dap" } }

  use {
    "Pocco81/DAPInstall.nvim",
    config = function()
      require "plugins.dapInstall"
    end,
  }

  -------------------------------- UI
  use {
    "lukas-reineke/indent-blankline.nvim",
    setup = function()
      require("plugins.others").blankline()
    end,
  }

  -- statusline
  use {
    "hoob3rt/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require "plugins.statusline"
    end,
  }

  -- color/theme related stuff
  use { "folke/tokyonight.nvim" }

  -- color highlighter
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("plugins.others").colorizer()
    end,
  }

  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require "plugins.icons"
    end,
  }

  -- git stuff
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "plugins.gitsigns"
    end,
  }

  use {
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup {}
    end,
  }

  use {
    "sindrets/diffview.nvim",
    config = function()
      require "plugins.diffview"
    end,
  }

  use {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("git-worktree").setup()
    end,
  }

  -------------------------------- Fuzzy Finder
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "plugins.telescope"
    end,
  }

  use { "nvim-lua/plenary.nvim" }
  use { "nvim-telescope/telescope-fzy-native.nvim" }
  use { "nvim-telescope/telescope-media-files.nvim" }

  -------------------------------- Utils
  use "famiu/bufdelete.nvim"

  use "ThePrimeagen/harpoon"

  use {
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("refactoring").setup()
    end,
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require "plugins.autopairs"
    end,
  }

  use {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  }

  use { "p00f/nvim-ts-rainbow" }

  use { "andymass/vim-matchup" }

  use {
    "terrortylor/nvim-comment",
    config = function()
      require "plugins.comment"
    end,
  }

  -- smooth scroll
  use {
    "karb94/neoscroll.nvim",
    config = function()
      require("plugins.others").neoscroll()
    end,
  }

  use {
    "machakann/vim-sandwich",
  }

  -- use {
  --   "folke/which-key.nvim",
  --   config = function()
  --     require("which-key").setup {}
  --   end,
  -- }

  -------------------------------- Misc
  -- Markdown previewer
  use { "iamcco/markdown-preview.nvim" }

  -- vim game
  use { "ThePrimeagen/vim-be-good" }
end)
