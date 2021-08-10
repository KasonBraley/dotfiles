local comment = require "kommentary.config"

comment.configure_language("javascript", {
  prefer_single_line_comments = true,
  single_line_comment_string = "auto",
  multi_line_comment_strings = "auto",
  hook_function = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})

comment.configure_language("typescriptreact", {
  prefer_single_line_comments = true,
  single_line_comment_string = "auto",
  multi_line_comment_strings = "auto",
  hook_function = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})

comment.configure_language("lua", {
  prefer_single_line_comments = true,
  single_line_comment_string = "auto",
  multi_line_comment_strings = "auto",
  hook_function = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})

comment.configure_language("html", {
  prefer_single_line_comments = true,
  single_line_comment_string = "auto",
  multi_line_comment_strings = "auto",
  hook_function = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})

comment.configure_language("css", {
  prefer_single_line_comments = true,
  single_line_comment_string = "auto",
  multi_line_comment_strings = "auto",
  hook_function = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})
