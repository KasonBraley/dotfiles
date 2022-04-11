local g = vim.g

vim.o.termguicolors = true

-- g.nvim_tree_auto_ignore_ft = {} -- don't open tree on specific fiypes.
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_root_folder_modifier = ":t"
g.nvim_tree_allow_resize = 1
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names

g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  -- folder_arrows= 1
}
g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★",
    deleted = "",
    ignored = "◌",
  },
  folder = {
    -- arrow_open = "",
    -- arrow_closed = "",
    default = "",
    open = "",
    empty = "", -- 
    empty_open = "",
    symlink = "",
    symlink_open = "",
  },
}

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  open_on_tab = false,
  hijack_cursor = false,
  quit_on_open = false,
  update_cwd = true,
  git = {
    ignore = true,
  },
  diagnostics = {
    enable = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },

  filters = {
    dotfiles = false,
    custom = {
      ".git$",
      "node_modules",
      ".cache",
    },
  },

  view = {
    width = 30,
    side = "right",
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {},
    },
  },
})
