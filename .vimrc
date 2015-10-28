set encoding=utf-8
scriptencoding utf-8
" 基本 {{{
let s:is_windows       = has('win32') || has('win64')
let s:is_mac           = has('mac') || has('macunix')
let s:has_vim_starting = has('vim_starting')
let s:has_gui_running  = has('gui_running')
let s:has_kaoriya      = has('kaoriya')
let s:base_columns     = 120
let g:mapleader        = ','

" 自動コマンド
augroup MyAutoCmd
  autocmd!
augroup END
command! -nargs=* Autocmd   autocmd MyAutoCmd <args>
command! -nargs=* AutocmdFT autocmd MyAutoCmd FileType <args>

" スタートアップ時間表示
if s:has_vim_starting
  let s:startuptime = reltime()
  Autocmd VimEnter * let s:startuptime = reltime(s:startuptime)
        \|  echomsg 'startuptime:' reltimestr(s:startuptime)
endif

" SID
function! s:get_sid()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeget_sid$')
endfunction
let s:sid = s:get_sid()
delfunction s:get_sid

" メニューを読み込まない
let g:did_install_default_menus = 1

" キー
nnoremap [App] <Nop>
nmap     ;     [App]

" $MYVIMRC調整
function! s:setup_myvimrc()
  let dropbox_vimrc = expand('~/Dropbox/dotfiles/.vimrc')
  if filereadable(dropbox_vimrc)
    let $MYVIMRC = dropbox_vimrc
  endif
endfunction

nnoremap <silent> <F1> :<C-u>call <SID>setup_myvimrc()<CR>:edit $MYVIMRC<CR>
nnoremap <silent> <F2> :<C-u>call <SID>setup_myvimrc()<CR>:source $MYVIMRC<CR>
nnoremap          <F3> :<C-u>NeoBundleUpdate<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>
nnoremap          <F4> :<C-u>NeoBundleInstall<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>

" 遅延初期化
augroup LazyInitialize
  autocmd!
  autocmd VimEnter,FocusLost,CursorHold,CursorHoldI * call s:lazy_initialize()
augroup END

let s:lazy_initialize = 2*1
function! s:lazy_initialize()
  let s:lazy_initialize -= 1
  if s:lazy_initialize > 0
    return
  endif

  if s:is_mac
    let $LUA_DLL = $VIM . '/../../Frameworks/libluajit-5.1.2.dylib'
  endif

  " 実行ファイル位置を$PATHに最優先で含める
  if s:is_windows
    let $PATH = $VIM . ';' . $PATH
  elseif s:is_mac
    let $PATH = $VIM . '/../../MacOS:' . $PATH
  endif

  if exists('+cryptmethod')
    set cryptmethod=blowfish2
  endif

  set iskeyword=@,48-57,_,128-167,224-235

  if s:is_windows && !executable('MSBuild')
    let $PATH .= ';C:/Windows/Microsoft.NET/Framework/v4.0.30319'
  endif

  " ローカル設定
  let s:vimrc_local = expand('~/.vimrc_local')
  if filereadable(s:vimrc_local)
    execute 'source' s:vimrc_local
  endif

  Autocmd BufWinEnter,ColorScheme .vimrc highlight def link myVimAutocmd vimAutoCmd
  Autocmd BufWinEnter,ColorScheme .vimrc syntax match vimAutoCmd /\<\(Autocmd\|AutocmdFT\)\>/

  augroup LazyInitialize
    autocmd!
  augroup END
endfunction
" }}}
" guioptions {{{
" メニューを読み込まない
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
" }}}
" プラグイン {{{
if s:has_vim_starting
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  let g:neobundle#install_max_processes   = 8
  let g:neobundle#install_process_timeout = 10*60
endif

call neobundle#begin('~/.vim/bundle/')

if neobundle#load_cache()
  NeoBundleFetch 'Shougo/neobundle.vim'

  call neobundle#load_toml('~/.vim/plugins/plugins.toml')
  call neobundle#load_toml('~/.vim/plugins/plugins.lazy.toml', {'lazy': 1})

  if s:is_windows
    call neobundle#load_toml('~/.vim/plugins/plugins.win.toml')
    call neobundle#load_toml('~/.vim/plugins/plugins.lazy.win.toml', {'lazy': 1})
  endif

  NeoBundleSaveCache
endif
" ライブラリ {{{
" vim-shell
let g:shell_mappings_enabled = 0

" vim-submode
if neobundle#tap('vim-submode')
  function! neobundle#hooks.on_source(bundle)
    let g:submode_timeout          = 0
    let g:submode_keep_leaving_key = 1

    call submode#enter_with('git_hunk', 'n', 's', 'ghj', ':<C-u>GitGutterNextHunk<CR>zvzz')
    call submode#enter_with('git_hunk', 'n', 's', 'ghk', ':<C-u>GitGutterPrevHunk<CR>zvzz')
    call submode#map(       'git_hunk', 'n', 's', 'j',   ':<C-u>GitGutterNextHunk<CR>zvzz')
    call submode#map(       'git_hunk', 'n', 's', 'k',   ':<C-u>GitGutterPrevHunk<CR>zvzz')
    call submode#enter_with('winsize',  'n', 's', 'gwh', '8<C-w>>')
    call submode#enter_with('winsize',  'n', 's', 'gwl', '8<C-w><')
    call submode#enter_with('winsize',  'n', 's', 'gwj', '4<C-w>-')
    call submode#enter_with('winsize',  'n', 's', 'gwk', '4<C-w>+')
    call submode#map(       'winsize',  'n', 's', 'h',   '8<C-w>>')
    call submode#map(       'winsize',  'n', 's', 'l',   '8<C-w><')
    call submode#map(       'winsize',  'n', 's', 'j',   '4<C-w>-')
    call submode#map(       'winsize',  'n', 's', 'k',   '4<C-w>+')
  endfunction
endif
" }}}
" 表示 {{{
" foldCC.vim
let g:foldCCtext_enable_autofdc_adjuster = 1
let g:foldCCtext_tail                    =
      \ 'printf("[ %4d lines  Lv%-2d]", v:foldend - v:foldstart + 1, v:foldlevel)'

set foldtext=FoldCCtext()

" vim-indent-guides
if s:has_gui_running
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_exclude_filetypes     = ['help']
  let g:indent_guides_default_mapping       = 0
  let g:indent_guides_auto_colors           = 0

  Autocmd VimEnter,ColorScheme * :highlight IndentGuidesOdd  guibg=#1B1E1E
  Autocmd VimEnter,ColorScheme * :highlight IndentGuidesEven guibg=#1E2121
endif

" syntastic
Autocmd BufWritePost *.{go,rb,py} call s:update_lightline()

" lightline.vim
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
      \       ['branch', 'gitgutter', 'filename', 'anzu', 'submode']
      \     ],
      \     'right': [
      \       ['syntastic', 'lineinfo'],
      \       ['percent']
      \     ]
      \   },
      \   'component': {'percent': '⭡%3p%%'},
      \   'component_function': {
      \     'fileformat':   s:sid . 'lightline_fileformat',
      \     'filetype':     s:sid . 'lightline_filetype',
      \     'fileencoding': s:sid . 'lightline_fileencoding',
      \     'modified':     s:sid . 'lightline_modified',
      \     'readonly':     s:sid . 'lightline_readonly',
      \     'filename':     s:sid . 'lightline_filename',
      \     'mode':         s:sid . 'lightline_mode',
      \     'lineinfo':     s:sid . 'lightline_lineinfo',
      \     'anzu':         'anzu#search_status',
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
      \   'separator': {   'left': '⮀', 'right': '⮂'},
      \   'subseparator': {'left': '⮁', 'right': '⮃'},
      \   'tabline': {
      \     'left':  [['tabs']],
      \     'right': [['filetype', 'fileformat', 'fileencoding']]
      \   },
      \   'tabline_separator': {   'left': '⮀', 'right': '⮂'},
      \   'tabline_subseparator': {'left': '⮁', 'right': '⮃'},
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
      \     '?':      ' '
      \   }
      \ }

function! s:lightline_mode()
  return  &filetype ==# 'unite'    ? 'Unite'    :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'vimshell' ? 'VimShell' :
        \ &filetype ==# 'quickrun' ? 'Quickrun' :
        \ &filetype =~# 'lingr'    ? 'Lingr'    :
        \ &filetype ==# 'agit'     ? 'Agit'     :
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

  return &readonly ? '⭤' : ''
endfunction

function! s:lightline_filename()
  try
    return (empty(s:lightline_readonly()) ? '' : s:lightline_readonly() . ' ') .
          \ (&filetype ==# 'unite'          ? unite#get_status_string()    :
          \  &filetype ==# 'vimfiler'       ? vimfiler#get_status_string() :
          \  &filetype ==# 'vimshell'       ? vimshell#get_status_string() :
          \  &filetype ==# 'lingr-messages' ? lingr#status()               :
          \  &filetype =~# 'lingr'          ? ''                           :
          \  &filetype ==# 'quickrun'       ? ''                           :
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

  if !s:is_in_git_branch()
    return ''
  endif

  if &filetype !=# 'vimfiler'
    try
      let branch = fugitive#head()
      return empty(branch) ? '' : '⭠ ' . branch
    catch
      return ''
    endtry
  endif

  return ''
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

  if !s:is_in_git_branch()
    return ''
  endif

  try
    let summary = gitgutter#hunk#summary()
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
  return &filetype =~# 'vimfiler\|unite\|vimshell\|quickrun\|lingr\|agit'
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

Autocmd CursorHold,CursorHoldI * call s:update_lightline()
function! s:update_lightline()
  try
    call lightline#update()
  catch
  endtry
endfunction
" }}}
" 編集 {{{
" vim-endwise
" http://cohama.hateblo.jp/entry/20121017/1350482411
let g:endwise_no_mappings = 1
AutocmdFT lua,ruby,vim imap <buffer> <CR> <CR><Plug>DiscretionaryEnd

" vim-closetag
let g:closetag_filenames = "*.{html,xhtml,xml,xaml}"

" vim-easy-align
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

" yankround.vim
let g:yankround_use_region_hl = 1

function! s:yankround_pre(count1)
  return (col('.') >= col('$') ? '$' : '') . ":\<C-u>set virtualedit=block\<CR>" . a:count1
endfunction
nmap <silent><expr> p     <SID>yankround_pre(v:count1) . '<Plug>(yankround-p)'
xmap <silent><expr> p     <SID>yankround_pre(v:count1) . '<Plug>(yankround-p)'
nmap <silent><expr> P     <SID>yankround_pre(v:count1) . '<Plug>(yankround-P)'
nmap <silent><expr> gp    <SID>yankround_pre(v:count1) . '<Plug>(yankround-gp)'
xmap <silent><expr> gp    <SID>yankround_pre(v:count1) . '<Plug>(yankround-gp)'
nmap <silent><expr> gP    <SID>yankround_pre(v:count1) . '<Plug>(yankround-gP)'
nmap <silent>       <C-p> <Plug>(yankround-prev)
nmap <silent>       <C-n> <Plug>(yankround-next)

" vim-smartinput
if neobundle#tap('vim-smartinput')
  function! neobundle#hooks.on_source(bundle)
    call smartinput#clear_rules()
    call smartinput#define_default_rules()
  endfunction
endif

" increment-activator
let g:increment_activator_filetype_candidates = {
      \   '_':   [['width', 'height']],
      \   'cs':  [['private', 'protected', 'public', 'internal'],
      \           ['abstract', 'virtual', 'override']],
      \   'cpp': [['private', 'protected', 'public']]
      \ }

" vim-over
let g:over_command_line_key_mappings = {"\<C-j>": "\<Esc>"}

nnoremap <silent> <Leader>s  :OverCommandLine<CR>%s/
vnoremap <silent> <Leader>s  :OverCommandLine<CR>s/
nnoremap <silent> <Leader>rs :<C-u>OverCommandLine<CR>%s///g<Left><Left>
vnoremap <silent> <Leader>rs :OverCommandLine<CR>s///g<Left><Left>

augroup InitializeOver
  autocmd!
  autocmd VimEnter,FocusLost,CursorHold,CursorHoldI * call s:initialize_over()
augroup END

let s:initialize_over_delay = 2*1
function! s:initialize_over()
  let s:initialize_over_delay -= 1
  if s:initialize_over_delay > 0
    return
  endif

  call over#load()

  augroup InitializeOver
    autocmd!
  augroup END
endfunction

" vim-jplus
nmap J         <Plug>(jplus)
vmap J         <Plug>(jplus)
nmap <Leader>J <Plug>(jplus-getchar-with-space)
vmap <Leader>J <Plug>(jplus-getchar-with-space)
" }}}
" 補完 {{{
" neocomplete.vim
if neobundle#tap('neocomplete.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup       = 1
    let g:neocomplete#enable_ignore_case      = 1
    let g:neocomplete#enable_smart_case       = 1
    let g:neocomplete#enable_auto_delimiter   = 1
    let g:neocomplete#enable_fuzzy_completion = 0
    let g:neocomplete#enable_refresh_always   = 1
    let g:neocomplete#enable_prefetch         = 1

    let g:neocomplete#auto_completion_start_length      = 3
    let g:neocomplete#manual_completion_start_length    = 0
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#min_keyword_length                = 3
    let g:neocomplete#force_overwrite_completefunc      = 1
    let g:neocomplete#skip_auto_completion_time         = '0.2'

    let g:neocomplete#sources#dictionary#dictionaries = {
          \   'default':  '',
          \   'vimshell': '~/.vimshell_hist'
          \ }

    let g:neocomplete#sources#vim#complete_functions = {
          \   'Unite':               'unite#complete_source',
          \   'VimShellExecute':     'vimshell#vimshell_execute_complete',
          \   'VimShellInteractive': 'vimshell#vimshell_execute_complete',
          \   'VimShellTerminal':    'vimshell#vimshell_execute_complete',
          \   'VimShell':            'vimshell#complete',
          \   'VimFiler':            'vimfiler#complete'
          \ }

    " 日本語は収集しない
    let g:neocomplete#keyword_patterns = {
          \   '_': '\h\w*'
          \ }

    let g:neocomplete#sources#omni#input_patterns = {
          \   'c':           '\%(\.\|->\)\h\w*',
          \   'disable_cpp': '\h\w*\%(\.\|->\)\h\w*\|\h\w*::',
          \   'cs':          '[a-zA-Z0-9.]\{2\}',
          \   'typescript':  '\h\w*\|[^. \t]\.\w*',
          \   'ruby':        '[^. *\t]\.\w*\|\h\w*::'
          \ }

    let g:neocomplete#force_omni_input_patterns = {
          \   'c':      '[^.[:digit:] *\t]\%(\.\|->\)\w*',
          \   'disable_cpp':    '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*',
          \   'objc':   '[^.[:digit:] *\t]\%(\.\|->\)\w*',
          \   'objcpp': '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*',
          \   'cs':     '[^.[:digit:] *\t]\%(\.\)\w*\|\h\w*::\w*'
          \ }

    let g:neocomplete#delimiter_patterns = {
          \   'c':   ['.', '->'],
          \   'disable_cpp': [' ::', '.'],
          \   'cs':  ['.'],
          \   'vim': ['#', '.']
          \ }

    let g:neocomplete#sources#file_include#exts = {
          \   'c':   ['', 'h'],
          \   'cpp': ['', 'h', 'hpp', 'hxx'],
          \   'cs':  ['', 'Designer.cs']
          \ }

    call neocomplete#custom#source('file', 'rank', 10)
  endfunction

  augroup InitializeNeocomplete
    autocmd!
    autocmd VimEnter,FocusLost,CursorHold,CursorHoldI * call s:initialize_neocomplete()
  augroup END

  let s:initialize_neocomplete_delay = 2*2
  function! s:initialize_neocomplete()
    let s:initialize_neocomplete_delay -= 1
    if s:initialize_neocomplete_delay > 0
      return
    endif

    call neocomplete#initialize()

    augroup InitializeNeocomplete
      autocmd!
    augroup END
  endfunction
endif

" neosnippet.vim
if neobundle#tap('neosnippet.vim')
  imap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)'
        \                                               : '<Tab>'
  smap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)'
        \                                               : '<Tab>'

  function! neobundle#hooks.on_source(bundle)
    let g:neosnippet#disable_runtime_snippets = {'_': 1}
    let g:neosnippet#snippets_directory       = '~/.vim/snippets'

    let snippets_local = expand('~/.vim/snippets.local')
    if isdirectory(snippets_local)
      let g:neosnippet#snippets_directory .= ',' . snippets_local
    endif

    call neocomplete#custom#source('neosnippet', 'rank', 1000)
  endfunction
endif
" }}}
" ファイル {{{
" vim-altr
if neobundle#tap('vim-altr')
  nmap ga <Plug>(altr-forward)
  nmap gA <Plug>(altr-back)

  function! neobundle#hooks.on_source(bundle)
    function! s:altr_define(...)
      for parent in ['', '/*', '/*/*', '/*/*/*']
        call altr#define(map(copy(a:000), 'printf(v:val, "' . parent . '")'))
      endfor
    endfunction

    " MVVM
    AutocmdFT cs,xml call altr#define(  '%Model.cs',
          \                             '%Vm.cs', 
          \                             '%.xaml',  
          \                             '%.xaml.cs')
    AutocmdFT cs,xml call s:altr_define('Models%s/%%Model.cs',
          \                             'ViewModels%s/%%Vm.cs',
          \                             'Views%s/%%.xaml',
          \                             'Views%s/%%.xaml.cs')
    AutocmdFT cs,xml call altr#define(  '%Model.cs',
          \                             '%ViewModel.cs',
          \                             '%.xaml',
          \                             '%.xaml.cs')
    AutocmdFT cs,xml call s:altr_define('Models%s/%%Model.cs',
          \                             'ViewModels%s/%%ViewModel.cs',
          \                             'Views%s/%%.xaml',
          \                             'Views%s/%%.xaml.cs')

    " xaml
    AutocmdFT cs,xml call altr#define(  '%.xaml',
          \                             '%.xaml.cs')
    AutocmdFT cs,xml call altr#define(  '%.cs',
          \                             '%.*.cs')

    " C++
    AutocmdFT cpp call altr#define(     '%.cpp',
          \                             '%.*.cpp',
          \                             '%.h')
    AutocmdFT cpp call s:altr_define(   'src%s/%%.cpp',
          \                             'include%s/%%.h')
  endfunction
endif
" }}}
" auto_mirroring.vim {{{
let g:auto_mirroring_dir =  expand('~/mirror')
" }}}
" 検索 {{{
" matchit.zip
if neobundle#tap('matchit.zip')
  function! neobundle#hooks.on_post_source(bundle)
    silent! execute 'doautocmd Filetype' &filetype
  endfunction
endif

" incsearch.vim
if neobundle#tap('incsearch.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:incsearch#auto_nohlsearch   = 1
    let g:incsearch#emacs_like_keymap = 1
    let g:incsearch#magic             = '\v'
  endfunction
endif

" vim-anzu
" 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
" 検索ヒット数の表示を消去する
Autocmd CursorHold,CursorHoldI * call s:update_display_anzu()
Autocmd WinLeave,TabLeave      * call s:clear_display_anzu()

let s:anzu_display_count = 0
function! s:begin_display_anzu()
  let s:anzu_display_count = 2000 / &updatetime
  call s:refresh_screen()
endfunction

function! s:update_display_anzu()
  if s:anzu_display_count >= 0
    let s:anzu_display_count -= 1
    call s:continue_cursor_hold()
  else
    call s:clear_display_anzu()
  endif
endfunction

function! s:clear_display_anzu()
  try
    call anzu#clear_search_status()
  catch
  endtry
endfunction

" clever-f.vim
if neobundle#tap('clever-f.vim')
  nmap f <Plug>(clever-f-f)
  xmap f <Plug>(clever-f-f)
  omap f <Plug>(clever-f-f)
  nmap F <Plug>(clever-f-F)
  xmap F <Plug>(clever-f-F)
  omap F <Plug>(clever-f-F)

  function! neobundle#hooks.on_source(bundle)
    let g:clever_f_not_overwrites_standard_mappings = 1
    let g:clever_f_ignore_case                      = 1
    let g:clever_f_smart_case                       = 1
    let g:clever_f_across_no_line                   = 1
    let g:clever_f_use_migemo                       = 1
    let g:clever_f_chars_match_any_signs            = ';'
    let g:clever_f_mark_char_color                  = 'Clever_f_mark_char'

    highlight default Clever_f_mark_char ctermfg=Green ctermbg=NONE cterm=underline
          \                              guifg=Green   guibg=NONE   gui=underline
  endfunction
endif
" }}}
" ファイルタイプ {{{
" vim-markdown
let g:markdown_fenced_languages = [
      \   'c',    'cpp', 'cs', 'go',
      \   'ruby', 'lua', 'python',
      \   'vim',
      \   'toml',
      \   'xml',  'json'
      \ ]

" vim-autoft
let g:autoft_config = [
      \   {'filetype': 'cs',  'pattern': '^\s*using'                     },
      \   {'filetype': 'cpp', 'pattern': '^\s*#\s*\%(include\|define\)\>'},
      \   {'filetype': 'xml', 'pattern': '<[0-9a-zA-Z]\+'                }
      \ ]
" }}}
" テキストオブジェクト {{{
xmap aa <Plug>(textobj-parameter-a)
xmap ia <Plug>(textobj-parameter-i)
omap aa <Plug>(textobj-parameter-a)
omap ia <Plug>(textobj-parameter-i)

xmap a. <Plug>(textobj-wiw-a)
xmap i. <Plug>(textobj-wiw-i)
omap a. <Plug>(textobj-wiw-a)
omap i. <Plug>(textobj-wiw-i)
" }}}
" オペレータ {{{
nmap R  <Plug>(operator-replace)
xmap R  <Plug>(operator-replace)

nmap t  <Plug>(operator-tcomment)
xmap t  <Plug>(operator-tcomment)

nmap _  <Plug>(operator-camelize-toggle)
xmap _  <Plug>(operator-camelize-toggle)

map  S  <Plug>(operator-surround-append)
nmap Sd <Plug>(operator-surround-delete)ab
nmap Sr <Plug>(operator-surround-replace)ab

" vim-operator-surround
let g:operator#surround#blocks = {
      \   '-': [
      \     {
      \       'block':      ["{\<CR>", "\<CR>}"],
      \       'motionwise': ['line'            ],
      \       'keys':       ['{', '}'          ]
      \     }
      \   ]
      \ }
" }}}
" アプリ {{{
" lingr-vim
noremap <silent> [App]1 :<C-u>call <SID>toggle_lingr()<CR>

let g:lingr_vim_say_buffer_height = 15

AutocmdFT lingr-rooms,lingr-members,lingr-messages
      \                   nnoremap <silent><buffer> q  :<C-u>call <SID>toggle_lingr()<CR>
AutocmdFT lingr-rooms,lingr-members,lingr-messages
      \                   nmap     <silent><buffer> ss <Plug>(lingr-messages-show-say-buffer)
AutocmdFT lingr-rooms,lingr-members,lingr-messages setlocal nolist
AutocmdFT lingr-rooms,lingr-members                setlocal nonumber

function! s:toggle_lingr()
  if bufnr('lingr-messages') == -1
    tabnew
    LingrLaunch
    wincmd l
  else
    LingrExit
  endif
endfunction

" vimshell.vim
noremap <silent> [App]s :<C-u>VimShellPop<CR>

let g:vimshell_popup_height   = 40
let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
let g:vimshell_prompt_expr    =
      \ 'escape(substitute(fnamemodify(getcwd(), ":~").">", "\\", "/", "g"), "\\[]()?! ")." "'

" vimfiler.vim
if neobundle#tap('vimfiler.vim')
  noremap <silent> [App]f :<C-u>VimFilerBufferDir<CR>

  function! neobundle#hooks.on_source(bundle)
    AutocmdFT vimfiler nmap     <buffer><expr>   <CR>
          \                         vimfiler#smart_cursor_map('<Plug>(vimfiler_cd_file)',
          \                                                   '<Plug>(vimfiler_edit_file)')
    AutocmdFT vimfiler nmap     <buffer><expr>   <C-j>
          \                         vimfiler#smart_cursor_map('<Plug>(vimfiler_exit)',
          \                                                   '<Plug>(vimfiler_exit)')
    AutocmdFT vimfiler nnoremap <silent><buffer> J :<C-u>Unite bookmark<CR>
    AutocmdFT vimfiler nnoremap <silent><buffer> / :<C-u>Unite file -horizontal<CR>

    let g:vimfiler_as_default_explorer        = 1
    let g:vimfiler_force_overwrite_statusline = 0
    let g:vimfiler_ignore_pattern             = []
    let g:vimfiler_tree_leaf_icon             = ' '
    let g:vimfiler_readonly_file_icon         = '⭤'
    let g:unite_kind_file_use_trashbox        = 1

    call vimfiler#custom#profile('default', 'context', {'auto_cd': 1})
  endfunction
endif

" memolist.vim
noremap <silent> [App]mn :<C-u>MemoNew<CR>
noremap <silent> [App]ml :<C-u>MemoList<CR>
noremap <silent> [App]mg :<C-u>MemoGrep<CR>

let g:memolist_unite        = 1
let g:memolist_memo_suffix  = 'md'
let g:memolist_unite_source = 'memolist'
let g:memolist_path         = '~/Dropbox/memo'

" wandbox-vim
if neobundle#tap('wandbox-vim')
  function! neobundle#hooks.on_source(bundle)
    " wandbox.vim で quickfix を開かないようにする
    let g:wandbox#open_quickfix_window = 0
    let g:wandbox#default_compiler     = {'cpp': 'clang-head'}
  endfunction
endif

" vim-quickrun
noremap <silent> [App]r :<C-u>QuickRun<CR>

let g:quickrun_config = {
      \   '_': {
      \     'hook/close_unite_quickfix/enable_hook_loaded': 1,
      \     'hook/unite_quickfix/enable_failure':           1,
      \     'hook/close_quickfix/enable_exit':              1,
      \     'hook/close_buffer/enable_failure':             1,
      \     'hook/close_buffer/enable_empty_data':          1,
      \     'outputter':                                    'multi:buffer:quickfix',
      \     'runner':                                       'vimproc',
      \     'runner/vimproc/updatetime':                    40
      \   },
      \   'cpp/wandbox': {
      \     'runner':                                       'wandbox',
      \     'runner/wandbox/compiler':                      'clang-head',
      \     'runner/wandbox/options':                       'warning,c++1y,boost-1.55'
      \   },
      \   'lua': {
      \     'type':                                         'lua/vim'
      \   }
      \ }

" vim-icondrag
if s:is_windows
  if neobundle#tap('vim-icondrag')
    function! neobundle#hooks.on_source(bundle)
      call icondrag#enable()
    endfunction
  endif
endif

" open-browser.vim
let g:openbrowser_no_default_menus = 1
" }}}
" Unite {{{
" unite.vim
if neobundle#tap('unite.vim')
  nnoremap [Unite] <Nop>
  xnoremap [Unite] <Nop>
  nmap     <Space> [Unite]
  xmap     <Space> [Unite]

  nnoremap <silent> [Unite]cg   :<C-u>Unite -no-split -buffer-name=grep        grep<CR>
  nnoremap <silent> [Unite]gg   :<C-u>Unite -no-split -buffer-name=grep        grep:.<CR>
  nnoremap <silent> [Unite]ccg  :<C-u>Unite -no-split -buffer-name=grep        grep:..<CR>
  nnoremap <silent> [Unite]cccg :<C-u>Unite -no-split -buffer-name=grep        grep:../..<CR>
  nnoremap <silent> [Unite]pg   :<C-u>Unite -no-split -buffer-name=grep        grep:!<CR>
  nnoremap <silent> [Unite]f    :<C-u>Unite           -buffer-name=buffer      buffer<CR>
  nnoremap <silent> [Unite]j    :<C-u>Unite           -buffer-name=bookmark    bookmark<CR>
  nnoremap <silent> [Unite]l    :<C-u>Unite -no-split -buffer-name=line        line<CR>
  nnoremap <silent> [Unite]o    :<C-u>Unite -vertical -buffer-name=outline     outline<CR>
  nnoremap <silent> [Unite]q    :<C-u>Unite -no-quit  -buffer-name=quickfix    quickfix<CR>
  nnoremap <silent> [Unite]m    :<C-u>Unite -no-split -buffer-name=neomru/file neomru/file<CR>
  nnoremap <silent> [Unite]v    :<C-u>call <SID>execute_if_on_git_branch(
        \                     'Unite -no-split -buffer-name=giti            giti')<CR>
  nnoremap <silent> [Unite]b    :<C-u>call <SID>execute_if_on_git_branch(
        \                     'Unite -no-split -buffer-name=giti/branch_all giti/branch_all')<CR>

  nnoremap <silent> [Unite]rr   :<C-u>UniteResume<CR>
  nnoremap <silent> [Unite]rg   :<C-u>UniteResume grep<CR>
  nnoremap <silent> [Unite]rf   :<C-u>UniteResume buffer<CR>
  nnoremap <silent> [Unite]rj   :<C-u>UniteResume bookmark<CR>
  nnoremap <silent> [Unite]rl   :<C-u>UniteResume line<CR>
  nnoremap <silent> [Unite]ro   :<C-u>UniteResume outline<CR>
  nnoremap <silent> [Unite]rq   :<C-u>UniteResume quickfix<CR>
  nnoremap <silent> [Unite]rm   :<C-u>UniteResume neomru/file<CR>
  nnoremap <silent> [Unite]rv   :<C-u>UniteResume giti<CR>
  nnoremap <silent> [Unite]rb   :<C-u>UniteResume giti/branch_all<CR>

  if s:is_windows
    nnoremap <silent> [Unite]e  :<C-u>Unite -no-split -buffer-name=everything everything<CR>
    nnoremap <silent> [Unite]re :<C-u>UniteResume everything<CR>
  endif

  function! neobundle#hooks.on_source(bundle)
    let g:unite_force_overwrite_statusline = 0
    let g:unite_source_alias_aliases       = {'memolist': {'source': 'file'}}
    let g:unite_source_bookmark_directory  = expand('~/.vim/unite/bookmark')

    if executable('jvgrep')
      let g:unite_source_grep_command       = 'jvgrep'
      let g:unite_source_grep_default_opts  =
            \ '-8 -r -i -I ' .
            \ '--exclude ''\.(git|svn|vs|o|a|exe|dll|pdb|nupkg)$|(\bobj\b|\bbin\b)'''
      let g:unite_source_grep_recursive_opt = '-R'
      let g:unite_source_grep_encoding      = 'utf-8'
    endif

    call unite#custom#profile('default', 'context', {
          \   'direction':        'rightbelow',
          \   'hide_icon':        0,
          \   'ignorecase':       1,
          \   'prompt':           '>>',
          \   'prompt_direction': 'top',
          \   'smartcase':        1,
          \   'start_insert':     1,
          \   'vertical':         0,
          \   'winwidth':         60
          \ })

    call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
    call unite#custom_default_action('directory',                 'vimfiler')
    call unite#custom_default_action('neomru/directory',          'vimfiler')

    call unite#custom#source('memolist',   'sorters',        ['sorter_ftime', 'sorter_reverse'])
    call unite#custom#source('everything', 'max_candidates', 500)
    call unite#custom#source('grep',       'max_candidates', 0)

    AutocmdFT unite nnoremap <silent><buffer><expr> <C-r> unite#do_action('replace')
    AutocmdFT unite inoremap <silent><buffer><expr> <C-r> unite#do_action('replace')
    AutocmdFT unite nmap     <silent><buffer>       <C-v> <Plug>(unite_toggle_auto_preview)
    AutocmdFT unite imap     <silent><buffer>       <C-v> <Plug>(unite_toggle_auto_preview)
    AutocmdFT unite nmap     <silent><buffer>       <C-j> <Plug>(unite_exit)
  endfunction
endif

" neomru.vim
if neobundle#tap('neomru.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:neomru#update_interval         = 1
    let g:neomru#file_mru_ignore_pattern = 'fugitiveblame'
    let g:neomru#file_mru_path           = expand('~/.vim/unite/neomru/file')
    let g:neomru#directory_mru_path      = expand('~/.vim/unite/neomru/directory')
  endfunction
endif

" unite-everything
if s:is_windows
  let g:unite_source_everything_full_path_search = 1
endif
" }}}
" C# {{{
" omnisharp-vim
let g:omnicomplete_fetch_full_documentation = 1
let g:Omnisharp_stop_server                 = 0
let g:OmniSharp_typeLookupInPreview         = 0
" }}}
" C++ {{{
" vim-clang-format
if s:is_windows
  let g:clang_format#command = 'C:/Development/LLVM/bin/clang-format.exe'
endif

let g:clang_format#style_options = {
      \   'AccessModifierOffset':                           -4,
      \   'AllowShortIfStatementsOnASingleLine':            'false',
      \   'AlwaysBreakBeforeMultilineStrings':              'false',
      \   'BreakBeforeBraces':                              'Allman',
      \   'BreakConstructorInitializersBeforeComma':        'true',
      \   'ColumnLimit':                                    0,
      \   'ConstructorInitializerAllOnOneLineOrOnePerLine': 'false',
      \   'IndentCaseLabels':                               'true',
      \   'IndentWidth':                                    4,
      \   'UseTab':                                         'Never'
      \ }
" }}}
" Go {{{
" gocode
if s:is_windows
  " todo: macだと補完候補が出てこなくなる
  let g:gocomplete#system_function = 'vimproc#system'
endif

" vim-godef
let g:godef_split                    = 0
let g:godef_same_file_in_same_window = 1
let g:godef_system_function          = 'vimproc#system'
" }}}
" Git {{{
" vim-gitgutter
let g:gitgutter_map_keys           = 0
let g:gitgutter_eager              = 0
let g:gitgutter_diff_args          = ''
let g:gitgutter_sign_column_always = 1

Autocmd FocusGained,FocusLost * GitGutter

" agit.vim
if s:is_windows
  let g:agit_enable_auto_show_commit = 0
endif

" vim-fugitive
Autocmd FocusGained,FocusLost * call s:update_fugitive()

function! s:update_fugitive()
  try
    call fugitive#detect(expand('<amatch>:p'))
    call lightline#update()
  catch
  endtry
endfunction
" }}}
call neobundle#end()
filetype plugin indent on
" }}}
" ファイルタイプごとの設定 {{{
Autocmd BufEnter,WinEnter,BufWinEnter *                         call s:update_all()
Autocmd BufWritePost                  *                         call s:update_numberwidth()
Autocmd BufNewFile,BufRead            *.xaml                    setlocal filetype=xml
Autocmd BufNewFile,BufRead            *.json                    setlocal filetype=json
Autocmd BufNewFile,BufRead            *.{fx,fxc,fxh,hlsl,hlsli} setlocal filetype=hlsl
Autocmd BufNewFile,BufRead            *.{fsh,vsh}               setlocal filetype=glsl
Autocmd BufNewFile,BufRead            *.{md,mkd,markdown}       setlocal filetype=markdown

AutocmdFT ruby       setlocal foldmethod=syntax
AutocmdFT ruby       setlocal tabstop=2
AutocmdFT ruby       setlocal shiftwidth=2
AutocmdFT ruby       setlocal softtabstop=2

AutocmdFT vim        setlocal foldmethod=marker
AutocmdFT vim        setlocal foldlevel=0
AutocmdFT vim        setlocal foldcolumn=5
AutocmdFT vim        setlocal tabstop=2
AutocmdFT vim        setlocal shiftwidth=2
AutocmdFT vim        setlocal softtabstop=2

AutocmdFT xml,html   setlocal foldmethod=syntax
AutocmdFT xml,html   setlocal foldlevel=99
AutocmdFT xml,html   setlocal foldcolumn=5
AutocmdFT xml,html   inoremap <silent> <buffer> >  ><Esc>:call closetag#CloseTagFun()<CR>
AutocmdFT xml,html   let g:xml_syntax_folding = 1

AutocmdFT go         setlocal foldmethod=syntax
AutocmdFT go         setlocal shiftwidth=4
AutocmdFT go         setlocal noexpandtab
AutocmdFT go         setlocal tabstop=4
AutocmdFT go         nnoremap <silent><buffer> K      :<C-u>Godoc<CR>
      \                                               zz
      \                                               :call <SID>refresh_screen()<CR>
AutocmdFT go         nnoremap <silent><buffer> <C-]>  :<C-u>call GodefUnderCursor()<CR>
      \                                               zz
      \                                               :call <SID>refresh_screen()<CR>
AutocmdFT c,cpp      setlocal foldmethod=syntax
AutocmdFT c,cpp      nnoremap <silent><buffer> [App]r :<C-u>QuickRun cpp/wandbox<CR>
AutocmdFT c,cpp      nnoremap <silent><buffer> <C-]>  :<C-u>UniteWithCursorWord
      \                                                     -immediately -buffer-name=tag tag<CR>

AutocmdFT cs         setlocal foldmethod=syntax
AutocmdFT cs         setlocal omnifunc=OmniSharp#Complete
AutocmdFT cs         nnoremap <silent><buffer> <C-]>  :<C-u>call OmniSharp#GotoDefinition()<CR>
      \                                               zz
      \                                               :call <SID>refresh_screen()<CR>

AutocmdFT typescript setlocal omnifunc=TSScompleteFunc

AutocmdFT json       setlocal shiftwidth=2
AutocmdFT neosnippet setlocal noexpandtab
AutocmdFT godoc      nnoremap <silent><buffer> q      :<C-u>close<CR>
AutocmdFT help       nnoremap <silent><buffer> q      :<C-u>close<CR>
AutocmdFT markdown   nnoremap <silent><buffer> [App]v :<C-u>PrevimOpen<CR>

function! s:update_all()
  setlocal formatoptions-=r
  setlocal formatoptions-=o
  setlocal textwidth=0

  call s:update_numberwidth()

  " ファイルの場所をカレントにする
  if &filetype !=# 'vimfiler'
    silent! execute 'lcd' fnameescape(expand('%:p:h'))
  endif
endfunction

function! s:update_numberwidth()
  " 行番号表示幅を設定する
  " http://d.hatena.ne.jp/osyo-manga/20140303/1393854617
  let w = len(line('$')) + 2
  if w < 5
    let w = 5
  endif

  let &l:numberwidth = w
endfunction

" 場所ごとに設定を用意する {{{
" http://vim-jp.org/vim-users-jp/2009/12/27/Hack-112.html
Autocmd BufNewFile,BufReadPost * let s:files =
      \   findfile('.vimrc.local', escape(expand('<afile>:p:h'), ' ') . ';', -1)
      \|  for s:i in reverse(filter(s:files, 'filereadable(v:val)'))
      \|    source `=s:i`
      \|  endfor
" }}}
" }}}
" キー無効 {{{
" Vimを閉じない
nnoremap ZQ <Nop>

" Exモード
nnoremap Q  <Nop>

" ミス操作で削除してしまうため
nnoremap dh <Nop>
nnoremap dj <Nop>
nnoremap dk <Nop>
nnoremap dl <Nop>

" よくミスるため
vnoremap u     <Nop>
onoremap u     <Nop>
inoremap <C-k> <Nop>
" }}}
" 編集 {{{
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
set completeopt=longest,menuone
set backspace=indent,eol,start
set noswapfile
set nobackup
set formatoptions+=j
set nofixeol

set tags=tags,./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags

" 文字コード自動判断
if has('guess_encode')
  set fileencodings=guess,iso-2022-jp,cp932,euc-jp,ucs-bom
else
  set fileencodings=iso-2022-jp,cp932,euc-jp,ucs-bom
endif

" ^Mを取り除く
command! RemoveCr call s:execute_keep_view('silent! %substitute/\r$//g | nohlsearch')

" 行末のスペースを取り除く
command! RemoveEolSpace call s:execute_keep_view('silent! %substitute/ \+$//g | nohlsearch')

" 整形
command! Format call s:execute_keep_view('call s:format()')
function! s:format()
  if &filetype ==# 'cs'
    OmniSharpCodeFormat
    " let csStylerCuiExe = 'mono ~/CsStyler/CsStyler.exe'
    " call s:filter_current_by_tempfile(csStylerCuiExe . ' --input=%s --output=%s', 0, 1)
  elseif &filetype ==# 'c'
    ClangFormat
  elseif &filetype ==# 'cpp'
    ClangFormat
  elseif &filetype ==# 'go'
    call s:filter_current_by_stdout('goimports %s', 0, 0)
  elseif &filetype ==# 'json' && executable('jq')
    call s:filter_current_by_stdout('jq . %s', 0, 0)
  elseif &filetype ==# 'javascript' && executable('js-beautify')
    call s:filter_current_by_stdout('js-beautify %s', 0, 0)
  elseif &filetype ==# 'xml'
    if expand('%:e') == 'xaml'
      let xamlStylerCuiExe =
            \ s:is_windows ? 'XamlStylerCui.exe' : 'mono ~/XamlStylerCui.exe'
      call s:filter_current_by_tempfile(xamlStylerCuiExe . ' --input=%s --output=%s', 0, 1)
    else
      if executable('xmllint')
        let $XMLLINT_INDENT = '    '
        if !s:filter_current_by_stdout('xmllint --format --encode ' . &encoding . ' %s', 1, 0)
          execute 'silent! %substitute/>\s*</>\r</g | normal! gg=G'
        endif
      endif
    endif
  else
    echomsg 'Format: Not supported:' &filetype
  endif
endfunction

" 現在のファイルパスをクリップボードへコピーする
command! CopyCurrentFilepath call setreg('*', expand('%:p'), 'v')

nnoremap Y y$

vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

nmap     <silent> <C-CR> V<C-CR>
vnoremap <silent> <C-CR> :<C-u>call <SID>copy_add_comment()<CR>

" http://qiita.com/akira-hamada/items/2417d0bcb563475deddb をもとに調整
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
" }}}
" インプットメソッド {{{
" macvim kaoriya gvim で submode が正しく動作しなくなるため
if !(s:is_mac && s:has_gui_running)
  set noimdisable
endif

set imsearch=0
set iminsert=0
if exists('+imdisableactivate')
  set imdisableactivate
endif
" }}}
" タブ・インデント {{{
set autoindent
set cindent
set tabstop=4       " ファイル内の <Tab> が対応する空白の数
set softtabstop=4   " <Tab> の挿入や <BS> の使用等の編集操作をするときに <Tab> が対応する空白の数
set shiftwidth=4    " インデントの各段階に使われる空白の数
set expandtab       " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う
set list
set listchars=tab:\⭟\ ,eol:↲,extends:»,precedes:«,nbsp:%
set breakindent

vnoremap < <gv
vnoremap > >gv
" }}}
" 検索 {{{
set incsearch
set ignorecase
set smartcase
set hlsearch

if executable('jvgrep')
  set grepprg=jvgrep
endif

" 日本語インクリメンタルサーチ
if s:has_kaoriya
  set migemo
  set migemodict=$VIMRUNTIME/dict/migemo-dict
endif

" http://haya14busa.com/enrich-your-search-experience-with-incsearch-vim/
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)

map  <silent> n  <Plug>(incsearch-nohl-n)
map  <silent> N  <Plug>(incsearch-nohl-N)
nmap <silent> n  <Plug>(incsearch-nohl)
      \          <Plug>(anzu-n)
      \          zvzz
      \          :call <SID>begin_display_anzu()<CR>
nmap <silent> N  <Plug>(incsearch-nohl)
      \          <Plug>(anzu-N)
      \          zvzz
      \          :call <SID>begin_display_anzu()<CR>

map  <silent> *  <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
map  <silent> g* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
map  <silent> #  <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
map  <silent> g# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)

" 複数Vimで検索を同期する {{{
if s:has_gui_running
  function! s:save_reg(reg, filename)
    call writefile([getreg(a:reg)], a:filename)
  endfunction

  function! s:load_reg(reg, filename)
    if filereadable(a:filename)
      call setreg(a:reg, readfile(a:filename), 'v')
    endif
  endfunction

  let vimreg_search = expand('~/vimreg_search.txt')

  Autocmd CursorHold,CursorHoldI,FocusLost * call s:save_reg('/', vimreg_search)
  Autocmd FocusGained                      * call s:load_reg('/', vimreg_search)
endif
" }}}
" }}}
" 表示 {{{
syntax enable               " 構文ごとに色分けをする
set number
set textwidth=0             " 一行に長い文章を書いていても自動折り返しをしない
set showcmd                 " コマンドをステータス行に表示
set noshowmatch             " 括弧の対応をハイライト
set wrap
set noshowmode
set shortmess+=I            " 起動時のメッセージを表示しない
set lazyredraw
set wildmenu
set wildmode=list:full
set showfulltag
set wildoptions=tagfile
set fillchars=vert:\        " 縦分割の境界線
set synmaxcol=500           " ハイライトする文字数を制限する
set updatetime=250
set previewheight=24
set cmdheight=4
set laststatus=2
set showtabline=2
set diffopt=vertical,filler
set noequalalways
set cursorline
set display=lastline
set conceallevel=2
set concealcursor=i
set colorcolumn=100

if s:has_gui_running
  set lines=100
  let &columns = s:base_columns
endif

Autocmd VimEnter * set t_vb=
Autocmd VimEnter * set visualbell
Autocmd VimEnter * set errorbells

nnoremap <silent> gf :<C-u>call <SID>smart_gf('n')<CR>
vnoremap <silent> gf :<C-u>call <SID>smart_gf('v')<CR>

function! s:smart_gf(mode)
  try
    let line       = getline('.')
    let repos_name = matchstr(line, 'repository\s\+=\s\+''\zs.\{-}\ze''')

    if !empty(repos_name)
      " NeoBundle
      execute 'OpenBrowser https://github.com/' . repos_name
    elseif !empty(openbrowser#get_url_on_cursor())
      " URL
      call openbrowser#_keymapping_smart_search(a:mode)
    else
      " 標準のgf
      normal! gf
    endif
  catch
    " 検索
    call openbrowser#_keymapping_search(a:mode)
  endtry
endfunction
" カーソル下の単語を移動するたびにハイライトする {{{
" http://d.hatena.ne.jp/osyo-manga/20140121/1390309901
Autocmd CursorHold                                * call s:hl_cword()
Autocmd CursorMoved,BufLeave,WinLeave,InsertEnter * call s:hl_clear()
Autocmd ColorScheme                               * highlight CursorWord guifg=Red

function! s:hl_clear()
  if exists('b:highlight_cursor_word_id') && exists('b:highlight_cursor_word')
    silent! call matchdelete(b:highlight_cursor_word_id)
    unlet b:highlight_cursor_word_id
    unlet b:highlight_cursor_word
  endif
endfunction

function! s:hl_cword()
  let word = expand('<cword>')
  if empty(word)
    return
  endif
  if get(b:, 'highlight_cursor_word', '') ==# word
    return
  endif

  call s:hl_clear()

  if !empty(filter(split(word, '\zs'), 'strlen(v:val) > 1'))
    return
  endif

  let pattern = printf('\<%s\>', expand('<cword>'))
  silent! let b:highlight_cursor_word_id = matchadd('CursorWord', pattern)
  let b:highlight_cursor_word = word
endfunction
" }}}
" カラースキーマ {{{
colorscheme molokai

Autocmd BufWinEnter,ColorScheme * call s:set_color()

function! s:set_color()
  " ^M を非表示
  syntax match HideCtrlM containedin=ALL /\r$/ conceal

  " 日本語入力時カーソル色を変更する
  highlight CursorIM guifg=NONE guibg=Red

  if !&readonly
    " 全角スペースとタブ文字の可視化
    syntax match InvisibleJISX0208Space '　' display containedin=ALL
    syntax match InvisibleTab           '\t' display containedin=ALL
    highlight InvisibleJISX0208Space guibg=#112233
    highlight InvisibleTab           guibg=#121212
  endif
endfunction
" }}}
" 半透明化 {{{
if s:has_gui_running
  if s:is_mac
    Autocmd GuiEnter,FocusGained * set transparency=3   " アクティブ時の透過率
    Autocmd FocusLost            * set transparency=48  " 非アクティブ時の透過率
  endif
endif
" }}}
" フォント {{{
if s:has_gui_running
  set guifont=Ricty\ Regular\ for\ Powerline:h12
endif

if s:is_windows && s:has_kaoriya
  set ambiwidth=auto
else
  set ambiwidth=double
endif
" }}}
" 'cursorline' を必要な時にだけ有効にする {{{
" http://d.hatena.ne.jp/thinca/20090530/1243615055
Autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
Autocmd CursorHold,CursorHoldI   * call s:auto_cursorline('CursorHold')
Autocmd WinEnter                 * call s:auto_cursorline('WinEnter')
Autocmd WinLeave                 * call s:auto_cursorline('WinLeave')

let s:cursorline_lock = 0
function! s:auto_cursorline(event)
  if s:is_unite_running()
    return
  endif

  if a:event ==# 'WinEnter'
    setlocal cursorline
    let s:cursorline_lock = 2

  elseif a:event ==# 'WinLeave'
    setlocal nocursorline

  elseif a:event ==# 'CursorMoved'
    if s:cursorline_lock
      if 1 < s:cursorline_lock
        let s:cursorline_lock = 1
      else
        setlocal nocursorline
        let s:cursorline_lock = 0
      endif
    endif

  elseif a:event ==# 'CursorHold'
    setlocal cursorline
    let s:cursorline_lock = 1
  endif
endfunction

function! s:force_show_cursorline()
  if s:is_unite_running()
    return
  endif

  setlocal cursorline
  let s:cursorline_lock = 1
endfunction
" }}}
" }}}
" 折り畳み {{{
set foldcolumn=0
set foldlevel=99

nnoremap <silent> zo zR
nnoremap <silent> zc zM

nnoremap <expr> zh foldlevel(line('.'))  >  0  ? 'zc' : '<C-h>'
nnoremap <expr> zl foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'

" 折り畳み外であれば何もしない
nnoremap <expr> zO foldclosed(line('.')) != -1 ? 'zO' : ''
" }}}
" モード移行 {{{
if !(s:is_mac && s:has_gui_running)
  inoremap <C-j> <Esc>
  nnoremap <C-j> <Esc>
  vnoremap <C-j> <Esc>
  cnoremap <C-j> <Esc>
else
  inoremap <silent> <C-j> <Esc>:<C-u>set noimdisable<CR>:set imdisable<CR>
  nnoremap <silent> <C-j> <Esc>:<C-u>set noimdisable<CR>:set imdisable<CR>
  vnoremap <silent> <C-j> <Esc>:<C-u>set noimdisable<CR>:set imdisable<CR>
  cnoremap <silent> <C-j> <Esc>:<C-u>set noimdisable<CR>:set imdisable<CR>
endif
" }}}
" コマンドラインモード {{{
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
" }}}
" カーソル移動 {{{
nnoremap <silent> k     :<C-u>call <SID>up_cursor(v:count1)<CR>
nnoremap <silent> j     :<C-u>call <SID>down_cursor(v:count1)<CR>
nnoremap <silent> h     :<C-u>call <SID>left_cursor(v:count1)<CR>
nnoremap <silent> l     :<C-u>call <SID>right_cursor(v:count1)<CR>

vnoremap <silent> k     gk
vnoremap <silent> j     gj
nnoremap <silent> 0     g0
nnoremap <silent> g0    0
nnoremap <silent> $     :<C-u>set virtualedit=block<CR>g$:set virtualedit=all<CR>
nnoremap <silent> g$    :<C-u>set virtualedit=block<CR>$:set virtualedit=all<CR>
nnoremap <silent> <C-e> <C-e>j
nnoremap <silent> <C-y> <C-y>k
vnoremap <silent> <C-e> <C-e>j
vnoremap <silent> <C-y> <C-y>k
nnoremap <silent> gg    ggzvzz:<C-u>call <SID>refresh_screen()<CR>
nnoremap <silent> G     Gzvzz:<C-u>call  <SID>refresh_screen()<CR>

nnoremap <silent> <C-i> <C-i>zz:<C-u>call <SID>refresh_screen()<CR>
nnoremap <silent> <C-o> <C-o>zz:<C-u>call <SID>refresh_screen()<CR>
nnoremap <silent> <C-h> ^:<C-u>set virtualedit=all<CR>
nnoremap <silent> <C-l> $:<C-u>set virtualedit=all<CR>
vnoremap <silent> <C-h> ^
vnoremap <silent> <C-l> $

nmap     <silent> <C-@> <Plug>(operator-jump-toggle)ai
xmap     <silent> <C-@> <Plug>(operator-jump-toggle)ai

nnoremap <silent> <Leader>m `

function! s:up_cursor(repeat)
  call s:enable_virtual_cursor()
  execute 'normal!' a:repeat . 'gk'
endfunction

function! s:down_cursor(repeat)
  call s:enable_virtual_cursor()
  execute 'normal!' a:repeat . 'gj'
endfunction

function! s:left_cursor(repeat)
  call s:disable_virtual_cursor()
  execute 'normal!' a:repeat . 'h'
endfunction

function! s:right_cursor(repeat)
  call s:disable_virtual_cursor()
  execute 'normal!' a:repeat . 'l'

  if foldclosed(line('.')) != -1
    normal! zv
  endif
endfunction

function! s:enable_virtual_cursor()
  set virtualedit=all
endfunction

function! s:disable_virtual_cursor()
  set virtualedit=block
endfunction

Autocmd InsertEnter * call s:disable_virtual_cursor()
" }}}
" ウィンドウ操作 {{{
set splitbelow    " 縦分割したら新しいウィンドウは下に
set splitright    " 横分割したら新しいウィンドウは右に

nnoremap <silent> <Leader>c :<C-u>close<CR>
" }}}
" アプリウィンドウ操作 {{{
nnoremap [Window]  <Nop>
nmap     <Leader>w [Window]

if s:has_gui_running
  noremap <silent> [Window]e :<C-u>call <SID>toggle_v_split_wide()<CR>
  noremap <silent> [Window]f :<C-u>call <SID>full_window()<CR>
  noremap <silent> [Window]H :<C-u>ResizeWin<CR>
  noremap <silent> [Window]J :<C-u>ResizeWin<CR>
  noremap <silent> [Window]K :<C-u>ResizeWin<CR>
  noremap <silent> [Window]L :<C-u>ResizeWin<CR>
  noremap <silent> [Window]h :<C-u>MoveWin<CR>
  noremap <silent> [Window]j :<C-u>MoveWin<CR>
  noremap <silent> [Window]k :<C-u>MoveWin<CR>
  noremap <silent> [Window]l :<C-u>MoveWin<CR>

  " アプリケーションウィンドウを最大高さにする {{{
  function! s:full_window()
    execute 'winpos' getwinposx() '0'
    set lines=9999
  endfunction
  " }}}
  " 縦分割する {{{
  let s:depth_vsp      = 1
  let s:opend_left_vsp = 0
  let s:opend_top_vsp  = 0

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

    let s:depth_vsp += 1
    let &columns = s:base_columns * s:depth_vsp
    execute 'botright vertical' s:base_columns 'split'
  endf

  function! s:close_v_split_wide()
    let s:depth_vsp -= 1
    let &columns = s:base_columns * s:depth_vsp
    only

    if s:depth_vsp == 1
      execute 'winpos' s:opend_left_vsp s:opend_top_vsp
    end
  endf
  " }}}
endif
" }}}
" タブ操作 {{{
nnoremap [Tab]     <Nop>
nmap     <Leader>t [Tab]

nnoremap <silent> [Tab]c :<C-u>tabnew<CR>
nnoremap <silent> [Tab]x :<C-u>tabclose<CR>
" }}}
" バッファ操作 {{{
" ウィンドウをとじないで現在のバッファを削除 {{{
function! s:delete_current_buffer()
  let confirm_msg             = '未保存です。閉じますか？'
  let current_win             = winnr()
  let current_buf             = winbufnr(current_win)
  let is_current_buf_modified = getbufvar(current_buf, '&modified')
  let buf_list                = filter(range(1, bufnr('$')), 'buflisted(v:val)')

  if len(buf_list) == 1
    if !is_current_buf_modified
      bdelete

    elseif confirm(confirm_msg, "&Yes\n&No", 1, 'Question') == 1
      bdelete!
    endif

    return
  endif

  if is_current_buf_modified
    if confirm(confirm_msg, "&Yes\n&No", 1, 'Question') != 1
      return
    endif
  endif

  let next_buf_index = match(buf_list, current_buf) + 1

  if next_buf_index == len(buf_list)
    let next_buf_index = 0
  endif

  let next_buf = buf_list[next_buf_index]

  while 1
    let winnr = bufwinnr(current_buf)
    if winnr == -1
      break
    endif

    execute winnr . 'wincmd w'
    execute 'buffer' next_buf
  endwhile

  execute 'bdelete' current_buf
  execute current_win . 'wincmd w'
endfunction
" }}}
" }}}
" Git {{{
nnoremap [Git]     <Nop>
nmap     <Leader>g [Git]

nnoremap <silent> [Git]b  :<C-u>call <SID>execute_if_on_git_branch('Gblame w')<CR>
nnoremap <silent> [Git]a  :<C-u>call <SID>execute_if_on_git_branch('Gwrite')<CR>:GitGutter<CR>
nnoremap <silent> [Git]c  :<C-u>call <SID>execute_if_on_git_branch('Gcommit')<CR>:GitGutter<CR>
nnoremap <silent> [Git]f  :<C-u>call <SID>execute_if_on_git_branch('GitiFetch')<CR>:GitGutter<CR>
nnoremap <silent> [Git]d  :<C-u>call <SID>execute_if_on_git_branch('Gdiff')<CR>
nnoremap <silent> [Git]s  :<C-u>call <SID>execute_if_on_git_branch('Gstatus')<CR>
nnoremap <silent> [Git]ps :<C-u>call <SID>execute_if_on_git_branch('Gpush')<CR>:GitGutter<CR>
nnoremap <silent> [Git]pl :<C-u>call <SID>execute_if_on_git_branch('Gpull')<CR>:GitGutter<CR>
nnoremap <silent> [Git]g  :<C-u>call <SID>execute_if_on_git_branch('Agit')<CR>
nnoremap <silent> [Git]h  :<C-u>call <SID>execute_if_on_git_branch('GitGutterPreviewHunk')<CR>
" }}}
" ヘルプ {{{
set helplang=ja,en
set keywordprg=

if s:has_kaoriya
  set runtimepath+=$VIM/plugins/vimdoc-ja
endif
" }}}
" 汎用関数 {{{
" CursorHold を継続させる{{{
function! s:continue_cursor_hold()
  " http://d.hatena.ne.jp/osyo-manga/20121102/1351836801
  call feedkeys(mode() ==# 'i' ? "\<C-g>\<Esc>" : "g\<Esc>", 'n')
endfunction
" }}}
" 画面リフレッシュ{{{
function! s:refresh_screen()
  call s:force_show_cursorline()
endfunction
" }}}
" コマンド実行後の表示状態を維持する {{{
function! s:execute_keep_view(expr)
  let wininfo = winsaveview()
  execute a:expr
  call winrestview(wininfo)
endfunction
" }}}
" Unite 実行中か {{{
function! s:is_unite_running()
  return &filetype ==# 'unite'
endfunction
" }}}
" Gitブランチ上にいるか {{{
function! s:is_in_git_branch()
  try
    return !empty(fugitive#head())
  catch
    return 0
  endtry
endfunction
" }}}
" Gitブランチ上であれば実行 {{{
function! s:execute_if_on_git_branch(line)
  if !s:is_in_git_branch()
    echomsg 'not on git branch:' a:line
    return
  endif

  execute a:line
endfunction
" }}}
" 標準出力経由でフィルタリング処理を行う {{{
function! s:filter_current_by_stdout(cmd, is_silent, is_auto_encoding)
  let retval = 255

  try
    let current_tempfile = tempname()
    call writefile(getline(1, '$'), current_tempfile)

    let normalized_current_tempfile = substitute(current_tempfile, '\', '/', 'g')

    if a:is_auto_encoding
      let formatted = vimproc#system2(printf(a:cmd, normalized_current_tempfile))
    else
      let formatted = vimproc#system(printf(a:cmd, normalized_current_tempfile))
    endif

    let retval = vimproc#get_last_status()

    if retval == 0
      call setreg('g', formatted, 'v')
      silent keepjumps normal! ggVG"gp
    else
      if !a:is_silent
        echo formatted
      endif
    endif
  finally
    call delete(current_tempfile)
  endtry

  return retval == 0
endfunction
" }}}
" テンポラリファイル経由でフィルタリング処理を行う {{{
function! s:filter_current_by_tempfile(cmd, is_silent, is_auto_encoding)
  let retval = 255

  try
    let current_tempfile = tempname()
    call writefile(getline(1, '$'), current_tempfile)

    let output_tempfile = tempname()

    let normalized_current_tempfile = substitute(current_tempfile, '\', '/', 'g')
    let normalized_output_tempfile  = substitute(output_tempfile,  '\', '/', 'g')

    if a:is_auto_encoding
      let out = vimproc#system2(printf(a:cmd, normalized_current_tempfile, normalized_output_tempfile))
    else
      let out = vimproc#system(printf(a:cmd, normalized_current_tempfile, normalized_output_tempfile))
    endif

    let retval = vimproc#get_last_status()

    if retval == 0
      call setreg('g', readfile(output_tempfile), 'v')
      silent keepjumps normal! ggVG"gp
    else
      if !a:is_silent
        echo out
      endif
    endif
  finally
    call delete(current_tempfile)
    call delete(output_tempfile)
  endtry

  return retval == 0
endfunction
" }}}
" }}}
" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab
