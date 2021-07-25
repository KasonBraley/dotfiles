local present, _ = pcall(require, "packerInit")
local packer

if present then
  packer = require "packer"
else
  return false
end

local use = packer.use

return packer.startup(
  function()
    -- Plugin Manager
    use {"wbthomason/packer.nvim", event = "VimEnter"}

    -------------------------------- LSP

    use {
      "neovim/nvim-lspconfig",
      after = "nvim-lspinstall",
      config = function()
        require "plugins.lspconfig"
      end
    }

    use {"kabouzeid/nvim-lspinstall", event = "BufRead"}

    use {
      "onsails/lspkind-nvim",
      event = "BufRead",
      config = function()
        require("plugins.others").lspkind()
      end
    }

    use {
      "glepnir/lspsaga.nvim",
      event = "BufRead",
      config = function()
        require("lspsaga").init_lsp_saga()
      end
    }

    -------------------------------- IDE Like Plugins
    use {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
      config = function()
        require "plugins.treesitter"
      end
    }

    -- use "nvim-treesitter/playground"

    -- load compe in insert mode only
    use {
      "hrsh7th/nvim-compe",
      event = "InsertEnter",
      config = function()
        require "plugins.compe"
      end,
      wants = "LuaSnip",
      requires = {
        {
          "L3MON4D3/LuaSnip",
          wants = "friendly-snippets",
          event = "InsertCharPre",
          config = function()
            require "plugins.luasnip"
          end
        },
        {"rafamadriz/friendly-snippets", event = "InsertCharPre"}
      }
    }

    use {
      "mhartington/formatter.nvim",
      cmd = "Format",
      config = function()
        require("plugins.format")
      end
    }

    use {
      "windwp/nvim-ts-autotag",
      event = "BufRead",
      config = function()
        require("nvim-ts-autotag").setup()
      end
    }

    -------------------------------- File Tree
    -- file managing , picker etc
    use {
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeToggle",
      config = function()
        require "plugins.nvimtree"
      end
    }

    -------------------------------- UI
    -- tabline
    use {
      "akinsho/nvim-bufferline.lua",
      after = "nvim-base16.lua",
      config = function()
        require "plugins.bufferline"
      end
    }

    -- statusline
    use {
      "glepnir/galaxyline.nvim",
      after = "nvim-base16.lua",
      config = function()
        require "plugins.statusline"
      end
    }

    -- color related stuff
    use {
      "siduck76/nvim-base16.lua",
      after = "packer.nvim",
      config = function()
        require "theme"
      end
    }

    use {
      "norcalli/nvim-colorizer.lua",
      event = "BufRead",
      config = function()
        require("plugins.others").colorizer()
      end
    }

    use {
      "kyazdani42/nvim-web-devicons",
      after = "nvim-base16.lua",
      config = function()
        require "plugins.icons"
      end
    }

    -- git stuff
    use {
      "lewis6991/gitsigns.nvim",
      after = "plenary.nvim",
      config = function()
        require "plugins.gitsigns"
      end
    }

    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufRead",
      setup = function()
        require("plugins.others").blankline()
      end
    }

    -------------------------------- Fuzzy Finder
    use {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      config = function()
        require "plugins.telescope"
      end
    }

    use {"nvim-lua/plenary.nvim", event = "BufRead"}
    use {"nvim-lua/popup.nvim", after = "plenary.nvim"}
    use {"nvim-telescope/telescope-fzy-native.nvim", cmd = "Telescope"}
    use {"nvim-telescope/telescope-media-files.nvim", cmd = "Telescope"}

    -------------------------------- Utils
    use "famiu/bufdelete.nvim"

    use {
      "windwp/nvim-autopairs",
      after = "nvim-compe",
      config = function()
        require "plugins.autopairs"
      end
    }

    use {"andymass/vim-matchup", event = "CursorMoved"}

    use {
      "terrortylor/nvim-comment",
      cmd = "CommentToggle",
      config = function()
        require("plugins.others").comment()
      end
    }

    -- load autosave only if its globally enabled
    use {
      "Pocco81/AutoSave.nvim",
      config = function()
        require "plugins.autosave"
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
        require("plugins.others").neoscroll()
      end
    }

    -- fast Motion plugin
    use {
      "phaazon/hop.nvim",
      as = "hop",
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require "hop".setup {keys = "etovxqpdygfblzhckisuran"}
      end
    }

    use {
      "blackCauldron7/surround.nvim",
      config = function()
        require("surround").setup {}
      end
    }

    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    }

    -------------------------------- Misc
    use {
      "Pocco81/TrueZen.nvim",
      cmd = {"TZAtaraxis", "TZMinimalist", "TZFocus"},
      config = function()
        require "plugins.zenmode"
      end
    }

    -- Markdown previewer
    use "iamcco/markdown-preview.nvim"
  end
)
