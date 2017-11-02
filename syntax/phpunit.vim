syntax match PHPUnitFail /^FAILURES.*$/
syntax match PHPUnitFailSmall /^not ok .*$/
syntax match PHPUnitOK /^\(OK\|ok\) .*$/
syntax match PHPUnitAssertFail /^Failed asserting.*$/


highlight PHPUnitFail guibg=#ff0000 ctermbg=Red guifg=White ctermfg=White
highlight PHPUnitOK guibg=Green ctermbg=Green guifg=Black ctermfg=Black
highlight def link PHPUnitFailSmall PHPUnitFail
highlight PHPUnitAssertFail guifg=LightRed ctermfg=LightRed



