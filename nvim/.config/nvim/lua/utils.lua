-- hide line numbers , statusline in specific buffers!
vim.api.nvim_exec(
  [[
   au TermOpen term://* setlocal nonumber norelativenumber laststatus=0 
   au TermOpen term://* startinsert
   au TermClose term://* bd!
   au FileType gitcommit setlocal spell
   au BufRead,BufNewFile *.md setlocal spell
   au BufWrite * set fileformat=unix 
   au BufRead,BufNewFile tsconfig.json setlocal filetype=jsonc
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
]],
  false
)
