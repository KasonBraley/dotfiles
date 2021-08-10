local M = {}

M.colorizer = function()
  require("colorizer").setup()
end

M.lspkind = function()
  require("lspkind").init()
end

M.neoscroll = function()
  require("neoscroll").setup()
end

M.blankline = function()
  vim.g.indentLine_enabled = 1
  vim.g.indent_blankline_char = "▏"

  vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard", "packer" }
  vim.g.indent_blankline_buftype_exclude = { "terminal" }

  vim.g.indent_blankline_show_trailing_blankline_indent = false
  vim.g.indent_blankline_show_first_indent_level = false
end

-- custom telescope search functions
M.search_dev = function()
  require("telescope.builtin").find_files {
    prompt_title = "~ dev ~ ",
    shorten_path = false,
    cwd = "~/dev/",
    layout_strategy = "horizontal",
    layout_config = {
      preview_width = 0.65,
    },
  }
end

M.search_dotfiles = function()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~ ",
    shorten_path = false,
    cwd = "~/dotfiles/nvim",
    layout_strategy = "horizontal",
    layout_config = {
      preview_width = 0.65,
    },
  }
end

return M
