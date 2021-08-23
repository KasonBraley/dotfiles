# Showcase

![basic](../../assets/rice_basic.png)<hr>
### File Tree
![basictree](../../assets/rice_basic_tree.png)<hr>
### Terminal
![basictreeterminal](../../assets/rice_basic_tree_terminal.png)<hr>
### Fuzzy Finder
![telescope](../../assets/rice_telescope.png)<hr>
### Intellisense
![lsp](../../assets/rice_lsp_definition.png)<hr>
<!-- ![completion](../../assets/rice_lsp_completion.mp4?raw=true)<hr> -->


### Neovim Plugins I Use

###### Plugin Manager
- [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim) - A use-package inspired plugin manager for Neovim. Uses native packages, supports Luarocks dependencies, written in Lua, allows for expressive config.

###### LSP 
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Quickstart configurations for the Nvim LSP client.
- [onsails/lspkind-nvim](https://github.com/onsails/lspkind-nvim) - The plugin adds vscode-like icons to neovim lsp completions.
- [kabouzeid/nvim-lspinstall](https://github.com/kabouzeid/nvim-lspinstall) - Provides the missing :LspInstall for nvim-lspconfig.
- [glepnir/lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim) A light-weight lsp plugin based on neovim built-in lsp with a highly performant UI.


######  IDE plugins - Intellisense, Linting, Formatting, Code Completion
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Nvim Treesitter configurations and abstraction layer.
- [JoosepAlviste/nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) - A Neovim plugin for setting the `commentstring` option based on the cursor location in the file. The location is checked via treesitter queries.
- [romgrk/nvim-treesitter-context](https://github.com/romgrk/nvim-treesitter-context)
- [nvim-treesitter/playground](https://github.com/nvim-treesitter/playground) - View treesitter information directly in Neovim.
- [hrsh7th/nvim-compe](https://github.com/hrsh7th/nvim-compe) - Auto completion plugin for nvim written in Lua.
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) - A snippet engine for Neovim written in Lua.
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Snippets collection for all kind of programming languages that integrates really well with vim-vsnip.
- [mhartington/formatter.nvim](https://github.com/mhartington/formatter.nvim) - A format runner for Neovim written in Lua.
- [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) - An asynchronous linter plugin for Neovim (>= 0.5) complementary to the built-in Language Server Protocol support.
- [ThePrimeagen/git-worktree.nvim](https://github.com/ThePrimeagen/git-worktree.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git integration: signs, hunk actions, blame, etc.
- [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) - Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
-[ThePrimeagen/refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) - The Refactoring library based off the Refactoring book by Martin Fowler


###### Debugging
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol client implementation for Neovim.
- [Pocco81/DAPInstall.nvim](https://github.com/Pocco81/DAPInstall.nvim) - A NeoVim plugin for managing several debuggers for Nvim-dap.
- [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - A UI for nvim-dap.
- [theHamsta/nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) - This plugin adds virtual text support to nvim-dap. nvim-treesitter is used to find variable definitions.


###### File Tree
- [kyazdani42/nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua) - A simple and fast file explorer tree for neovim.


###### UI
- [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - A clean, dark and light Neovim theme written in Lua, with support for LSP, TreeSitter and lots of plugins.
- [hoob3rt/lualine.nvim](https://github.com/hoob3rt/lualine.nvim) - A blazing fast and easy to configure neovim statusline.
- [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - A Lua fork of [vim-devicons](https://github.com/ryanoasis/vim-devicons).
- [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - A high-performance color highlighter for Neovim which has no external dependencies.

###### Fuzzy Finder
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Telescope.nvim is a highly [extendable](https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions) fuzzy finder over lists. Built on the latest awesome features from neovim core. Telescope is centered around modularity, allowing for easy customization.
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Plenary: full; complete; entire; absolute; unqualified. All the lua functions I don't want to write twice.
- [nvim-lua/popup.nvim](https://github.com/nvim-lua/popup.nvim) - An implementation of the Popup API from vim in Neovim.
- [nvim-telescope/telescope-fzy-native.nvim](https://github.com/nvim-telescope/telescope-fzy-native.nvim) - A compiled FZY style sorter.
- [nvim-telescope/telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim) - Preview images, pdf, epub, video, and fonts inside of Neovim using Telescope.

###### Navigation
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon) - The goal of Harpoon is to get you where you want with the fewest keystrokes.

###### Git
- [TimUntersberger/neogit](https://github.com/TimUntersberger/neogit) - A work-in-progress Magit clone for Neovim that is geared toward the Vim philosophy.


###### Utils
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim) - Neovim plugin that shows a popup with possible keybindings of the command you started typing.
- [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - IndentLine replacement in lua with more features and treesitter support.
- [blackCauldron7/surround.nvim](https://github.com/blackCauldron7/surround.nvim) - A surround text object plugin for neovim written in lua.
- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) - A minimalist autopairs for Neovim written by Lua.
- [terrortylor/nvim-comment](https://github.com/b3nj5m1n/kommentary) - Commenting plugin written in lua
- [famiu/bufdelete.nvim](https://github.com/famiu/bufdelete.nvim) - Delete Neovim buffers without losing your window layout.
- [karb94/neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) - Smooth scrolling for neovim.
- [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Use treesitter to autoclose and autorename xml,html,jsx tag.
- [p00f/nvim-ts-rainbow](https://github.com/p00f/nvim-ts-rainbow) - Rainbow :rainbow: parentheses for neovim using tree-sitter :rainbow:.
- [andymass/vim-matchup](https://github.com/andymass/vim-matchup) - match-up is a plugin that lets you highlight, navigate, and operate on sets of matching text. It extends vim's % key to language-specific words instead of just single characters.


###### Misc
- [davidgranstrom/nvim-markdown-preview](https://github.com/davidgranstrom/nvim-markdown-preview) - Markdown preview in the browser using pandoc and live-server through Neovim's job-control API.
- [ThePrimeagen/vim-be-good](https://github.com/ThePrimeagen/vim-be-good) - Vim-be-good is a nvim plugin designed to make you better at Vim Movements.

#### NPM Dependencies
- [prettierD](https://github.com/fsouza/prettierd)
- [live-server](https://github.com/tapio/live-server)
- [eslint](https://github.com/eslint/eslint)
- [js-beautify](https://github.com/beautify-web/js-beautify) - I only use the `html-beautify` portion of this package. I use `html-beautify` to format HTML files instead of `Prettier` because I don't like how `Prettier` formats HTML files.

#### Other Dependencies
- [StyLua](https://github.com/JohnnyMorganz/StyLua)
