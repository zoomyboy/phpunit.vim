" root of unit tests
if !exists('g:phpunit_testroot')
  let g:phpunit_testroot = 'tests'
endif
if !exists('g:phpunit_srcroot')
  let g:phpunit_srcroot = 'src'
endif

if !exists('g:php_bin')
  let g:php_bin = ''
endif

if !exists('g:phpunit_bin')
  let g:phpunit_bin = 'phpunit'
endif

if !exists('g:phpunit_options')
  let g:phpunit_options = ['--stop-on-failure', '--columns=50', '--debug'] 
endif

" you can set there subset of tests if you do not want to run
" full set
if !exists('g:phpunit_tests')
  let g:phpunit_tests = g:phpunit_testroot
endif


let g:PHPUnit = {}

fun! g:PHPUnit.buildBaseCommand()
  let cmd = []
  if g:php_bin != ""
    call add(cmd, g:php_bin)
  endif
  call add(cmd, g:phpunit_bin)
  call add(cmd, join(g:phpunit_options, " "))
  return cmd
endfun

" *************************************************
" ------------------ Open Buffer ------------------
" *************************************************
fun! g:PHPUnit.OpenBuffer(cmd, title)
  let g:phpunitcommand = join(a:cmd," ")

  " is there phpunit_buffer?
  if exists('g:phpunit_buffer') && bufexists(g:phpunit_buffer)
    let phpunit_win = bufwinnr(g:phpunit_buffer)
    " is buffer visible?
    if phpunit_win > 0
      " switch to visible phpunit buffer
      execute phpunit_win . "wincmd w"
    else
      " split current buffer, with phpunit_buffer
      execute "rightbelow vertical sb ".g:phpunit_buffer
    endif
    " well, phpunit_buffer is opened, clear content
    setlocal modifiable
    silent %d
  else
    " there is no phpunit_buffer create new one
    rightbelow 50vnew
    let g:phpunit_buffer=bufnr('%')
  endif

  file PHPUnit
  " exec 'file Diff-' . file
  setlocal nobuflisted noswapfile nonumber nowrap buftype=nofile  modifiable bufhidden=hide

python3 << EOF
import vim
import subprocess

l = 3
runningTest = False
vim.current.buffer[0] = "Starting PHPUnit..."
vim.current.buffer.append("")
vim.current.buffer.append(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
vim.current.buffer.append("")

p = subprocess.Popen(vim.vars['phpunitcommand'].decode('utf-8'), shell=True, stdout=subprocess.PIPE, universal_newlines=True, bufsize=1)

for line in p.stdout:
    if line.endswith("by Sebastian Bergmann and contributors.\n"): continue
    if line.isspace(): continue

    if line.startswith("Starting test") and line.find("::"):
        vim.current.buffer.append('R '+line.split("::")[1][0:-3])
        l += 1
        runningTest = True
    elif line.startswith("Time:"):
        vim.current.buffer.append("")
        vim.current.buffer.append("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        vim.current.buffer.append("")
    elif line.startswith('.') and runningTest == True:
        vim.current.buffer[l] = vim.current.buffer[l].replace("R", "S", 1)
        runningTest = False
    elif line.startswith('F') and runningTest == True:
        vim.current.buffer[l] = vim.current.buffer[l].replace("R", "F", 1)
        runningTest = False
    else:
        vim.current.buffer.append(line)
        l += 1
    vim.command('redraw')
    vim.command('syntax sync fromstart')
EOF

  setlocal nomodifiable

endfun




fun! g:PHPUnit.RunAll()
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd + [expand(g:phpunit_testroot)]
 
  silent call g:PHPUnit.OpenBuffer(cmd, "RunAll") 
endfun

fun! g:PHPUnit.RunCurrentFile()
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd +  [bufname("%")]
  silent call g:PHPUnit.OpenBuffer(cmd, bufname("%")) 
endfun
fun! g:PHPUnit.RunTestCase(filter)
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd + ["--filter", a:filter , bufname("%")]
  silent call g:PHPUnit.OpenBuffer(cmd, bufname("%") . ":" . a:filter) 
endfun

fun! g:PHPUnit.SwitchFile()
  let file = expand('%')
  let cmd = ''
  let isTest = expand('%:t') =~ "Test\.php$"

  if isTest
    " replace phpunit_testroot with libroot
    let file = substitute(file, '^' . g:phpunit_testroot . '/', g:phpunit_srcroot . '/', '')

    " remove 'Test.' from filename
    let file = substitute(file,'Test\.php$','.php','')
    let cmd = 'to '
  else
    let file = expand('%:r')
    let file = substitute(file,'^'.g:phpunit_srcroot, g:phpunit_testroot, '')
    let file = file . 'Test.php'
    let cmd = 'bo '
  endif
  " exec 'tabe ' . f 

  " is there window with complent file open?
  let win = bufwinnr(file)
  if win > 0
    execute win . "wincmd w"
  else
    execute cmd . "vsplit " . file
    let dir = expand('%:h')
    if ! isdirectory(dir) 
      cal mkdir(dir,'p')
    endif
  endif
endf

command! -nargs=0 PHPUnitRunAll :call g:PHPUnit.RunAll()
command! -nargs=0 PHPUnitRunCurrentFile :call g:PHPUnit.RunCurrentFile()
command! -nargs=1 PHPUnitRunFilter :call g:PHPUnit.RunTestCase(<f-args>)
command! -nargs=0 PHPUnitSwitchFile :call g:PHPUnit.SwitchFile()

nnoremap <Leader>ta :PHPUnitRunAll<CR>
nnoremap <Leader>tf :PHPUnitRunCurrentFile<CR>
nnoremap <Leader>ts :PHPUnitSwitchFile<CR>
