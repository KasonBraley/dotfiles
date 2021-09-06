local autopairs = require "nvim-autopairs"
local autopairs_completion = require "nvim-autopairs.completion.cmp"

autopairs.setup {
  check_ts = true,
}

autopairs_completion.setup {
  map_cr = true,
  map_complete = true,
  auto_select = true,
}
