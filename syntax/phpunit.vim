syntax match PHPUnitFail /^FAILURES.*$/
syntax match PHPUnitFailSmall /^not ok .*$/
syntax match PHPUnitOk /^\(OK\|ok\) (.*ions)$/
syntax match PHPUnitAssertFail /^Failed asserting.*$/

syntax region PHPUnitTestResults start="^>\{50\}$" end="^<\{50\}$" contains=PHPUnitRunning,PHPUnitSuccess,PHPUnitWarning,PHPUnitError,PHPUnitFailure
syntax match PHPUnitRunning /^R\ / contained
syntax match PHPUnitSuccess /^S\ / contained
syntax match PHPUnitWarning /^W\ / contained
syntax match PHPUnitError /^E\ / contained
syntax match PHPUnitFailure /^F\ / contained


highlight PHPUnitFail guibg=#ff0000 ctermbg=Red guifg=White ctermfg=White
highlight PHPUnitOk guibg=Green ctermbg=Green guifg=Black ctermfg=Black
highlight def link PHPUnitFailSmall PHPUnitFail
highlight PHPUnitAssertFail guifg=LightRed ctermfg=LightRed

highlight PHPUnitRunning guibg=#666600 ctermbg=Yellow guifg=White ctermfg=White
highlight def link PHPUnitSuccess PHPUnitOk
highlight def link PHPUnitError PHPUnitFail
highlight def link PHPUnitFailure PHPUnitFail
highlight def link PHPUnitWarning PHPUnitRunning
