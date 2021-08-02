local M = {}

M.colorizer = function()
  local present, colorizer = pcall(require, "colorizer")
  if present then
    colorizer.setup()
    vim.cmd("ColorizerReloadAllBuffers")
  end
end

M.comment = function()
  local present, nvim_comment = pcall(require, "nvim_comment")
  if present then
    nvim_comment.setup()
  end
end

M.lspkind = function()
  local present, lspkind = pcall(require, "lspkind")
  if present then
    lspkind.init()
  end
end

M.neoscroll = function()
  pcall(
    function()
      require("neoscroll").setup()
    end
  )
end

M.blankline = function()
  vim.g.indentLine_enabled = 1
  vim.g.indent_blankline_char = "▏"

  vim.g.indent_blankline_filetype_exclude = {"help", "terminal", "dashboard"}
  vim.g.indent_blankline_buftype_exclude = {"terminal"}

  vim.g.indent_blankline_show_trailing_blankline_indent = false
  vim.g.indent_blankline_show_first_indent_level = false
end

M.search_dev = function()
  require("telescope.builtin").find_files(
    {
      prompt_title = "~ dev ~ ",
      shorten_path = false,
      cwd = "~/dev/",
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 0.65
      }
    }
  )
end

M.search_dotfiles = function()
  require("telescope.builtin").find_files(
    {
      prompt_title = "~ dotfiles ~ ",
      shorten_path = false,
      cwd = "~/dotfiles/nvim",
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 0.65
      }
    }
  )
end

return M
