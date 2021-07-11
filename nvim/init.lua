-- load all plugins
require "pluginList"
require "options"
require "plugins.bufferline"

local g = vim.g

g.mapleader = " "
g.auto_save = false

-- colorscheme related stuff

g.nvchad_theme = "onedark"
local base16 = require "base16"
base16(base16.themes["onedark"], true)

require "highlights"
require "mappings"

-- require "plugins.toggleterm"
require "plugins.format"
-- require "lsp_signature".on_attach()

require("utils").hideStuff()
