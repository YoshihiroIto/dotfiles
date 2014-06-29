set nocompatible
set encoding=utf-8
scriptencoding utf-8
" 基本 {{{
" グローバル関数 {{{
function! IsWindows()
  if !exists('s:vimrc_isWindows')
    let s:vimrc_isWindows = has('win32') || has('win64')
  endif

  return s:vimrc_isWindows
endfunction

function! IsMac()
  if !exists('s:vimrc_isMac')
    let s:vimrc_isMac = has('mac')
  endif

  return s:vimrc_isMac
endfunction

function! IsGuiRunning()
  if !exists('s:vimrc_isGuiRunning')
    let s:vimrc_isGuiRunning = has('gui_running')
  endif

  return s:vimrc_isGuiRunning
endfunction
" }}}

if has('vim_starting')
  let s:git_dotvimrc  = expand('~/dotfiles/.vimrc')
  let s:git_dotgvimrc = expand('~/dotfiles/.gvimrc')

  if filereadable(s:git_dotvimrc)
    let $MYVIMRC = s:git_dotvimrc
  endif

  if filereadable(s:git_dotgvimrc)
    let $MYGVIMRC = s:git_dotgvimrc
  endif

  unlet s:git_dotvimrc
  unlet s:git_dotgvimrc
endif

let g:mapleader   = ','
let s:baseColumns = IsWindows() ? 140 : 120
let s:VimrcLocal  = expand('~/.vimrc_local')
let $DOTVIM       = expand('~/.vim')
set viminfo+=!

augroup MyAutoGroup
  autocmd!
augroup END

" 文字コード自動判断
if has('iconv')
  if has('guess_encode')
    set fileencodings=guess,iso-2022-jp,cp932,euc-jp,ucs-bom
  else
    set fileencodings=iso-2022-jp,cp932,euc-jp,ucs-bom
  endif
endif

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if IsWindows() && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
if IsMac()
  set iskeyword=@,48-57,_,128-167,224-235
  let $PATH = simplify($VIM . '/../../MacOS') . ':' . $PATH
endif

" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

" メニューを読み込まない
set guioptions+=M
let g:did_install_default_menus = 1

nnoremap [App] <Nop>
nmap     ;     [App]
" }}}
" プラグイン {{{
function! s:SetNeoBundle() " {{{
  " ライブラリ
  NeoBundle     'Shougo/vimproc'
  NeoBundle     'tpope/vim-dispatch'
  NeoBundle     'xolox/vim-misc'
  NeoBundleLazy 'xolox/vim-shell'
  NeoBundleLazy 'basyura/twibill.vim'
  NeoBundleLazy 'LeafCage/nebula.vim'
  NeoBundleLazy 'mattn/webapi-vim'
  NeoBundleLazy 'tyru/open-browser.vim'
  NeoBundleLazy 'kana/vim-submode'

  " 表示
  NeoBundle     'tomasr/molokai'
  NeoBundle     'Yggdroot/indentLine'
  NeoBundle     'itchyny/lightline.vim', {
        \         'depends': [
        \           'vimproc',
        \           'vim-fugitive',
        \           'vim-gitgutter',
        \           'vim-anzu',
        \           'syntastic'
        \         ]
        \       }
  NeoBundleLazy 'vim-scripts/matchparenpp'
  NeoBundleLazy 'majutsushi/tagbar'
  NeoBundleLazy 'LeafCage/foldCC'
  NeoBundleLazy 'movewin.vim'

  " 編集
  NeoBundleLazy 'tomtom/tcomment_vim'
  NeoBundleLazy 'tpope/vim-surround'
  NeoBundleLazy 'tpope/vim-repeat'
  NeoBundleLazy 'LeafCage/yankround.vim'
  NeoBundleLazy 'kana/vim-smartinput'
  NeoBundleLazy 'nishigori/increment-activator'
  NeoBundleLazy 'osyo-manga/vim-over'
  NeoBundleLazy 'thinca/vim-qfreplace'
  NeoBundleLazy 'junegunn/vim-easy-align'

  " 補完
  NeoBundleLazy 'Shougo/neocomplete.vim'
  NeoBundleLazy 'Shougo/neosnippet.vim'
  NeoBundleLazy 'Shougo/neosnippet-snippets'
  NeoBundleLazy 'nosami/Omnisharp'

  " ファイル
  NeoBundleLazy 'kana/vim-altr'
  NeoBundleLazy 'YoshihiroIto/vim-auto-mirroring'

  " 検索
  NeoBundleLazy 'matchit.zip'
  NeoBundleLazy 'osyo-manga/vim-anzu'
  NeoBundleLazy 'rhysd/clever-f.vim'
  NeoBundleLazy 'thinca/vim-visualstar'

  " 言語
  NeoBundleLazy 'YoshihiroIto/syntastic'
  NeoBundleLazy 'Rip-Rip/clang_complete'
  NeoBundleLazy 'rhysd/vim-clang-format'
  NeoBundleLazy 'osyo-manga/shabadou.vim'
  NeoBundleLazy 'vim-jp/cpp-vim'
  NeoBundle     'YoshihiroIto/vim-gocode'
  NeoBundleLazy 'dgryski/vim-godef'
  NeoBundleLazy 'Mizuchi/STL-Syntax'
  NeoBundleLazy 'beyondmarc/hlsl.vim'
  NeoBundleLazy 'tikhomirov/vim-glsl'
  NeoBundleLazy 'vim-ruby/vim-ruby'
  NeoBundleLazy 'vim-scripts/JSON.vim'
  NeoBundleLazy 'tpope/vim-markdown'
  NeoBundleLazy 'pangloss/vim-javascript'
  NeoBundleLazy 'kchmck/vim-coffee-script'
  NeoBundleLazy 'jelera/vim-javascript-syntax'
  NeoBundleLazy 'rhysd/wandbox-vim'
  NeoBundleLazy 'thinca/vim-quickrun'
  NeoBundleLazy 'kannokanno/previm'

  " テキストオブジェクト
  NeoBundleLazy 'kana/vim-textobj-user'
  NeoBundleLazy 'kana/vim-textobj-entire'
  NeoBundleLazy 'kana/vim-textobj-indent'
  NeoBundleLazy 'kana/vim-textobj-line'
  NeoBundleLazy 'rhysd/vim-textobj-word-column'
  NeoBundleLazy 'thinca/vim-textobj-comment'
  NeoBundleLazy 'sgur/vim-textobj-parameter'
  NeoBundleLazy 'rhysd/vim-textobj-anyblock'
  NeoBundleLazy 'h1mesuke/textobj-wiw'

  " オペレータ
  NeoBundleLazy 'kana/vim-operator-user'
  NeoBundleLazy 'kana/vim-operator-replace'
  NeoBundleLazy 'tyru/operator-camelize.vim'
  NeoBundleLazy 'emonkak/vim-operator-sort'
  NeoBundleLazy 'deris/vim-rengbang'

  " アプリ
  NeoBundleLazy 'tsukkee/lingr-vim'
  NeoBundleLazy 'tpope/vim-fugitive'
  NeoBundleLazy 'airblade/vim-gitgutter'
  NeoBundleLazy 'Shougo/vimshell.vim'
  NeoBundleLazy 'Shougo/vimfiler.vim'
  NeoBundleLazy 'basyura/TweetVim'
  NeoBundleLazy 'gregsexton/gitv'
  NeoBundleLazy 'glidenote/memolist.vim'
  if IsMac()
    NeoBundleLazy 'itchyny/dictionary.vim'
  endif
  if IsWindows() && IsGuiRunning()
    NeoBundleLazy 'YoshihiroIto/vim-icondrag'
  endif

  " Unite
  NeoBundleLazy 'Shougo/unite.vim'
  NeoBundleLazy 'Shougo/unite-outline'
  NeoBundleLazy 'osyo-manga/unite-quickfix'
  NeoBundleLazy 'osyo-manga/unite-fold'
  NeoBundleLazy 'Shougo/neomru.vim'
  NeoBundleLazy 'YoshihiroIto/vim-unite-giti'
  if IsWindows()
    NeoBundleLazy 'sgur/unite-everything'
  endif
endfunction " }}}

if has('vim_starting')
  set rtp+=$DOTVIM/bundle/neobundle.vim/
endif

call neobundle#begin(expand('$DOTVIM/bundle/'))

if neobundle#has_cache()
  NeoBundleLoadCache
else
  NeoBundleFetch 'Shougo/neobundle.vim'
  call s:SetNeoBundle()
  NeoBundleSaveCache
endif

call neobundle#end()
" ライブラリ {{{
" vimproc {{{
if neobundle#tap('vimproc')
  call neobundle#config({
        \   'autoload': {
        \     'function_prefix': 'vimproc',
        \   },
        \   'build': {
        \     'mac':  'make -f make_mac.mak',
        \     'unix': 'make -f make_unix.mak',
        \   },
        \ })

  call neobundle#untap()
endif
" }}}
" vim-shell {{{
if neobundle#tap('vim-shell')
  function! neobundle#hooks.on_source(bundle)
    let g:shell_mappings_enabled = 0
  endfunction

  call neobundle#untap()
endif
" }}}
" nebula.vim {{{
if neobundle#tap('nebula.vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': [
        \       'NebulaPutLazy',
        \       'NebulaPutFromClipboard',
        \       'NebulaYankOptions',
        \       'NebulaYankConfig',
        \       'NebulaPutConfig',
        \       'NebulaYankTap'
        \     ]
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" webapi-vim {{{
if neobundle#tap('webapi-vim')
  call neobundle#config({
        \   'autoload': {
        \     'function_prefix': 'webapi'
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" open-browser.vim {{{
if neobundle#tap('open-browser.vim')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'mappings': ['<Plug>(openbrowser-'],
        \     'commands': [
        \       {
        \         'name':     'OpenBrowserSearch',
        \         'complete': 'customlist,openbrowser#_cmd_complete'
        \       },
        \       {
        \         'name':     'OpenBrowserSmartSearch',
        \         'complete': 'customlist,openbrowser#_cmd_complete'
        \       },
        \       {
        \         'name':     'OpenBrowser',
        \         'complete': 'file'
        \       }
        \     ],
        \   }
        \ })

  let g:netrw_nogx                   = 1 " disable netrw's gx mapping.
  let g:openbrowser_no_default_menus = 1

  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  call neobundle#untap()
endif
" }}}
" vim-submode {{{
if neobundle#tap('vim-submode')
  call neobundle#config({
        \   'autoload': {
        \     'function_prefix': 'submode'
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    " todo:mac gvimで動作しない。なぜ？
    call submode#enter_with('gitgutter', 'n', 'r', '<Leader>j', '<Plug>GitGutterNextHunkzvzz')
    call submode#map(       'gitgutter', 'n', 'r', 'j',         '<Plug>GitGutterNextHunkzvzz')
    call submode#map(       'gitgutter', 'n', 'r', 'k',         '<Plug>GitGutterPrevHunkzvzz')
  endfunction

  call neobundle#untap()
endif
" }}}
" dictionary.vim {{{
if IsMac()
  if neobundle#tap('dictionary.vim')
    call neobundle#config({
          \   'autoload': {
          \     'commands': ['Dictionary']
          \   }
          \ })

    call neobundle#untap()
  endif
endif
" }}}
" }}}
" 表示 {{{
" tagbar {{{
if neobundle#tap('tagbar')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['TagbarToggle']
        \   }
        \ })

  noremap <silent> t :<C-u>TagbarToggle<CR>

  call neobundle#untap()
endif
" }}}
" foldCC {{{
if neobundle#tap('foldCC')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['vim', 'xml']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:foldCCtext_enable_autofdc_adjuster = 1
    set foldtext=foldCC#foldtext()
  endfunction

  call neobundle#untap()
endif
" }}}
" movewin.vim {{{
if neobundle#tap('movewin.vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['MoveWin']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" lightline {{{
let s:p = lightline#colorscheme#default#palette

let s:p.normal.left   = [['#195E00', '#07AF00', 'bold'], ['gray7', 'gray2']]
let s:p.normal.branch = [['white', 'gray4']]

let s:p.insert.left   = [['darkestcyan', 'white', 'bold'], ['mediumcyan', 'darkestblue']]
let s:p.insert.middle = [['mediumcyan', 'darkestblue']]
let s:p.insert.right  = [['darkestcyan', 'mediumcyan'], ['mediumcyan', 'darkblue'], ['mediumcyan', 'darkestblue']]
let s:p.insert.branch = [['white', 'darkblue']]

let s:p.visual.left   = [['#AB2362', 'white', 'bold'], ['#FF84BA', '#870036']]
let s:p.visual.middle = [['#FF84BA', '#870036']]
let s:p.visual.right  = [['#75003D', '#FF87BB'], ['#FE86BB', '#AF0053'], ['#FF84BA', '#870036']]
let s:p.visual.branch = [['white', '#AF0053']]

let g:lightline#colorscheme#yoi#palette = lightline#colorscheme#fill(s:p)

unlet s:p

let g:lightline = {
      \   'colorscheme': 'yoi',
      \   'active': {
      \     'left': [
      \       ['mode',   'paste'],
      \       ['branch', 'gitgutter', 'filename', 'anzu']
      \     ],
      \     'right': [
      \       ['syntastic', 'lineinfo'],
      \       ['percent']
      \     ]
      \   },
      \   'component': {
      \     'percent':  '⭡%3p%%',
      \     'lineinfo': '%4l/%L : %-3v'
      \   },
      \   'component_function': {
      \     'fileformat':   'MyFileformat',
      \     'filetype':     'MyFiletype',
      \     'fileencoding': 'MyFileencoding',
      \     'modified':     'MyModified',
      \     'readonly':     'MyReadonly',
      \     'filename':     'MyFilename',
      \     'mode':         'MyMode',
      \     'anzu':         'anzu#search_status'
      \   },
      \   'component_expand': {
      \     'syntastic':    'SyntasticStatuslineFlag',
      \     'branch':       'GetCurrentBranch',
      \     'gitgutter':    'MyGitGutter',
      \   },
      \   'component_type': {
      \     'syntastic':    'error',
      \     'branch':       'branch',
      \     'gitgutter':    'branch'
      \   },
      \   'separator': {
      \     'left':  '⮀',
      \     'right': '⮂'
      \   },
      \   'subseparator': {
      \     'left':  '⮁',
      \     'right': '⮃'
      \   },
      \   'tabline': {
      \     'left':  [
      \       ['tabs']
      \     ],
      \     'right': [
      \       ['filetype', 'fileformat', 'fileencoding']
      \     ]
      \   },
      \   'tabline_separator': {
      \     'left':  '⮀',
      \     'right': '⮂'
      \   },
      \   'tabline_subseparator': {
      \     'left':  '⮁',
      \     'right': '⮃'
      \   },
      \   'mode_map': {
      \     'n':     'N',
      \     'i':     'I',
      \     'R':     'R',
      \     'v':     'V',
      \     'V':     'VL',
      \     'c':     'C',
      \     '<C-v>': 'VB',
      \     's':     'S',
      \     'S':     'SL',
      \     '<C-s>': 'SB',
      \     '?':     ' '
      \   }
      \ }

function! MyMode()
  return  &ft ==  'unite'    ? 'Unite'    :
        \ &ft ==  'vimfiler' ? 'VimFiler' :
        \ &ft ==  'vimshell' ? 'VimShell' :
        \ &ft ==  'tweetvim' ? 'TweetVim' :
        \ &ft ==  'quickrun' ? 'quickrun' :
        \ &ft =~? 'lingr'    ? 'lingr'    :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let s:lightlineNoDispFt = 'vimfiler\|unite\|vimshell\|tweetvim\|quickrun\|lingr'

function! MyModified()
  return &ft =~ s:lightlineNoDispFt ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? s:lightlineNoDispFt && &readonly ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft ==  'vimfiler'  ? vimfiler#get_status_string() :
        \  &ft ==  'unite'     ? unite#get_status_string() :
        \  &ft ==  'vimshell'  ? vimshell#get_status_string() :
        \  &ft =~? 'lingr'     ? lingr#status() :
        \  &ft ==  'tweetvim'  ? '' :
        \  &ft ==  'quickrun'  ? '' :
        \ ''  != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified()  ? ' ' . MyModified() : '')
endfunction

function! GetCurrentBranch()

  if &ft =~? s:lightlineNoDispFt
    return ''
  endif

  if !s:IsInGitBranch()
    return ''
  endif

  if &ft !~? 'vimfiler'
    let _ = fugitive#head()
    return strlen(_) ? '⭠ ' . _ : ''
  endif

  return ''
endfunction

function! MyFileformat()

  if &ft =~? s:lightlineNoDispFt
    return ''
  endif

  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()

  if &ft =~? s:lightlineNoDispFt
    return ''
  endif

  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()

  if &ft =~? s:lightlineNoDispFt
    return ''
  endif

  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

augroup MyAutoGroup
  autocmd CursorHold,CursorHoldI * call lightline#update()
augroup END

" http://qiita.com/yuyuchu3333/items/20a0acfe7e0d0e167ccc
function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif

  if !s:IsInGitBranch()
    return ''
  endif

  if &ft =~? s:lightlineNoDispFt
    return ''
  endif

  let symbols = [g:gitgutter_sign_added, g:gitgutter_sign_modified, g:gitgutter_sign_removed]
  let hunks   = GitGutterGetHunkSummary()
  let ret     = []

  for i in [0, 1, 2]
    call add(ret, symbols[i] . hunks[i])
  endfor

  return join(ret, ' ')
endfunction
" }}}
" indentLine {{{
let g:indentLine_fileType    = ['c', 'cpp', 'cs', 'ruby', 'vim', 'go', 'json', 'glsl', 'hlsl', 'xml', 'markdown']
let g:indentLine_faster      = 1
let g:indentLine_color_term  = 0
let g:indentLine_indentLevel = 20
let g:indentLine_char        = '⭟'
let g:indentLine_color_gui   = '#505050'

augroup MyAutoGroup
  autocmd BufReadPost * call s:SafeIndentLinesEnable()

  function! s:SafeIndentLinesEnable()
    if !exists(':IndentLinesEnable')
      NeoBundleSource indentLine
    endif

    IndentLinesEnable
  endfunction
augroup END
" }}}
" }}}
" 編集 {{{
" vim-easy-align {{{
if neobundle#tap('vim-easy-align')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['EasyAlign', 'LiveEasyAlign'],
        \     'mappings': [
        \       '<Plug>(EasyAlignOperator)',
        \       ['sxn', '<Plug>(EasyAlign)'],
        \       ['sxn', '<Plug>(LiveEasyAlign)'],
        \       ['sxn', '<Plug>(EasyAlignRepeat)']
        \     ]
        \   }
        \ })

  nmap <Leader>m <Plug>(EasyAlign)
  vmap <Leader>m <Plug>(EasyAlign)

  nmap <silent> <Leader>a=       vii<Leader>m=
  nmap <silent> <Leader>a:       vii<Leader>m:
  nmap <silent> <Leader>a,       vii<Leader>m*,
  nmap <silent> <Leader>a<Space> vii<Leader>m*<Space>
  xmap <silent> <Leader>a=       <Leader>m=
  xmap <silent> <Leader>a:       <Leader>m:
  xmap <silent> <Leader>a,       <Leader>m*,
  xmap <silent> <Leader>a<Space> <Leader>m*<Space>

  call neobundle#untap()
endif
" }}}
" yankround {{{
if neobundle#tap('yankround.vim')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': ['<Plug>(yankround-'],
        \   }
        \ })

  nmap p     <Plug>(yankround-p)
  xmap p     <Plug>(yankround-p)
  nmap P     <Plug>(yankround-P)
  nmap gp    <Plug>(yankround-gp)
  xmap gp    <Plug>(yankround-gp)
  nmap gP    <Plug>(yankround-gP)
  nmap <C-p> <Plug>(yankround-prev)
  nmap <C-n> <Plug>(yankround-next)

  function! neobundle#hooks.on_source(bundle)
    let g:yankround_use_region_hl = 1
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-smartinput {{{
if neobundle#tap('vim-smartinput')
  call neobundle#config({
        \   'autoload': {
        \     'insert': 1,
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    call smartinput#clear_rules()
    call smartinput#define_default_rules()
  endfunction

  call neobundle#untap()
endif
" }}}
" increment-activator {{{
if neobundle#tap('increment-activator')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': ['<C-x>', '<C-a>']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:increment_activator_filetype_candidates = {
          \   '_':   [['width', 'height']],
          \   'cs':  [['private', 'protected', 'public', 'internal']],
          \   'cpp': [['private', 'protected', 'public']],
          \ }
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-over {{{
if neobundle#tap('vim-over')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['OverCommandLineNoremap', 'OverCommandLine']
        \   }
        \ })

  noremap <silent> <Leader>s :OverCommandLine<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:over_command_line_key_mappings = {
          \   '\<C-j>': '\<Esc>',
          \ }
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-qfreplace' {{{
if neobundle#tap('vim-qfreplace')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['unite', 'quickfix'],
        \     'commands':  ['Qfreplace']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" }}}
" 補完 {{{
" neocomplete.vim {{{
if neobundle#tap('neocomplete.vim')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'insert': 1,
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup       = 1
    let g:neocomplete#enable_ignore_case      = 1
    let g:neocomplete#enable_smart_case       = 1
    let g:neocomplete#enable_auto_delimiter   = 1
    let g:neocomplete#enable_fuzzy_completion = 1
    let g:neocomplete#enable_refresh_always   = 1
    let g:neocomplete#enable_prefetch         = 1

    let g:neocomplete#auto_completion_start_length      = 3
    let g:neocomplete#manual_completion_start_length    = 0
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#min_keyword_length                = 3
    let g:neocomplete#force_overwrite_completefunc      = 1
    let g:neocomplete#skip_auto_completion_time         = ''

    let g:neocomplete#sources#dictionary#dictionaries = {
          \   'default':  '',
          \   'vimshell': $HOME . '/.vimshell_hist'
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
          \   'c':    '\%(\.\|->\)\h\w*',
          \   'cpp':  '\h\w*\%(\.\|->\)\h\w*\|\h\w*::',
          \   'cs':   '[a-zA-Z0-9.]\{2\}',
          \   'ruby': '[^. *\t]\.\w*\|\h\w*::'
          \ }

    let g:neocomplete#force_omni_input_patterns = {
          \   'c':      '[^.[:digit:] *\t]\%(\.\|->\)\w*',
          \   'cpp':    '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*',
          \   'objc':   '[^.[:digit:] *\t]\%(\.\|->\)\w*',
          \   'objcpp': '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*',
          \   'cs':     '[^.[:digit:] *\t]\%(\.\)\w*\|\h\w*::\w*'
          \ }

    let g:neocomplete#delimiter_patterns = {
          \   'c':   ['.', '->'],
          \   'cpp': [' ::', '.'],
          \   'cs':  ['.'],
          \   'vim': ['#', '.']
          \ }

    let g:neocomplete#sources#file_include#exts = {
          \   'c':   ['', 'h'],
          \   'cpp': ['', 'h', 'hpp', 'hxx'],
          \   'cs':  ['', 'Designer.cs']
          \ }
  endfunction

  call neobundle#untap()
endif
" }}}
" neosnippet.vim {{{
if neobundle#tap('neosnippet.vim')
  call neobundle#config({
        \   'depends':  ['neosnippet-snippets', 'neocomplete.vim'],
        \   'autoload': {
        \     'insert': 1,
        \     'filetypes': ['neosnippet'],
        \     'commands': [
        \       'NeoSnippetClearMarkers',
        \       {
        \         'name':     'NeoSnippetSource',
        \         'complete': 'file'
        \       },
        \       {
        \         'name':     'NeoSnippetMakeCache',
        \         'complete': 'customlist,neosnippet#commands#_filetype_complete'
        \       },
        \       {
        \          'name':     'NeoSnippetEdit',
        \          'complete': 'customlist,neosnippet#commands#_edit_complete'
        \       }
        \     ],
        \     'mappings': [['sxi', '<Plug>(neosnippet_']],
        \     'unite_sources': [
        \       'neosnippet',
        \       'neosnippet_file',
        \       'neosnippet_target'
        \     ]
        \   }
        \ })

  imap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : pumvisible() ? '<C-n>' : '<Tab>'
  smap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'

  function! neobundle#hooks.on_source(bundle)
    let g:neosnippet#enable_snipmate_compatibility = 1
    let g:neosnippet#snippets_directory            = '$DOTVIM/snippets'

    if isdirectory(expand('$DOTVIM/snippets.local'))
      let g:neosnippet#snippets_directory = '$DOTVIM/snippets.local,' . g:neosnippet#snippets_directory
    endif

    call neocomplete#custom#source('neosnippet', 'rank', 1000)

    " for snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif
  endfunction

  call neobundle#untap()
endif
" }}}
" Omnisharp {{{
if neobundle#tap('Omnisharp')
  call neobundle#config({
        \   'depends':  ['neocomplete.vim', 'syntastic', 'vim-dispatch'],
        \   'autoload': {
        \     'filetypes': ['cs']
        \   },
        \   'build': {
        \     'windows': 'C:/Windows/Microsoft.NET/Framework/v4.0.30319/MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
        \     'mac':     'xbuild server/OmniSharp.sln',
        \     'unix':    'xbuild server/OmniSharp.sln',
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:Omnisharp_stop_server         = 0
    let g:OmniSharp_typeLookupInPreview = 1
  endfunction

  call neobundle#untap()
endif
" }}}
" }}}
" ファイル {{{
" vim-altr {{{
if neobundle#tap('vim-altr')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': [['scxino', '<Plug>(altr-']]
        \   }
        \ })

  nmap <F5> <Plug>(altr-forward)
  nmap <F6> <Plug>(altr-back)

  function! neobundle#hooks.on_source(bundle)
    call altr#define('Models/%Model.cs',       'ViewModels/%Vm.cs',       'Views/%.xaml',       'Views/%.xaml.cs')
    call altr#define('Models/*/%Model.cs',     'ViewModels/*/%Vm.cs',     'Views/*/%.xaml',     'Views/*/%.xaml.cs')
    call altr#define('Models/*/*/%Model.cs',   'ViewModels/*/*/%Vm.cs',   'Views/*/*/%.xaml',   'Views/*/*/%.xaml.cs')
    call altr#define('Models/*/*/*/%Model.cs', 'ViewModels/*/*/*/%Vm.cs', 'Views/*/*/*/%.xaml', 'Views/*/*/*/%.xaml.cs')
    call altr#define('%Model.cs',              '%Vm.cs',                  '%.xaml',             '%.xaml.cs')
  endfunction

  call neobundle#untap()
endif
" }}}
" }}}
" 検索 {{{
" vim-anzu {{{
if neobundle#tap('vim-anzu')
  nmap <silent> n <Plug>(anzu-n)zvzz:<C-u>call <SID>BeginDisplayAnzu()<CR>:<C-u>call <SID>RefreshScreen()<CR>
  nmap <silent> N <Plug>(anzu-N)zvzz:<C-u>call <SID>BeginDisplayAnzu()<CR>:<C-u>call <SID>RefreshScreen()<CR>
  nmap <silent> * <Plug>(anzu-star):<C-u>call  <SID>RefreshScreen()<CR>
  nmap <silent> # <Plug>(anzu-sharp):<C-u>call <SID>RefreshScreen()<CR>

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoGroup
      " 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
      " 検索ヒット数の表示を消去する
      autocmd CursorHold,CursorHoldI * call s:UpdateDisplayAnzu()
      autocmd WinLeave,TabLeave      * call s:ClearDisplayAnzu()

      " anzuを表示する時間
      let s:anzuDisplayTime = 2000

      let s:anzuDisplayCount = 0
      function! s:BeginDisplayAnzu()
        let s:anzuDisplayCount = s:anzuDisplayTime / &updatetime
      endfunction

      function! s:UpdateDisplayAnzu()
        if s:anzuDisplayCount >= 0
          let s:anzuDisplayCount = s:anzuDisplayCount - 1

          call s:ContinueCursorHold()
        else
          call s:ClearDisplayAnzu()
        endif
      endfunction

      function! s:ClearDisplayAnzu()
        " let s:anzuDisplayCount = 0
        call anzu#clear_search_status()
      endfunction
    augroup END
  endfunction

  call neobundle#untap()
endif
" }}}
" clever-f.vim {{{
if neobundle#tap('clever-f.vim')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': 'f',
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:clever_f_ignore_case           = 1
    let g:clever_f_smart_case            = 1
    let g:clever_f_across_no_line        = 1
    let g:clever_f_use_migemo            = 1
    let g:clever_f_chars_match_any_signs = ';'
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-visualstar {{{
if neobundle#tap('vim-visualstar')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': ['<Plug>(visualstar-']
        \   }
        \ })

  map *  <Plug>(visualstar-*)
  map #  <Plug>(visualstar-#)
  map g* <Plug>(visualstar-g*)
  map g# <Plug>(visualstar-g#)

  call neobundle#untap()
endif
" }}}
" }}}
" 言語 {{{
" syntastic {{{
if neobundle#tap('syntastic')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['ruby', 'cs']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:syntastic_cs_checkers = ['syntax', 'issues']

    augroup MyAutoGroup
      autocmd BufWritePost *.{go,rb,cs} call s:SyntasticCheck()
    augroup END
  endfunction

  call neobundle#untap()
endif

function! s:SyntasticCheck()

  let syntastic_ft = 'ruby\|cs'

  " if &ft =~? syntastic_ft
  "   if exists(':SyntasticCheck')
  "     SyntasticCheck
  "   endif
  "
  "   call lightline#update()
  " endif

  call lightline#update()
endfunction
" }}}
" clang_complete {{{
if neobundle#tap('clang_complete')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['c', 'cpp', 'objc']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:clang_use_library   = 1
    let g:clang_complete_auto = 0
    let g:clang_auto_select   = 0

    if IsWindows()
      let g:clang_user_options = '-I C:/Development/boost_1_55_0 -I "C:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include" -std=c++11 -fms-extensions -fmsc-version=1300 -fgnu-runtime -D__MSVCRT_VERSION__=0x700 -D_WIN32_WINNT=0x0500 2> NUL || exit 0"'
      let g:clang_library_path = 'C:/Development/llvm/build/bin/Release/'
    elseif IsMac()
      let g:clang_user_options = '-std=c++11'
    endif
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-clang-format {{{
if neobundle#tap('vim-clang-format')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['c', 'cpp', 'objc']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    if IsWindows()
      let g:clang_format#command = 'C:/Development/llvm/build/bin/Release/clang-format'
    else
      let g:clang_format#command = 'clang-format-3.4'
    endif

    let g:clang_format#style_options = {
          \   'AccessModifierOffset':                -4,
          \   'ColumnLimit':                         120,
          \   'AllowShortIfStatementsOnASingleLine': 'true',
          \   'AlwaysBreakTemplateDeclarations':     'true',
          \   'Standard':                            'C++11',
          \   'BreakBeforeBraces':                   'Stroustrup',
          \ }

    let g:clang_format#code_style = 'Chromium'

    command! -range=% -nargs=0 CppFormat call clang_format#replace(<line1>, <line2>)
  endfunction

  call neobundle#untap()
endif
" }}}
" wandbox-vim {{{
if neobundle#tap('wandbox-vim')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'filetypes': ['c', 'cpp', 'objc'],
        \     'commands': [
        \       {
        \         'name':     'WandboxAsync',
        \         'complete': 'customlist,wandbox#complete_command'
        \       },
        \       {
        \         'name':     'WandboxSync',
        \         'complete': 'customlist,wandbox#complete_command'
        \       },
        \       {
        \         'name':     'Wandbox',
        \         'complete': 'customlist,wandbox#complete_command'
        \       },
        \       'WandboxOptionList',
        \       'WandboxOpenBrowser',
        \       'WandboxOptionListAsync',
        \       'WandboxAbortAsyncWorks'
        \     ]
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    " wandbox.vim で quickfix を開かないようにする
    let g:wandbox#open_quickfix_window = 0

    let g:wandbox#default_compiler = {
          \   'cpp' : 'clang-head',
          \ }
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-quickrun {{{
if neobundle#tap('vim-quickrun')
  call neobundle#config({
        \   'depends':  ['shabadou.vim', 'wandbox-vim', 'vimproc'],
        \   'autoload': {
        \     'mappings': [['sxn', '<Plug>(quickrun']],
        \     'commands': [
        \       {
        \         'complete': 'customlist,quickrun#complete',
        \         'name':     'QuickRun'
        \       }
        \     ]
        \   }
        \ })

  map <silent> [App]r :<C-u>QuickRun<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:quickrun_config = {
          \   '_': {
          \     'hook/close_unite_quickfix/enable_hook_loaded': 1,
          \     'hook/unite_quickfix/enable_failure':           1,
          \     'hook/close_quickfix/enable_exit':              1,
          \     'hook/close_buffer/enable_failure':             1,
          \     'hook/close_buffer/enable_empty_data':          1,
          \     'outputter':                                    'multi:buffer:quickfix',
          \     'runner':                                       'vimproc',
          \     'runner/vimproc/updatetime':                    40,
          \   },
          \   'cpp/wandbox': {
          \     'runner':                                       'wandbox',
          \     'runner/wandbox/compiler':                      'clang-head',
          \     'runner/wandbox/options':                       'warning,c++1y,boost-1.55',
          \   },
          \   'json': {
          \     'command':                                      'jq',
          \     'exec':                                         "%c '.' %s"
          \   },
          \   'lua': {
          \     'type':                                         'lua/vim'
          \   }
          \ }
  endfunction

  call neobundle#untap()
endif
" }}}
" cpp-vim {{{
if neobundle#tap('cpp-vim')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['cpp']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-gocode {{{
if neobundle#tap('vim-gocode')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'filetypes': ['go']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    if IsWindows()
      let g:gocomplete#system_function = 'vimproc#system'
    endif

    let g:gofmt_command   = 'goimports'
    let g:go_fmt_autofmt  = 0
    let g:go_fmt_commands = 0
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-godef {{{
if neobundle#tap('vim-godef')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'filetypes': ['go']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:godef_split                    = 0
    let g:godef_same_file_in_same_window = 1
    let g:godef_system_function          = 'vimproc#system'
  endfunction

  call neobundle#untap()
endif
" }}}
" STL-Syntax {{{
if neobundle#tap('STL-Syntax')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['cpp']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" hlsl.vim {{{
if neobundle#tap('hlsl.vim')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['hlsl']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-glsl {{{
if neobundle#tap('vim-glsl')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['glsl']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-ruby {{{
if neobundle#tap('vim-ruby')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['ruby']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" JSON.vim {{{
if neobundle#tap('JSON.vim')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['json', 'markdown']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-markdown {{{
if neobundle#tap('vim-markdown')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['markdown']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:markdown_fenced_languages = ['c', 'cpp', 'cs', 'ruby', 'vim', 'go', 'json']
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-javascript {{{
if neobundle#tap('vim-javascript.vim')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['javascript']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-coffee-script {{{
if neobundle#tap('vim-coffee-script')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['coffee']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-javascript-syntax {{{
if neobundle#tap('vim-javascript-syntax')
  call neobundle#config({
        \   'autoload': {
        \     'filetypes': ['javascript']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" previm {{{
if neobundle#tap('previm')
  call neobundle#config({
        \   'depends':  ['open-browser.vim'],
        \   'autoload': {
        \     'filetypes': ['markdown']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" }}}
" テキストオブジェクト {{{
" http://d.hatena.ne.jp/osyo-manga/20130717/1374069987
" vim-textobj-entire {{{
if neobundle#tap('vim-textobj-entire')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ae'], ['xo', 'ie']]
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-textobj-indent {{{
if neobundle#tap('vim-textobj-indent')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']]
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-textobj-line {{{
if neobundle#tap('vim-textobj-line')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'al'], ['xo', 'il']]
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-textobj-word-column {{{
if neobundle#tap('vim-textobj-word-column')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'av'], ['xo', 'aV'], ['xo', 'iv'], ['xo', 'iV']]
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-textobj-comment {{{
if neobundle#tap('vim-textobj-comment')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ac'], ['xo', 'ic']]
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-textobj-parameter {{{
if neobundle#tap('vim-textobj-parameter')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', '<Plug>(textobj-parameter']]
        \   }
        \ })

  xmap aa <Plug>(textobj-parameter-a)
  xmap ia <Plug>(textobj-parameter-i)
  omap aa <Plug>(textobj-parameter-a)
  omap ia <Plug>(textobj-parameter-i)

  call neobundle#untap()
endif
" }}}
" vim-textobj-anyblock {{{
if neobundle#tap('vim-textobj-anyblock')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ab'], ['xo', 'ib']]
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" textobj-wiw {{{
if neobundle#tap('textobj-wiw')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', '<Plug>(textobj-wiw']]
        \   }
        \ })

  xmap a. <Plug>(textobj-wiw-a)
  xmap i. <Plug>(textobj-wiw-i)
  omap a. <Plug>(textobj-wiw-a)
  omap i. <Plug>(textobj-wiw-i)

  call neobundle#untap()
endif
" }}}
" }}}
" オペレータ {{{
" http://qiita.com/rbtnn/items/a47ed6684f1f0bc52906
" vim-operator-replace {{{
if neobundle#tap('vim-operator-replace')
  call neobundle#config({
        \   'depends':  ['vim-operator-user'],
        \   'autoload': {
        \     'mappings': [['nx', '<Plug>(operator-replace)']]
        \   }
        \ })

  nmap R         <Plug>(operator-replace)
  xmap R         <Plug>(operator-replace)

  call neobundle#untap()
endif
" }}}
" operator-camelize.vim {{{
if neobundle#tap('operator-camelize.vim')
  call neobundle#config({
        \   'depends':  ['vim-operator-user'],
        \   'autoload': {
        \     'mappings': [['nx', '<Plug>(operator-camelize-toggle)']]
        \   }
        \ })

  nmap <Leader>c <Plug>(operator-camelize-toggle)iw
  xmap <Leader>c <Plug>(operator-camelize-toggle)iw

  call neobundle#untap()
endif
" }}}
" vim-operator-sort {{{
if neobundle#tap('vim-operator-sort')
  call neobundle#config({
        \   'depends':  ['vim-operator-user'],
        \   'autoload': {
        \     'mappings': [['nx', '<Plug>(operator-sort']]
        \   }
        \ })

  nmap <Leader>o <Plug>(operator-sort)
  xmap <Leader>o <Plug>(operator-sort)

  call neobundle#untap()
endif
" }}}
" vim-rengbang {{{
if neobundle#tap('vim-vim-rengbang-sort')
  call neobundle#config({
        \   'depends':  ['vim-operator-user'],
        \   'autoload': {
        \     'commands': ['RengBang'],
        \     'mappings': [['nx', '<Plug>(operator-rengbang']]
        \   }
        \ })

  nmap <Leader>r <Plug>(operator-rengbang)
  xmap <Leader>r <Plug>(operator-rengbang)

  call neobundle#untap()
endif
" }}}
" }}}
" アプリ {{{
" lingr-vim {{{
if neobundle#tap('lingr-vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['LingrLaunch']
        \   }
        \ })

  noremap <silent> [App]1 :<C-u>call <SID>ToggleLingr()<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:lingr_vim_say_buffer_height = 15

    augroup MyAutoGroup
      autocmd FileType lingr-rooms    call s:SetLingr()
      autocmd FileType lingr-members  call s:SetLingr()
      autocmd FileType lingr-messages call s:SetLingr()

      function! s:SetLingr()
        let b:disableSmartClose = 0

        noremap  <silent><buffer> <Leader>w :<C-u>call <SID>ToggleLingr()<CR>
        nnoremap <silent><buffer> q         :<C-u>call <SID>ToggleLingr()<CR>

        setlocal nolist
      endfunction
    augroup END
  endfunction

  function! s:ToggleLingr()
    if bufnr('lingr-messages') == -1
      tabnew
      LingrLaunch
      execute 'wincmd l'
    else
      LingrExit
    endif
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-fugitive {{{
if neobundle#tap('vim-fugitive')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'insert':          1,
        \     'function_prefix': 'fugitive'
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoGroup
      autocmd FocusGained,FocusLost * call s:UpdateFugitive()
    augroup END
  endfunction

  call neobundle#untap()
endif

function! s:UpdateFugitive()
  call fugitive#detect(expand('<amatch>:p'))

  call s:SyntasticCheck()
endfunction
" }}}
" vim-gitgutter {{{
if neobundle#tap('vim-gitgutter')
  call neobundle#config({
        \   'depends':  ['vim-shell'],
        \   'autoload': {
        \     'function_prefix': 'GitGutter'
        \   }
        \ })

  nmap <F7> <Plug>GitGutterNextHunkzvzz
  nmap <F8> <Plug>GitGutterPrevHunkzvzz

  function! neobundle#hooks.on_source(bundle)
    let g:gitgutter_map_keys  = 0
    let g:gitgutter_eager     = 0
    let g:gitgutter_diff_args = '-w'
  endfunction

  call neobundle#untap()
endif
" }}}
" vimshell.vim {{{
if neobundle#tap('vimshell.vim')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'commands': ['VimShell', 'VimShellPop']
        \   }
        \ })

  noremap <silent> [App]s :<C-u>VimShellPop<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:vimshell_popup_height = 40
  endfunction

  call neobundle#untap()
endif
" }}}
" vimfiler.vim {{{
if neobundle#tap('vimfiler.vim')
  call neobundle#config({
        \   'depends':  ['vimproc', 'unite.vim', 'vimshell.vim'],
        \   'autoload': {
        \     'commands': ['VimFilerBufferDir'],
        \   }
        \ })

  noremap <silent> [App]f :<C-u>VimFilerBufferDir<CR>

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoGroup
      autocmd FileType vimfiler call s:SetVimfiler()

      " http://qiita.com/Linda_pp/items/f1cb09ac94202abfba0e
      autocmd FileType vimfiler nnoremap <silent><buffer> / :<C-u>Unite file -horizontal -default-action=vimfiler<CR>

      function! s:SetVimfiler()
        nmap <buffer><expr> <CR>  vimfiler#smart_cursor_map('<Plug>(vimfiler_cd_file)', '<Plug>(vimfiler_edit_file)')
        nmap <buffer><expr> <C-j> vimfiler#smart_cursor_map('<Plug>(vimfiler_exit)',    '<Plug>(vimfiler_exit)')

        " dotfile表示状態に設定
        execute ':normal .'
      endfunction
    augroup END

    let g:vimfiler_as_default_explorer        = 1
    let g:vimfiler_force_overwrite_statusline = 0
    let g:vimfiler_tree_leaf_icon             = ' '
    let g:vimfiler_enable_auto_cd             = 1
    let g:unite_kind_file_use_trashbox        = 1
  endfunction

  call neobundle#untap()
endif
" }}}
" Tweetvim {{{
if neobundle#tap('TweetVim')
  call neobundle#config({
        \   'depends':  ['vimproc', 'twibill.vim', 'open-browser.vim', 'webapi-vim'],
        \   'autoload': {
        \     'commands': ['TweetVimHomeTimeline', 'TweetVimUserStream']
        \   }
        \ })

  noremap <silent> [App]2 :<C-u>call <SID>ToggleTweetVim()<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:tweetvim_include_rts       = 1
    let g:tweetvim_display_separator = 0
    let g:tweetvim_tweet_per_page    = 30
    let g:tweetvim_display_icon      = 1

    augroup MyAutoGroup
      autocmd FileType tweetvim call s:SetTweetVim()

      function! s:SetTweetVim()
        nmap     <silent><buffer> rr <Plug>(tweetvim_action_reload)
        nnoremap <silent><buffer> q  :<C-u>call <SID>ToggleTweetVim()<CR>
      endfunction
    augroup END
  endfunction

  function! s:ToggleTweetVim()
    if bufnr('tweetvim') == -1
      tabnew
      TweetVimHomeTimeline
    else
      silent! execute 'bwipeout tweetvim'
    endif
  endfunction

  call neobundle#untap()
endif
" }}}
" gitv {{{
if neobundle#tap('gitv')
  call neobundle#config({
        \   'depends':  ['vim-fugitive'],
        \   'autoload': {
        \     'commands': ['Gitv', 'Gitv!']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" memolist {{{
if neobundle#tap('memolist.vim')
  call neobundle#config({
        \   'depends':  ['unite.vim'],
        \   'autoload': {
        \     'commands': ['MemoNew', 'MemoList', 'MemoGrep']
        \   }
        \ })

  noremap <silent> [App]mn :<C-u>MemoNew<CR>
  noremap <silent> [App]ml :<C-u>MemoList<CR>
  noremap <silent> [App]mg :<C-u>MemoGrep<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:memolist_unite        = 1
    let g:memolist_path         = expand('~/Dropbox/memo')
    let g:memolist_memo_suffix  = 'md'
  endfunction

  call neobundle#untap()
endif
" }}}
" }}}
" Unite {{{
" unite.vim {{{
if neobundle#tap('unite.vim')
  call neobundle#config({
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'commands': ['Unite', 'UniteResume', 'UniteWithCursorWord']
        \   }
        \ })

  nnoremap [Unite] <Nop>
  xnoremap [Unite] <Nop>
  nmap     <Space> [Unite]
  xmap     <Space> [Unite]

  nnoremap <silent> [Unite]g  :<C-u>Unite grep -auto-preview -no-split -buffer-name=search-buffer<CR>
  nnoremap <silent> [Unite]pg :<C-u>call <SID>unite_grep_project('-auto-preview -no-split -buffer-name=search-buffer')<CR>
  nnoremap <silent> [Unite]r  :<C-u>UniteResume -no-split search-buffer<CR>

  nnoremap <silent> [Unite]f  :<C-u>Unite buffer<CR>
  nnoremap <silent> [Unite]t  :<C-u>Unite tab<CR>
  nnoremap <silent> [Unite]l  :<C-u>Unite -no-split line<CR>
  nnoremap <silent> [Unite]o  :<C-u>Unite outline<CR>
  nnoremap <silent> [Unite]z  :<C-u>Unite fold<CR>
  nnoremap <silent> [Unite]q  :<C-u>Unite -no-quit quickfix<CR>
  nnoremap <silent> [Unite]v  :<C-u>call <SID>ExecuteIfOnGitBranch('Unite giti')<CR>
  nnoremap <silent> [Unite]b  :<C-u>call <SID>ExecuteIfOnGitBranch('Unite giti/branch_all')<CR>

  if IsWindows()
    nnoremap <silent> [Unite]m  :<C-u>Unite -no-split neomru/file everything<CR>
  else
    nnoremap <silent> [Unite]m  :<C-u>Unite -no-split neomru/file<CR>
  endif

  nnoremap          [Unite]uu :<C-u>NeoBundleUpdate<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>
  nnoremap          [Unite]ui :<C-u>NeoBundleInstall<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>
  nnoremap          [Unite]uc :<C-u>NeoBundleClearCache<CR>

  " http://sanrinsha.lolipop.jp/blog/2013/03/%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E5%86%85%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92unite-grep%E3%81%99%E3%82%8B.html
  function! s:unite_grep_project(...)
    let opts = (a:0 ? join(a:000, ' ') : '')
    let dir = unite#util#path2project_directory(expand('%'))
    execute 'Unite' opts 'grep:' . dir
  endfunction

  function! neobundle#hooks.on_source(bundle)
    let g:unite_force_overwrite_statusline = 0

    " http://blog.monochromegane.com/blog/2014/01/16/the-platinum-searcher/
    " https://github.com/monochromegane/the_platinum_searcher
    if executable('pt')
      let g:unite_source_grep_command       = 'pt'
      let g:unite_source_grep_default_opts  = '--nogroup --nocolor -S'
      let g:unite_source_grep_recursive_opt = ''
      let g:unite_source_grep_encoding      = 'utf-8'

      let g:unite_source_rec_async_command  = 'pt --nocolor --nogroup -g .'
    endif

    call unite#custom#profile('default', 'context', {
        \   'direction':        'rightbelow',
        \   'prompt_direction': 'top',
        \   'vertical':         0,
        \   'start_insert':     1
        \ })

    call unite#custom#profile('source/outline,source/fold,source/giti,source/giti/branch_all', 'context', {
        \   'vertical': 1
        \ })

    call unite#custom#profile('default', 'ignorecase', 1)
    call unite#custom#profile('default', 'smartcase',  1)
    call unite#custom#source( 'fold',    'matchers',   'matcher_migemo')
  endfunction

  call neobundle#untap()
endif
" }}}
" unite-outline {{{
if neobundle#tap('unite-outline')
  call neobundle#config({
        \   'depends':  ['unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['outline']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" unite-quickfix {{{
if neobundle#tap('unite-quickfix')
  call neobundle#config({
        \   'depends':  ['unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['quickfix']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" unite-fold {{{
if neobundle#tap('unite-fold')
  call neobundle#config({
        \   'depends':  ['unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['fold']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" neomru.vim {{{
if neobundle#tap('neomru.vim')
  call neobundle#config({
        \   'depends':  ['unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['neomru/file']
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    let g:neomru#update_interval         = 1
    let g:neomru#file_mru_limit          = 500
    let g:neomru#file_mru_ignore_pattern = 'fugitiveblame'
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-unite-giti {{{
if neobundle#tap('vim-unite-giti')
  call neobundle#config({
        \   'depends':  ['unite.vim', 'vimproc'],
        \   'autoload': {
        \     'function_prefix': 'giti',
        \     'unite_sources':   [
        \       'giti',     'giti/branch', 'giti/branch_all', 'giti/config',
        \       'giti/log', 'giti/remote', 'giti/status'
        \     ],
        \     'commands': [
        \       'Giti',                        'GitiWithConfirm',   'GitiFetch', 'GitiPush',
        \       'GitiPushWithSettingUpstream', 'GitiPushExpressly', 'GitiPull',  'GitiPullSquash',
        \       'GitiPullRebase',              'GitiPullExpressly', 'GitiDiff',  'GitiDiffCached',
        \       'GitiLog',                     'GitiLogLine'
        \     ]
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoGroup
      autocmd User UniteGitiGitExecuted call s:UpdateFugitive()
    augroup END
  endfunction

  call neobundle#untap()
endif
" }}}
" unite-everything {{{
if IsWindows()
  if neobundle#tap('unite-everything')
    call neobundle#config({
          \   'depends':  ['unite.vim'],
          \   'autoload': {
          \     'unite_sources': ['everything', 'everything/async'],
          \   }
          \ })

    function! neobundle#hooks.on_source(bundle)
      let g:unite_source_everything_full_path_search = 1

      call unite#custom_max_candidates('everything', 300)
    endfunction

    call neobundle#untap()
  endif
endif
" }}}
" }}}
" }}}
" キー無効 {{{
" Vimを閉じない
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" ミス操作で削除してしまうため
nnoremap dh <Nop>
nnoremap dj <Nop>
nnoremap dk <Nop>
nnoremap dl <Nop>

" よくミスるため
vnoremap u  <Nop>
onoremap u  <Nop>
" }}}
" ファイルタイプごとの設定 {{{
let s:firstOneShotDelay = 2
let s:firstOneShotPhase = 0
function! s:FirstOneShot() " {{{

  function! s:FirstOneShotPhase0()

    filetype plugin indent on

    " ライブラリ {{{
    NeoBundleSource vim-submode
    " }}}
    " 表示 {{{
    " NeoBundleSource indentLine
    " NeoBundleSource lightline.vim
    NeoBundleSource matchparenpp
    NeoBundleSource foldcc
    " }}}
    " 編集 {{{
    NeoBundleSource tcomment_vim
    NeoBundleSource vim-surround
    NeoBundleSource vim-repeat
    NeoBundleSource vim-smartinput
    " }}}
    " ファイル {{{
    NeoBundleSource vim-altr
    NeoBundleSource vim-auto-mirroring
    " }}}
    " 検索 {{{
    NeoBundleSource vim-anzu
    NeoBundleSource matchit.zip
    " }}}
    " アプリ {{{
    NeoBundleSource vim-fugitive
    NeoBundleSource vim-gitgutter
    if IsWindows() && IsGuiRunning()
      NeoBundleSource vim-icondrag
      IconDragEnable
    endif
    " }}}
    " Unite {{{
    NeoBundleSource unite.vim
    NeoBundleSource neomru.vim
    " }}}
    " 言語 {{{
    NeoBundleSource syntastic
    " }}}

    set incsearch
    set ignorecase
    set smartcase

    if filereadable(s:VimrcLocal)
      execute 'source' s:VimrcLocal
    endif

    " 意図的に vital.vim を読み込み
    call unite#util#strchars('')
    call unite#util#sort_by([], '')
    call unite#util#get_vital().import('Vim.Message')

    if exists(':IndentLinesReset')
      IndentLinesReset
    endif
  endfunction

  function! s:FirstOneShotPhase1()
    augroup FirstOneShot
      autocmd!
    augroup END
  endfunction

  if s:firstOneShotDelay > 0
    let s:firstOneShotDelay = s:firstOneShotDelay - 1
    " call s:ContinueCursorHold()
  else
    call call(printf('s:FirstOneShotPhase%d', s:firstOneShotPhase), [])
    let s:firstOneShotPhase = s:firstOneShotPhase + 1
  endif

  " call s:ContinueCursorHold()
endfunction " }}}

augroup FirstOneShot
  autocmd!
  autocmd CursorHold,BufEnter,WinEnter,BufWinEnter * call s:FirstOneShot()
augroup END

augroup MyAutoGroup
  autocmd BufEnter,WinEnter,BufWinEnter,BufWritePost *                   call     s:UpdateAll()
  autocmd BufNewFile,BufRead                         *.xaml              setlocal ft=xml
  autocmd BufNewFile,BufRead                         *.json              setlocal ft=json
  autocmd BufNewFile,BufRead                         *.{fx,fxc,fxh,hlsl} setlocal ft=hlsl
  autocmd BufNewFile,BufRead                         *.{fsh,vsh}         setlocal ft=glsl
  autocmd BufNewFile,BufRead                         *.{md,mkd,markdown} setlocal ft=markdown
  autocmd BufWritePost                               $MYVIMRC            NeoBundleClearCache

  autocmd FileType *          call s:SetAll()
  autocmd FileType ruby       call s:SetRuby()
  autocmd FileType vim        call s:SetVim()
  autocmd FileType qf         call s:SetQuickFix()
  autocmd FileType help       call s:SetHelp()
  autocmd FileType unite      call s:SetUnite()
  autocmd FileType cs         call s:SetCs()
  autocmd FileType c,cpp      call s:SetCpp()
  autocmd FileType go         call s:SetGo()
  autocmd FileType godoc      call s:SetGodoc()
  autocmd FileType coffee     call s:SetCoffee()
  autocmd FileType json       call s:SetJson()
  autocmd FileType xml,html   call s:SetXml()
  autocmd FileType neosnippet call s:SetNeosnippet()
  autocmd FileType markdown   call s:SetMarkdown()

  function! s:UpdateAll()

    " 行番号表示幅を設定する
    " http://d.hatena.ne.jp/osyo-manga/20140303/1393854617
    let w = len(line('$')) + 2
    if w < 5
      let w = 5
    endif

    let &l:numberwidth = w

    " ファイルの場所をカレントにする
    if &ft != '' && &ft != 'vimfiler'
      silent! execute 'lcd' fnameescape(expand('%:p:h'))
    endif

    call s:SetAll()
  endfunction

  function! s:SetAll()
    setlocal formatoptions-=ro
    setlocal textwidth=0
  endfunction

  function! s:SetRuby()
    setlocal foldmethod=syntax
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal softtabstop=2
  endfunction

  function! s:SetVim()
    setlocal foldmethod=marker
    setlocal foldlevel=0
    setlocal foldcolumn=5

    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal softtabstop=2
  endfunction

  function! s:SetXml()
    " Hack #22: XMLの閉じタグを補完する
    " http://vim-users.jp/2009/06/hack22/
    inoremap <buffer> </ </<C-x><C-o>

    let g:xml_syntax_folding = 1

    setlocal foldmethod=syntax
    setlocal foldlevel=99
    setlocal foldcolumn=5
  endfunction

  function! s:SetGo()
    setlocal foldmethod=syntax
    setlocal shiftwidth=4
    setlocal noexpandtab
    setlocal tabstop=4
    compiler go

    nmap <silent><buffer> <Leader><C-k><C-k> :<C-u>Godoc<CR>zz
    nmap <silent><buffer> <C-]>              :<C-u>call GodefUnderCursor()<CR>zz

    command! -buffer Fmt call s:GolangFormat()

    augroup MyAutoGroup
      autocmd BufWritePost <buffer> call s:GolangFormat()
    augroup END
  endfunction

  function! s:SetGodoc()
    nnoremap <silent><buffer> q :<C-u>close<CR>
  endfunction

  function! s:SetCoffee()
    setlocal shiftwidth=2
  endfunction

  function! s:SetJson()
    setlocal shiftwidth=2
  endfunction

  function! s:SetCpp()
    setlocal foldmethod=syntax

    map <silent><buffer> [App]r :<C-u>QuickRun cpp/wandbox<CR>
  endfunction

  function! s:SetCs()
    setlocal omnifunc=OmniSharp#Complete
    setlocal foldmethod=syntax
    let g:omnicomplete_fetch_full_documentation = 0

    nnoremap <silent><buffer> <C-]>   :<C-u>call OmniSharp#GotoDefinition()<CR>zz
    nnoremap <silent><buffer> <S-F12> :<C-u>call OmniSharp#FindUsages()<CR>
  endfunction

  function! s:SetUnite()
    let unite = unite#get_current_unite()
    if unite.buffer_name =~# '^search'
      nmap <silent><buffer><expr> <C-r> unite#do_action('replace')
      imap <silent><buffer><expr> <C-r> unite#do_action('replace')
    endif

    nmap <silent><buffer> <C-v> <Plug>(unite_toggle_auto_preview)
    imap <silent><buffer> <C-v> <Plug>(unite_toggle_auto_preview)
    nmap <silent><buffer> <C-j> <Plug>(unite_exit)
  endfunction

  function! s:SetHelp()
    noremap <silent><buffer> q :<C-u>close<CR>
  endfunction

  function! s:SetNeosnippet()
    setlocal noexpandtab
  endfunction

  function! s:SetMarkdown()
    nnoremap <silent><buffer> [App]v :<C-u>PrevimOpen<CR>
  endfunction

  function! s:SetQuickFix()
    noremap  <silent><buffer> p     <CR>zz<C-w>p
    nnoremap <silent><buffer> r     :<C-u>Qfreplace<CR>
    nnoremap <silent><buffer> q     :<C-u>cclose<CR>
    nnoremap <silent><buffer> e     <CR>
    nnoremap <silent><buffer> <CR>  <CR>zz:<C-u>cclose<CR>
    nnoremap <silent><buffer> k     kzz
    nnoremap <silent><buffer> j     jzz
    nnoremap <silent><buffer> <C-k> kzz<CR>zz<C-w>p
    nnoremap <silent><buffer> <C-j> jzz<CR>zz<C-w>p

    " http://d.hatena.ne.jp/thinca/20130708/1373210009
    nnoremap <silent><buffer> dd    :<C-u>call <SID>del_entry()<CR>
    nnoremap <silent><buffer> x     :<C-u>call <SID>del_entry()<CR>
    vnoremap <silent><buffer> d     :<C-u>call <SID>del_entry()<CR>
    vnoremap <silent><buffer> x     :<C-u>call <SID>del_entry()<CR>
    nnoremap <silent><buffer> u     :<C-u>call <SID>undo_entry()<CR>
  endfunction

  function! s:del_entry() range
    let qf = getqflist()
    let history = get(w:, 'qf_history', [])
    call add(history, copy(qf))
    let w:qf_history = history
    unlet! qf[a:firstline - 1 : a:lastline - 1]
    call setqflist(qf, 'r')
    execute a:firstline
  endfunction

  function! s:undo_entry()
    let history = get(w:, 'qf_history', [])
    if !empty(history)
      call setqflist(remove(history, -1), 'r')
    endif
  endfunction

  " 場所ごとに設定を用意する {{{
  " http://vim-users.jp/2009/12/hack112/
  autocmd BufNewFile,BufReadPost * call s:LoadVimLocal(expand('<afile>:p:h'))

  function! s:LoadVimLocal(loc)
    let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
    for i in reverse(filter(files, 'filereadable(v:val)'))
      source `=i`
    endfor
  endfunction
  " }}}
augroup END
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
set iminsert=0
set imsearch=0
set formatexpr=autofmt#japanese#formatexpr()
set nrformats-=octal
set nrformats+=alpha
set completeopt=longest,menuone
set backspace=indent,eol,start
set noswapfile
set nobackup
" set spell
" set spelllang+=cjk

noremap U J

" ^Mを取り除く
command! RemoveCr call s:ExecuteKeepView('silent! %substitute/\r$//g | nohlsearch')

" 行末のスペースを取り除く
command! RemoveEolSpace call s:ExecuteKeepView('silent! %substitute/ \+$//g | nohlsearch')

" 整形
command! Format call s:SmartFormat()

" http://lsifrontend.hatenablog.com/entry/2013/10/11/052640
nmap     <silent> <C-CR> yy:<C-u>TComment<CR>p
nmap     <silent> <C-m>  yy:<C-u>TComment<CR>p
vnoremap <silent> <C-CR> :<C-u>call <SID>CopyAddComment()<CR>
vnoremap <silent> <C-m>  :<C-u>call <SID>CopyAddComment()<CR>

" http://qiita.com/akira-hamada/items/2417d0bcb563475deddb をもとに調整
function! s:CopyAddComment() range
  let selectedCount = line("'>") - line("'<")

  " 選択中の行をyank
  normal! ""gvy

  " yankした物をPする
  normal P

  " 元のコードを選択
  if selectedCount == 0
    execute 'normal V'
  else
    execute 'normal V' . selectedCount . 'j'
  endif

  " コメントアウトする
  normal gc

  " ビジュアルモードからエスケープ
  execute "normal! \e\e"

  " 元の位置に戻る
  execute 'normal ' . (selectedCount + 1) . 'j'
endfunction

" http://vim.wikia.com/wiki/Pretty-formatting_XML
function! s:DoFormatXML() range
  " Save the file type
  let l:origft = &ft

  " Clean the file type
  set ft=

  " Add fake initial tag (so we can process multiple top-level elements)
  execute ":let l:beforeFirstLine=" . a:firstline . "-1"
  if l:beforeFirstLine < 0
    let l:beforeFirstLine=0
  endif
  execute a:lastline . "put ='</PrettyXML>'"
  execute l:beforeFirstLine . "put ='<PrettyXML>'"
  execute ":let l:newLastLine=" . a:lastline . "+2"
  if l:newLastLine > line('$')
    let l:newLastLine=line('$')
  endif

  " Remove XML header
  execute ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

  " Recalculate last line of the edited code
  let l:newLastLine=search('</PrettyXML>')

  " Execute external formatter
  execute ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

  " Recalculate first and last lines of the edited code
  let l:newFirstLine=search('<PrettyXML>')
  let l:newLastLine=search('</PrettyXML>')

  " Get inner range
  let l:innerFirstLine=l:newFirstLine+1
  let l:innerLastLine=l:newLastLine-1

  " Remove extra unnecessary indentation
  execute ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

  " Remove fake tag
  execute l:newLastLine . "d"
  execute l:newFirstLine . "d"

  " Put the cursor at the first line of the edited code
  execute ":" . l:newFirstLine

  " Restore the file type
  execute "set ft=" . l:origft
endfunction
command! -range=% XmlFormat <line1>,<line2>call s:DoFormatXML()

" http://qiita.com/tekkoc/items/324d736f68b0f27680b8
function! s:Jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif

  execute "%! jq \"" . l:arg . "\""
endfunction
command! -nargs=? JsonFormat call s:Jq(<f-args>)

" 自動的にディレクトリを作成する
" http://vim-users.jp/2011/02/hack202/
augroup MyAutoGroup
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
          \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END
" }}}
" タブ・インデント {{{
set autoindent
set cindent
set tabstop=4                     " ファイル内の <Tab> が対応する空白の数。
set softtabstop=4                 " <Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数。
set shiftwidth=4                  " インデントの各段階に使われる空白の数。
set expandtab                     " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う。
set list
set listchars=tab:\⭟\ ,eol:↲,extends:»,precedes:«,nbsp:%

if (v:version >= 704 && has('patch338'))
  set breakindent
endif

vnoremap < <gv
vnoremap > >gv
" }}}
" 検索 {{{
if executable('pt')
  set grepprg=pt\ --nogroup\ --nocolor\ -S
  set grepformat=%f:%l:%m
endif

" 日本語インクリメンタルサーチ
if has('migemo')
  set migemo

  if IsWindows()
    set migemodict=$VIM/dict/utf-8/migemo-dict
  elseif IsMac()
    set migemodict=$VIMRUNTIME/dict/migemo-dict
  endif
endif

" 検索時のハイライトを解除
nnoremap <silent> <Leader>/   :nohlsearch<CR>

" http://deris.hatenablog.jp/entry/2013/05/15/024932
" very magic
nnoremap / /\v

" *による検索時に初回は移動しない
nnoremap <silent> * viw:<C-u>call <SID>StarSearch()<CR>:<C-u>set hlsearch<CR>`<
vnoremap <silent> * :<C-u>call    <SID>StarSearch()<CR>:<C-u>set hlsearch<CR>
function! s:StarSearch()
  let orig = @"
  normal! gvy
  let text = @"
  let @/ = '\V' . substitute(escape(text, '\/'), '\n', '\\n', 'g')
  let @" = orig
endfunction
" }}}
" 表示 {{{
syntax enable                     " 構文ごとに色分けをする
set number
set textwidth=0                   " 一行に長い文章を書いていても自動折り返しをしない
set showcmd                       " コマンドをステータス行に表示
set showmatch                     " 括弧の対応をハイライト
set wrap
set noshowmode
set shortmess+=I                  " 起動時のメッセージを表示しない
set lazyredraw
set wildmenu
set wildmode=list:full
set showfulltag
set wildoptions=tagfile
set fillchars=vert:\              " 縦分割の境界線
set synmaxcol=500                 " ハイライトする文字数を制限する
set updatetime=750
set previewheight=24
set laststatus=0
set cmdheight=1
set laststatus=2
set showtabline=2
set diffopt=vertical,filler

" 'cursorline' を必要な時にだけ有効にする {{{
" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup MyAutoGroup
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI   * call s:auto_cursorline('CursorHold')
  autocmd WinEnter                 * call s:auto_cursorline('WinEnter')
  autocmd WinLeave                 * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if s:IsUniteRunning()
      return
    endif

    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      " setlocal nocursorline
      setlocal cursorline
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

  function! s:ForceShowCursolLine()
    if s:IsUniteRunning()
      return
    endif

    setlocal cursorline
    let s:cursorline_lock = 1
  endfunction
augroup END
" }}}
" 全角スペースをハイライト {{{
" http://fifnel.com/2009/04/07/2300/
if has('syntax')
  function! s:ActivateInvisibleIndicator()
    syntax match InvisibleJISX0208Space '　' display containedin=ALL
    highlight InvisibleJISX0208Space term=underline guibg=#112233

    syntax match InvisibleTab '\t' display containedin=ALL
    highlight InvisibleTab term=underline ctermbg=Gray guibg=#121212
  endf

  augroup MyAutoGroup
    autocmd BufNew,BufRead * call s:ActivateInvisibleIndicator()
  augroup END
endif
" }}}
" Vim でカーソル下の単語を移動するたびにハイライトする {{{
" http://d.hatena.ne.jp/osyo-manga/20140121/1390309901
let g:enable_highlight_cursor_word = 1

augroup MyAutoGroup
  " autocmd CursorMoved * call s:hl_cword()
  autocmd CursorHold  * call s:hl_cword()
  autocmd BufLeave    * call s:hl_clear()
  autocmd WinLeave    * call s:hl_clear()
  autocmd InsertEnter * call s:hl_clear()
  autocmd CursorMoved * call s:hl_clear()

  autocmd ColorScheme * highlight CursorWord guifg=Red

  function! s:hl_clear()
    if exists('b:highlight_cursor_word_id') && exists('b:highlight_cursor_word')
      silent! call matchdelete(b:highlight_cursor_word_id)
      unlet b:highlight_cursor_word_id
      unlet b:highlight_cursor_word
    endif
  endfunction

  function! s:hl_cword()
    let word = expand("<cword>")
    if word == ""
      return
    endif
    if get(b:, "highlight_cursor_word", "") ==# word
      return
    endif

    call s:hl_clear()
    if !g:enable_highlight_cursor_word
      return
    endif

    if !empty(filter(split(word, '\zs'), "strlen(v:val) > 1"))
      return
    endif

    let pattern = printf("\\<%s\\>", expand("<cword>"))
    silent! let b:highlight_cursor_word_id = matchadd("CursorWord", pattern)
    let b:highlight_cursor_word = word
  endfunction
augroup END
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
inoremap <C-j> <Esc>
nnoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
inoremap <Esc> <Nop>
cnoremap <Esc> <Nop>
vnoremap <Esc> <Nop>
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
nnoremap <silent> k     :<C-u>call <SID>UpCursor(v:count1)<CR>
nnoremap <silent> j     :<C-u>call <SID>DownCursor(v:count1)<CR>
nnoremap <silent> h     :<C-u>call <SID>LeftCursor(v:count1)<CR>
nnoremap <silent> l     :<C-u>call <SID>RightCursor(v:count1)<CR>

vnoremap <silent> k     gk
vnoremap <silent> j     gj
nnoremap <silent> 0     g0
nnoremap <silent> g0    0
nnoremap <silent> $     g$
nnoremap <silent> g$    $
nnoremap <silent> <C-e> <C-e>j
nnoremap <silent> <C-y> <C-y>k
vnoremap <silent> <C-e> <C-e>j
vnoremap <silent> <C-y> <C-y>k
nmap     <silent> gg    ggzvzz:<C-u>call  <SID>RefreshScreen()<CR>
nmap     <silent> G     Gzvzz:<C-u>call   <SID>RefreshScreen()<CR>

noremap  <silent> <C-i> <C-i>zz:<C-u>call <SID>RefreshScreen()<CR>
noremap  <silent> <C-o> <C-o>zz:<C-u>call <SID>RefreshScreen()<CR>
map      <silent> <C-h> :<C-u>call <SID>DisableVirtualCursor()<CR>^:<C-u>call <SID>RefreshScreen()<CR>
map      <silent> <C-l> :<C-u>call <SID>DisableVirtualCursor()<CR>g$:<C-u>call <SID>RefreshScreen()<CR>

nmap     <silent> <Leader>m `

function! s:UpCursor(repeat)
  call s:EnableVirtualCursor()

  let c = a:repeat
  while c > 0
    normal! gk
    let c -= 1
  endwhile
endfunction

function! s:DownCursor(repeat)
  call s:EnableVirtualCursor()

  let c = a:repeat
  while c > 0
    normal! gj
    let c -= 1
  endwhile
endfunction

function! s:LeftCursor(repeat)
  call s:DisableVirtualCursor()

  let c = a:repeat
  while c > 0
    normal! h
    let c -= 1
  endwhile
endfunction

function! s:RightCursor(repeat)
  call s:DisableVirtualCursor()

  let c = a:repeat
  while c > 0
    normal! l
    let c -= 1
  endwhile

  if foldclosed(line('.')) != -1
    normal zv
  endif
endfunction

function! s:EnableVirtualCursor()
  set virtualedit=all
endfunction

function! s:DisableVirtualCursor()
  set virtualedit=block
endfunction

augroup MyAutoGroup
  autocmd InsertEnter * call s:DisableVirtualCursor()
augroup END
" }}}
" ウィンドウ操作 {{{
set splitbelow                    " 縦分割したら新しいウィンドウは下に
set splitright                    " 横分割したら新しいウィンドウは右に

nnoremap [Window]  <Nop>
nmap     <Leader>w [Window]

noremap  <silent> [Window]e :<C-u>call <SID>ToggleVSplitWide()<CR>
noremap  <silent> [Window]w :<C-u>call <SID>SmartClose()<CR>

" アプリウィンドウ操作
if IsGuiRunning()
  noremap <silent> [Window]H :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]J :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]K :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]L :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]h :<C-u>MoveWin<CR>
  noremap <silent> [Window]j :<C-u>MoveWin<CR>
  noremap <silent> [Window]k :<C-u>MoveWin<CR>
  noremap <silent> [Window]l :<C-u>MoveWin<CR>
  noremap <silent> [Window]f :<C-u>call <SID>FullWindow()<CR>
endif
" }}}
" タブライン操作 {{{
nnoremap [Tab]     <Nop>
nmap     <Leader>t [Tab]

nnoremap <silent> [Tab]c :tabnew<CR>
nnoremap <silent> [Tab]x :tabclose<CR>

for s:n in range(1, 9)
  execute 'nnoremap <silent> [Tab]' . s:n  ':<C-u>tabnext' . s:n . '<CR>'
endfor

nnoremap <silent> K :<C-u>tabp<CR>
nnoremap <silent> J :<C-u>tabn<CR>

" Vimですべてのバッファをタブ化する
" http://qiita.com/kuwa72/items/deef2703af74d2d993ee
nnoremap <silent> L :<C-u>call <SID>CleanEmptyBuffers()<CR>:<C-u>tab ba<CR>
" }}}
" バッファ操作 {{{
nnoremap [Buffer]  <Nop>
nmap     <Leader>b [Buffer]

nnoremap <silent> [Buffer]x :bdelete<CR>
nnoremap <silent> <Leader>x :bdelete<CR>

for s:n in range(1, 9)
  execute 'nnoremap <silent> [Buffer]' . s:n  ':<C-u>b' . s:n . '<CR>'
endfor

" nnoremap <silent> <C-k> :<C-u>bprevious<CR>
" nnoremap <silent> <C-j> :<C-u>bnext<CR>

" }}}
" ファイル操作 {{{
" vimrc / gvimrc の編集
nnoremap <silent> <F1> :<C-u>call <SID>SmartOpen($MYVIMRC)<CR>
nnoremap <silent> <F2> :<C-u>call <SID>SmartOpen($MYGVIMRC)<CR>
nnoremap <silent> <F3> :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
" }}}
" Git {{{
nnoremap [Git]     <Nop>
nmap     <Leader>g [Git]

nnoremap <silent> [Git]b    :<C-u>call <SID>ExecuteIfOnGitBranch('Gblame w')<CR>
nnoremap <silent> [Git]a    :<C-u>call <SID>ExecuteIfOnGitBranch('Gwrite')<CR>
nnoremap <silent> [Git]c    :<C-u>call <SID>ExecuteIfOnGitBranch('Gcommit')<CR>
nnoremap <silent> [Git]f    :<C-u>call <SID>ExecuteIfOnGitBranch('GitiFetch')<CR>
nnoremap <silent> [Git]d    :<C-u>call <SID>ExecuteIfOnGitBranch('Gdiff')<CR>
nnoremap <silent> [Git]s    :<C-u>call <SID>ExecuteIfOnGitBranch('Gstatus')<CR>
nnoremap <silent> [Git]v    :<C-u>call <SID>ExecuteIfOnGitBranch('Gitv')<CR>
nnoremap <silent> [Git]push :<C-u>call <SID>ExecuteIfOnGitBranch('GitiPush')<CR>
nnoremap <silent> [Git]pull :<C-u>call <SID>ExecuteIfOnGitBranch('GitiPull')<CR>
" }}}
" ヘルプ {{{
nnoremap <Leader><C-k>      :<C-u>help<Space>
nnoremap <Leader><C-k><C-k> :<C-u>help <C-r><C-w><CR>
vnoremap <Leader><C-k><C-k> :<C-u>help <C-r><C-w><CR>

set helplang=ja,en
set rtp+=$VIM/plugins/vimdoc-ja
" }}}
" 汎用関数 {{{
" SID取得 {{{
function! s:SID()

  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfunction
" }}}
" CursorHold を継続させる{{{
function! s:ContinueCursorHold()

  " http://d.hatena.ne.jp/osyo-manga/20121102/1351836801
  call feedkeys(mode() ==# 'i' ? "\<C-g>\<Esc>" : "g\<Esc>", 'n')
endfunction
" }}}
" アプリケーションウィンドウサイズの変更 {{{
function! s:ResizeWin()

  let d1 = 4
  let d2 = 4

  let t = &titlestring
  let x = &columns
  let y = &lines
  let k = 'k'

  if x == -1 || y == -1
    echoerr 'Can not get window position'
  else
    while stridx('hjklHJKL', k) >= 0
      let &titlestring = 'Resizeing window: (' . x . ', ' . y . ')'
      redraw

      let k = nr2char(getchar())

      if k ==? 'h'
        let x = x - d1
        if k == 'h'
          let x = x - d2
        endif
      endif

      if k ==? 'j'
        let y = y + d1
        if k == 'j'
          let y = y + d2
        endif
      endif

      if k ==? 'k'
        let y = y - d1
        if k == 'k'
          let y = y - d2
        endif
      endif

      if k ==? 'l'
        let x = x + d1
        if k == 'l'
          let x = x + d2
        endif
      endif

      let &columns = x
      let &lines = y
    endwhile
  endif

  let &titlestring = t
endfunction
" }}}
" アプリケーションウィンドウを最大高さにする {{{
function! s:FullWindow()
  execute 'winpos' getwinposx() '0'
  execute 'set lines=9999'
endfunction
" }}}
" 縦分割する {{{
let s:depthVsp     = 1
let s:opendLeftVsp = 0
let s:opendTopVsp  = 0

function! s:ToggleVSplitWide()

  if s:depthVsp <= 1
    call s:OpenVSplitWide()
  else
    call s:CloseVSplitWide()
  endif
endfunction

function! s:OpenVSplitWide()

  if s:depthVsp == 1
    let s:opendLeftVsp = getwinposx()
    let s:opendTopVsp  = getwinposy()
  endif

  let s:depthVsp += 1
  let &columns = s:baseColumns * s:depthVsp
  execute 'botright vertical' s:baseColumns 'split'
endf

function! s:CloseVSplitWide()

  let s:depthVsp -= 1
  let &columns = s:baseColumns * s:depthVsp
  call s:SmartClose()

  if s:depthVsp == 1
    execute 'winpos' s:opendLeftVsp s:opendTopVsp
  end
endf
" }}}
" 画面リフレッシュ{{{
function! s:RefreshScreen()

  " ステータスライン上のanzuが更新されない
  " silent doautocmd CursorHold <buffer>

  call s:ForceShowCursolLine()
endfunction
" }}}
" 賢いクローズ {{{
" ウィンドウが１つかつバッファが一つかつ&columns が s:baseColumns            :quit
" ウィンドウが１つかつバッファが一つかつ&columns が s:baseColumnsでない      &columns = s:baseColumns
" 現在のウィンドウに表示しているバッファが他のウィンドウでも表示されてる     :close
"                                                           表示されていない :bdelete
function! s:SmartClose()

  if exists('b:disableSmartClose')
    return
  end

  let currentWindow           = winnr()
  let currentBuffer           = winbufnr(currentWindow)
  let isCurrentBufferModified = getbufvar(currentBuffer, '&modified')
  let tabCount                = tabpagenr('$')
  let windows                 = range(1, winnr('$'))

  if (len(windows) == 1) && (s:GetListedBufferCount() == 1) && (tabCount == 1)
    if &columns == s:baseColumns
      if isCurrentBufferModified == 0
        quit
      elseif confirm('未保存です。閉じますか？', "&Yes\n&No", 1, 'Question') == 1
        quit!
      endif
    else
      let &columns   = s:baseColumns
      let s:depthVsp = 1
    endif
  else
    for i in windows
      " 現在のウィンドウは無視
      if i != currentWindow
        " 他のウィンドウでも表示されている
        if winbufnr(i) == currentBuffer
          close
          return
        endif
      endif
    endfor

    if isCurrentBufferModified == 0
      bdelete
    elseif confirm('未保存です。閉じますか？', "&Yes\n&No", 1, 'Question') == 1
      bdelete!
    endif
  endif
endfunction
" }}}
" 賢いファイルオープン {{{
function! s:SmartOpen(filepath)

  " 新規タブであればそこに開く、そうでなければ新規新規タブに開く
  " if (&ft == '') && (s:GetIsCurrentBufferModified() == 0) && (s:GetCurrentBufferSize() == 0)
  "   execute 'edit' a:filepath
  " else
  "   execute 'tabnew' a:filepath
  " endif

  execute ':edit' a:filepath
  call s:CleanEmptyBuffers()
endfunction
" }}}
" 読み込み済みのバッファ数を得る {{{
function! s:GetListedBufferCount()

  let bufferCount = 0

  let lastBuffer = bufnr('$')
  let buf = 1
  while buf <= lastBuffer

    if buflisted(buf)
      let bufferCount += 1
    endif

    let buf += 1
  endwhile

  return bufferCount
endfunction
" }}}
" 現在のバッファが編集済みか？ {{{
function! s:GetIsCurrentBufferModified()

  let currentWindow           = winnr()
  let currentBuffer           = winbufnr(currentWindow)
  let isCurrentBufferModified = getbufvar(currentBuffer, '&modified')

  return isCurrentBufferModified
endfunction
" }}}
" カレントバッファのサイズを取得 {{{
function! s:GetCurrentBufferSize()

  let byte = line2byte(line('$') + 1)
  if byte == -1
    return 0
  else
    return byte - 1
  endif
endfunction
" }}}
" 空バッファを削除 {{{
" http://stackoverflow.com/questions/6552295/deleting-all-empty-buffers-in-vim
function! s:CleanEmptyBuffers()

  let buffers = filter(range(1, bufnr('$')), "buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && getbufvar(v:val, '&modified', 0)==0")
  if !empty(buffers)
    execute 'bd ' join(buffers, ' ')
  endif
endfunction
" }}}
" コマンド実行後の表示状態を維持する {{{
function! s:ExecuteKeepView(expr)

  let wininfo = winsaveview()
  execute a:expr
  call winrestview(wininfo)
endfunction
" }}}
" 整形 {{{
function! s:SmartFormat()

  if &ft == 'cpp'
    CppFormat
  elseif &ft == 'c'
    CppFormat
  elseif &ft == 'xml'
    XmlFormat
  elseif &ft == 'json'
    JsonFormat
  elseif &ft == 'go'
    Fmt
  else
    echo 'Format : Not supported. : ' . &ft
  endif
endfunction
" }}}
" Unite 実行中か {{{
function! s:IsUniteRunning()

  return &ft == 'unite'
endfunction
" }}}
" Gitブランチにいるか {{{
function! s:IsInGitBranch()

  if !exists('*fugitive#head')
    NeoBundleSource vim-fugitive
  endif

  return fugitive#head() != ''
endfunction
" }}}
" Gitブランチ上であれば実行 {{{
function! s:ExecuteIfOnGitBranch(line)

  if !s:IsInGitBranch()
    echo 'not in git branch : ' . a:line
    return
  endif

  execute a:line
endfunction
" }}}
" GolangFormat {{{
function! s:GolangFormat()

  let pos_save                     = getpos('.')
  let sel_save                     = &l:selection
  let &l:selection                 = 'inclusive'
  let [save_g_reg, save_g_regtype] = [getreg('g'), getregtype('g')]

  try
    let formatted = vimproc#system('goimports ' . expand('%:p'))

    if vimproc#get_last_status() == 0
      call setreg('g', formatted, 'v')
      silent keepjumps normal! ggVG"gp
    endif
  finally
    call setreg('g', save_g_reg, save_g_regtype)
    let &l:selection = sel_save
    call setpos('.', pos_save)
  endtry
endfunction
" }}}
" }}}
" コンソール用 {{{
if !IsGuiRunning()

  source $MYGVIMRC
endif
" }}}
" メモ {{{
" +--------+--------+--------+--------+--------+--------+--------+
" |        | normal | visual | select |  wait  | insert |command |
" +--------+--------+--------+--------+--------+--------+--------+
" |  map   |   ○   |   ○   |        |   ○   |        |        |
" |  map!  |        |        |        |        |   ○   |   ○   |
" |  nmap  |   ○   |        |        |        |        |        |
" |  vmap  |        |   ○   |   ○   |        |        |        |
" |  xmap  |        |   ○   |        |        |        |        |
" |  smap  |        |        |   ○   |        |        |        |
" |  omap  |        |        |        |   ○   |        |        |
" |  imap  |        |        |        |        |   ○   |        |
" |  cmap  |        |        |        |        |        |   ○   |
" +--------+--------+--------+--------+--------+--------+--------+
" }}}
" vim: set ts=2 sw=2 sts=2 et :

