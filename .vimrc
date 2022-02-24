if has('vim_starting')
  let s:startuptime = reltime()
  augroup startuptime
    autocmd!
    autocmd startuptime VimEnter *
      \  echomsg 'startuptime:' reltimestr(reltime(s:startuptime))
      \| unlet s:startuptime
  augroup END
endif

" --------------------------------------------------------------------------------
" 基本
" --------------------------------------------------------------------------------
let s:sid              = expand('<SID>')
let s:home_dir         = expand('~/')
let s:plugin_dir       = s:home_dir . '.vim_plugged/'
let s:dropbox_dir      = s:home_dir . 'Dropbox/'
let s:vim_winrect_file = s:home_dir . 'vim_winrect.vim'
let s:is_installed     = isdirectory(s:plugin_dir)
let s:is_vscode        = exists('g:vscode')
let s:is_neovim        = has('nvim')
let s:is_gui           = has('gui_running')
let s:is_windows       = has('win32')
let s:base_columns     = 140

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

if s:is_windows
  let g:python3_host_prog  = s:home_dir . 'AppData/Local/Programs/Python/Python310/python.exe'
endif

augroup MyAutoCmd
  autocmd!
augroup END

command! -nargs=* Autocmd     autocmd MyAutoCmd          <args>
command! -nargs=* AutocmdFT   autocmd MyAutoCmd FileType <args>
command! -nargs=* AutocmdUser autocmd MyAutoCmd User     <args>

" --------------------------------------------------------------------------------
" プラグイン
" --------------------------------------------------------------------------------
function! s:execute_if_installed(proc)
  if s:is_installed
    call a:proc()
  endif
endfunction

function! s:plugin_display(...)
  if !(a:0 >= 1 ? a:1 : 1) | return | endif

  Plug 'YoshihiroIto/night-owl.vim' " {{{
  " }}}
  Plug 'itchyny/lightline.vim' " {{{
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
        \     'seachcount':   s:sid . 'lightline_searchcount',
        \     'cocstatus':   'coc#status',
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
        \     'right': [['cocstatus', 'filetype', 'fileformat', 'fileencoding']]
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

    try
      let l:result = searchcount()
      if empty(l:result)
        return ''
      endif
    catch
      return ''
    endtry

    if l:result.incomplete ==# 1
      return '[?/??]'

    elseif l:result.incomplete ==# 2
      if l:result.total > l:result.maxcount && l:result.current > l:result.maxcount
        return printf('[>%d/>%d]', l:result.current, l:result.total)

      elseif l:result.total > l:result.maxcount
        return printf('[%d/>%d]', l:result.current, l:result.total)
      endif
    endif

    return printf('[%d/%d]', l:result.current, l:result.total)
  endfunction

  function! s:is_lightline_no_disp_group()
    return winwidth(0) <= 50
  endfunction

  if s:is_installed
    Autocmd CursorHold,CursorHoldI * call lightline#update()
    AutocmdUser CocStatusChange,CocDiagnosticChange call lightline#update()
  endif
  " }}}
endfunction

function! s:plugin_display_lazy(...)
  if !(a:0 >= 1 ? a:1 : 1) | return | endif

  Plug 'YoshihiroIto/vim-icondrag', {'on': []} " {{{
  AutocmdUser vim-icondrag call s:execute_if_installed({-> icondrag#enable()})
  " }}}
  Plug 'neoclide/coc.nvim', {'on': [], 'branch': 'release'} " {{{
  AutocmdUser coc.nvim call s:execute_if_installed({-> s:init_coc()})

  let g:coc_global_extensions = [
        \   'coc-calc',
        \   'coc-clangd',
        \   'coc-css',
        \   'coc-html',
        \   'coc-json',
        \   'coc-omnisharp',
        \   'coc-powershell',
        \   'coc-prettier',
        \   'coc-snippets',
        \   'coc-spell-checker',
        \   'coc-tsserver',
        \   'coc-vimlsp',
        \   'coc-yaml',
        \ ]

  function! s:init_coc()
    call coc#config('diagnostic.warningSign', '!!')
    call coc#config('coc.source.around.firstMatch', 0)
    call coc#config('coc.source.buffer.firstMatch', 0)
    call coc#config('coc.preferences.formatOnSaveFiletypes', [
          \   'css',
          \   'html',
          \   'javascript',
          \   'json',
          \   'scss',
          \   'typescript',
          \   'vue',
          \   'yaml',
          \ ])
    call coc#config('suggest.completionItemKindLabels', {
          \   'keyword':       "\uf1de",
          \   'variable':      "\ue79b",
          \   'value':         "\uf89f",
          \   'operator':      "\u03a8",
          \   'constructor':   "\uf0ad",
          \   'function':      "\u0192",
          \   'reference':     "\ufa46",
          \   'constant':      "\uf8fe",
          \   'method':        "\uf09a",
          \   'struct':        "\ufb44",
          \   'class':         "\uf0e8",
          \   'interface':     "\uf417",
          \   'text':          "\ue612",
          \   'enum':          "\uf435",
          \   'enumMember':    "\uf02b",
          \   'module':        "\uf40d",
          \   'color':         "\ue22b",
          \   'property':      "\ue624",
          \   'field':         "\uf9be",
          \   'unit':          "\uf475",
          \   'event':         "\ufacd",
          \   'file':          "\uf723",
          \   'folder':        "\uf114",
          \   'snippet':       "\ue60b",
          \   'typeParameter': "\uf728",
          \   'default':       "\uf29c",
          \ })

    " coc-snippets
    call coc#config('snippets.ultisnips.directories', ['~/.vim/UltiSnips'])
    imap <C-e> <Plug>(coc-snippets-expand)
    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'

    Autocmd CursorHold * silent call CocActionAsync('highlight')

    nmap     <silent> <C-]>  <Plug>(coc-definition)
    nmap     <silent> ]e     <Plug>(coc-rename)
    nmap     <silent> ]f     <Plug>(coc-fix-current)
    nmap     <silent> <M-CR> <Plug>(coc-codeaction-cursor)
    nnoremap <silent> K      <Cmd>call <SID>show_documentation()<CR>

    command! -nargs=* -range Format call s:format(<range>)
    function! s:format(range)
      if a:range == 0
        call CocActionAsync('format')
      else
        call CocActionAsync('formatSelected', visualmode())
      endif
    endfunction

    function! s:show_documentation()
      if (index(['vim', 'help'], &filetype) >= 0)
        execute 'help' expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg expand('<cword>')
      endif
    endfunction
  endfunction
  " }}}
  Plug 'itchyny/vim-gitbranch', {'on': []} " {{{
  " }}}
  Plug 'airblade/vim-gitgutter', {'on': []} " {{{
  AutocmdUser vim-gitgutter call s:execute_if_installed({-> s:init_gitgutter()})

  let g:gitgutter_map_keys = 0
  let g:gitgutter_grep     = ''

  function! s:init_gitgutter()
    call gitgutter#enable()
    Autocmd WinEnter * GitGutter
  endfunction
  " }}}
  Plug 'lambdalisue/vim-rplugin', {'on': []} " {{{
  " }}}
  Plug 'YoshihiroIto/lista.nvim', {'on': []} " {{{
  nnoremap <silent> <leader>l <Cmd>Lista<CR>
  let g:lista#custom_mappings = [
        \   ['<C-j>', '<Esc>'],
        \   ['<C-p>', '<S-Tab>'],
        \   ['<C-n>', '<Tab>'],
        \ ]
  " }}}
  Plug 'iamcco/markdown-preview.nvim', {'on': [], 'do': 'cd app & yarn install'} " {{{
  nnoremap <silent> <leader>p <Cmd>MarkdownPreview<CR>
  " }}}
  Plug 'cocopon/vaffle.vim', {'on': []} " {{{
  let g:vaffle_show_hidden_files = 1

  AutocmdFT vaffle nmap <silent><buffer> <Esc> <Plug>(vaffle-quit)
  " }}}
  Plug 'itchyny/vim-cursorword', {'on': []} " {{{
  let g:cursorword_delay     = 270
  let g:cursorword_highlight = 0
  Autocmd BufNewFile,BufRead,ColorScheme *
        \  highlight CursorWord0 guifg=Red ctermfg=Red
        \| highlight CursorWord1 guifg=Red ctermfg=Red
  " }}}
  Plug 'itchyny/vim-autoft', {'on': []} " {{{
  let g:autoft_config = [
        \   {'filetype': 'cs',   'pattern': '^\s*using'},
        \   {'filetype': 'cpp',  'pattern': '^\s*#\s*\%(include\|define\)\>'},
        \   {'filetype': 'go',   'pattern': '^import ('},
        \   {'filetype': 'html', 'pattern': '<\%(!DOCTYPE\|html\|head\|script\|meta\|link|div\|span\)\>\|^html:5\s*$'},
        \   {'filetype': 'xml',  'pattern': '<[0-9a-zA-Z]\+'},
        \ ]
  " }}}
  Plug 'glidenote/memolist.vim', {'on': []} " {{{
  noremap <silent> <leader>k <Cmd>execute 'CtrlP' g:memolist_path<CR>
  let g:memolist_memo_suffix = 'md'
  let g:memolist_path        = s:dropbox_dir . 'memo/'
  " }}}
  Plug 'YoshihiroIto/vim-closetag', {'on': []} " {{{
  AutocmdFT xml,html,xhtml
        \  inoremap <silent><buffer> > ><Esc><Cmd>call closetag#CloseIt()<CR>
  "}}}
  Plug 'kana/vim-submode', {'on': []} " {{{
  AutocmdUser vim-submode call s:execute_if_installed({-> s:init_submode()})

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

    call submode#enter_with('git_hunk', 'n', 'sr', 'ghj', '<Plug>(GitGutterNextHunk)zv')
    call submode#enter_with('git_hunk', 'n', 'sr', 'ghk', '<Plug>(GitGutterPrevHunk)zv')
    call submode#map(       'git_hunk', 'n', 'sr', 'j',   '<Plug>(GitGutterNextHunk)zv')
    call submode#map(       'git_hunk', 'n', 'sr', 'k',   '<Plug>(GitGutterPrevHunk)zv')

    call submode#enter_with('diagnostic', 'n', 'sr', 'gbj', '<Plug>(coc-diagnostic-next)zv')
    call submode#enter_with('diagnostic', 'n', 'sr', 'gbk', '<Plug>(coc-diagnostic-prev)zv')
    call submode#map(       'diagnostic', 'n', 'sr', 'j',   '<Plug>(coc-diagnostic-next)zv')
    call submode#map(       'diagnostic', 'n', 'sr', 'k',   '<Plug>(coc-diagnostic-prev)zv')

    call submode#enter_with('mark', 'n', 's', 'gmj', ']`zv')
    call submode#enter_with('mark', 'n', 's', 'gmk', '[`zv')
    call submode#map(       'mark', 'n', 's', 'j',   ']`zv')
    call submode#map(       'mark', 'n', 's', 'k',   '[`zv')

    call submode#enter_with('window', 'nt', 's', 'gwh', '<C-w>h')
    call submode#enter_with('window', 'nt', 's', 'gwl', '<C-w>l')
    call submode#enter_with('window', 'nt', 's', 'gwj', '<C-w>j')
    call submode#enter_with('window', 'nt', 's', 'gwk', '<C-w>k')
    call submode#map(       'window', 'nt', 's', 'h',   '<C-w>h')
    call submode#map(       'window', 'nt', 's', 'l',   '<C-w>l')
    call submode#map(       'window', 'nt', 's', 'j',   '<C-w>j')
    call submode#map(       'window', 'nt', 's', 'k',   '<C-w>k')

    if s:is_gui
      let l:call_resize_appwin = '<Cmd>call ' . s:sid . 'submode_resize_appwin'
      let l:call_move_appwin   = '<Cmd>call ' . s:sid . 'submode_move_appwin'

      call submode#enter_with('appwinsize', 'nt', 's', '<leader>wH', l:call_resize_appwin . '(-1,  0)<CR>')
      call submode#enter_with('appwinsize', 'nt', 's', '<leader>wL', l:call_resize_appwin . '(+1,  0)<CR>')
      call submode#enter_with('appwinsize', 'nt', 's', '<leader>wJ', l:call_resize_appwin . '( 0, +1)<CR>')
      call submode#enter_with('appwinsize', 'nt', 's', '<leader>wK', l:call_resize_appwin . '( 0, -1)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'H',          l:call_resize_appwin . '(-1,  0)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'L',          l:call_resize_appwin . '(+1,  0)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'J',          l:call_resize_appwin . '( 0, +1)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'K',          l:call_resize_appwin . '( 0, -1)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'h',          l:call_resize_appwin . '(-1,  0)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'l',          l:call_resize_appwin . '(+1,  0)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'j',          l:call_resize_appwin . '( 0, +1)<CR>')
      call submode#map(       'appwinsize', 'nt', 's', 'k',          l:call_resize_appwin . '( 0, -1)<CR>')

      call submode#enter_with('appwinpos', 'nt', 's', '<leader>wh', l:call_move_appwin . '(-1,  0)<CR>')
      call submode#enter_with('appwinpos', 'nt', 's', '<leader>wl', l:call_move_appwin . '(+1,  0)<CR>')
      call submode#enter_with('appwinpos', 'nt', 's', '<leader>wj', l:call_move_appwin . '( 0, +1)<CR>')
      call submode#enter_with('appwinpos', 'nt', 's', '<leader>wk', l:call_move_appwin . '( 0, -1)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'H',          l:call_move_appwin . '(-1,  0)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'L',          l:call_move_appwin . '(+1,  0)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'J',          l:call_move_appwin . '( 0, +1)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'K',          l:call_move_appwin . '( 0, -1)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'h',          l:call_move_appwin . '(-1,  0)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'l',          l:call_move_appwin . '(+1,  0)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'j',          l:call_move_appwin . '( 0, +1)<CR>')
      call submode#map(       'appwinpos', 'nt', 's', 'k',          l:call_move_appwin . '( 0, -1)<CR>')
    endif
  endfunction
  " }}}
  Plug 'markonm/traces.vim', {'on': []} " {{{
  let g:traces_preview_window = 'botright 10new'
  " }}}
  Plug 'ctrlpvim/ctrlp.vim', {'on': []} " {{{
  nnoremap <silent> <leader>m <Cmd>CtrlPMRUFiles<CR>

  let g:ctrlp_match_window    = 'bottom,order:ttb,min:48,max:48'
  let g:ctrlp_map             = ''
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
  Plug 'mattn/ctrlp-matchfuzzy', {'on': []} " {{{
  if exists('?matchfuzzy')
    let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
  endif
  " }}}
  " Plug 'YoshihiroIto/ctrlp-sessions', {'on': []} " {{{
  " nnoremap <silent> <leader>s <Cmd>CtrlPSessions<CR>
  " " }}}
  Plug 'vim-jp/vimdoc-ja', {'on': []} " {{{
  " }}}
  Plug 'leafOfTree/vim-vue-plugin', {'on': []} " {{{
  " }}}
  Plug 'beyondmarc/hlsl.vim', {'on': []} " {{{
  " }}}
  Plug 'tikhomirov/vim-glsl', {'on': []} " {{{
  " }}}
  Plug 'plasticboy/vim-markdown', {'on': []} " {{{
  let g:vim_markdown_folding_disabled        = 1
  let g:vim_markdown_no_default_key_mappings = 1
  " }}}
endfunction

function! s:plugin_editing_lazy()
  Plug 'andymass/vim-matchup', {'on': []} " {{{
  let g:matchup_matchparen_status_offscreen = 0
  let g:matchup_matchparen_deferred         = 1
  " }}}
  Plug 'tomtom/tcomment_vim', {'on': []} " {{{
  let g:tcomment_maps                       = !s:is_vscode
  let g:tcomment_mapleader1                 = ''
  let g:tcomment_mapleader2                 = ''
  let g:tcomment_mapleader_uncomment_anyway = ''
  let g:tcomment_mapleader_comment_anyway   = ''
  let g:tcomment_textobject_inlinecomment   = ''
  " }}}
  Plug 'cohama/lexima.vim', {'on': []} " {{{
  " }}}
  Plug 'junegunn/vim-easy-align', {'on': []} " {{{
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
  Plug 'machakann/vim-sandwich', {'on': []} " {{{
  AutocmdUser vim-sandwich call s:execute_if_installed({-> s:init_sandwich()})

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

    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
    let g:sandwich#recipes += [{
          \   'buns':     ['${', '}'],
          \   'input':    ['$'],
          \   'filetype': ['typescript'],
          \ }]
  endfunction
  " }}}
  Plug 'haya14busa/vim-asterisk', {'on': []} " {{{
  " }}}
  Plug 'haya14busa/is.vim', {'on': []} " {{{
  map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
  map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
  map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
  map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
  " }}}
  Plug 'tyru/open-browser.vim', {'on': []} " {{{
  let g:openbrowser_no_default_menus = 1
  let g:netrw_nogx = 1
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  " }}}
  Plug 'unblevable/quick-scope', {'on': []} " {{{
  let g:qs_ignorecase = 1

  Autocmd BufNewFile,BufRead,ColorScheme *
        \  highlight QuickScopePrimary   guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
        \| highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81  cterm=underline
  " }}}
  Plug 'rhysd/clever-f.vim', {'on': []} " {{{
  let g:clever_f_across_no_line = 1
  let g:clever_f_ignore_case    = 1

  nmap f <Plug>(clever-f-f)
  xmap f <Plug>(clever-f-f)
  omap f <Plug>(clever-f-f)
  nmap F <Plug>(clever-f-F)
  xmap F <Plug>(clever-f-F)
  omap F <Plug>(clever-f-F)
  " }}}
  Plug 'kana/vim-textobj-user', {'on': []} " {{{
  " }}}
  Plug 'kana/vim-textobj-indent', {'on': []} " {{{
  " }}}
  Plug 'kana/vim-textobj-entire', {'on': []} " {{{
  " }}}
  Plug 'kana/vim-textobj-line', {'on': []} " {{{
  " }}}
  Plug 'rhysd/vim-textobj-word-column', {'on': []} " {{{
  " }}}
  Plug 'whatyouhide/vim-textobj-xmlattr', {'on': []} " {{{
  " }}}
  Plug 'sgur/vim-textobj-parameter', {'on': []} " {{{
  xmap aa <Plug>(textobj-parameter-a)
  xmap ia <Plug>(textobj-parameter-i)
  omap aa <Plug>(textobj-parameter-a)
  omap ia <Plug>(textobj-parameter-i)
  " }}}
  Plug 'rhysd/vim-textobj-wiw', {'on': []} " {{{
  xmap a. <Plug>(textobj-wiw-a)
  xmap i. <Plug>(textobj-wiw-i)
  omap a. <Plug>(textobj-wiw-a)
  omap i. <Plug>(textobj-wiw-i)
  " }}}
  Plug 'thinca/vim-textobj-between', {'on': []} " {{{
  let g:textobj_between_no_default_key_mappings = 1
  xmap ac <Plug>(textobj-between-a)
  xmap ic <Plug>(textobj-between-i)
  omap ac <Plug>(textobj-between-a)
  omap ic <Plug>(textobj-between-i)
  " }}}
  Plug 'kana/vim-operator-user', {'on': []} " {{{
  " }}}
  Plug 'kana/vim-operator-replace', {'on': []} " {{{
  map R <Plug>(operator-replace)
  " }}}
  Plug 'tyru/operator-camelize.vim', {'on': []} " {{{
  map <Leader>c <Plug>(operator-camelize-toggle)
  " }}}
endfunction

call plug#begin(s:plugin_dir)
call s:plugin_display(!s:is_vscode)
call plug#end()

" --------------------------------------------------------------------------------
" ファイルタイプごとの設定
" --------------------------------------------------------------------------------
Autocmd BufNewFile,BufRead *.xaml      setlocal filetype=xml
Autocmd BufNewFile,BufRead *.cake      setlocal filetype=cs
Autocmd BufNewFile,BufRead *.hlsli     setlocal filetype=hlsl
Autocmd BufNewFile,BufRead *.{fsh,vsh} setlocal filetype=glsl

AutocmdFT *
      \  setlocal formatoptions-=ro
      \| setlocal textwidth=0
      \| setlocal iskeyword=@,48-57,_,192-255

AutocmdFT typescript,ruby,vue,json,yaml,vim,xml,html,xhtml
      \  setlocal tabstop=2
      \| setlocal shiftwidth=2
      \| setlocal softtabstop=2

AutocmdFT vim
      \  setlocal foldmethod=marker
      \| setlocal foldlevel=0
      \| setlocal foldcolumn=2

AutocmdFT xml,html,xhtml
      \  setlocal foldmethod=syntax
      \| setlocal foldlevel=99
      \| setlocal foldcolumn=2

AutocmdFT dosbatch
      \  setlocal fileencoding=sjis

AutocmdFT help
      \  nnoremap <silent><buffer> q <Cmd>close<CR>

AutocmdFT qf
      \  nnoremap <silent><buffer> q <Cmd>cclose<CR>

" --------------------------------------------------------------------------------
" 表示
" --------------------------------------------------------------------------------
if !s:is_vscode
  set number
  set textwidth=0
  set noshowcmd
  set wrap
  set noshowmode
  set shortmess=filnxtToOIsScq
  set lazyredraw
  set synmaxcol=500
  set previewheight=24
  set cmdheight=3
  set laststatus=2
  set showtabline=2
  set noequalalways
  set cursorline
  set display=lastline
  set concealcursor=i
  set signcolumn=yes
  set list
  set fillchars=vert:\ ,eob:\ "
  set listchars=tab:\»\ ,eol:↲,extends:»,precedes:«,nbsp:%
  set breakindent
  set belloff=all
  set diffopt=internal,filler,algorithm:histogram,indent-heuristic
  set splitbelow
  set splitright
  set scrolloff=4
  set ambiwidth=double

  if exists('*setcellwidths')
    call setcellwidths([[0x2500, 0x257f, 1], [0xE0A0, 0xE0B7, 1]])
  endif

  if s:is_gui
    " ウィンドウ矩形復元する
    if filereadable(s:vim_winrect_file)
      execute 'source' s:vim_winrect_file
    endif

    let &columns = s:base_columns

    set guioptions=M
    set winaltkeys=no
    set guifont=HackGenNerd\ Console:h11
    set linespace=0
  else
    set termguicolors
  endif

  if exists('&wincolor')
    Autocmd ColorScheme                      * highlight NormalNC guifg=#a0a0a0 guibg=#121212
    Autocmd WinEnter,BufWinEnter,FocusGained * setlocal  wincolor=
    Autocmd WinLeave,FocusLost               * setlocal  wincolor=NormalNC
  endif

  if s:is_installed
    colorscheme night-owl
  endif

  filetype plugin indent on
  syntax enable
endif

" --------------------------------------------------------------------------------
" 設定
" --------------------------------------------------------------------------------
function! s:settings()
  " プラグイン
  call plug#begin(s:plugin_dir)
  call s:plugin_display_lazy(!s:is_vscode)
  call s:plugin_editing_lazy()
  call plug#end()

  call plug#load(g:plugs_order)

  if !s:is_vscode
    Autocmd BufWinEnter,ColorScheme .vimrc
          \ syntax match vimAutoCmd /\<\(Autocmd\|AutocmdFT\|AutocmdUser\)\>/

    function! s:edit_vimrc()
      let l:dropbox_vimrc = s:dropbox_dir . 'dotfiles/.vimrc'
      execute 'edit' filereadable(l:dropbox_vimrc) ? l:dropbox_vimrc : $MYVIMRC
    endfunction

    function! s:update_all_plugins()
      call plug#begin(s:plugin_dir)
      call s:plugin_display()
      call s:plugin_display_lazy()
      call s:plugin_editing_lazy()
      call plug#end()

      PlugUpdate
    endfunction

    nnoremap <silent> <leader>1 <Cmd>call <SID>edit_vimrc()<CR>
    nnoremap <silent> <leader>2 <Cmd>call <SID>update_all_plugins()<CR>
  endif

  " ローカル設定
  let l:vimrc_local = s:home_dir . '.vimrc.local'
  if filereadable(l:vimrc_local)
    execute 'source' l:vimrc_local
  endif

  " 開発
  if s:is_vscode
    nnoremap ]e <Cmd>call VSCodeNotify('editor.action.rename')<CR>
    nnoremap ]r <Cmd>call VSCodeNotify('workbench.action.debug.start')<CR>

    nnoremap <silent> <leader>f <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>
  else
    nnoremap <silent> <leader>f <Cmd>Vaffle<CR>

    tnoremap <Esc> <C-w>N
    tnoremap <C-j> <C-w>N
    tnoremap <C-v> <C-w>"*
    tnoremap <C-n> <Down>
    tnoremap <C-p> <Up>
  endif

  " 検索
  set incsearch
  set ignorecase
  set smartcase
  set hlsearch
  set grepprg=rg\ --smart-case\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  set helplang=ja,en
  set keywordprg=

  if !s:is_vscode
    " 複数Vimで検索を同期する {{{
    function! s:save_reg(reg, filename)
      call writefile([getreg(a:reg)], a:filename)
    endfunction

    function! s:load_reg(reg, filename)
      if filereadable(a:filename)
        call setreg(a:reg, readfile(a:filename), 'v')
      endif
    endfunction

    Autocmd CursorHold,FocusLost * silent! call s:save_reg('/', s:home_dir . 'vimreg_search.txt')
    Autocmd FocusGained          * silent! call s:load_reg('/', s:home_dir . 'vimreg_search.txt')
    " }}}
    " ウィンドウ矩形を記憶する {{{
    Autocmd VimLeavePre * call s:save_window_rect()

    function! s:save_window_rect()
      let l:options = [
            \   'set columns=' . &columns,
            \   'set lines=' . &lines,
            \   'winpos ' . getwinposx() . ' ' . getwinposy(),
            \ ]
      call writefile(l:options, s:vim_winrect_file)
    endfunction
    " }}}
    " grep {{{
    nnoremap <silent> <leader>g <Cmd>Grep<CR>
    nnoremap <silent> <leader>q <Cmd>CtrlPQuickfix<CR>

    command! -nargs=? Grep call s:grep(<f-args>)

    AutocmdFT qf nnoremap <silent><buffer> q <Cmd>call <SID>grep_cancel()<CR>

    function! s:grep(...) abort
      let l:word = a:0 >= 1 ? a:1 : input('Search pattern: ')

      redraw
      echo ''

      if empty(l:word)
        return
      endif

      call setqflist([])

      let l:cmd = printf('%s "%s" "%s"', &grepprg, l:word, s:projectRoot('.'))

      if exists('?job_start')
        let s:grep_job_id = job_start(l:cmd, {
              \   'callback': {_, msg -> execute('caddexpr msg | cwindow')},
              \   'exit_cb':  {_, __  -> execute('cclose | CtrlPQuickfix | unlet s:grep_job_id')},
              \ })
      else
        cgetexpr system(l:cmd)
        cwindow
        cclose
        CtrlPQuickfix
      endif
    endfunction

    function! s:grep_cancel()
      if exists('s:grep_job_id')
        call job_stop(s:grep_job_id)
        unlet s:grep_job_id
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
      if !empty(&buftype) || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
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
  else
    nnoremap <silent> <leader>g <Cmd>call VSCodeNotify('workbench.view.search')<CR>
  endif

  " 編集
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
  set noshowmatch
  set wildmenu
  set wildmode=list:full
  set wildoptions=tagfile
  set showfulltag
  set updatetime=300
  set browsedir=buffer

  if exists('&cryptmethod')
    set cryptmethod=blowfish2
  endif

  " 自動リロード
  Autocmd WinEnter,CursorHold * call s:execute_keep_view('checktime')

  " ^Mを取り除く
  command! RemoveCr call s:execute_keep_view('silent! %substitute/\r$//g | nohlsearch')

  " 行末のスペースを取り除く
  command! RemoveEolSpace call s:execute_keep_view('silent! %substitute/ \+$//g | nohlsearch')

  " 現在のファイルパスをクリップボードへコピーする
  command! CopyFilepath     call setreg('*', expand('%:t'), 'v')
  command! CopyFullFilepath call setreg('*', expand('%:p'), 'v')

  vnoremap <C-a> <C-a>gv
  vnoremap <C-x> <C-x>gv

  imap <C-h> <BS>

  nnoremap Y y$

  " モード移行
  inoremap <C-j> <Esc>
  nmap     <C-j> <Esc>
  vnoremap <C-j> <Esc>
  cnoremap <C-j> <Esc>

  " カーソル移動
  noremap <silent> j  gj
  noremap <silent> k  gk
  noremap <silent> gj j
  noremap <silent> gk k
  noremap <silent> 0  g0
  noremap <silent> g0 0
  noremap <silent> $  g$
  noremap <silent> g$ $
  noremap <silent> gg ggzv
  noremap <silent> G  Gzv

  " 折り畳み
  nnoremap <expr> zh foldlevel(line('.'))  >   0 ? 'zc' : '<C-h>'
  nnoremap <expr> zl foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'

  " Nop
  nnoremap ZZ <Nop>
  nnoremap ZQ <Nop>
  nnoremap Q  <Nop>

  " 全角考慮r
  xnoremap <expr> r {'v': "\<C-v>r", 'V': "\<C-v>0o$r", "\<C-v>": 'r'}[mode()]

  if s:is_vscode
    nnoremap <silent> u     <Cmd>call VSCodeNotify('undo')<CR>
    nnoremap <silent> <C-r> <Cmd>call VSCodeNotify('redo')<CR>

    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine
  else
    " コピー＆コメント
    nmap     <silent> <C-CR>    <leader>t
    vmap     <silent> <C-CR>    <leader>t
    nmap     <silent> <leader>t V<leader>t
    vnoremap <silent> <leader>t :<C-u>call <SID>copy_add_comment()<CR>
    function! s:copy_add_comment() range
      normal! gvy
      execute 'normal!' (line("'>") - line("'<") + 1) . 'j'
      normal! Pgv
      normal  gc
      execute 'normal!' (line("'>") - line("'<") + 1) . 'j'
    endfunction
  endif

  " キーボードマクロ
  if s:is_neovim
    nnoremap q qq<ESC>
  else
    nnoremap q qq<ESC>:echo''<CR>
  endif
  nnoremap <expr> @ empty(reg_recording()) ? '@q' : ''

  " マーク
  nnoremap <silent> m <Cmd>call <SID>put_mark()<CR>

  Autocmd BufReadPost * delmarks!

  function! s:put_mark()
    let l:begin  = char2nr('a')
    let l:end    = char2nr('z')
    let l:length = l:end - l:begin + 1

    let b:mark_index = exists('b:mark_index') ? (b:mark_index + 1) % l:length : 0

    execute 'mark' nr2char(l:begin + b:mark_index)
  endfunction

  function! s:execute_keep_view(expr)
    let l:wininfo = winsaveview()
    execute a:expr
    call winrestview(l:wininfo)
  endfunction

  if exists('##TerminalOpen')
    Autocmd TerminalOpen *
          \  call term_setkill(   '%', '++kill=term')
          \| call term_setrestore('%', '++kill=term')
  endif

  " アプリウィンドウ操作
  if s:is_gui
    Autocmd WinEnter *
          \  if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&diff') == 1)
          \|   diffoff
          \|   call s:set_wide(1)
          \| endif

    command! -nargs=1 -complete=file Diff
          \  call s:set_wide(1)
          \| vertical diffsplit <args>

    noremap <silent> <leader>we <Cmd>call <SID>toggle_wide_window()<CR>
    noremap <silent> <leader>wf <Cmd>call <SID>full_window()<CR>

    " アプリケーションウィンドウを最大高さにする
    function! s:full_window()
      execute 'winpos' getwinposx() 0
      set lines=9999
    endfunction

    " 縦分割する
    function! s:toggle_wide_window()
      if !exists('s:is_wide')
        let s:is_wide = 0
      endif

      let s:is_wide = xor(s:is_wide, 1)
      call s:set_wide(s:is_wide)

      if s:is_wide == 1
        let s:org_pos = [getwinposx(), getwinposy()]
        execute 'botright vertical' s:base_columns 'split'
      else
        only
        execute 'winpos' s:org_pos[0] s:org_pos[1]
      endif
    endfunction

    function! s:set_wide(is_wide)
      let &columns = s:base_columns * (a:is_wide + 1)
    endfunction
  endif
endfunction
call timer_start(100, {-> s:settings()})

