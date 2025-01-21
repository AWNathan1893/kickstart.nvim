" LateX-specfic configuration related to the VimTeX plugin

" Only load this plugin it has not yet been loaded for this buffer

" Adapted from @ejmastnak's dotfiles: https://github.com/ejmastnak/dotfiles/blob/main/config/nvim/ftplugin/tex/vimtex.vim

if exists("b:did_myvimtexsettings")
  finish
endif
let b:did_myvimtexsettings = 1

" nmap <leader>i <plug>(vimtex-info)

nmap <leader>t <CMD>VimtexTocToggle<CR> " Table of Contents

" Toggle shell escape on an off when using minted package
" ---------------------------------------------
" Toggles shell escape compilation on and off
" function! s:TexToggleShellEscape() abort
"   if g:vimtex_compiler_latexmk.options[0] ==# '-shell-escape'
"     " Disable shell escape
"     call remove(g:vimtex_compiler_latexmk.options, 0)
"   else
"     " Enable shell escape
"     call insert(g:vimtex_compiler_latexmk.options, '-shell-escape', 0)
"   endif
"   VimtexReload
"   VimtexClean
" endfunction
"
" nmap <leader>te <Plug>TexToggleShellEscape
" nnoremap <script> <Plug>TexToggleShellEscape <SID>TexToggleShellEscape
" nnoremap <SID>TexToggleShellEscape :call <SID>TexToggleShellEscape()<CR>
"
" " When loading new buffers, search for references to minted package in the
" " document preamble and enable shell escape if minted is detected.
" silent execute '!head -n 20 ' . expand('%') . ' | grep "minted" > /dev/null'
" if ! v:shell_error  " 'minted' found in preamble
"   call insert(g:vimtex_compiler_latexmk.options, '-shell-escape', 0)
" endif
" ---------------------------------------------

" The following events are all taken from :h vimtex-events
" Compile on initialization, cleanup on stopping compilation
  augroup vimtex_event_1
    autocmd!
    autocmd User VimtexEventCompileStopped     VimtexClean
    autocmd User VimtexEventInitPost VimtexCompile
  augroup END

  " Close viewers when VimTeX buffers are closed
  function! CloseViewers()
    if executable('xdotool')
          \ && exists('b:vimtex.viewer.xwin_id')
          \ && b:vimtex.viewer.xwin_id > 0
      call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
    endif
  endfunction

  augroup vimtex_event_2
    autocmd!
    autocmd User VimtexEventQuit call CloseViewers()
  augroup END

  " " Add custom mappings in ToC buffer
  " function! TocMappings()
  "   " You probably don't want to do this, though...
  "   nnoremap <silent><buffer><nowait> q :quitall!
  " endfunction
  "
  " augroup vimtex_event_3
  "   autocmd!
  "   autocmd User VimtexEventTocCreated call TocMappings()
  " augroup END

  " Specify window position when opening ToC entries
  augroup vimtex_event_4
    autocmd!
    autocmd User VimtexEventTocActivated normal! zt
  augroup END

  function! CenterAndFlash() abort
    " Close all folds, then open only the folds at cursor position, then
    " center the cursor in window.
    normal! zMzvzz

    let save_cursorline_state = &cursorline

    " Add simple flashing effect, see
    " * https://vi.stackexchange.com/a/3481/29697
    " * https://stackoverflow.com/a/33775128/38281
    for i in range(1, 3)
      set cursorline
      redraw
      sleep 200m
      set nocursorline
      redraw
      sleep 200m
    endfor

    let &cursorline = save_cursorline_state
  endfunction

  " Specify additional behaviour after inverse search
  augroup vimtex_event_5
    autocmd!
    autocmd User VimtexEventViewReverse call CenterAndFlash()
  augroup END

  " Focus the terminal after inverse search
  augroup vimtex_event_6
    autocmd!
    autocmd User VimtexEventViewReverse call b:vimtex.viewer.xdo_focus_vim()
  augroup END
" ---------------------------------------------

" DEFINE MAPPINGS
" ---------------------------------------------
nmap dse <plug>(vimtex-env-delete)
nmap dsc <plug>(vimtex-cmd-delete)
nmap dsm <plug>(vimtex-env-delete-math)
nmap dsd <plug>(vimtex-delim-delete)
nmap cse <plug>(vimtex-env-change)
nmap csc <plug>(vimtex-cmd-change)
nmap csm <plug>(vimtex-env-change-math)
nmap csd <plug>(vimtex-delim-change-math)
nmap tsf <plug>(vimtex-cmd-toggle-frac)
nmap tsc <plug>(vimtex-cmd-toggle-star)
nmap tse <plug>(vimtex-env-toggle-star)
nmap tsd <plug>(vimtex-delim-toggle-modifier)
nmap tsD <plug>(vimtex-delim-toggle-modifier-reverse)
nmap tsm <plug>(vimtex-env-toggle-math)
imap ]] <plug>(vimtex-delim-close)
imap <buffer> <f7> <plug>(vimtex-cmd-create)}<left>
nmap <localleader>c <plug>(vimtex-compile)
nmap <localleader>v <plug>(vimtex-view)

" Text objects in operator-pending mode
omap ac <plug>(vimtex-ac)
xmap ac <plug>(vimtex-ac)
omap ic <plug>(vimtex-ic)
xmap ic <plug>(vimtex-ic)

omap ad <plug>(vimtex-ad)
xmap ad <plug>(vimtex-ad)
omap id <plug>(vimtex-id)
xmap id <plug>(vimtex-id)

omap ae <plug>(vimtex-ae)
xmap ae <plug>(vimtex-ae)
omap ie <plug>(vimtex-ie)
xmap ie <plug>(vimtex-ie)

omap am <plug>(vimtex-a$)
xmap am <plug>(vimtex-a$)
omap im <plug>(vimtex-i$)
xmap im <plug>(vimtex-i$)

omap aP <plug>(vimtex-aP)
xmap aP <plug>(vimtex-aP)
omap iP <plug>(vimtex-iP)
xmap iP <plug>(vimtex-iP)

omap ai <plug>(vimtex-am)
xmap ai <plug>(vimtex-am)
omap ii <plug>(vimtex-im)
xmap ii <plug>(vimtex-im)

" nvo mode mappings
map %  <plug>(vimtex-%)
map ]] <plug>(vimtex-]])
map ][ <plug>(vimtex-][)
map [] <plug>(vimtex-[])
map [[ <plug>(vimtex-[[)

map ]m <plug>(vimtex-]m)
map ]M <plug>(vimtex-]M)
map [m <plug>(vimtex-[m)
map [M <plug>(vimtex-[M)

map ]n <plug>(vimtex-]n)
map ]N <plug>(vimtex-]N)
map [n <plug>(vimtex-[n)
map [N <plug>(vimtex-[N)

map ]r <plug>(vimtex-]r)
map ]R <plug>(vimtex-]R)
map [r <plug>(vimtex-[r)
map [R <plug>(vimtex-[R)

map ]/ <plug>(vimtex-]/
map ]* <plug>(vimtex-]star
map [/ <plug>(vimtex-[/
map [* <plug>(vimtex-[star
