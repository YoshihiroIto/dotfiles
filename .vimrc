if has('vim_starting')
  let s:startuptime = reltime()
  augroup startuptime
    autocmd!
    autocmd startuptime VimEnter * echomsg 'startuptime:' reltimestr(reltime(s:startuptime))
  augroup END
endif

" --------------------------------------------------------------------------------
" 基本
" --------------------------------------------------------------------------------
let s:sid          = expand('<SID>')
let s:home_dir     = expand('~/')
let s:dotvim_dir   = s:home_dir . '.vim/'
let s:plugin_dir   = s:home_dir . '.vim_plugged/'
let s:dropbox_dir  = s:home_dir . 'Dropbox/'
let s:is_installed = isdirectory(s:home_dir . '.vim_plugged/')
let s:is_vscode    = exists('g:vscode')
let s:is_gui       = has('gui_running')
let s:base_columns = 140

let g:no_gvimrc_example         = 1
let g:no_vimrc_example          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_gzip               = 1
let g:loaded_matchparen         = 1
let g:loaded_logiPat            = 1
let g:loaded_netrw              = 1
let g:loaded_netrwFileHandlers  = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_netrwSettings      = 1
let g:loaded_rrhelper           = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tohtml             = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:loaded_spellfile_plugin   = 1
let g:skip_loading_mswin        = 1
let g:did_install_syntax_menu   = 1
let g:did_install_default_menus = 1
let g:did_menu_trans            = 1

let g:mapleader          = "\<Space>"
let g:vimsyn_folding     = 'af'
let g:xml_syntax_folding = 1
let g:python3_host_prog  = s:home_dir . 'AppData/Local/Programs/Python/Python310/python.exe'

" ローカル設定
" let s:vimrc_local = s:home_dir . '.vimrc.local'
" if filereadable(s:vimrc_local)
"   execute 'source' s:vimrc_local
" endif

augroup MyAutoCmd
  autocmd!
augroup END

command! -nargs=* Autocmd     autocmd MyAutoCmd          <args>
command! -nargs=* AutocmdFT   autocmd MyAutoCmd FileType <args>
command! -nargs=* AutocmdUser autocmd MyAutoCmd User     <args>

" --------------------------------------------------------------------------------
" プラグイン
" --------------------------------------------------------------------------------
call plug#begin(s:home_dir . '.vim_plugged/') "{

function! s:execute_if_installed(func_name)
  if s:is_installed
    call function(a:func_name)()
  endif
endfunction

if !s:is_vscode
  Plug 'YoshihiroIto/night-owl.vim'
  Plug 'YoshihiroIto/vim-icondrag', {'on': []}
  " vim-icondrag {{{
  AutocmdUser vim-icondrag call s:execute_if_installed('icondrag#enable')
  " }}}

  Plug 'itchyny/vim-gitbranch', {'on': []}
  Plug 'airblade/vim-gitgutter', {'on': []}
  " vim-gitgutter {{{
  AutocmdUser vim-gitgutter call s:execute_if_installed('s:init_gitgutter')

  let g:gitgutter_map_keys = 0
  let g:gitgutter_grep     = ''

  function! s:init_gitgutter()
    call gitgutter#enable()
    Autocmd WinEnter * GitGutter
  endfunction
  " }}}

  Plug 'lambdalisue/vim-rplugin', {'on': []}
  Plug 'YoshihiroIto/lista.nvim', {'on': []}
  nnoremap <silent> <leader>l   :<C-u>Lista<CR>
  " lista {{{
  let g:lista#custom_mappings = [
        \  ['<C-j>', '<Esc>'],
        \  ['<C-p>', '<S-Tab>'],
        \  ['<C-n>', '<Tab>'],
        \ ]
  " }}}

  Plug 'iamcco/markdown-preview.nvim', {'on': [], 'do': 'cd app & yarn install'}
  " markdown-preview.nvim {{{
  nnoremap <silent> <leader>p :<C-u>MarkdownPreview<CR>
  " }}}

  Plug 'cocopon/vaffle.vim', {'on': []}
  " vaffle.vim {{{
  let g:vaffle_show_hidden_files = 1

  AutocmdFT vaffle nmap <silent><buffer> <Esc> <Plug>(vaffle-quit)
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
  " Plug 'posva/vim-vue', {'for': 'vue'}

  Plug 'glidenote/memolist.vim', {'on': []}
  " memolist.vim {{{
  noremap <silent> <leader>n :<C-u>MemoNew<CR>
  noremap <silent> <leader>k :execute 'CtrlP' g:memolist_path<CR>
  let g:memolist_memo_suffix = 'md'
  let g:memolist_path        = s:dropbox_dir . 'memo/'
  " }}}

  Plug 'mattn/vim-lsp-settings', {'on': []}
  " vim-lsp-settings {{{
  let g:lsp_settings_servers_dir = s:home_dir . 'lsp_server'
  " }}}

  Plug 'prabirshrestha/vim-lsp', {'on': []}
  " vim-lsp {{{
  AutocmdUser vim-lsp call s:execute_if_installed('s:init_lsp')

  let g:lsp_auto_enable = 0

  function! s:init_lsp()
    let g:lsp_diagnostics_enabled        = 1
    let g:lsp_diagnostics_echo_cursor    = 1
    let g:lsp_document_highlight_enabled = 0
    nnoremap <silent> <C-]> :<C-u>LspDefinition<CR>zz
    nnoremap <silent> ;e    :<C-u>LspRename<CR>

    call lsp#enable()
  endfunction
  " }}}

  Plug 'mattn/ctrlp-matchfuzzy', {'on': []}
  Plug 'ctrlpvim/ctrlp.vim', {'on': []}
  " ctrlp {{{
  nnoremap <silent> <leader>m   :<C-u>CtrlPMRUFiles<CR>

  let g:ctrlp_match_window    = 'bottom,order:ttb,min:48,max:48'
  let g:ctrlp_map             = ''
  let g:ctrlp_match_func      = {'match': 'ctrlp_matchfuzzy#matcher'}
  let g:ctrlp_user_command    = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching     = 0
  let g:ctrlp_prompt_mappings = {
        \   'PrtBS()':            ['<BS>', '<C-h>'],
        \   'PrtSelectMove("j")': ['<C-n>'],
        \   'PrtSelectMove("k")': ['<C-p>'],
        \   'PrtHistory(-1)':     ['<Down>'],
        \   'PrtHistory(1)':      ['<Up>'],
        \   'PrtCurLeft()':       ['<Left>'],
        \   'PrtCurRight()':      ['<Right>'],
        \   'PrtExit()':          ['<Esc>', '<C-j>'],
        \ }
  let g:ctrlp_status_func     = {
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
  let g:lightline = {
        \   'colorscheme': 'nightowl',
        \   'active': {
        \     'left': [
        \       ['mode'],
        \       ['branch', 'gitgutter', 'filename']
        \     ],
        \     'right': [
        \       ['lineinfo'],
        \       ['seachcount', 'percent']
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
        \     'seachcount':   s:sid . 'lightline_searchcount'
        \   },
        \   'component_expand': {
        \     'branch':    s:sid . 'lightline_current_branch',
        \     'gitgutter': s:sid . 'lightline_git_summary'
        \   },
        \   'component_type': {
        \     'branch':    'branch',
        \     'gitgutter': 'branch'
        \   },
        \   'separator':    {'left': '', 'right': ''},
        \   'subseparator': {'left': '', 'right': ''},
        \   'tabline': {
        \     'left':  [['tabs']],
        \     'right': [['filetype', 'fileformat', 'fileencoding']]
        \   },
        \   'tabline_separator':    {'left': '', 'right': ''},
        \   'tabline_subseparator': {'left': '', 'right': ''},
        \   'tab_component_function': {
        \     'modified': s:sid . 'lightline_tab_component',
        \     'readonly': s:sid . 'lightline_tab_component',
        \     'tabnum':   s:sid . 'lightline_tab_component',
        \   },
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
    if s:is_lightline_no_disp_group()
      return ''
    endif

    return lightline#mode()
  endfunction

  function! s:lightline_modified()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    if mode() ==# 't'
      return ''
    endif

    return &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! s:lightline_readonly()
    return &readonly ? '' : ''
  endfunction

  function! s:lightline_filename()
    try
      let l:readonly = s:lightline_readonly()
      let l:modified = s:lightline_modified()
      let l:filename = expand('%:t')

      return  (empty(l:readonly) ? '' : l:readonly . ' ') .
            \ (empty(l:filename) ? '[No Name]' : l:filename) .
            \ (empty(l:modified) ? '' : ' ' . l:modified)
    catch
      return ''
    endtry
  endfunction

  function! s:lightline_tab_component(_)
    return ''
  endfunction

  function! s:lightline_current_branch()
    if empty(expand('%:p'))
      return ''
    endif

    try
      let l:branch = gitbranch#name()
      return empty(l:branch) ? '' : '' . l:branch
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

    return (empty(&filetype) ? 'no filetype' : &filetype)
  endfunction

  function! s:lightline_fileencoding()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    return (empty(&fileencoding) ? &encoding : &fileencoding)
  endfunction

  function! s:lightline_git_summary()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    if empty(expand('%:p'))
      return ''
    endif

    try
      let l:branch = gitbranch#name()
      if empty(l:branch)
        return ''
      endif

      let l:summary = GitGutterGetHunkSummary()
      return printf('%s%d %s%d %s%d',
            \ g:gitgutter_sign_added,    l:summary[0],
            \ g:gitgutter_sign_modified, l:summary[1],
            \ g:gitgutter_sign_removed,  l:summary[2])
    catch
      return ''
    endtry
  endfunction

  function! s:lightline_lineinfo()
    if s:is_lightline_no_disp_group()
      return ''
    endif

    return printf('%4d/%d : %-3d', line('.'), line('$'), col('.'))
  endfunction

  function! s:lightline_searchcount()
    if !v:hlsearch
      return ''
    endif

    let result = searchcount()
    if empty(result)
      return ''
    endif

    if result.incomplete ==# 1
      return '[?/??]'

    elseif result.incomplete ==# 2
      if result.total > result.maxcount && result.current > result.maxcount
        return printf('[>%d/>%d]', result.current, result.total)

      elseif result.total > result.maxcount
        return printf('[%d/>%d]', result.current, result.total)
      endif
    endif
    return printf('[%d/%d]', result.current, result.total)
  endfunction

  function! s:is_lightline_no_disp_group()
    return winwidth(0) <= 50
  endfunction

  if s:is_installed
    Autocmd CursorHold,CursorHoldI * call lightline#update()
  endif
  " }}}

  Plug 'kana/vim-submode', {'on': []}
  " submode {{{
  AutocmdUser vim-submode call s:execute_if_installed('s:init_submode')

  function! s:submode_snap(value, scale)
    return a:value / a:scale * a:scale
  endfunction

  function! s:submode_resize_appwin(x, y)
    let l:scale = 8

    if a:x != 0
      let &columns = s:submode_snap(&columns, l:scale) + a:x * l:scale
    endif

    if a:y != 0
      let &lines   = s:submode_snap(&lines,   l:scale) + a:y * l:scale
    endif
  endfunction

  function! s:submode_move_appwin(x, y)
    let l:scale = 64
    let l:win_x = getwinposx()
    let l:win_y = getwinposy()

    if a:x == 0
      let l:x = l:win_x
    else
      let l:x = l:win_x + a:x * l:scale

      if l:win_x != s:submode_snap(l:win_x, l:scale)
        let l:x = s:submode_snap(l:x, l:scale)
      endif
    endif

    if a:y == 0
      let l:y = l:win_y
    else
      let l:y = l:win_y + a:y * l:scale

      if l:win_y != s:submode_snap(l:win_y, l:scale)
        let l:y = s:submode_snap(y, l:scale)
      endif
    endif

    execute 'winpos' l:x l:y
  endfunction

  function! s:init_submode()
    let g:submode_timeout          = 0
    let g:submode_keep_leaving_key = 1

    call submode#enter_with('git_hunk', 'n', 's', 'ghj', ':<C-u>GitGutterEnable<CR>:GitGutterNextHunk<CR>zvzz')
    call submode#enter_with('git_hunk', 'n', 's', 'ghk', ':<C-u>GitGutterEnable<CR>:GitGutterPrevHunk<CR>zvzz')
    call submode#map(       'git_hunk', 'n', 's', 'j',   ':<C-u>GitGutterEnable<CR>:GitGutterNextHunk<CR>zvzz')
    call submode#map(       'git_hunk', 'n', 's', 'k',   ':<C-u>GitGutterEnable<CR>:GitGutterPrevHunk<CR>zvzz')

    if s:is_gui
      let l:call_resize_appwin = ':<C-u>call ' . s:sid . 'submode_resize_appwin'
      let l:call_move_appwin   = ':<C-u>call ' . s:sid . 'submode_move_appwin'

      call submode#enter_with('appwinsize', 'n', 's', '<leader>wH', l:call_resize_appwin . '(-1, 0)<CR>')
      call submode#enter_with('appwinsize', 'n', 's', '<leader>wL', l:call_resize_appwin . '(+1, 0)<CR>')
      call submode#enter_with('appwinsize', 'n', 's', '<leader>wJ', l:call_resize_appwin . '(0, +1)<CR>')
      call submode#enter_with('appwinsize', 'n', 's', '<leader>wK', l:call_resize_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'H',          l:call_resize_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'L',          l:call_resize_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'J',          l:call_resize_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'K',          l:call_resize_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'h',          l:call_resize_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'l',          l:call_resize_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'j',          l:call_resize_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinsize', 'n', 's', 'k',          l:call_resize_appwin . '(0, -1)<CR>')

      call submode#enter_with('appwinpos', 'n', 's', '<leader>wh', l:call_move_appwin . '(-1, 0)<CR>')
      call submode#enter_with('appwinpos', 'n', 's', '<leader>wl', l:call_move_appwin . '(+1, 0)<CR>')
      call submode#enter_with('appwinpos', 'n', 's', '<leader>wj', l:call_move_appwin . '(0, +1)<CR>')
      call submode#enter_with('appwinpos', 'n', 's', '<leader>wk', l:call_move_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'H',          l:call_move_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'L',          l:call_move_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'J',          l:call_move_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'K',          l:call_move_appwin . '(0, -1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'h',          l:call_move_appwin . '(-1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'l',          l:call_move_appwin . '(+1, 0)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'j',          l:call_move_appwin . '(0, +1)<CR>')
      call submode#map(       'appwinpos', 'n', 's', 'k',          l:call_move_appwin . '(0, -1)<CR>')
    endif
  endfunction
  " }}}

  Plug 'prabirshrestha/asyncomplete-lsp.vim', {'on': []}
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim', {'on': []}
  Plug 'akaimo/asyncomplete-around.vim', {'on': []}
  Plug 'prabirshrestha/asyncomplete.vim', {'on': []}
  " asyncomplete.vim {{{
  AutocmdUser asyncomplete.vim call s:execute_if_installed('s:init_asyncomplete')
  let g:asyncomplete_around_range = 120

  function! s:init_asyncomplete()
    call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
          \   'name':      'ultisnips',
          \   'allowlist': ['*'],
          \   'completor': function('asyncomplete#sources#ultisnips#completor'),
          \ }))

    call asyncomplete#register_source(asyncomplete#sources#around#get_source_options({
          \   'name':      'around',
          \   'allowlist': ['*'],
          \   'completor': function('asyncomplete#sources#around#completor'),
          \ }))

    call asyncomplete#enable_for_buffer()
  endfunction
  " }}}

  Plug 'SirVer/ultisnips', {'on': []}
  " ultisnips {{{
  let g:UltiSnipsSnippetDirectories  = [s:dotvim_dir . 'UltiSnips']
  let g:UltiSnipsJumpForwardTrigger  = '<Tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
  let g:UltiSnipsListSnippets        = '<S-Tab>'
  let g:UltiSnipsExpandTrigger       = '<C-e>'
  " }}}

  Plug 'vim-jp/vimdoc-ja', {'on': []}

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

  " Plug 'tyru/capture.vim'
  " Plug 'thinca/vim-prettyprint'
endif

Plug 'andymass/vim-matchup', {'on': []}
" vim-matchup {{{
let g:matchup_matchparen_status_offscreen = 0
let g:matchup_matchparen_deferred         = 1
" }}}

Plug 'markonm/traces.vim', {'on': []}
" traces.vim {{{
let g:traces_preview_window = 'botright 10new'
" }}}

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
AutocmdUser vim-sandwich call s:execute_if_installed('s:init_sandwich')

let g:operator_sandwich_no_default_key_mappings = 1

function! s:init_sandwich()
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

Plug 'haya14busa/vim-asterisk', {'on': []}
Plug 'haya14busa/is.vim', {'on': []}
" is.vim {{{
map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
" }}}

Plug 'rhysd/clever-f.vim', {'on': []}
" clever-f.vim {{{
let g:clever_f_smart_case                       = 1
let g:clever_f_fix_key_direction                = 1
let g:clever_f_not_overwrites_standard_mappings = 1
let g:clever_f_across_no_line                   = 1

nmap f     <Plug>(clever-f-f)
xmap f     <Plug>(clever-f-f)
omap f     <Plug>(clever-f-f)
nmap F     <Plug>(clever-f-F)
xmap F     <Plug>(clever-f-F)
omap F     <Plug>(clever-f-F)
nmap <Esc> <Plug>(clever-f-reset)
xmap <Esc> <Plug>(clever-f-reset)
omap <Esc> <Plug>(clever-f-reset)
" }}}

Plug 'unblevable/quick-scope', {'on': []}
" quick-scope {{{
let g:qs_ignorecase = 1

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary   guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81  cterm=underline
augroup END
" }}}

call plug#end()

function! s:load_plug(timer)
  if !s:is_vscode
    call plug#load(
          \   'vim-icondrag',
          \   'vim-submode',
          \   'vim-gitbranch',
          \   'vim-gitgutter',
          \   'vim-rplugin',
          \   'lista.nvim',
          \   'markdown-preview.nvim',
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
          \   'asyncomplete-around.vim',
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
        \   'clever-f.vim',
        \   'quick-scope',
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
endfunction "}
call timer_start(30, function('s:load_plug'))

" --------------------------------------------------------------------------------
" ファイルタイプごとの設定
" --------------------------------------------------------------------------------
Autocmd FileType           *                         call s:update_all()
Autocmd BufNewFile,BufRead *.xaml                    setlocal filetype=xml
Autocmd BufNewFile,BufRead *.cake                    setlocal filetype=cs
Autocmd BufNewFile,BufRead *.{fx,fxc,fxh,hlsl,hlsli} setlocal filetype=hlsl
Autocmd BufNewFile,BufRead *.{fsh,vsh}               setlocal filetype=glsl

Autocmd VimEnter COMMIT_EDITMSG
      \  if getline(1) == ''
      \|   startinsert
      \| endif

AutocmdFT qf
      \  nnoremap <silent><buffer> q :<C-u>cclose<CR>

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
      \  setlocal tabstop=2
      \| setlocal shiftwidth=2
      \| setlocal softtabstop=2
      \| setlocal foldmethod=marker
      \| setlocal foldlevel=0
      \| setlocal foldcolumn=5

AutocmdFT xml,html
      \  setlocal foldmethod=syntax
      \| setlocal foldlevel=99
      \| setlocal foldcolumn=5
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
  setlocal formatoptions-=ro
  setlocal textwidth=0
endfunction

" --------------------------------------------------------------------------------
" 表示
" --------------------------------------------------------------------------------
if !s:is_vscode
  set number
  set textwidth=0
  set noshowcmd
  set noshowmatch
  set wrap
  set noshowmode
  set shortmess=filnxtToOIsS
  set lazyredraw
  set wildmenu
  set wildmode=list:full
  set showfulltag
  set wildoptions=tagfile
  set fillchars=vert:\ "
  set synmaxcol=500
  set updatetime=100
  set previewheight=24
  set cmdheight=1
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
  set diffopt=internal,filler,algorithm:histogram,indent-heuristic
  set splitbelow
  set splitright
  set browsedir=buffer
  set scrolloff=4

  set ambiwidth=double
  if exists('*setcellwidths')
    call setcellwidths([[0x2500, 0x257f, 1], [0xE0A0, 0xE0B7, 1]])
  endif

  if s:is_gui
    set guioptions=M
    set winaltkeys=no

    set lines=100
    let &columns = s:base_columns

    set guifont=HackGenNerd\ Console:h11
    " set renderoptions=type:directx
    " set printfont=HackGenNerd\ Console:h11
  else
    set termguicolors
  endif

  Autocmd ColorScheme * call s:set_color()
  function! s:set_color()
    " ^M を非表示
    syntax match HideCtrlM containedin=ALL /\r$/ conceal

    " 日本語入力時カーソル色を変更する
    highlight CursorIM guifg=NONE guibg=Red
  endfunction

  if s:is_installed
    colorscheme night-owl
  endif

  filetype plugin indent on
  syntax enable

  " 折り畳み
  nnoremap <expr> zh foldlevel(line('.'))  >  0  ? 'zc' : '<C-h>'
  nnoremap <expr> zl foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'

  " アプリウィンドウ操作
  if s:is_gui
    command! -nargs=1 -complete=file Diff
          \  call <SID>toggle_v_wide()
          \| vertical diffsplit <args>

    noremap <silent> <leader>we :<C-u>call <SID>toggle_v_split_wide()<CR>
    noremap <silent> <leader>wf :<C-u>call <SID>full_window()<CR>

    " アプリケーションウィンドウを最大高さにする
    function! s:full_window()
      execute 'winpos' getwinposx() '0'
      set lines=9999
    endfunction

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
set helplang=ja,en
set keywordprg=

if !s:is_vscode
  " 複数Vimで検索を同期する
  function! s:save_reg(reg, filename)
    call writefile([getreg(a:reg)], a:filename)
  endfunction

  function! s:load_reg(reg, filename)
    if filereadable(a:filename)
      call setreg(a:reg, readfile(a:filename), 'v')
    endif
  endfunction

  let s:vimreg_search = s:home_dir . 'vimreg_search.txt'
  Autocmd CursorHold,CursorHoldI,FocusLost * silent! call s:save_reg('/', s:vimreg_search)
  Autocmd FocusGained                      * silent! call s:load_reg('/', s:vimreg_search)

  " grep {{{
  nnoremap <silent> <leader>g :<C-u>Grep<CR>
  nnoremap <silent> <leader>q :<C-u>CtrlPQuickfix<CR>

  command! -nargs=? Grep call <SID>grep(<f-args>)

  AutocmdFT qf nnoremap <silent><buffer> q :<C-u>call <SID>grep_cancel()<CR>

  let s:grep_job_id = ''

  function! s:grep(...) abort
    if a:0 >= 1
      let l:word = a:1
    else
      let l:word = input('Search pattern: ')
    endif

    redraw
    echo ''

    if l:word == ''
      return
    endif

    call setqflist([])

    let s:grep_job_id = job_start('rg --smart-case --vimgrep --no-heading ' . l:word . ' ' . s:projectRoot('.'), {
          \   'callback' : function('s:grep_add'),
          \   'exit_cb'  : function('s:grep_close')
          \ })
  endfunction

  function! s:grep_add(ch, msg)
    if s:grep_job_id ==# ''
      return
    endif

    caddexpr a:msg
    cwindow
  endfunction

  function! s:grep_close(ch, msg)
    if s:grep_job_id ==# ''
      return
    endif

    cclose
    CtrlPQuickfix

    let s:grep_job_id = ''
  endfunction

  function! s:grep_cancel()
    if s:grep_job_id !=# ''
      call job_stop(s:grep_job_id)
      let s:grep_job_id = ''
    endif

    cclose
  endfunction

  " https://github.com/mattn/vim-findroot
  function! s:goup(path, patterns) abort
    let l:path = a:path
    while 1
      for l:pattern in a:patterns
        let l:current = l:path . '/' . l:pattern
        if stridx(l:pattern, '*') != -1 && !empty(glob(l:current, 1))
          return l:path
        elseif l:pattern =~# '/$'
          if isdirectory(l:current)
            return l:path
          endif
        elseif filereadable(l:current)
          return l:path
        endif
      endfor
      let l:next = fnamemodify(l:path, ':h')
      if l:next == l:path || (has('win32') && l:next =~# '^//[^/]\+$')
        break
      endif
      let l:path = l:next
    endwhile
    return ''
  endfunction

  function! s:projectRoot(default) abort
    let l:bufname = expand('%:p')
    if &buftype !=# '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
      return a:default
    endif
    let l:dir = escape(fnamemodify(l:bufname, ':p:h:gs!\!/!:gs!//!/!'), ' ')
    let l:dir = s:goup(l:dir, ['.git/', '*.sln'])
    if empty(l:dir)
      return a:default
    else
      return l:dir
    endif
  endfunction
  " }}}
endif

" --------------------------------------------------------------------------------
" 編集
" --------------------------------------------------------------------------------
set clipboard=unnamedplus,unnamed
set modeline
set virtualedit=block
set autoread
set whichwrap=b,s,h,l,<,>,[,]
set mouse=a
set hidden
set timeoutlen=2000
set nrformats=alpha,bin,hex
set backspace=indent,eol,start
set noswapfile
set nobackup
set formatoptions=tcj
set nofixeol
set tags=tags,./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
set autoindent
set cindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autochdir

if s:is_vscode
  nnoremap <silent> u     :<C-u>call VSCodeNotify('undo')<CR>
  nnoremap <silent> <C-r> :<C-u>call VSCodeNotify('redo')<CR>
endif

" ^Mを取り除く
command! RemoveCr call s:execute_keep_view('silent! %substitute/\r$//g | nohlsearch')

" 行末のスペースを取り除く
command! RemoveEolSpace call s:execute_keep_view('silent! %substitute/ \+$//g | nohlsearch')

function! s:execute_keep_view(expr)
  let l:wininfo = winsaveview()
  execute a:expr
  call winrestview(l:wininfo)
endfunction

" 現在のファイルパスをクリップボードへコピーする
command! CopyFilepath     call setreg('*', expand('%:t'), 'v')
command! CopyFullFilepath call setreg('*', expand('%:p'), 'v')

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
nmap     <C-j> <Esc>
vnoremap <C-j> <Esc>
cnoremap <C-j> <Esc>

" カーソル移動
noremap <silent> j     gj
noremap <silent> k     gk
noremap <silent> gj    j
noremap <silent> gk    k
noremap <silent> 0     g0
noremap <silent> g0    0
noremap <silent> $     g$
noremap <silent> g$    $
noremap <silent> gg    ggzv
noremap <silent> G     Gzv
noremap <silent> <C-i> <C-i>
noremap <silent> <C-o> <C-o>

" キーボードマクロ
nnoremap          q     qq<ESC>
nnoremap <expr>   @     reg_recording() == '' ? '@q' : ''

" マーク
nnoremap <silent> m     :<C-u>call <SID>AutoMarkrement()<CR>
nnoremap <silent> <C-k> ]`
nnoremap <silent> <C-l> [`

Autocmd BufReadPost * delmarks!

function! s:AutoMarkrement()
  let l:begin  = char2nr('a')
  let l:end    = char2nr('z')
  let l:length = l:end - l:begin + 1

  if !exists('b:markrement_pos')
    let b:markrement_pos = 0
  else
    let b:markrement_pos = (b:markrement_pos + 1) % l:length
  endif

  execute 'mark' nr2char(l:begin + b:markrement_pos)
endfunction

" Nop
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q  <Nop>

" --------------------------------------------------------------------------------
" 遅延設定
" --------------------------------------------------------------------------------
function! s:lazy_setting(timer)
  if exists('+cryptmethod')
    set cryptmethod=blowfish2
  endif

  if !s:is_vscode
    Autocmd BufWinEnter,ColorScheme .vimrc
          \ syntax match vimAutoCmd /\<\(Autocmd\|AutocmdFT\|AutocmdUser\)\>/

    function! s:edit_vimrc()
      let l:dropbox_vimrc = s:dropbox_dir . 'dotfiles/.vimrc'
      if filereadable(l:dropbox_vimrc)
        execute 'edit' l:dropbox_vimrc
      else
        execute 'edit' $MYVIMRC
      endif
    endfunction

    nnoremap <silent> <F1> :<C-u>call <SID>edit_vimrc()<CR>
    nnoremap <silent> <F2> :<C-u>PlugUpdate<CR>
  endif
endfunction
call timer_start(50, function('s:lazy_setting'))

