autocmd BufFilePost * call g:PHPUnit.SetFiletype()
fun! g:PHPUnit.SetFiletype()
	if expand("%") == "PHPUnit"
		set filetype=phpunit
	endif
endfun
