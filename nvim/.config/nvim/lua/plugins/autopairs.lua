local present, autopairs = pcall(require,"nvim-autopairs")
if not present then
  return
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

autopairs.setup({
  check_ts = true,
  enable_check_bracket_line = false
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
