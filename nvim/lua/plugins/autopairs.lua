local autopairs = require "nvim-autopairs"
local autopairs_completion = require "nvim-autopairs.completion.compe"

autopairs.setup()
autopairs_completion.setup {
  map_cr = true,
  map_complete = true, -- insert () func completion
}
