local packer = require "packer"
local util = require "packer.util"

packer.init {
  package_root = util.join_paths(vim.fn.stdpath "data", "site", "pack"),
}

local use = packer.use

packer.startup(function()
  -- local use = use
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
    "glepnir/lspsaga.nvim",
    config = function()
      require("lspsaga").init_lsp_saga()
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
    "hrsh7th/nvim-compe",
    config = function()
      require "plugins.compe"
    end,
    wants = "LuaSnip",
    requires = {
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require "plugins.luasnip"
        end,
      },
      { "rafamadriz/friendly-snippets" },
    },
  }

  -- use {
  --   "mfussenegger/nvim-lint",
  --   config = function()
  --     require "plugins.lint"
  --   end,
  -- }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require "plugins.lint"
    end,
  }

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

  -- tabline
  -- use {
  --   "kdheepak/tabline.nvim",
  --   requires = { { "hoob3rt/lualine.nvim", opt = true }, { "kyazdani42/nvim-web-devicons", opt = true } },
  --   config = function()
  --     require "plugins.tabline"
  --   end,
  -- }

  -- statusline
  use {
    "hoob3rt/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require "plugins.statusline"
    end,
  }

  -- color/theme related stuff
  use "folke/tokyonight.nvim"

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
  use { "nvim-lua/popup.nvim" }
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

  use {
    "p00f/nvim-ts-rainbow",
  }

  use { "andymass/vim-matchup" }

  use {
    -- "b3nj5m1n/kommentary",
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

  -- fast Motion plugin
  use {
    "phaazon/hop.nvim",
    as = "hop",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
    end,
  }

  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require("surround").setup {}
    end,
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end,
  }

  -------------------------------- Misc
  use {
    "Pocco81/TrueZen.nvim",
    config = function()
      require "plugins.zenmode"
    end,
  }

  -- Markdown previewer
  use "iamcco/markdown-preview.nvim"

  -- vim game
  use {
    "ThePrimeagen/vim-be-good",
  }
end)
