vim.cmd([[
	setlocal makeprg=mvn\ verify\ -q\ 
	setlocal errorformat=\[ERROR]\ %f:[%l\\,%v]\ %m
]])
