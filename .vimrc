set nocompatible
set encoding=utf-8
scriptencoding utf-8

" 基本 {{{
let s:isWindows    = has('win32') || has('win64')
let s:isMac        = has('mac')
let s:isGuiRunning = has('gui_running')
let s:isStarting   = has('vim_starting')
let s:baseColumns  = s:isWindows ? 140 : 120
let g:mapleader    = ','
let s:vimrc_local  = expand('~/.vimrc_local')
let $DOTVIM        = expand('~/.vim')
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
if s:isWindows && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
if s:isMac
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

if !s:isGuiRunning
  let $MYGVIMRC = expand('~/.gvimrc')
endif

" 右ウィンドウ幅
let s:rightWindowWidth = 40
" }}}
" プラグイン {{{
function! s:SetNeoBundle() " {{{
  " 表示 {{{
  NeoBundle 'tomasr/molokai'
  NeoBundle 'itchyny/lightline.vim', {
        \   'depends':  ['Shougo/vimproc', 'tpope/vim-fugitive', 'osyo-manga/vim-anzu', 'scrooloose/syntastic']
        \ }
  NeoBundle 'Yggdroot/indentLine'

  NeoBundleLazy 'vim-scripts/matchparenpp'

  NeoBundleLazy 'majutsushi/tagbar', {
        \   'autoload': {
        \     'commands': ['TagbarToggle']
        \   }
        \ }

  NeoBundleLazy 'LeafCage/foldCC', {
        \   'autoload': {
        \     'filetypes': ['vim']
        \   }
        \ }

  NeoBundleLazy 'movewin.vim', {
        \   'autoload': {
        \     'commands': ['MoveWin']
        \   }
        \ }
  " }}}
  " 編集 {{{
  NeoBundleLazy 'tomtom/tcomment_vim'
  NeoBundleLazy 'tpope/vim-surround'
  NeoBundleLazy 'tpope/vim-repeat'

  NeoBundleLazy 'LeafCage/yankround.vim', {
        \   'autoload': {
        \     'mappings': ['<Plug>(yankround-'],
        \   }
        \ }

  NeoBundleLazy 'kana/vim-smartinput', {
        \   'autoload': {
        \     'insert': 1,
        \   }
        \ }

  NeoBundleLazy 'cohama/vim-smartinput-endwise', {
        \   'autoload': {
        \     'insert': 1,
        \   }
        \ }

  NeoBundleLazy 'nishigori/increment-activator', {
        \   'autoload': {
        \     'mappings': ['<C-x>', '<C-a>']
        \   }
        \ }

  NeoBundleLazy 'osyo-manga/vim-over', {
        \   'autoload': {
        \     'commands': ['OverCommandLineNoremap', 'OverCommandLine']
        \   }
        \ }

  NeoBundleLazy 'thinca/vim-qfreplace', {
        \   'autoload': {
        \     'filetypes': ['unite', 'quickfix'],
        \       'commands':  ['Qfreplace']
        \   }
        \ }

  NeoBundleLazy 'junegunn/vim-easy-align', {
        \   'autoload': {
        \     'commands': ['EasyAlign', 'LiveEasyAlign'],
        \     'mappings': [
        \       '<Plug>(EasyAlignOperator)',
        \       ['sxn', '<Plug>(EasyAlign)'],
        \       ['sxn', '<Plug>(LiveEasyAlign)'],
        \       ['sxn', '<Plug>(EasyAlignRepeat)']
        \     ]
        \   }
        \ }

  NeoBundleLazy 'terryma/vim-expand-region', {
        \   'autoload': {
        \     'mappings': [['sxn', '<Plug>(expand_region_']]
        \   }
        \ }
  " }}}
  " 補完 {{{
  NeoBundleLazy 'Shougo/neocomplete.vim', {
        \   'depends':  ['Shougo/vimproc'],
        \   'autoload': {
        \     'insert': 1,
        \   }
        \ }

  NeoBundleLazy 'Shougo/neosnippet', {
        \   'depends':  ['Shougo/neosnippet-snippets', 'Shougo/neocomplete.vim'],
        \   'autoload': {
        \     'insert': 1,
        \     'filetypes': ['neosnippet'],
        \     'commands': [
        \       'NeoSnippetClearMarkers',
        \         {
        \           'name':     'NeoSnippetSource',
        \           'complete': 'file'
        \         },
        \         {
        \           'name':     'NeoSnippetMakeCache',
        \           'complete': 'customlist,neosnippet#commands#_filetype_complete'
        \         },
        \         {
        \            'name':     'NeoSnippetEdit',
        \            'complete': 'customlist,neosnippet#commands#_edit_complete'
        \         }
        \       ],
        \       'mappings': [['sxi', '<Plug>(neosnippet_']],
        \       'unite_sources': [
        \         'neosnippet',
        \         'neosnippet_file',
        \         'neosnippet_target'
        \       ]
        \   }
        \ }

  NeoBundleLazy 'Shougo/neosnippet-snippets', {
        \   'autoload': {
        \     'insert': 1,
        \   }
        \ }

  NeoBundleLazy 'nosami/Omnisharp', {
        \   'depends':  ['Shougo/neocomplete.vim', 'Shougo/vimproc', 'scrooloose/syntastic'],
        \   'autoload': {
        \     'filetypes': ['cs']
        \   },
        \   'build': {
        \     'windows': 'C:/Windows/Microsoft.NET/Framework/v4.0.30319/MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
        \     'mac':     'xbuild server/OmniSharp.sln',
        \     'unix':    'xbuild server/OmniSharp.sln',
        \   }
        \ }
  " }}}
  " ファイル {{{
  NeoBundleLazy 'kana/vim-altr', {
        \   'autoload': {
        \     'mappings': [['scxino', '<Plug>(altr-']]
        \   }
        \ }
  " }}}
  " 検索 {{{
  NeoBundleLazy 'osyo-manga/vim-anzu'
  NeoBundleLazy 'matchit.zip'

  NeoBundleLazy 'rhysd/clever-f.vim', {
        \   'autoload': {
        \     'mappings': 'f',
        \   }
        \ }

  NeoBundleLazy 'thinca/vim-visualstar', {
        \   'autoload': {
        \     'mappings': ['<Plug>(visualstar-']
        \   }
        \ }
  " }}}
  " 言語 {{{
  NeoBundleLazy 'vim-jp/cpp-vim', {
        \   'autoload': {
        \     'filetypes': ['cpp']
        \   }
        \ }

  NeoBundle 'YoshihiroIto/vim-gocode', {
        \   'autoload': {
        \     'filetypes': ['go']
        \   }
        \ }

  NeoBundleLazy 'dgryski/vim-godef', {
        \   'autoload': {
        \     'filetypes': ['go']
        \   }
        \ }

  NeoBundleLazy 'scrooloose/syntastic', {
        \   'autoload': {
        \     'filetypes': ['go', 'ruby']
        \   }
        \ }

  NeoBundleLazy 'Mizuchi/STL-Syntax', {
        \   'autoload': {
        \     'filetypes': ['cpp']
        \   }
        \ }

  NeoBundleLazy 'Rip-Rip/clang_complete', {
        \   'autoload': {
        \     'filetypes': ['c', 'cpp', 'objc']
        \   }
        \ }

  NeoBundleLazy 'rhysd/vim-clang-format', {
        \   'depends':  ['kana/vim-operator-user'],
        \   'autoload': {
        \     'filetypes': ['c', 'cpp', 'objc']
        \   }
        \ }

  NeoBundleLazy 'beyondmarc/hlsl.vim', {
        \   'autoload': {
        \     'filetypes': ['hlsl']
        \   }
        \ }

  NeoBundleLazy 'tikhomirov/vim-glsl', {
        \   'autoload': {
        \     'filetypes': ['glsl']
        \   }
        \ }

  NeoBundleLazy 'vim-ruby/vim-ruby', {
        \   'autoload': {
        \     'filetypes': ['ruby']
        \   }
        \ }

  NeoBundleLazy 'vim-scripts/JSON.vim', {
        \   'autoload': {
        \     'filetypes': ['json']
        \   }
        \ }

  NeoBundleLazy 'plasticboy/vim-markdown', {
        \   'autoload': {
        \     'filetypes': ['markdown', 'mkd']
        \   }
        \ }

  NeoBundleLazy 'pangloss/vim-javascript', {
        \   'autoload': {
        \     'filetypes': ['javascript']
        \   }
        \ }

  NeoBundleLazy 'kchmck/vim-coffee-script', {
        \   'autoload': {
        \     'filetypes': ['coffee']
        \   }
        \ }

  NeoBundleLazy 'jelera/vim-javascript-syntax', {
        \   'autoload': {
        \     'filetypes': ['javascript']
        \   }
        \ }

  NeoBundleLazy 'rhysd/wandbox-vim', {
        \   'autoload': {
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
        \ }

  NeoBundleLazy 'thinca/vim-quickrun', {
        \   'depends':  ['osyo-manga/shabadou.vim', 'rhysd/wandbox-vim', 'Shougo/vimproc'],
        \   'autoload': {
        \     'mappings': [['sxn', '<Plug>(quickrun']],
        \     'commands': [
        \       {
        \         'complete': 'customlist,quickrun#complete',
        \         'name':     'QuickRun'
        \       }
        \     ]
        \   }
        \ }

  NeoBundleLazy 'osyo-manga/shabadou.vim'
  " }}}
  " テキストオブジェクト {{{
  NeoBundleLazy 'kana/vim-textobj-user'

  NeoBundleLazy 'kana/vim-textobj-entire', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ae'], ['xo', 'ie']]
        \   }
        \ }

  NeoBundleLazy 'kana/vim-textobj-indent', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']]
        \   }
        \ }

  NeoBundleLazy 'kana/vim-textobj-line', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'al'], ['xo', 'il']]
        \   }
        \ }

  NeoBundleLazy 'rhysd/vim-textobj-word-column', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'av'], ['xo', 'aV'], ['xo', 'iv'], ['xo', 'iV']]
        \   }
        \ }

  NeoBundleLazy 'thinca/vim-textobj-comment', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ac'], ['xo', 'ic']]
        \   }
        \ }

  NeoBundleLazy 'sgur/vim-textobj-parameter', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', '<Plug>(textobj-parameter']]
        \   }
        \ }

  NeoBundleLazy 'rhysd/vim-textobj-anyblock', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ab'], ['xo', 'ib']]
        \   }
        \ }

  NeoBundleLazy 'thinca/vim-textobj-between', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'af'], ['xo', 'if']]
        \   }
        \ }

  NeoBundleLazy 'h1mesuke/textobj-wiw', {
        \   'depends':  ['kana/vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', '<Plug>(textobj-wiw']]
        \   }
        \ }
  " }}}
  " オペレータ {{{
  NeoBundleLazy 'kana/vim-operator-user'

  NeoBundleLazy 'kana/vim-operator-replace', {
        \   'depends':  ['kana/vim-operator-user'],
        \   'autoload': {
        \     'mappings': [['nx', '<Plug>(operator-replace)']]
        \   }
        \ }

  NeoBundleLazy 'tyru/operator-camelize.vim', {
        \   'depends':  ['kana/vim-operator-user'],
        \   'autoload': {
        \     'mappings': [['nx', '<Plug>(operator-camelize-toggle)']]
        \   }
        \ }

  NeoBundleLazy 'emonkak/vim-operator-sort', {
        \   'depends':  ['kana/vim-operator-user'],
        \   'autoload': {
        \     'mappings': [['nx', '<Plug>(operator-sort']]
        \   }
        \ }

  NeoBundleLazy 'deris/vim-rengbang',  {
        \   'depends':  ['kana/vim-operator-user'],
        \   'autoload': {
        \     'commands': ['RengBang'],
        \     'mappings': [['nx', '<Plug>(operator-rengbang']]
        \   }
        \ }

  NeoBundleLazy 'osyo-manga/vim-operator-jump_side', {
        \   'depends':  ['kana/vim-operator-user'],
        \   'autoload': {
        \     'mappings': ['<Plug>(operator-jump-toggle)'],
        \   }
        \ }
  " }}}
  " アプリ {{{
  NeoBundleLazy 'basyura/twibill.vim'

  NeoBundleLazy 'LeafCage/nebula.vim', {
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
        \ }

  NeoBundleLazy 'tsukkee/lingr-vim', {
        \   'autoload': {
        \     'commands': ['LingrLaunch']
        \   }
        \ }

  NeoBundleLazy 'mattn/benchvimrc-vim', {
        \   'autoload': {
        \     'commands': ['BenchVimrc']
        \   }
        \ }

  NeoBundleLazy 'Shougo/vimfiler', {
        \   'depends':  ['Shougo/vimproc', 'Shougo/unite.vim', 'Shougo/vimshell.vim'],
        \   'autoload': {
        \     'commands': ['VimFilerBufferDir'],
        \     'explorer': 1
        \   }
        \ }

  NeoBundleLazy 'Shougo/vimshell.vim', {
        \   'depends':  ['Shougo/vimproc'],
        \   'autoload': {
        \     'commands': ['VimShell', 'VimShellPop']
        \   }
        \ }

  NeoBundleLazy 'basyura/TweetVim', {
        \   'depends':  [
        \     'Shougo/vimproc',
        \     'basyura/twibill.vim',
        \     'tyru/open-browser.vim',
        \     'mattn/webapi-vim',
        \   ],
        \   'autoload': {
        \     'commands': ['TweetVimHomeTimeline', 'TweetVimUserStream']
        \   }
        \ }

  NeoBundleLazy 'tpope/vim-fugitive', {
        \   'autoload': {
        \     'function_prefix': 'fugitive'
        \   }
        \ }

  NeoBundleLazy 'Shougo/vimproc', {
        \   'autoload': {
        \     'function_prefix': 'vimproc',
        \   },
        \   'build': {
        \     'mac':  'make -f make_mac.mak',
        \     'unix': 'make -f make_unix.mak',
        \   },
        \ }

  NeoBundleLazy 'mattn/webapi-vim', {
        \   'autoload': {
        \     'function_prefix': 'webapi'
        \   }
        \ }

  NeoBundleLazy 'tyru/open-browser.vim', {
        \   'depends':  ['Shougo/vimproc'],
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
        \ }

  if s:isMac
    NeoBundleLazy 'itchyny/dictionary.vim', {
          \   'autoload': {
          \     'commands': ['Dictionary']
          \   }
          \ }
  endif

  if s:isWindows && s:isGuiRunning
    NeoBundleLazy 'YoshihiroIto/vim-icondrag'
  endif
  " }}}
  " Unite {{{
  NeoBundleLazy 'Shougo/unite.vim', {
        \   'depends':  ['Shougo/vimproc'],
        \   'autoload': {
        \     'commands': ['Unite', 'UniteResume', 'UniteWithCursorWord']
        \   }
        \ }

  NeoBundleLazy 'Shougo/unite-outline', {
        \   'depends':  ['Shougo/unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['outline']
        \   }
        \ }

  NeoBundleLazy 'tsukkee/unite-tag', {
        \   'depends':  ['Shougo/unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['tag']
        \   }
        \ }

  NeoBundleLazy 'osyo-manga/unite-quickfix', {
        \   'depends':  ['Shougo/unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['quickfix']
        \   }
        \ }

  NeoBundleLazy 'osyo-manga/unite-fold', {
        \   'depends':  ['Shougo/unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['fold']
        \   }
        \ }

  NeoBundleLazy 'Shougo/neomru.vim', {
        \   'depends':  ['Shougo/unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['neomru/file']
        \   }
        \ }

  if s:isWindows
    NeoBundleLazy 'sgur/unite-everything', {
          \   'depends':  ['Shougo/unite.vim'],
          \   'autoload': {
          \     'unite_sources': ['everything', 'everything/async'],
          \   }
          \ }
  elseif s:isMac
    " NeoBundleLazy 'choplin/unite-spotlight', {
    "       \   'depends':  ['Shougo/unite.vim'],
    "       \   'autoload': {
    "       \     'unite_sources': ['spotlight'],
    "       \   }
    "       \ }
  endif
  " }}}
endfunction " }}}

if s:isStarting
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
" }}}
" 表示 {{{
" TagBar {{{
noremap <silent> <F8>    :<C-u>call <SID>ToggleTagBar()<CR>

let g:tagbar_width = s:rightWindowWidth

function! s:ToggleTagBar()
  if bufwinnr(bufnr('__Tagbar__')) != -1
    TagbarToggle
    let &columns = &columns - (g:tagbar_width + 1)
  else
    let &columns = &columns + (g:tagbar_width + 1)
    TagbarToggle
  endif
endfunction
" }}}
" lightline {{{
let s:p = lightline#colorscheme#default#palette

let s:p.normal.left     = [['#195E00', '#07AF00', 'bold'], ['gray7', 'gray2']]
let s:p.normal.fugitive = [['white', 'gray4']]

let s:p.insert.left     = [['darkestcyan', 'white', 'bold'], ['mediumcyan', 'darkestblue']]
let s:p.insert.middle   = [['mediumcyan', 'darkestblue']]
let s:p.insert.right    = [['darkestcyan', 'mediumcyan'], ['mediumcyan', 'darkblue'], ['mediumcyan', 'darkestblue']]
let s:p.insert.fugitive = [['white', 'darkblue']]

let s:p.visual.left     = [['#AB2362', 'white', 'bold'], ['#FF84BA', '#870036']]
let s:p.visual.middle   = [['#FF84BA', '#870036']]
let s:p.visual.right    = [['#75003D', '#FF87BB'], ['#FE86BB', '#AF0053'], ['#FF84BA', '#870036']]
let s:p.visual.fugitive = [['white', '#AF0053']]

" let s:p.visual.left     = [['#671B12', 'white', 'bold'], ['#FFB586', '#873700']]
" let s:p.visual.middle   = [['#FFB586', '#873700']]
" let s:p.visual.right    = [['#672021', '#FFB587'], ['#FEB386', '#AF3C00'], ['#FFB586', '#873700']]
" let s:p.visual.fugitive = [['white', '#AF3C00']]

" let s:p.normal.left     = [['#0E3D00', 'white', 'bold'], ['#65DE65', '#006600']]
" let s:p.normal.middle   = [['#65DE65', '#006600']]
" let s:p.normal.right    = [['#005300', '#66DE66'], ['#65DE65', '#008E00'], ['#65DE65', '#006600']]
" let s:p.normal.fugitive = [['white', '#008E00']]

let g:lightline#colorscheme#yoi#palette = lightline#colorscheme#fill(s:p)

unlet s:p

let g:lightline = {
      \   'colorscheme': 'yoi',
      \   'active': {
      \     'left': [
      \       ['mode',     'paste'],
      \       ['fugitive', 'filename', 'anzu']
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
      \     'charcode':     'MyCharCode',
      \     'anzu':         'anzu#search_status'
      \   },
      \   'component_expand': {
      \     'syntastic':    'SyntasticStatuslineFlag',
      \     'fugitive':     'MyFugitive'
      \   },
      \   'component_type': {
      \     'syntastic':    'error',
      \     'fugitive':     'fugitive'
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

function! MyMode()
  return  &ft ==   'unite'    ? 'Unite'    :
        \ &ft ==   'vimfiler' ? 'VimFiler' :
        \ &ft ==   'vimshell' ? 'VimShell' :
        \ &ft ==   'quickrun' ? 'quickrun' :
        \ &ft =~? 'lingr'     ? 'lingr'    :
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
        \  &ft ==  'tweetvim'  ? '' :
        \  &ft ==  'quickrun'  ? '' :
        \  &ft =~? 'lingr'     ? '' :
        \ ''  != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified()  ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()

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

function! MyCharCode()

  if &ft =~? s:lightlineNoDispFt
    return ''
  endif

  if winwidth(0) <= 80
    return ''
  endif

  " Get the output of :ascii
  redir => ascii
  silent! ascii
  redir END

  if match(ascii, 'NUL') != -1
    return 'NUL'
  endif

  " Zero pad hex values
  let nrformat = '0x%02x'

  let encoding = (&fenc == '' ? &enc : &fenc)

  if encoding == 'utf-8'
    " Zero pad with 4 zeroes in unicode files
    let nrformat = '0x%04x'
  endif

  " Get the character and the numeric value from the return value of :ascii
  " This matches the two first pieces of the return value, e.g.
  " "<F>  70" => char: 'F', nr: '70'
  let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

  " Format the numeric value
  let nr = printf(nrformat, nr)

  return "'". char ."' ". nr
endfunction
" }}}
" indentLine {{{
let g:indentLine_fileType    = ['c', 'cpp', 'cs', 'vim', 'rb', 'go', 'glsl', 'hlsl', 'xml', 'json']
let g:indentLine_faster      = 1
let g:indentLine_color_term  = 0
let g:indentLine_indentLevel = 20
let g:indentLine_char        = '⭟'
let g:indentLine_color_gui   = '#505050'

augroup MyAutoGroup
  autocmd BufReadPost * call s:SafeIndentLinesEnable()

  function! s:SafeIndentLinesEnable()
    if exists(':IndentLinesEnable')
      IndentLinesEnable
    endif
  endfunction
augroup END

" }}}
" }}}
" 編集 {{{
" vim-easy-align {{{
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
" }}}
" vim-smartinput-endwise {{{
" http://cohama.hateblo.jp/entry/2013/11/08/013136
let s:bundle = neobundle#get('vim-smartinput-endwise')
function! s:bundle.hooks.on_source(bundle)

  call smartinput_endwise#define_default_rules()
endfunction
unlet s:bundle
" }}}
" yankround {{{
let g:yankround_use_region_hl = 1

nmap p     <Plug>(yankround-p)
xmap p     <Plug>(yankround-p)
nmap P     <Plug>(yankround-P)
nmap gp    <Plug>(yankround-gp)
xmap gp    <Plug>(yankround-gp)
nmap gP    <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
" }}}
" increment-activator {{{
let g:increment_activator_filetype_candidates = {
      \   '_':   [['width', 'height']],
      \   'cs':  [['private', 'protected', 'public', 'internal']],
      \   'cpp': [['private', 'protected', 'public']],
      \ }
" }}}
" vim-over {{{
noremap <silent> <Leader>s :OverCommandLine<CR>

let g:over_command_line_key_mappings = {
      \   '\<C-j>': '\<Esc>',
      \ }
" }}}
" vim-expand-region {{{
map J <Plug>(expand_region_expand)
map K <Plug>(expand_region_shrink)

let g:expand_region_text_objects = {
      \   'il': 0,
      \   'ii': 0,
      \   'ai': 0,
      \   'ip': 0,
      \ }
" }}}
" }}}
" 補完 {{{
" neocomplete {{{
let s:bundle = neobundle#get('neocomplete.vim')
function! s:bundle.hooks.on_source(bundle)

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

  let g:neocomplete#skip_auto_completion_time               = ''
  let g:neocomplete#disable_auto_select_buffer_name_pattern = '\[Command Line\]'

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
unlet s:bundle
" }}}
" neosnippet {{{
let s:bundle = neobundle#get('neosnippet')
function! s:bundle.hooks.on_source(bundle)

  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#snippets_directory            = '$DOTVIM/snippets'

  if isdirectory(expand('$DOTVIM/snippets.local'))
    let g:neosnippet#snippets_directory = '$DOTVIM/snippets.local,' . g:neosnippet#snippets_directory
  endif

  call neocomplete#custom#source('neosnippet', 'rank', 1000)

  " Plugin key-mappings.
  imap <C-k>  <Plug>(neosnippet_expand_or_jump)
  smap <C-k>  <plug>(neosnippet_expand_or_jump)

  imap <expr> <Tab> neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'
  smap <expr> <Tab> neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'

  " for snippet_complete marker.
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
endfunction
unlet s:bundle

" }}}
" Omnisharp {{{
let s:bundle = neobundle#get('Omnisharp')
function! s:bundle.hooks.on_source(bundle)

  let g:Omnisharp_stop_server         = 0
  let g:OmniSharp_typeLookupInPreview = 1
endfunction
unlet s:bundle
" }}}
" }}}
" ファイル {{{
nmap <F5>  <Plug>(altr-back)
nmap <F6>  <Plug>(altr-forward)

let s:bundle = neobundle#get('vim-altr')
function! s:bundle.hooks.on_source(bundle)
  call altr#define('Models/%Model.cs',       'ViewModels/%Vm.cs',       'Views/%.xaml',       'Views/%.xaml.cs')
  call altr#define('Models/*/%Model.cs',     'ViewModels/*/%Vm.cs',     'Views/*/%.xaml',     'Views/*/%.xaml.cs')
  call altr#define('Models/*/*/%Model.cs',   'ViewModels/*/*/%Vm.cs',   'Views/*/*/%.xaml',   'Views/*/*/%.xaml.cs')
  call altr#define('Models/*/*/*/%Model.cs', 'ViewModels/*/*/*/%Vm.cs', 'Views/*/*/*/%.xaml', 'Views/*/*/*/%.xaml.cs')
  call altr#define('%Model.cs',              '%Vm.cs',                  '%.xaml',             '%.xaml.cs')
endfunction
unlet s:bundle
" }}}
" 検索 {{{
" clever-f.vim {{{
let g:clever_f_ignore_case           = 1
let g:clever_f_smart_case            = 1
let g:clever_f_across_no_line        = 1
let g:clever_f_use_migemo            = 1
let g:clever_f_chars_match_any_signs = ';'
" }}}
" vim-visualstar {{{
map *  <Plug>(visualstar-*)
map #  <Plug>(visualstar-#)
map g* <Plug>(visualstar-g*)
map g# <Plug>(visualstar-g#)
" }}}
" vim-anzu {{{
nmap <silent> n <Plug>(anzu-n)zOzz:<C-u>call <SID>BeginDisplayAnzu()<CR>:<C-u>call <SID>RefreshScreen()<CR>
nmap <silent> N <Plug>(anzu-N)zOzz:<C-u>call <SID>BeginDisplayAnzu()<CR>:<C-u>call <SID>RefreshScreen()<CR>
nmap <silent> * <Plug>(anzu-star):<C-u>call  <SID>RefreshScreen()<CR>
nmap <silent> # <Plug>(anzu-sharp):<C-u>call <SID>RefreshScreen()<CR>

let s:bundle = neobundle#get('vim-anzu')
function! s:bundle.hooks.on_source(bundle)

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
unlet s:bundle
" }}}
" }}}
" 言語 {{{
" syntastic {{{
let g:syntastic_cs_checkers = ['syntax', 'issues']
augroup MyAutoGroup
  function! s:SyntasticCheck()
    SyntasticCheck
    call lightline#update()
  endfunction

  autocmd BufWritePost *.{go,rb} call s:SyntasticCheck()
augroup END
" }}}
" clang_complete {{{
let s:bundle = neobundle#get('clang_complete')
function! s:bundle.hooks.on_source(bundle)

  let g:clang_use_library   = 1
  let g:clang_complete_auto = 0
  let g:clang_auto_select   = 0

  if s:isWindows
    let g:clang_user_options = '-I C:/Development/boost_1_55_0 -I "C:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include" -std=c++11 -fms-extensions -fmsc-version=1300 -fgnu-runtime -D__MSVCRT_VERSION__=0x700 -D_WIN32_WINNT=0x0500 2> NUL || exit 0"'
    let g:clang_library_path = 'C:/Development/llvm/build/bin/Release/'
  elseif s:isMac
    let g:clang_user_options = '-std=c++11'
  endif
endfunction
unlet s:bundle
" }}}
" vim-clang-format {{{
let s:bundle = neobundle#get('vim-clang-format')
function! s:bundle.hooks.on_source(bundle)

  if s:isWindows
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
unlet s:bundle
" }}}
" wandbox-vim {{{
let s:bundle = neobundle#get('wandbox-vim')
function! s:bundle.hooks.on_source(bundle)

  " wandbox.vim で quickfix を開かないようにする
  let g:wandbox#open_quickfix_window = 0

  let g:wandbox#default_compiler = {
        \   'cpp' : 'clang-head',
        \ }
endfunction
unlet s:bundle
" }}}
" vim-quickrun {{{
map <silent> [App]r    :<C-u>QuickRun<CR>

let s:bundle = neobundle#get('vim-quickrun')
function! s:bundle.hooks.on_source(bundle)

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
unlet s:bundle
" }}}
" vim-markdown {{{
let g:vim_markdown_folding_disabled = 0
" }}}
" }}}
" テキストオブジェクト {{{
" http://d.hatena.ne.jp/osyo-manga/20130717/1374069987
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
" http://qiita.com/rbtnn/items/a47ed6684f1f0bc52906
" vim-operator-replace {{{
nmap R         <Plug>(operator-replace)
xmap R         <Plug>(operator-replace)
" }}}
" operator-camelize.vim {{{
nmap <Leader>c <Plug>(operator-camelize-toggle)iw
xmap <Leader>c <Plug>(operator-camelize-toggle)iw
" }}}
" vim-operator-sort {{{
nmap <Leader>o <Plug>(operator-sort)
xmap <Leader>o <Plug>(operator-sort)
" }}}
" vim-rengbang {{{
nmap <Leader>r <Plug>(operator-rengbang)
xmap <Leader>r <Plug>(operator-rengbang)
" }}}
" vim-operator-jump_side {{{
nmap <silent> <Leader><Leader> <Plug>(operator-jump-toggle)ai:<C-u>call <SID>RefreshScreen()<CR>
" }}}
" }}}
" アプリ {{{
" open-browser.vim {{{
let g:netrw_nogx                   = 1 " disable netrw's gx mapping.
let g:openbrowser_no_default_menus = 1

nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}
" vimshell.vim {{{
noremap <silent> [App]s :<C-u>VimShellPop<CR>

let g:vimshell_popup_height = 40
" }}}
" VimFiler {{{
noremap <silent> [App]f :<C-u>VimFilerBufferDir<CR>

let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)

  augroup MyAutoGroup
    autocmd FileType vimfiler call s:vimfiler_my_settings()
  augroup END

  function! s:vimfiler_my_settings()
    nmap <buffer><expr> <Enter> vimfiler#smart_cursor_map(
          \  "\<Plug>(vimfiler_cd_file)",
          \  "\<Plug>(vimfiler_edit_file)")
    nmap <buffer><expr> <C-j> vimfiler#smart_cursor_map(
          \  "\<Plug>(vimfiler_exit)",
          \  "\<Plug>(vimfiler_exit)")

    " dotfile表示状態に設定
    exe ':normal .'
  endfunction

  let g:vimfiler_as_default_explorer        = 1
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_tree_leaf_icon             = ' '
endfunction
unlet s:bundle
" }}}
" lingr. vim {{{
noremap <silent> [App]1 :<C-u>call <SID>ToggleLingr()<CR>

let s:bundle = neobundle#get('lingr-vim')
function! s:bundle.hooks.on_source(bundle)

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
unlet s:bundle

function! s:ToggleLingr()
  if bufnr('lingr-messages') == -1
    tabnew
    LingrLaunch
    exe 'wincmd l'
  else
    LingrExit
  endif
endfunction
" }}}
" Tweetvim {{{
noremap <silent> [App]2 :<C-u>call <SID>ToggleTweetVim()<CR>

function! s:ToggleTweetVim()
  if bufnr('tweetvim') == -1
    tabnew
    TweetVimHomeTimeline
  else
    silent! exe 'bwipeout tweetvim'
  endif
endfunction

let s:bundle = neobundle#get('TweetVim')
function! s:bundle.hooks.on_source(bundle)

  let g:tweetvim_include_rts       = 1
  let g:tweetvim_display_separator = 0
  let g:tweetvim_tweet_per_page    = 35
  let g:tweetvim_display_icon      = 1

  augroup MyAutoGroup
    autocmd FileType tweetvim call s:SetTweetVim()

    function! s:SetTweetVim()
      nmap     <silent><buffer> rr <Plug>(tweetvim_action_reload)
      nnoremap <silent><buffer> q  :<C-u>call <SID>ToggleTweetVim()<CR>
    endfunction
  augroup END
endfunction
unlet s:bundle
" }}}
" }}}
" Unite {{{
nnoremap [Unite] <Nop>
xnoremap [Unite] <Nop>
nmap     <Space> [Unite]
xmap     <Space> [Unite]

nnoremap <silent> [Unite]g  :<C-u>Unite grep -prompt-direction=top -auto-preview -no-split -buffer-name=search-buffer<CR>
nnoremap <silent> [Unite]pg :<C-u>call <SID>unite_grep_project('-prompt-direction=top -auto-preview -no-split -buffer-name=search-buffer')<CR>
nnoremap <silent> [Unite]r  :<C-u>UniteResume -prompt-direction=top -no-split search-buffer<CR>

nnoremap <silent> [Unite]f  :<C-u>Unite -prompt-direction=top -no-split file<CR>
nnoremap <silent> [Unite]b  :<C-u>Unite -prompt-direction=top -no-split buffer<CR>
nnoremap <silent> [Unite]t  :<C-u>Unite -prompt-direction=top -no-split tab<CR>
nnoremap <silent> [Unite]l  :<C-u>Unite -prompt-direction=top -no-split line<CR>
nnoremap <silent> [Unite]o  :<C-u>Unite -prompt-direction=top -no-split outline<CR>
nnoremap <silent> [Unite]z  :<C-u>Unite -prompt-direction=top -no-split fold<CR>
nnoremap <silent> [Unite]q  :<C-u>Unite -prompt-direction=top -no-quit -horizontal quickfix<CR>

if s:isWindows
  nnoremap <silent> [Unite]m  :<C-u>Unite -prompt-direction=top -no-split neomru/file everything<CR>
  nnoremap <silent> [Unite]e  :<C-u>Unite -prompt-direction=top -no-split everything<CR>
else
  " nnoremap <silent> [Unite]m  :<C-u>Unite -prompt-direction=top -no-split neomru/file spotlight<CR>
  " nnoremap <silent> [Unite]e  :<C-u>Unite -prompt-direction=top -no-split spotlight<CR>
  nnoremap <silent> [Unite]m  :<C-u>Unite -prompt-direction=top -no-split neomru/file<CR>
endif

nnoremap          [Unite]uu :<C-u>NeoBundleUpdate<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>
nnoremap          [Unite]ui :<C-u>NeoBundleInstall<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>
nnoremap          [Unite]uc :<C-u>NeoBundleClearCache<CR>

" http://sanrinsha.lolipop.jp/blog/2013/03/%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E5%86%85%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92unite-grep%E3%81%99%E3%82%8B.html
function! s:unite_grep_project(...)
  let opts = (a:0 ? join(a:000, ' ') : '')
  let dir = unite#util#path2project_directory(expand('%'))
  exe 'Unite' opts 'grep:' . dir
endfunction

let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)

  " let g:unite_winwidth = s:rightWindowWidth

  let g:unite_enable_split_vertically         = 1
  let g:unite_split_rule                      = 'rightbelow'

  " insert modeで開始
  let g:unite_enable_start_insert             = 1

  let g:unite_force_overwrite_statusline = 0

  call unite#custom#source('fold', 'matchers', 'matcher_migemo')

  " http://blog.monochromegane.com/blog/2014/01/16/the-platinum-searcher/
  " https://github.com/monochromegane/the_platinum_searcher
  if executable('pt')
    let g:unite_source_grep_command       = 'pt'
    let g:unite_source_grep_default_opts  = '--nogroup --nocolor -S'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding      = 'utf-8'
  endif
endfunction
unlet s:bundle
" unite-everything {{{
if s:isWindows
  let s:bundle = neobundle#get('unite-everything')
  function! s:bundle.hooks.on_source(bundle)
    call unite#custom_max_candidates('everything', 300)

    let g:unite_source_everything_full_path_search = 1
  endfunction
  unlet s:bundle
endif
" }}}
" neomru.vim {{{
let s:bundle = neobundle#get('neomru.vim')
function! s:bundle.hooks.on_source(bundle)
  let g:neomru#update_interval = 1
  let g:neomru#file_mru_limit  = 500
endfunction
unlet s:bundle
" }}}
" }}}
" その他 {{{
" NeoBundleLazy したプラグインをフォーカスが外れている時に自動的に読み込む {{{
" http://d.hatena.ne.jp/osyo-manga/20140212

" Lazy しているプラグイン名をリストアップ
function! s:get_lazy_plugins()
  return map(filter(neobundle#config#get_neobundles(), 'v:val.lazy'), 'v:val.name')
endfunction

function! s:is_not_sourced(source)
  return neobundle#config#is_installed(a:source) && !neobundle#config#is_sourced(a:source)
endfunction

function! s:source()
  let sources = map(filter(s:get_lazy_plugins(), 's:is_not_sourced(v:val)'), 'v:val')

  for s in sources
    call neobundle#source(s)
  endfor

  " 明示的に初期化したいものはここで
  " call over#load()

  augroup auto-source
    autocmd!
  augroup END

  echom ''
endfunction

augroup auto-source
  autocmd!
  autocmd FocusLost * call s:source()
augroup END
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
" golang {{{
if s:isStarting
  if !exists('$GOROOT')
    if s:isMac
      let $GOROOT = '/usr/local/opt/go/libexec'
    endif
  endif

  exe 'set rtp+=' . globpath($GOROOT, 'misc/vim')
endif
" }}}

let s:firstOneShotDelay = 2
let s:firstOneShotPhase = 0
function! s:FirstOneShot() " {{{

  function! s:FirstOneShotPhase0()

    filetype plugin indent on

    " 表示 {{{
    " NeoBundleSource indentLine
    " NeoBundleSource lightline.vim
    NeoBundleSource matchparenpp
    " }}}
    " 編集 {{{
    NeoBundleSource tcomment_vim
    NeoBundleSource vim-surround
    NeoBundleSource vim-repeat
    " }}}
    " ファイル {{{
    NeoBundleSource vim-altr
    " }}}
    " 検索 {{{
    NeoBundleSource vim-anzu
    NeoBundleSource matchit.zip
    " }}}
    " アプリ {{{
    NeoBundleSource vim-fugitive
    if s:isWindows && s:isGuiRunning
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

    set incsearch                     " インクリメンタルサーチ
    set ignorecase                    " 検索パターンにおいて大文字と小文字を区別しない。
    set smartcase                     " 検索パターンが大文字を含んでいたらオプション 'ignorecase' を上書きする。

    if filereadable(s:vimrc_local)
      exe 'source' s:vimrc_local
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

    " call over#load()
  endfunction

  function! s:FirstOneShotPhase2()
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
  autocmd BufEnter,WinEnter,BufWinEnter,BufWritePost *                   call s:UpdateAll()
  autocmd BufNewFile,BufRead                         *.xaml              setlocal ft=xml
  autocmd BufNewFile,BufRead                         *.json              setlocal ft=json
  autocmd BufNewFile,BufRead                         *.{fx,fxc,fxh,hlsl} setlocal ft=hlsl
  autocmd BufNewFile,BufRead                         *.{fsh,vsh}         setlocal ft=glsl
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
      silent! exe 'lcd' fnameescape(expand('%:p:h'))
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
    setlocal foldlevel=100
    setlocal foldcolumn=5
  endfunction

  function! s:SetGo()
    setlocal foldmethod=syntax
    setlocal shiftwidth=4
    setlocal noexpandtab
    setlocal tabstop=4
    compiler go

    let g:godef_split                    = 0
    let g:godef_same_file_in_same_window = 1

    nnoremap <buffer> <Leader><C-k><C-k> :<C-u>Godoc<CR>zz
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

    map <silent><buffer> [App]r    :<C-u>QuickRun cpp/wandbox<CR>
  endfunction

  function! s:SetCs()
    setlocal omnifunc=OmniSharp#Complete
    setlocal foldmethod=syntax
    let g:omnicomplete_fetch_full_documentation = 0

    nnoremap <buffer> <F12>   :<C-u>call OmniSharp#GotoDefinition()<CR>zz
    nnoremap <buffer> <S-F12> :<C-u>call OmniSharp#FindUsages()<CR>
  endfunction

  function! s:SetUnite()
    let unite = unite#get_current_unite()
    if unite.buffer_name =~# '^search'
      nmap <silent><buffer><expr> <C-r> unite#do_action('replace')
      imap <silent><buffer><expr> <C-r> unite#do_action('replace')
    endif

    nmap <buffer> <C-v> <Plug>(unite_toggle_auto_preview)
    imap <buffer> <C-v> <Plug>(unite_toggle_auto_preview)
    nmap <buffer> <C-j> <Plug>(unite_exit)
  endfunction

  function! s:SetHelp()
    noremap  <silent><buffer> q     :<C-u>close<CR>
  endfunction

  function! s:SetNeosnippet()
    setlocal noexpandtab
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
    exe a:firstline
  endfunction

  function! s:undo_entry()
    let history = get(w:, 'qf_history', [])
    if !empty(history)
      call setqflist(remove(history, -1), 'r')
    endif
  endfunction

  " 場所ごとに設定を用意する {{{
  " http://vim-users.jp/2009/12/hack112/
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))

  function! s:vimrc_local(loc)
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
set modeline                      " モードラインを有効
set virtualedit=block
set autoread                      " 他で書き換えられたら自動で読み直す
set whichwrap=b,s,h,l,<,>,[,]     " カーソルを行頭、行末で止まらないようにする
set mouse=a                       " 全モードでマウスを有効化
set hidden                        " 変更中のファイルでも、保存しないで他のファイルを表示
set timeoutlen=2000
set iminsert=0                    " 挿入モードでのデフォルトのIME状態設定
set imsearch=0                    " 検索モードでのデフォルトのIME状態設定
set formatexpr=autofmt#japanese#formatexpr()
set nrformats-=octal
set nrformats+=alpha
set completeopt=longest,menuone
set backspace=indent,eol,start

noremap  U                  J
nnoremap <Leader><C-k>      :<C-u>help<Space>
nnoremap <Leader><C-k><C-k> :<C-u>help <C-r><C-w><CR>

" ^Mを取り除く
command! RemoveCr call s:ExecuteKeepView('silent! %substitute/\r$//g | nohlsearch')

" 行末のスペースを取り除く
command! RemoveEolSpace call s:ExecuteKeepView('silent! %substitute/ \+$//g | nohlsearch')

" 整形
command! Format call s:SmartFormat()

" http://lsifrontend.hatenablog.com/entry/2013/10/11/052640
nmap     <silent> <C-CR> yy:<C-u>TComment<CR>p
vnoremap <silent> <C-CR> :<C-u>call <SID>CopyAddComment()<CR>

" http://qiita.com/akira-hamada/items/2417d0bcb563475deddb をもとに調整
function! s:CopyAddComment() range
  let selectedCount = line("'>") - line("'<")

  " 選択中の行をyank
  normal! ""gvy

  " yankした物をPする
  normal P

  " 元のコードを選択
  if selectedCount == 0
    exe 'normal V'
  else
    exe 'normal V' . selectedCount . 'j'
  endif

  " コメントアウトする
  normal gc

  " ビジュアルモードからエスケープ
  exe "normal! \e\e"

  " 元の位置に戻る
  exe 'normal ' . (selectedCount + 1) . 'j'
endfunction

" http://vim.wikia.com/wiki/Pretty-formatting_XML
function! s:DoFormatXML() range
  " Save the file type
  let l:origft = &ft

  " Clean the file type
  set ft=

  " Add fake initial tag (so we can process multiple top-level elements)
  exe ":let l:beforeFirstLine=" . a:firstline . "-1"
  if l:beforeFirstLine < 0
    let l:beforeFirstLine=0
  endif
  exe a:lastline . "put ='</PrettyXML>'"
  exe l:beforeFirstLine . "put ='<PrettyXML>'"
  exe ":let l:newLastLine=" . a:lastline . "+2"
  if l:newLastLine > line('$')
    let l:newLastLine=line('$')
  endif

  " Remove XML header
  exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

  " Recalculate last line of the edited code
  let l:newLastLine=search('</PrettyXML>')

  " Execute external formatter
  exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

  " Recalculate first and last lines of the edited code
  let l:newFirstLine=search('<PrettyXML>')
  let l:newLastLine=search('</PrettyXML>')

  " Get inner range
  let l:innerFirstLine=l:newFirstLine+1
  let l:innerLastLine=l:newLastLine-1

  " Remove extra unnecessary indentation
  exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

  " Remove fake tag
  exe l:newLastLine . "d"
  exe l:newFirstLine . "d"

  " Put the cursor at the first line of the edited code
  exe ":" . l:newFirstLine

  " Restore the file type
  exe "set ft=" . l:origft
endfunction
command! -range=% XmlFormat <line1>,<line2>call s:DoFormatXML()

" http://qiita.com/tekkoc/items/324d736f68b0f27680b8
function! s:Jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif

  exe "%! jq \"" . l:arg . "\""
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
" インデント {{{
set autoindent
set cindent                       " Cプログラムファイルの自動インデントを始める

set list
set listchars=tab:\⭟\ ,eol:↲,extends:»,precedes:«,nbsp:%

vnoremap < <gv
vnoremap > >gv
" }}}
" タブ {{{
set tabstop=4                     " ファイル内の <Tab> が対応する空白の数。
set softtabstop=4                 " <Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数。
set shiftwidth=4                  " インデントの各段階に使われる空白の数。
set expandtab                     " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う。
" }}}
" バックアップ・スワップファイル {{{
set noswapfile                    " スワップファイルを作らない
set nobackup                      " バックアップファイルを使わない

" 自動ミラーリング {{{
let s:mirrorDir = expand('$DOTVIM/mirror')
let s:mirrorMaxHistory = 7
augroup MyAutoGroup
  autocmd VimEnter    * call s:TrimMirrorDirs()
  autocmd BufWritePre * call s:MirrorCurrentFile()

  " 古いミラーディレクトリを削除する
  function! s:TrimMirrorDirs()

    let mirrorDirs = sort(split(glob(s:mirrorDir . '/*'),  '\n'))

    while len(mirrorDirs) > s:mirrorMaxHistory
      let dir = remove(mirrorDirs, 0)
      call s:RemoveDir(dir)
    endwhile
  endfunction

  " カレントファイルをミラーリングする
  function! s:MirrorCurrentFile()

    let sourceFilepath = expand('%:p')

    if filereadable(sourceFilepath)
      " ファイルパス作成
      let currentMirrorDir = s:mirrorDir . '/' . strftime('%Y%m%d')
      let currentPostfix   = strftime('%H%M%S')
      let filename         = expand('%:p:t:r')
      let ext              = expand('%:p:t:e')

      if ext != ''
        let ext = '.' . ext
      endif

      let outputFilepath = currentMirrorDir . '/' . filename . currentPostfix . ext

      " ミラー先ディレクトリを確認
      call s:MakeDir(currentMirrorDir)

      " 保存直前状態をミラー先にコピーする
      call s:CopyFile(sourceFilepath, outputFilepath)
    endif
  endfunction
augroup END
" }}}
" }}}
" 検索 {{{
if executable('pt')
  set grepprg=pt\ --nogroup\ --nocolor\ -S
  set grepformat=%f:%l:%m
endif

" 日本語インクリメンタルサーチ
if has('migemo')
  set migemo

  if s:isWindows
    set migemodict=$VIM/dict/utf-8/migemo-dict
  elseif s:isMac
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
set number                        " 行番号表示
set textwidth=0                   " 一行に長い文章を書いていても自動折り返しをしない
set showcmd                       " コマンドをステータス行に表示
set showmatch                     " 括弧の対応をハイライト
set wrap                          " ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
set noshowmode                    " モードを表示しない（ステータスラインで表示するため）
set shortmess+=I                  " 起動時のメッセージを表示しない
set lazyredraw                    " スクリプト実行中に画面を描画しない
set wildmenu
set wildmode=list:full            " コマンドライン補完を便利に
" set wildignorecase                " 補完時に大文字小文字を区別しない
set showfulltag
set wildoptions=tagfile
set fillchars=vert:\              " 縦分割の境界線
set synmaxcol=500                 " ハイライトする文字数を制限する
set updatetime=220
set previewheight=24
set laststatus=0
set cmdheight=1
set laststatus=2
set showtabline=2

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

  function! s:IsUniteRunning()
    return &ft == 'unite'
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
let g:foldCCtext_enable_autofdc_adjuster = 1

set foldcolumn=0
set foldlevel=99
set foldtext=foldCC#foldtext()

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
nmap     <silent> gg    ggzOzz:<C-u>call  <SID>RefreshScreen()<CR>
nmap     <silent> G     GzOzz:<C-u>call   <SID>RefreshScreen()<CR>

noremap  <silent> <C-i> <C-i>zz:<C-u>call <SID>RefreshScreen()<CR>
noremap  <silent> <C-o> <C-o>zz:<C-u>call <SID>RefreshScreen()<CR>
map      <silent> H     :<C-u>call <SID>DisableVirtualCursor()<CR>^:<C-u>call <SID>RefreshScreen()<CR>
map      <silent> L     :<C-u>call <SID>DisableVirtualCursor()<CR>$:<C-u>call <SID>RefreshScreen()<CR>

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
if s:isGuiRunning
  noremap <silent> [Window]H :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]J :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]K :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]L :<C-u>call <SID>ResizeWin()<CR>
  noremap <silent> [Window]h :MoveWin<CR>
  noremap <silent> [Window]j :MoveWin<CR>
  noremap <silent> [Window]k :MoveWin<CR>
  noremap <silent> [Window]l :MoveWin<CR>
  noremap <silent> [Window]f :<C-u>call <SID>FullWindow()<CR>
endif
" }}}
" タブライン操作 {{{
nnoremap [Tab]     <Nop>
nmap     <Leader>t [Tab]

nnoremap <silent> [Tab]c :tabnew<CR>
nnoremap <silent> [Tab]x :tabclose<CR>

for s:n in range(1, 9)
  exe 'nnoremap <silent> [Tab]' . s:n  ':<C-u>tabnext' . s:n . '<CR>'
endfor

nnoremap <silent> <C-K> :<C-u>tabp<CR>
nnoremap <silent> <C-J> :<C-u>tabn<CR>

" Vimですべてのバッファをタブ化する
" http://qiita.com/kuwa72/items/deef2703af74d2d993ee
nnoremap <silent> <C-L> :<C-u>call <SID>CleanEmptyBuffers()<CR>:<C-u>tab ba<CR>
" }}}
" バッファ操作 {{{
nnoremap [Buffer]  <Nop>
nmap     <Leader>b [Buffer]

nnoremap <silent> [Buffer]x :bdelete<CR>
nnoremap <silent> <Leader>x :bdelete<CR>

for s:n in range(1, 9)
  exe 'nnoremap <silent> [Buffer]' . s:n  ':<C-u>b' . s:n . '<CR>'
endfor
" }}}
" ファイル操作 {{{
" vimrc / gvimrc の編集
nnoremap <silent> <F1> :<C-u>call <SID>SmartOpen($MYVIMRC)<CR>
nnoremap <silent> <F2> :<C-u>call <SID>SmartOpen($MYGVIMRC)<CR>
nnoremap <silent> <F3> :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
" }}}
" マーク {{{
nmap <silent> <Leader>m `
" }}}
" ヘルプ {{{
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
  exe 'winpos' getwinposx() '0'
  exe 'set lines=9999'
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
  exe 'botright vertical' s:baseColumns 'split'
endf

function! s:CloseVSplitWide()

  let s:depthVsp -= 1
  let &columns = s:baseColumns * s:depthVsp
  call s:SmartClose()

  if s:depthVsp == 1
    exe 'winpos' s:opendLeftVsp s:opendTopVsp
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
    if  &columns == s:baseColumns
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
  "   exe 'edit' a:filepath
  " else
  "   exe 'tabnew' a:filepath
  " endif

  exe ':edit' a:filepath
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
    exe 'bd ' join(buffers, ' ')
  endif
endfunction
" }}}
" ファイルコピー{{{
function! s:CopyFile(sourceFilepath, targetFilepath)

  let esource = vimproc#shellescape(expand(a:sourceFilepath))
  let etarget = vimproc#shellescape(expand(a:targetFilepath))

  if s:isWindows
    call vimproc#system('copy ' . esource . ' ' . etarget)
  elseif s:isMac
    call vimproc#system('cp ' . esource . ' ' . etarget)
  else
    echo 'CopyFile : Not supported.'
  endif
endfunction
" }}}
" ディレクトリ作成 {{{
function! s:MakeDir(path)

  if isdirectory(a:path) == 0
    call mkdir(a:path, 'p')
  endif
endfunction
" }}}
" ディレクトリ削除 {{{
function! s:RemoveDir(path)

  let epath = vimproc#shellescape(expand(a:path))

  if isdirectory(a:path)
    if s:isWindows
      call vimproc#system_bg('rd /S /Q ' . epath)
    elseif s:isMac
      call vimproc#system_bg('rm -rf ' . epath)
    else
      echo 'RemoveDir : Not supported.'
    endif
  endif
endfunction
" }}}
" 現在位置にテキストを挿入する {{{
function! s:InsertTextAtCurrent(text)

  let pos = getpos('.')
  exe ':normal i' . a:text
  call setpos('.', pos)
endfunction
" }}}
" コマンド実行後の表示状態を維持する {{{
function! s:ExecuteKeepView(expr)

  let wininfo = winsaveview()
  exe a:expr
  call winrestview(wininfo)
endfunction
" }}}
" カーソル位置のn文字前を取得する {{{
" http://d.hatena.ne.jp/eagletmt/20100623/1277289728
function! s:GetPrevCursorChar(n)

  let chars = split(getline('.')[0 : col('.') - 1], '\zs')
  let len = len(chars)
  if a:n >= len
    return ''
  else
    return chars[len(chars) - a:n - 1]
  endif
endfunction
" }}}
" 現在位置が括弧上にあるか 0:ない 1:開括弧 2:閉括弧 {{{
function! s:GetOnBraceChar()

  let s:openBraces  = ['(', '{', '[', '<', '"', "'"]
  let s:closeBraces = [')', '}', ']', '>']

  let s:currentChar = s:GetPrevCursorChar(0)
  for s:b in s:openBraces
    if s:b == s:currentChar
      return 1
    endif
  endfor

  for s:b in s:closeBraces
    if s:b == s:currentChar
      return 2
    endif
  endfor

  return 0
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
" }}}
" コンソール用 {{{
if !s:isGuiRunning

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

