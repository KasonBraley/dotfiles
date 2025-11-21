return {
  {
    "ThePrimeagen/harpoon",
    commit = "7cf2e20a411ea106d7367fab4f10bf0243e4f2c2",
    config = function()
      vim.keymap.set("n", "<C-e>", require("harpoon.ui").toggle_quick_menu)
      vim.keymap.set("n", "<Leader>a", require("harpoon.mark").add_file)
      vim.keymap.set("n", "<C-1>", function() require("harpoon.ui").nav_file(1) end)
      vim.keymap.set("n", "<C-2>", function() require("harpoon.ui").nav_file(2) end)
      vim.keymap.set("n", "<C-3>", function() require("harpoon.ui").nav_file(3) end)
      vim.keymap.set("n", "<C-4>", function() require("harpoon.ui").nav_file(4) end)
      vim.keymap.set("n", "tj", function() require("harpoon.term").gotoTerminal(1) end)
      vim.keymap.set("n", "tk", function() require("harpoon.term").gotoTerminal(2) end)
    end
  },
}
