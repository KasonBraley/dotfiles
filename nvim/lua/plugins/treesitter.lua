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
    }
  }
