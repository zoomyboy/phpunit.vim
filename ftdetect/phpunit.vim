autocmd BufFilePost * call s:setFiletype()

fun! s:setFiletype()
	if expand("%") == "PHPUnit"
		set filetype=phpunit
	endif
endfun
