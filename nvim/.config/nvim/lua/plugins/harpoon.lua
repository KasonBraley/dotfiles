return {
  {
    "ThePrimeagen/harpoon",
    commit = "7cf2e20a411ea106d7367fab4f10bf0243e4f2c2",
    config = function()
      vim.keymap.set("n", "<C-e>", require("harpoon.ui").toggle_quick_menu)
      -- vim.keymap.set("n", "<C-y>", require("harpoon.cmd-ui").toggle_quick_menu)
      vim.keymap.set("n", "<Leader>a", require("harpoon.mark").add_file)
      vim.keymap.set("n", "<Leader>j", function() require("harpoon.ui").nav_file(1) end)
      vim.keymap.set("n", "<Leader>k", function() require("harpoon.ui").nav_file(2) end)
      vim.keymap.set("n", "<Leader>l", function() require("harpoon.ui").nav_file(3) end)
      vim.keymap.set("n", "<Leader>;", function() require("harpoon.ui").nav_file(4) end)
      vim.keymap.set("n", "tj", function() require("harpoon.term").gotoTerminal(1) end)
      vim.keymap.set("n", "tk", function() require("harpoon.term").gotoTerminal(2) end)
      vim.keymap.set(
        "n",
        "cj",
        ":lua require('harpoon.term').sendCommand(2,1); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
      )
      vim.keymap.set(
        "n",
        "ck",
        ":lua require('harpoon.term').sendCommand(2,2); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
      )
    end
  },
}
