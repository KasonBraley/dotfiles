local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
  return
end

  ts_config.setup {
    ensure_installed = {
      "javascript",
      "html",
      "css",
      "typescript",
      "tsx",
      "json",
      "bash",
      "lua",
      "python"
      -- "rust",
      -- "go"
    },
    highlight = {
      enable = true,
      use_languagetree = true
    },
    matchup = {
      enable = true,
      disable = {}
    },
    autotag = {
      enable = true,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1000,
      -- colors = {},
      -- termcolors = {}
    },
    context_commentstring = {
      enable = true,
    }
  }
