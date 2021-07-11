local packer = require("packer")
local use = packer.use

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float {border = "single"}
    end
  }
}

return packer.startup(
  function()
    use "wbthomason/packer.nvim"

    -- tabline
    use "akinsho/nvim-bufferline.lua"

    -- statusline
    use {
      "glepnir/galaxyline.nvim",
      config = function()
        require("plugins.statusline").config()
      end
    }

    -- color related stuff
    use "siduck76/nvim-base16.lua"

    use {
      "norcalli/nvim-colorizer.lua",
      event = "BufRead",
      config = function()
        require("colorizer").setup()
        vim.cmd("ColorizerReloadAllBuffers")
      end
    }

    -- language related plugins
    use {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
      config = function()
        require("plugins.treesitter").config()
      end
    }

    use {
      "neovim/nvim-lspconfig",
      event = "BufRead",
      config = function()
        require("plugins.lspconfig").config()
      end
    }

    use {
      "kabouzeid/nvim-lspinstall",
      event = "VimEnter"
    }

    use {
      "onsails/lspkind-nvim",
      event = "BufRead",
      config = function()
        require("lspkind").init()
      end
    }

    -- load compe in insert mode only
    use {
      "hrsh7th/nvim-compe",
      event = "InsertEnter",
      config = function()
        require("plugins.compe").config()
      end,
      wants = {"LuaSnip"},
      requires = {
        {
          "L3MON4D3/LuaSnip",
          event = "InsertCharPre",
          config = function()
            require("plugins.compe").snippets()
          end
        }
      }
    }

    use "mhartington/formatter.nvim"
    use "famiu/bufdelete.nvim"

    -- file managing , picker etc
    use {
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeToggle",
      config = function()
        require("plugins.nvimtree").config()
      end
    }

    use {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("plugins.icons").config()
      end
    }

    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        {"nvim-lua/popup.nvim"},
        {"nvim-lua/plenary.nvim"}
      },
      cmd = "Telescope",
      config = function()
        require("plugins.telescope").config()
      end
    }

    use {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      cmd = "Telescope"
    }

    use {
      "nvim-telescope/telescope-media-files.nvim",
      cmd = "Telescope"
    }

    -- git stuff
    use {
      "lewis6991/gitsigns.nvim",
      event = "BufRead",
      config = function()
        require("plugins.gitsigns").config()
      end
    }

    -- misc plugins
    use {
      "windwp/nvim-autopairs",
      after = "nvim-compe",
      config = function()
        require("nvim-autopairs").setup()
        require("nvim-autopairs.completion.compe").setup(
          {
            map_cr = true,
            map_complete = true -- insert () func completion
          }
        )
      end
    }

    use {"andymass/vim-matchup", event = "CursorMoved"}

    use {
      "terrortylor/nvim-comment",
      cmd = "CommentToggle",
      config = function()
        require("nvim_comment").setup()
      end
    }

    use {
      "glepnir/dashboard-nvim",
      cmd = {
        "Dashboard",
        "DashboardNewFile",
        "DashboardJumpMarks",
        "SessionLoad",
        "SessionSave"
      },
      setup = function()
        require("plugins.dashboard").config()
      end
    }

    use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}

    -- load autosave only if its globally enabled
    use {
      "Pocco81/AutoSave.nvim",
      config = function()
        require("plugins.zenmode").autoSave()
      end,
      cond = function()
        return vim.g.auto_save == true
      end
    }

    -- smooth scroll
    use {
      "karb94/neoscroll.nvim",
      event = "WinScrolled",
      config = function()
        require("neoscroll").setup()
      end
    }

    use {
      "Pocco81/TrueZen.nvim",
      cmd = {"TZAtaraxis", "TZMinimalist"},
      config = function()
        require("plugins.zenmode").config()
      end
    }

    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufRead",
      setup = function()
        require("utils").blankline()
      end
    }
    -- Markdown previewer
    use {"npxbr/glow.nvim", run = ":GlowInstall"}

    -- Terminal
    use {
      "akinsho/nvim-toggleterm.lua",
      config = function()
        require("plugins.toggleterm").config()
      end
    }

    -- snippet support
    -- use {
    --   "hrsh7th/vim-vsnip",
    --   event = "InsertCharPre"
    -- }
    use {
      "rafamadriz/friendly-snippets",
      event = "InsertCharPre"
    }

    -- fast Motion plugin
    use "ggandor/lightspeed.nvim"

    use {
      "blackCauldron7/surround.nvim",
      config = function()
        require("surround").setup {}
      end
    }

    use "ray-x/lsp_signature.nvim"

    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    }
  end
)
