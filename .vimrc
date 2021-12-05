set encoding=utf-8
scriptencoding utf-8

" --------------------------------------------------------------------------------
" 基本
" --------------------------------------------------------------------------------
let s:sid          = expand('<SID>')
let s:dotvim_dir   = expand('~/.vim')
let s:dropbox_dir  = expand('~/Dropbox')
let s:is_vscode    = exists('g:vscode')
let s:is_gui       = has('gui_running')
let s:base_columns = 140

let g:no_gvimrc_example        = 1
let g:no_vimrc_example         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_matchparen        = 1
let g:loaded_logiPat           = 1
let g:loaded_netrw             = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tohtml            = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_spellfile_plugin  = 1
let g:skip_loading_mswin       = 1
let g:did_install_syntax_menu  = 1

let g:mapleader         = "\<Space>"
let g:python3_host_prog = 'C:/Users/yoi/AppData/Local/Programs/Python/Python310/python.exe'

" ローカル設定
let s:vimrc_local = expand('~/.vimrc.local')
if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif

if !s:is_vscode
  " 自動コマンド
  augroup MyAutoCmd
    autocmd!
  augroup END

  command! -nargs=* Autocmd   autocmd MyAutoCmd <args>
  command! -nargs=* AutocmdFT autocmd MyAutoCmd FileType <args>
  Autocmd BufWinEnter,ColorScheme .vimrc
        \  highlight def link myVimAutocmd vimAutoCmd
        \| syntax match vimAutoCmd /\<\(Autocmd\|AutocmdFT\)\>/

  function! s:edit_vimrc()
    let dropbox_vimrc = s:dropbox_dir . '/dotfiles/.vimrc'
    if filereadable(dropbox_vimrc)
      execute 'edit' dropbox_vimrc
    else
      execute 'edit' $MYVIMRC
    endif
  endfunction

  nnoremap <silent> <F1> :<C-u>call <SID>edit_vimrc()<CR>
  nnoremap <silent> <F2> :<C-u>PlugUpdate<CR>

  " スタートアップ時間表示
  if has('vim_starting')
    let s:startuptime = reltime()
    Autocmd VimEnter *
          \  let s:startuptime = reltime(s:startuptime)
          \| echomsg 'startuptime:' reltimestr(s:startuptime)
  endif
endif

" --------------------------------------------------------------------------------
" プラグイン
" --------------------------------------------------------------------------------
call plug#begin('~/.vim_plugged')

if !s:is_vscode
  Plug 'YoshihiroIto/night-owl.vim'
  Plug 'YoshihiroIto/vim-icondrag', {'on': []}
  " vim-icondrag {{{
  autocmd! User vim-icondrag call icondrag#enable()
  " }}}

  Plug 'itchyny/vim-gitbranch', {'on': []}
  Plug 'airblade/vim-gitgutter', {'on': []}
  " vim-gitgutter {{{
  autocmd! User vim-gitgutter
        \  call gitgutter#enable()
        \| let g:gitgutter_map_keys = 0
        \| let g:gitgutter_grep     = ''
  " }}}

  Plug 'osyo-manga/vim-hopping', {'on': []}
  " vim-hopping {{{
  nnoremap <silent> <leader>l   :<C-u>HoppingStart<CR>
  let g:hopping#keymapping = {
        \   "\<C-n>" : '<Over>(hopping-next)',
        \   "\<C-p>" : '<Over>(hopping-prev)',
        \ }
  " }}}

  Plug 'previm/previm', {'on': []}
  " previm {{{
  nnoremap <silent> <leader>p :<C-u>PrevimOpen<CR>
  " }}}

  Plug 'cocopon/vaffle.vim', {'on': []}
  " vaffle.vim {{{
  let g:vaffle_show_hidden_files = 1
  " }}}

  Plug 'itchyny/vim-cursorword', {'on': []}
  " vim-cursorword {{{
  let g:cursorword_delay     = 270
  let g:cursorword_highlight = 0
  Autocmd ColorScheme *
        \  highlight CursorWord0 guifg=Red ctermfg=Red
        \| highlight CursorWord1 guifg=Red ctermfg=Red
  " }}}

  Plug 'itchyny/vim-autoft', {'on': []}
  " vim-autoft {{{
  let g:autoft_config = [
        \   {'filetype': 'cs',   'pattern': '^\s*using'},
        \   {'filetype': 'cpp',  'pattern': '^\s*#\s*\%(include\|define\)\>'},
        \   {'filetype': 'go',   'pattern': '^import ('},
        \   {'filetype': 'html', 'pattern': '<\%(!DOCTYPE\|html\|head\|script\|meta\|link|div\|span\)\>\|^html:5\s*$'},
        \   {'filetype': 'xml',  'pattern': '<[0-9a-zA-Z]\+'},
        \ ]
  " }}}

  " Plug 'beyondmarc/hlsl.vim', {'for': 'hlsl'}
  Plug 'posva/vim-vue', {'for': 'vue'}

  Plug 'glidenote/memolist.vim', {'on': []}
  " memolist.vim {{{
  noremap <silent> <leader>n :<C-u>MemoNew<CR>
  noremap <silent> <leader>k :execute 'CtrlP' g:memolist_path<CR>
  let g:memolist_memo_suffix = 'md'
  let g:memolist_path        = s:dropbox_dir . '/memo'
  " }}}

  Plug 'mattn/vim-lsp-settings', {'on': []}
  " vim-lsp-settings {{{
  let g:lsp_settings_servers_dir = expand('~/lsp_server')
  " }}}

  Plug 'prabirshrestha/vim-lsp', {'on': []}
  " vim-lsp {{{
  autocmd! User vim-lsp call s:init_lsp()
  let g:lsp_auto_enable = 0

  function s:init_lsp()
    let g:lsp_diagnostics_enabled        = 1
    let g:lsp_diagnostics_echo_cursor    = 1
    let g:lsp_document_highlight_enabled = 0
    nmap <silent> <C-]> :<C-u>LspDefinition<CR>
    nmap <silent> ;e    :<C-u>LspRename<CR>

    call lsp#enable()
  endfunction
  " }}}

  Plug 'mattn/ctrlp-matchfuzzy', {'on': []}
  Plug 'ctrlpvim/ctrlp.vim', {'on': []}
  " ctrlp {{{
  nnoremap <silent> <leader>m   :<C-u>CtrlPMRUFiles<CR>

  let g:ctrlp_match_window = 'bottom,order:ttb,min:32,max:32'
  let g:ctrlp_map          = ''
  let g:ctrlp_regexp       = 1
  let g:ctrlp_match_func   = {'match': 'ctrlp_matchfuzzy#matcher'}
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching  = 0

  let g:ctrlp_prompt_mappings = {
        \   'PrtBS()':              ['<bs>', '<c-]>', '<c-h>'],
        \   'PrtDelete()':          ['<del>'],
        \   'PrtDeleteWord()':      ['<c-w>'],
        \   'PrtClear()':           ['<c-u>'],
        \   'PrtSelectMove("j")':   ['<c-n>'],
        \   'PrtSelectMove("k")':   ['<c-p>'],
        \   'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
        \   'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
        \   'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
        \   'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
        \   'PrtHistory(-1)':       ['<down>'],
        \   'PrtHistory(1)':        ['<up>'],
        \   'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
        \   'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
        \   'AcceptSelection("t")': ['<c-t>'],
        \   'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
        \   'ToggleFocus()':        ['<s-tab>'],
        \   'ToggleRegex()':        ['<c-r>'],
        \   'ToggleByFname()':      ['<c-d>'],
        \   'ToggleType(1)':        ['<c-f>', '<c-up>'],
        \   'ToggleType(-1)':       ['<c-b>', '<c-down>'],
        \   'PrtExpandDir()':       ['<tab>'],
        \   'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
        \   'PrtInsert()':          ['<c-\>'],
        \   'PrtCurStart()':        ['<c-a>'],
        \   'PrtCurEnd()':          ['<c-e>'],
        \   'PrtCurLeft()':         ['<left>', '<c-^>'],
        \   'PrtCurRight()':        ['<c-l>', '<right>'],
        \   'PrtClearCache()':      ['<F5>'],
        \   'PrtDeleteEnt()':       ['<F7>'],
        \   'CreateNewFile()':      ['<c-y>'],
        \   'MarkToOpen()':         ['<c-z>'],
        \   'OpenMulti()':          ['<c-o>'],
        \   'PrtExit()':            ['<esc>', '<c-c>', '<c-g>', '<c-j>'],
        \ }

  let g:ctrlp_status_func = {
        \   'main': s:sid . 'ctrlp_Name_1',
        \   'prog': s:sid . 'ctrlp_Name_2',
        \ }

  function! s:ctrlp_Name_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    let g:lightline.ctrlp_marked = a:marked
    return lightline#statusline(0)
  endfunction

  function! s:ctrlp_Name_2(str)
    return lightline#statusline(0)
  endfunction
  " }}}

  Plug 'itchyny/lightline.vim'
  " lightline.vim {{{
  let g:lightline#colorscheme#yoi#palette = {
        \   'inactive': {
        \     'left':     [['#585858', '#262626', 240, 235],
        \                  ['#585858', '#121212', 240, 233]],
        \     'right':    [['#262626', '#606060', 235, 241],
        \                  ['#585858', '#262626', 240, 235],
        \                  ['#585858', '#121212', 240, 233]]
        \   },
        \   'insert':   {
        \     'branch':   [['#FFFFFF', '#0087AF', 231,  31]],
        \     'left':     [['#005F5F', '#FFFFFF',  23, 231],
        \                  ['#87DFFF', '#005F87', 117,  24]],
        \     'middle':   [['#87DFFF', '#005F87', 117,  24]],
        \     'right':    [['#005F5F', '#87DFFF',  23, 117],
        \                  ['#87DFFF', '#0087AF', 117,  31],
        \                  ['#87DFFF', '#005F87', 117,  24]]
        \   },
        \   'normal':   {
        \     'branch':   [['#FFFFFF', '#585858', 231, 240]],
        \     'error':    [['#BCBCBC', '#FF0000', 250, 196]],
        \     'left':     [['#195E00', '#07AF00',  22,  34],
        \                  ['#8A8A8A', '#303030', 245, 236]],
        \     'middle':   [['#8A8A8A', '#303030', 245, 236]],
        \     'right':    [['#606060', '#D0D0D0', 241, 252],
        \                  ['#BCBCBC', '#585858', 250, 240],
        \                  ['#9E9E9E', '#303030', 247, 236]],
        \     'warning':  [['#262626', '#B58900', 235, 136]]
        \   },
        \   'replace':  {
        \     'left':     [['#FFFFFF', '#DF0000', 231, 160],
        \                  ['#FFFFFF', '#585858', 231, 240]],
        \     'middle':   [['#8A8A8A', '#303030', 245, 236]],
        \     'right':    [['#606060', '#D0D0D0', 241, 252],
        \                  ['#BCBCBC', '#585858', 250, 240],
        \                  ['#9E9E9E', '#303030', 247, 236]]
        \   },
        \   'tabline':  {
        \     'left':     [['#BCBCBC', '#585858', 250, 240]],
        \     'middle':   [['#303030', '#9E9E9E', 236, 247]],
        \     'right':    [['#BCBCBC', '#4E4E4E', 250, 239]],
        \     'tabsel':   [['#BCBCBC', '#262626', 250, 235]]
        \   },
        \   'visual':   {
        \     'branch':   [['#FFFFFF', '#AF0053', 231, 125]],
        \     'left':     [['#AB2362', '#FFFFFF', 125, 231],
        \                  ['#FF84BA', '#870036', 211,  89]],
        \     'middle':   [['#FF84BA', '#870036', 211,  89]],
        \     'right':    [['#75003D', '#FF87BB',  89, 211],
        \                  ['#FE86BB', '#AF0053', 211, 125],
        \                  ['#FF84BA', '#870036', 211,  89]]
        \   }
        \ }

  let g:lightline = {
        \   'colorscheme': 'yoi',
        \   'active': {
        \     'left': [
        \       ['mode',   'paste'],
        \       ['branch', 'gitgutter', 'filename', 'submode']
        \     ],
        \     'right': [
        \       ['syntastic', 'lineinfo'],
        \       ['percent']
        \     ]
        \   },
        \   'component': {'percent': '%3p%%'},
        \   'component_function': {
        \     'fileformat':   s:sid . 'lightline_fileformat',
        \     'filetype':     s:sid . 'lightline_filetype',
        \     'fileencoding': s:sid . 'lightline_fileencoding',
        \     'modified':     s:sid . 'lightline_modified',
        \     'readonly':     s:sid . 'lightline_readonly',
        \     'filename':     s:sid . 'lightline_filename',
        \     'mode':         s:sid . 'lightline_mode',
        \     'lineinfo':     s:sid . 'lightline_lineinfo',
        \     'submode':      'submode#current'
        \   },
        \   'component_expand': {
        \     'syntastic':    'SyntasticStatuslineFlag',
        \     'branch':       s:sid . 'lightline_current_branch',
        \     'gitgutter':    s:sid . 'lightline_git_summary'
        \   },
        \   'component_type': {
        \     'syntastic':    'error',
        \     'branch':       'branch',
        \     'gitgutter':    'branch'
        \   },
        \   'separator': {   'left': '', 'right': ''},
        \   'subseparator': {'left': '', 'right': ''},
        \   'tabline': {
        \     'left':  [['tabs']],
        \     'right': [['filetype', 'fileformat', 'fileencoding']]
        \   },
        \   'tabline_separator': {   'left': '', 'right': ''},
        \   'tabline_subseparator': {'left': '︱', 'right': '︱'},
        \   'mode_map': {
        \     'n':      'N',
        \     'i':      'I',
        \     'R':      'R',
        \     'v':      'V',
        \     'V':      'VL',
        \     'c':      'C',
        \     "\<C-v>": 'VB',
        \     's':      'S',
        \     'S':      'SL',
        \     "\<C-s>": 'SB',
        \     't':      'T',
        \     '?':      ' '
        \   }
        \ }

  function! s:lightline_mode()
    return  &filetype ==# 'quickrun' ? 'Quickrun' :
          \ winwidth(0) > 50 ? lightline#mode() : ''
  endfunction

  function! s:lightline_modified()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    return &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! s:lightline_readonly()
    if s:is_lightline_no_disp_filetype()
      return ''
    endif

    return &readonly ? '' : ''
  endfunction

  function! s:lightline_filename()
    try
      return (empty(s:lightline_readonly()) ? '' : s:lightline_readonly() . ' ') .
            \ (&filetype ==# 'quickrun' ? ''      :
            \  empty(expand('%:t')) ? '[No Name]' : expand('%:t')) .
            \ (empty(s:lightline_modified()) ? '' : ' ' . s:lightline_modified())
    catch
      return ''
    endtry
  endfunction

  function! s:lightline_current_branch()
    if s:is_lightline_no_disp_filetype()
      return ''
    endif

    if empty(expand('%:p'))
      return ''
    endif

    try
      let branch = gitbranch#name()
      return empty(branch) ? '' : '' . branch
    catch
      return ''
    endtry
  endfunction

  function! s:lightline_fileformat()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    return &fileformat
  endfunction

  function! s:lightline_filetype()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    return empty(&filetype) ? 'no filetype' : &filetype
  endfunction

  function! s:lightline_fileencoding()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    return empty(&fileencoding) ? &encoding : &fileencoding
  endfunction

  function! s:lightline_git_summary()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    if empty(expand('%:p'))
      return ''
    endif

    try
      let branch = gitbranch#name()
      if empty(branch)
        return ''
      endif

      let summary = GitGutterGetHunkSummary()
      return printf('%s%d %s%d %s%d',
            \ g:gitgutter_sign_added,    summary[0],
            \ g:gitgutter_sign_modified, summary[1],
            \ g:gitgutter_sign_removed,  summary[2])
    catch
      return ''
    endtry
  endfunction

  function! s:lightline_lineinfo()
    if winwidth(0) <= 50
      return ''
    endif

    return printf('%4d/%d : %-3d', line('.'), line('$'), col('.'))
  endfunction

  function! s:is_lightline_no_disp_filetype()
    return &filetype =~# 'quickrun'
  endfunction

  function! s:is_lightline_no_disp_group()
    if winwidth(0) <= 50
      return 1
    endif

    if s:is_lightline_no_disp_filetype()
      return 1
    endif

    return 0
  endfunction

  Autocmd CursorHold,CursorHoldI * call lightline#update()
  " }}}

  Plug 'kana/vim-submode', {'on': []}
  " submode {{{
  autocmd! User vim-submode call s:init_submode()

  function! s:submode_snap(value, scale)
    return a:value / a:scale * a:scale
  endfunction

  function! s:submode_resize_appwin(x, y)
    let scale = get(g:, 'yoi_resize_appwin_size', 8)

    if a:x != 0
      let &columns = s:submode_snap(&columns, scale) + a:x * scale
    endif

    if a:y != 0
      let &lines   = s:submode_snap(&lines,   scale) + a:y * scale
    endif
  endfunction

  function! s:submode_move_appwin(x, y)
    let scale = get(g:, 'yoi_move_appwin_size', 64)
    let win_x = getwinposx()
    let win_y = getwinposy()

    if a:x == 0
      let x = win_x
    else
      let x = win_x + a:x * scale

      if win_x != s:submode_snap(win_x, scale)
        let x = s:submode_snap(x, scale)
      endif
    endif

    if a:y == 0
      let y = win_y
    else
      let y = win_y + a:y * scale

      if win_y != s:submode_snap(win_y, scale)
        let y = s:submode_snap(y, scale)
      endif
    endif

    execute 'winpos' x y
  endfunction

  function s:init_submode()
    let g:submode_timeout          = 0
    let g:submode_keep_leaving_key = 1

    call submode#enter_with('git_hunk', 'n', 's', 'ghj', ':<C-u>GitGutterEnable<CR>:GitGutterNextHunk<CR>zvzz')
    call submode#enter_with('git_hunk', 'n', 's', 'ghk', ':<C-u>GitGutterEnable<CR>:GitGutterPrevHunk<CR>zvzz')
    call submode#map(       'git_hunk', 'n', 's', 'j',   ':<C-u>GitGutterEnable<CR>:GitGutterNextHunk<CR>zvzz')
    call submode#map(       'git_hunk', 'n', 's', 'k',   ':<C-u>GitGutterEnable<CR>:GitGutterPrevHunk<CR>zvzz')

    call submode#enter_with('winsize', 'n', 's', 'gwh', '8<C-w>>')
    call submode#enter_with('winsize', 'n', 's', 'gwl', '8<C-w><')
    call submode#enter_with('winsize', 'n', 's', 'gwj', '4<C-w>-')
    call submode#enter_with('winsize', 'n', 's', 'gwk', '4<C-w>+')
    call submode#map(       'winsize', 'n', 's', 'h',   '8<C-w>>')
    call submode#map(       'winsize', 'n', 's', 'l',   '8<C-w><')
    call submode#map(       'winsize', 'n', 's', 'j',   '4<C-w>-')
    call submode#map(       'winsize', 'n', 's', 'k',   '4<C-w>+')

    if s:is_gui
      let call_resize_appwin = ':<C-u>call ' . s:sid . 'submode_resize_appwin'
      let call_move_appwin   = ':<C-u>call ' . s:sid . 'submode_move_appwin'

      call submode#enter_with('appwinsize', 'n', 's', '<leader>wH', call_resize_appwin . '(-1, 0)<CR>')
      call submode#enter_with('appwinsize', 'n', 's', '<leader>wL', call_resize_appwin . '(+1, 0)<CR>')
      call submode#enter_with('appwinsize', 'n', 's', '<leader>wJ', call_resize_appwin . '(0, +1)<CR>')
      call submode#enter_with('appwinsize', 'n', 's', '<leader>wK', call_resize_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'H',          call_resize_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'L',          call_resize_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'J',          call_resize_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'K',          call_resize_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'h',          call_resize_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'l',          call_resize_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'j',          call_resize_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'k',          call_resize_appwin . '(0, -1)<CR>')

      call submode#enter_with('appwinpos', 'n', 's', '<leader>wh', call_move_appwin . '(-1, 0)<CR>')
      call submode#enter_with('appwinpos', 'n', 's', '<leader>wl', call_move_appwin . '(+1, 0)<CR>')
      call submode#enter_with('appwinpos', 'n', 's', '<leader>wj', call_move_appwin . '(0, +1)<CR>')
      call submode#enter_with('appwinpos', 'n', 's', '<leader>wk', call_move_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'H',          call_move_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'L',          call_move_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'J',          call_move_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'K',          call_move_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'h',          call_move_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'l',          call_move_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'j',          call_move_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'k',          call_move_appwin . '(0, -1)<CR>')
    endif
  endfunction
  " }}}

  Plug 'prabirshrestha/asyncomplete-lsp.vim', {'on': []}
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim', {'on': []}
  Plug 'prabirshrestha/asyncomplete-buffer.vim', {'on': []}
  Plug 'prabirshrestha/asyncomplete.vim', {'on': []}
  " asyncomplete.vim {{{
  autocmd! User asyncomplete.vim call s:init_asyncomplete()

  function s:init_asyncomplete()
    call asyncomplete#enable_for_buffer()

    call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
          \   'name': 'ultisnips',
          \   'whitelist': ['*'],
          \   'priority': 10,
          \   'completor': function('asyncomplete#sources#ultisnips#completor'),
          \ }))

    call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \   'name': 'buffer',
          \   'whitelist': ['*'],
          \   'priority': 30,
          \   'completor': function('asyncomplete#sources#buffer#completor'),
          \   'config': {
          \     'max_buffer_size': 5000000,
          \   },
          \ }))
  endfunction
  " }}}

  Plug 'SirVer/ultisnips', {'on': []}
  " ultisnips {{{
  let g:UltiSnipsSnippetDirectories  = [s:dotvim_dir . '/UltiSnips']
  let g:UltiSnipsJumpForwardTrigger  = "<Tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
  let g:UltiSnipsListSnippets        = "<S-Tab>"
  let g:UltiSnipsExpandTrigger       = "<C-e>"
  " }}}

  " Plug 'prettier/vim-prettier', {
  "       \   'do': 'yarn install',
  "       \   'for': [
  "         \    'javascript', 'typescript', 'css',     'less',
  "         \    'scss',       'json',       'graphql', 'markdown',
  "         \    'vue',        'svelte',     'yaml',    'html']
  "         \ }
  " " vim-prettier {{{
  " let g:prettier#exec_cmd_async            = 1
  " let g:prettier#autoformat                = 1
  " let g:prettier#autoformat_require_pragma = 0
  " let g:prettier#quickfix_enabled          = 0
  " "}}}

  " Plug 'editorconfig/editorconfig-vim'

  Plug 'vim-jp/vimdoc-ja', {'on': []}
endif

Plug 'andymass/vim-matchup', {'on': []}
" vim-matchup {{{
let g:matchup_matchparen_status_offscreen = 0
" }}}

Plug 'markonm/traces.vim', {'on': []}
" traces.vim {{{
let g:traces_preview_window = 'botright 10new'
" }}}

Plug 'haya14busa/vim-asterisk', {'on': []}

Plug 'tomtom/tcomment_vim', {'on': []}
Plug 'cohama/lexima.vim', {'on': []}

Plug 'kana/vim-textobj-user', {'on': []}

Plug 'glts/vim-textobj-comment', {'on': []}
Plug 'kana/vim-textobj-indent', {'on': []}
Plug 'kana/vim-textobj-entire', {'on': []}
Plug 'kana/vim-textobj-line', {'on': []}
Plug 'rhysd/vim-textobj-word-column', {'on': []}
Plug 'whatyouhide/vim-textobj-xmlattr', {'on': []}

Plug 'sgur/vim-textobj-parameter', {'on': []}
" vim-textobj-parameter {{{
xmap aa <Plug>(textobj-parameter-a)
xmap ia <Plug>(textobj-parameter-i)
omap aa <Plug>(textobj-parameter-a)
omap ia <Plug>(textobj-parameter-i)
" }}}

Plug 'rhysd/vim-textobj-wiw', {'on': []}
" vim-textobj-wiw {{{
xmap a. <Plug>(textobj-wiw-a)
xmap i. <Plug>(textobj-wiw-i)
omap a. <Plug>(textobj-wiw-a)
omap i. <Plug>(textobj-wiw-i)
" }}}

Plug 'kana/vim-operator-user', {'on': []}

Plug 'YoshihiroIto/vim-operator-tcomment', {'on': []}
" vim-operator-tcomment {{{
nmap t  <Plug>(operator-tcomment)
xmap t  <Plug>(operator-tcomment)
" }}}

Plug 'kana/vim-operator-replace', {'on': []}
" vim-operator-replace {{{
map R  <Plug>(operator-replace)
" }}}

Plug 'junegunn/vim-easy-align', {'on': []}
" vim-easy-align {{{
nmap <silent> <Leader>a=       v<Plug>(textobj-indent-i)<Plug>(EasyAlign)=
nmap <silent> <Leader>a:       v<Plug>(textobj-indent-i)<Plug>(EasyAlign):
nmap <silent> <Leader>a,       v<Plug>(textobj-indent-i)<Plug>(EasyAlign)*,
nmap <silent> <Leader>a<Space> v<Plug>(textobj-indent-i)<Plug>(EasyAlign)*<Space>
nmap <silent> <Leader>a\|      v<Plug>(textobj-indent-i)<Plug>(EasyAlign)*\|
xmap <silent> <Leader>a=       <Plug>(EasyAlign)=
xmap <silent> <Leader>a:       <Plug>(EasyAlign):
xmap <silent> <Leader>a,       <Plug>(EasyAlign)*,
xmap <silent> <Leader>a<Space> <Plug>(EasyAlign)*<Space>
xmap <silent> <Leader>a\|      <Plug>(EasyAlign)*\|
" }}}

Plug 'machakann/vim-sandwich', {'on': []}
" vim-sandwich {{{
autocmd! User vim-sandwich call s:init_sandwich()
let g:operator_sandwich_no_default_key_mappings = 1
function s:init_sandwich()
  map  <silent> S   <Plug>(sandwich-add)
  nmap <silent> Sd  <Plug>(sandwich-delete)
  xmap <silent> Sd  <Plug>(sandwich-delete)
  nmap <silent> Sr  <Plug>(sandwich-replace)
  xmap <silent> Sr  <Plug>(sandwich-replace)
  nmap <silent> Sdd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  nmap <silent> Srr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

  call operator#sandwich#set('delete', 'all', 'highlight', 0)
endfunction
" }}}

Plug 'tyru/open-browser.vim', {'on': []}
" open-browser.vim {{{
let g:openbrowser_no_default_menus = 1
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}

Plug 'YoshihiroIto/vim-closetag', {'on': []}
" vim-closetag {{{
let g:closetag_filenames = '*.{html,xhtml,xml,xaml}'
" }}}

Plug 'haya14busa/is.vim', {'on': []}
" is.vim {{{
map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
" }}}

call plug#end()

function! s:load_plug(timer)
  if !s:is_vscode
    call plug#load(
          \   'vim-icondrag',
          \   'vim-submode',
          \   'vim-gitbranch',
          \   'vim-gitgutter',
          \   'vim-hopping',
          \   'previm',
          \   'vaffle.vim',
          \   'vim-cursorword',
          \   'vim-autoft',
          \   'memolist.vim',
          \   'vim-lsp-settings',
          \   'vim-lsp',
          \   'ctrlp.vim',
          \   'ctrlp-matchfuzzy',
          \   'ultisnips',
          \   'vimdoc-ja',
          \ )

    call plug#load(
          \   'asyncomplete-lsp.vim',
          \   'asyncomplete-ultisnips.vim',
          \   'asyncomplete-buffer.vim',
          \   'asyncomplete.vim'
          \ )
  endif

  call plug#load(
        \   'vim-matchup',
        \   'traces.vim',
        \   'vim-asterisk',
        \   'tcomment_vim',
        \   'lexima.vim',
        \   'vim-closetag',
        \   'is.vim',
        \   'vim-easy-align',
        \   'vim-sandwich',
        \   'open-browser.vim'
        \ )

  call plug#load(
        \   'vim-textobj-user',
        \   'vim-textobj-comment',
        \   'vim-textobj-indent',
        \   'vim-textobj-entire',
        \   'vim-textobj-line',
        \   'vim-textobj-word-column',
        \   'vim-textobj-xmlattr',
        \   'vim-textobj-parameter',
        \   'vim-textobj-wiw',
        \   'vim-operator-user',
        \   'vim-operator-tcomment',
        \   'vim-operator-replace'
        \ )
endfunction

call timer_start(100, function('s:load_plug'))

filetype plugin indent on

" --------------------------------------------------------------------------------
" ファイルタイプごとの設定
" --------------------------------------------------------------------------------
Autocmd BufEnter,WinEnter,BufWinEnter *                         call s:update_all()
Autocmd BufNewFile,BufRead            *.xaml                    setlocal filetype=xml
Autocmd BufNewFile,BufRead            *.cake                    setlocal filetype=cs
Autocmd BufNewFile,BufRead            *.json                    setlocal filetype=json
Autocmd BufNewFile,BufRead            *.{fx,fxc,fxh,hlsl,hlsli} setlocal filetype=hlsl
Autocmd BufNewFile,BufRead            *.{fsh,vsh}               setlocal filetype=glsl
Autocmd BufNewFile,BufRead            *.{md,mkd,markdown}       setlocal filetype=markdown

AutocmdFT qf
      \  nnoremap <silent><buffer> <C-l> :<C-u>cclose<CR>:CtrlPQuickfix<CR>
      \| nnoremap <silent><buffer> q     :<C-u>cclose<CR>

AutocmdFT typescript
      \  setlocal tabstop=2
      \| setlocal shiftwidth=2
      \| setlocal softtabstop=2

AutocmdFT ruby
      \  setlocal tabstop=2
      \| setlocal shiftwidth=2
      \| setlocal softtabstop=2

AutocmdFT vue
      \  setlocal tabstop=2
      \| setlocal shiftwidth=2
      \| setlocal softtabstop=2

AutocmdFT vim
      \  setlocal foldmethod=marker
      \| setlocal foldlevel=0
      \| setlocal foldcolumn=5
      \| setlocal tabstop=2
      \| setlocal shiftwidth=2
      \| setlocal softtabstop=2

AutocmdFT xml,html
      \  setlocal foldlevel=99
      \| setlocal foldcolumn=5
      \| setlocal foldmethod=syntax
      \| inoremap <silent><buffer> >  ><Esc>:call closetag#CloseTagFun()<CR>

AutocmdFT json
      \  setlocal foldmethod=syntax
      \| setlocal shiftwidth=2
      \| command! Format %!jq

AutocmdFT dosbatch
      \  setlocal fileencoding=sjis

AutocmdFT help
      \  nnoremap <silent><buffer> q  :<C-u>close<CR>

function! s:update_all()
  setlocal formatoptions-=r
  setlocal formatoptions-=o
  setlocal textwidth=0

  " ファイルの場所をカレントにする
  silent! execute 'lcd' fnameescape(expand('%:p:h'))
endfunction

" --------------------------------------------------------------------------------
" 表示
" --------------------------------------------------------------------------------
if !s:is_vscode
  syntax enable               " 構文ごとに色分けをする

  " メニューを読み込まない
  let g:did_install_default_menus = 1
  let g:did_menu_trans            = 1
  set guioptions+=M

  " ツールバー削除
  set guioptions-=T

  " メニューバー削除
  set guioptions-=m

  " スクロールバー削除
  set guioptions-=r
  set guioptions-=l
  set guioptions-=R
  set guioptions-=L

  " テキストベースタブ
  set guioptions-=e

  set number
  set textwidth=0             " 一行に長い文章を書いていても自動折り返しをしない
  set noshowcmd
  set noshowmatch             " 括弧の対応をハイライト
  set wrap
  set noshowmode
  set shortmess+=I            " 起動時のメッセージを表示しない
  set shortmess-=S
  set shortmess+=s
  set lazyredraw
  set wildmenu
  set wildmode=list:full
  set showfulltag
  set wildoptions=tagfile
  set fillchars=vert:\        " 縦分割の境界線
  set synmaxcol=2000          " ハイライトする文字数を制限する
  set updatetime=100
  set previewheight=24
  set cmdheight=4
  set laststatus=2
  set showtabline=2
  set noequalalways
  set cursorline
  set display=lastline
  set concealcursor=i
  set signcolumn=yes
  set list
  set listchars=tab:\»\ ,eol:↲,extends:»,precedes:«,nbsp:%
  set breakindent
  set foldcolumn=0
  set foldlevel=99
  set belloff=all
  set ambiwidth=double

  let g:vimsyn_folding     = 'af'
  let g:xml_syntax_folding = 1

  if s:is_gui
    set lines=100
    let &columns = s:base_columns
  endif

  colorscheme night-owl

  if !s:is_gui
    set termguicolors
  endif

  Autocmd BufWinEnter,ColorScheme * call s:set_color()

  function! s:set_color()
    " ^M を非表示
    syntax match HideCtrlM containedin=ALL /\r$/ conceal

    " 日本語入力時カーソル色を変更する
    highlight CursorIM guifg=NONE guibg=Red

    if !&readonly
      " 全角スペースとタブ文字の可視化
      syntax match InvisibleJISX0208Space '　' display containedin=ALL
      highlight InvisibleJISX0208Space guibg=#112233
    endif
  endfunction

  augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter [/\?] :set hlsearch
    autocmd CmdlineLeave [/\?] :set nohlsearch
  augroup END

  if s:is_gui
    set guifont=HackGenNerd\ Console:h11
    set renderoptions=type:directx
  endif

  set printfont=HackGenNerd\ Console:h11

  " 折り畳み
  nnoremap <expr> zh foldlevel(line('.'))  >  0  ? 'zc' : '<C-h>'
  nnoremap <expr> zl foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'

  " アプリウィンドウ操作
  if s:is_gui
    noremap <silent> <leader>we :<C-u>call <SID>toggle_v_split_wide()<CR>
    noremap <silent> <leader>wf :<C-u>call <SID>full_window()<CR>

    " アプリケーションウィンドウを最大高さにする
    function! s:full_window()
      execute 'winpos' getwinposx() '0'
      set lines=9999
    endfunction

    command! -nargs=1 -complete=file Diff
          \  call <SID>toggle_v_wide()
          \| vertical diffsplit <args>

    Autocmd WinEnter *
          \  if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&diff')) == 1
          \|   diffoff
          \|   call <SID>toggle_v_wide()
          \| endif

    " 縦分割する
    let s:depth_vsp      = 1
    let s:opend_left_vsp = 0
    let s:opend_top_vsp  = 0

    function! s:toggle_v_wide()
      if s:depth_vsp <= 1
        let s:depth_vsp += 1
      else
        let s:depth_vsp -= 1
      endif

      let &columns = s:base_columns * s:depth_vsp
    endfunction

    function! s:toggle_v_split_wide()
      if s:depth_vsp <= 1
        call s:open_v_split_wide()
      else
        call s:close_v_split_wide()
      endif
    endfunction

    function! s:open_v_split_wide()
      if s:depth_vsp == 1
        let s:opend_left_vsp = getwinposx()
        let s:opend_top_vsp  = getwinposy()
      endif

      call s:toggle_v_wide()

      execute 'botright vertical' s:base_columns 'split'
    endfunction

    function! s:close_v_split_wide()
      call s:toggle_v_wide()

      only

      if s:depth_vsp == 1
        execute 'winpos' s:opend_left_vsp s:opend_top_vsp
      endif
    endfunction
  endif
endif

" --------------------------------------------------------------------------------
" 開発
" --------------------------------------------------------------------------------
if s:is_vscode
  nnoremap ;e :<C-u>call VSCodeNotify('editor.action.rename')<CR>
  nnoremap ;r :<C-u>call VSCodeNotify('workbench.action.debug.start')<CR>

  nnoremap <silent> <leader>f :<C-u>call VSCodeNotify('workbench.view.explorer')<CR>
else
  nnoremap <silent> <leader>f :<C-u>Vaffle<CR>

  tnoremap <Esc> <C-w>N
  tnoremap <C-j> <C-w>N
endif

" --------------------------------------------------------------------------------
" 検索
" --------------------------------------------------------------------------------
set incsearch
set ignorecase
set smartcase
set hlsearch
set grepprg=rg\ --smart-case\ --vimgrep\ --no-heading
set grepformat=%f:%l:%c:%m,%f:%l:%m

" ヘルプ
set helplang=ja,en
set keywordprg=

" 複数Vimで検索を同期する
if s:is_gui
  function! s:save_reg(reg, filename)
    call writefile([getreg(a:reg)], a:filename)
  endfunction

  function! s:load_reg(reg, filename)
    if filereadable(a:filename)
      call setreg(a:reg, readfile(a:filename), 'v')
    endif
  endfunction

  let s:vimreg_search = expand('~/vimreg_search.txt')
  Autocmd CursorHold,CursorHoldI,FocusLost * silent! call s:save_reg('/', s:vimreg_search)
  Autocmd FocusGained                      * silent! call s:load_reg('/', s:vimreg_search)
endif

if !s:is_vscode
  function! s:grep(word) abort
    call setqflist([])

    cgetexpr system(printf(&grepprg . ' "%s"', a:word))

    execute 'cwindow'
    execute 'cclose'
    execute 'CtrlPQuickfix'
  endfunction

  command! -nargs=1 Grep call <SID>grep(<q-args>)
endif

" --------------------------------------------------------------------------------
" 編集
" --------------------------------------------------------------------------------
set browsedir=buffer              " バッファで開いているファイルのディレクトリ
set clipboard=unnamedplus,unnamed " クリップボードを使う
set modeline
set virtualedit=block
set autoread
set whichwrap=b,s,h,l,<,>,[,]     " カーソルを行頭、行末で止まらないようにする
set mouse=a                       " 全モードでマウスを有効化
set hidden                        " 変更中のファイルでも、保存しないで他のファイルを表示
set timeoutlen=2000
set nrformats-=octal
set nrformats+=alpha
set backspace=indent,eol,start
set noswapfile
set nobackup
set formatoptions+=j
set nofixeol
set tags=tags,./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
set diffopt=internal,filler,algorithm:histogram,indent-heuristic
set splitbelow              " 縦分割したら新しいウィンドウは下に
set splitright              " 横分割したら新しいウィンドウは右に

if exists('+cryptmethod')
  set cryptmethod=blowfish2
endif

if s:is_vscode
  nnoremap <silent> u     :<C-u>call VSCodeNotify('undo')<CR>
  nnoremap <silent> <C-r> :<C-u>call VSCodeNotify('redo')<CR>
endif

" タブ・インデント
set autoindent
set cindent
set tabstop=4       " ファイル内の <Tab> が対応する空白の数
set softtabstop=4   " <Tab> の挿入や <BS> の使用等の編集操作をするときに <Tab> が対応する空白の数
set shiftwidth=4    " インデントの各段階に使われる空白の数
set expandtab       " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う

" ^Mを取り除く
command! RemoveCr call s:execute_keep_view('silent! %substitute/\r$//g | nohlsearch')

" 行末のスペースを取り除く
command! RemoveEolSpace call s:execute_keep_view('silent! %substitute/ \+$//g | nohlsearch')

function! s:execute_keep_view(expr)
  let wininfo = winsaveview()
  execute a:expr
  call winrestview(wininfo)
endfunction

" 現在のファイルパスをクリップボードへコピーする
command! CopyFilepath     call setreg('*', expand('%:t'), 'v')
command! CopyFullFilepath call setreg('*', expand('%:p'), 'v')

nnoremap Y y$

vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" 全角考慮r
xnoremap <expr> r {'v': "\<C-v>r", 'V': "\<C-v>0o$r", "\<C-v>": 'r'}[mode()]

nmap     <silent> <C-CR> V<C-CR>
vnoremap <silent> <C-CR> :<C-u>call <SID>copy_add_comment()<CR>
function! s:copy_add_comment() range
  " 選択中の行をヤンクする
  normal! ""gvy

  " コメントアウトする
  call tcomment#Comment(line("'<"), line("'>"), 'i', '<bang>', '')

  " 元の位置に戻る
  execute 'normal!' (line("'>") - line("'<") + 1) . 'j'

  " ヤンクした物をペーストする
  normal! P
endfunction

" モード移行
inoremap <C-j> <Esc>
nnoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
cnoremap <C-j> <Esc>

" カーソル移動
nnoremap <silent> j     gj
nnoremap <silent> k     gk
nnoremap <silent> gj    j
nnoremap <silent> gk    k
vnoremap <silent> k     gk
vnoremap <silent> j     gj
vnoremap <silent> gj    j
vnoremap <silent> gk    k
nnoremap <silent> 0     g0
nnoremap <silent> g0    0
nnoremap <silent> $     g$
nnoremap <silent> g$    $
nnoremap <silent> gg    ggzv
nnoremap <silent> G     Gzv

noremap <expr> <C-b>    max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
noremap <expr> <C-f>    max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
nmap    <expr> <C-y>    (line('w0') <= 1         ? 'k' : "\<C-y>k")
nmap    <expr> <C-e>    (line('w$') >= line('$') ? 'j' : "\<C-e>j")

nnoremap <silent> <C-i> <C-i>zz
nnoremap <silent> <C-o> <C-o>zz

