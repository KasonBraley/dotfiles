if not pcall(require, "nvim-treesitter") then
  return
end

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "javascript",
    "html",
    "css",
    "typescript",
    "tsx",
    "json",
    "bash",
    "lua",
    "python",
    "yaml",
    "dockerfile",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  matchup = {
    enable = true,
    disable = {},
  },
  autotag = {
    enable = true,
  },
  autopairs = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>s"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>S"] = "@parameter.inner",
      },
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
  },
})
