set nocompatible
set encoding=utf-8
scriptencoding utf-8
" 基本 {{{
let s:is_windows     = has('win32') || has('win64')
let s:is_mac         = has('mac') || has('macunix')
let s:is_linux       = has('unix') && !s:is_windows && !s:is_mac
let s:is_gui_running = has('gui_running')
let s:is_starting    = has('vim_starting')

if s:is_starting
  let s:git_dot_vimrc = expand('~/dotfiles/.vimrc')

  if filereadable(s:git_dot_vimrc)
    let $MYVIMRC = s:git_dot_vimrc
  endif

  unlet s:git_dot_vimrc
endif

let g:mapleader    = ','
let s:base_columns = 120
let s:vimrc_local  = expand('~/.vimrc_local')
let $DOTVIM        = expand('~/.vim')
set viminfo+=!

" メニューを読み込まない
let g:did_install_default_menus = 1

augroup MyAutoCmd
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
if s:is_windows && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
if s:is_mac
  set iskeyword=@,48-57,_,128-167,224-235
  let $PATH = simplify($VIM . '/../../MacOS') . ':' . $PATH
endif

" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

nnoremap [App] <Nop>
nmap     ;     [App]

" guioptions {{{
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
" }}}
" プラグイン {{{
function! s:set_neobundle() " {{{
  " ライブラリ
  NeoBundle     'Shougo/vimproc'
  NeoBundle     'tpope/vim-dispatch'
  NeoBundle     'xolox/vim-misc'
  NeoBundle     'xolox/vim-shell'
  NeoBundleLazy 'basyura/twibill.vim'
  NeoBundleLazy 'LeafCage/nebula.vim'
  NeoBundleLazy 'mattn/webapi-vim'
  NeoBundleLazy 'tyru/open-browser.vim'
  if !has('kaoriya')
    NeoBundle 'vim-jp/vimdoc-ja'
  endif

  " 表示
  NeoBundle     'tomasr/molokai'
  NeoBundle     'Yggdroot/indentLine'
  NeoBundle     'itchyny/lightline.vim'
  NeoBundle     'vim-scripts/matchparenpp'
  NeoBundleLazy 'YoshihiroIto/tagbar'
  NeoBundleLazy 'LeafCage/foldCC'
  if s:is_gui_running
    NeoBundleLazy 'movewin.vim'
    NeoBundleLazy 'YoshihiroIto/vim-resize-win'
  endif

  " 編集
  NeoBundle     'tpope/vim-surround'
  NeoBundle     'tpope/vim-repeat'
  NeoBundleLazy 'tomtom/tcomment_vim'
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
  NeoBundleLazy 'koron/codic-vim'

  " ファイル
  NeoBundle     'YoshihiroIto/vim-auto-mirroring'
  NeoBundleLazy 'kana/vim-altr'

  " 検索
  NeoBundle     'matchit.zip'
  NeoBundleLazy 'osyo-manga/vim-anzu'
  NeoBundleLazy 'rhysd/clever-f.vim'
  NeoBundleLazy 'Lokaltog/vim-easymotion'
  NeoBundleLazy 'thinca/vim-visualstar'

  " 言語
  NeoBundle     'YoshihiroIto/vim-gocode'
  NeoBundleLazy 'YoshihiroIto/syntastic'
  NeoBundleLazy 'Rip-Rip/clang_complete'
  NeoBundleLazy 'rhysd/vim-clang-format'
  NeoBundleLazy 'osyo-manga/shabadou.vim'
  NeoBundleLazy 'vim-jp/cpp-vim'
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
  NeoBundleLazy 'glts/vim-textobj-comment'
  NeoBundleLazy 'sgur/vim-textobj-parameter'
  NeoBundleLazy 'rhysd/vim-textobj-anyblock'
  NeoBundleLazy 'h1mesuke/textobj-wiw'
  NeoBundleLazy 'whatyouhide/vim-textobj-xmlattr'

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
  NeoBundleLazy 'glidenote/memolist.vim'
  NeoBundleLazy 'Shougo/vinarise.vim'
  NeoBundleLazy 'cohama/agit.vim'
  if s:is_mac
    NeoBundleLazy 'itchyny/dictionary.vim'
  endif
  if s:is_windows && s:is_gui_running
    NeoBundle 'YoshihiroIto/vim-icondrag'
  endif

  " Unite
  NeoBundle     'Shougo/unite.vim'
  NeoBundle     'Shougo/neomru.vim'
  NeoBundleLazy 'Shougo/unite-outline'
  NeoBundleLazy 'osyo-manga/unite-quickfix'
  NeoBundleLazy 'osyo-manga/unite-fold'
  NeoBundleLazy 'YoshihiroIto/vim-unite-giti'
  NeoBundleLazy 'rhysd/unite-codic.vim'
  if s:is_windows
    NeoBundleLazy 'sgur/unite-everything'
  endif
endfunction " }}}

if s:is_starting
  let g:neobundle#install_max_processes = 8
  set rtp+=$DOTVIM/bundle/neobundle.vim/
endif

call neobundle#begin(expand('$DOTVIM/bundle/'))

if neobundle#has_fresh_cache()
  NeoBundleLoadCache
else
  NeoBundleFetch 'Shougo/neobundle.vim'
  call s:set_neobundle()
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
let g:shell_mappings_enabled = 0
" }}}
" twibill.vim {{{
if neobundle#tap('twibill.vim')
  call neobundle#config({
        \   'depends': ['vimproc'],
        \ })

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

  let g:netrw_nogx                   = 1
  let g:openbrowser_no_default_menus = 1

  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  call neobundle#untap()
endif
" }}}
" dictionary.vim {{{
if s:is_mac
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
        \   'depends':  ['vimproc'],
        \   'autoload': {
        \     'commands': ['TagbarToggle']
        \   }
        \ })

  noremap <silent> <C-t> :<C-u>TagbarToggle<CR>

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
" vim-resize-win {{{
if neobundle#tap('vim-resize-win')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['ResizeWin']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" lightline {{{

" g:lightline#colorscheme#powerline#palette
let s:p                = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.right   = [['gray5', 'gray10'], ['gray9', 'gray4'], ['gray8', 'gray2']]
let s:p.inactive.right = [['gray1', 'gray5'], ['gray4', 'gray1'], ['gray4', 'gray0']]
let s:p.inactive.left  = s:p.inactive.right[1:]
let s:p.replace.left   = [['white', 'brightred', 'bold'], ['white', 'gray4']]
let s:p.normal.middle  = [['gray7', 'gray2']]
let s:p.replace.middle = s:p.normal.middle
let s:p.replace.right  = s:p.normal.right
let s:p.tabline.left   = [['gray9', 'gray4']]
let s:p.tabline.tabsel = [['gray9', 'gray1']]
let s:p.tabline.middle = [['gray2', 'gray8']]
let s:p.tabline.right  = [['gray9', 'gray3']]
let s:p.normal.error   = [['gray9', 'brightestred']]
let s:p.normal.warning = [['gray1', 'yellow']]
" 以下yoi固有
let s:p.normal.left    = [['#195E00', '#07AF00', 'bold'], ['gray7', 'gray2']]
let s:p.normal.branch  = [['white', 'gray4']]
let s:p.insert.left    = [['darkestcyan', 'white', 'bold'], ['mediumcyan', 'darkestblue']]
let s:p.insert.middle  = [['mediumcyan', 'darkestblue']]
let s:p.insert.right   = [['darkestcyan', 'mediumcyan'], ['mediumcyan', 'darkblue'], ['mediumcyan', 'darkestblue']]
let s:p.insert.branch  = [['white', 'darkblue']]
let s:p.visual.left    = [['#AB2362', 'white', 'bold'], ['#FF84BA', '#870036']]
let s:p.visual.middle  = [['#FF84BA', '#870036']]
let s:p.visual.right   = [['#75003D', '#FF87BB'], ['#FE86BB', '#AF0053'], ['#FF84BA', '#870036']]
let s:p.visual.branch  = [['white', '#AF0053']]

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
      \     'fileformat':   'LightlineFileformat',
      \     'filetype':     'LightlineFiletype',
      \     'fileencoding': 'LightlineFileencoding',
      \     'modified':     'LightlineModified',
      \     'readonly':     'LightlineReadonly',
      \     'filename':     'LightlineFilename',
      \     'mode':         'LightlineMode',
      \     'anzu':         'anzu#search_status'
      \   },
      \   'component_expand': {
      \     'syntastic':    'SyntasticStatuslineFlag',
      \     'branch':       'LightlineCurrentBranch',
      \     'gitgutter':    'LightlineGitSummary',
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

function! LightlineMode()
  return  &ft ==  'unite'    ? 'Unite'    :
        \ &ft ==  'vimfiler' ? 'VimFiler' :
        \ &ft ==  'vimshell' ? 'VimShell' :
        \ &ft ==  'tweetvim' ? 'TweetVim' :
        \ &ft ==  'quickrun' ? 'quickrun' :
        \ &ft =~? 'lingr'    ? 'lingr'    :
        \ &ft =~? 'agit'     ? 'Agit'     :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let s:lighline_no_disp_ft = 'vimfiler\|unite\|vimshell\|tweetvim\|quickrun\|lingr\|agit'

function! LightlineModified()
  return &ft =~ s:lighline_no_disp_ft ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? s:lighline_no_disp_ft && &readonly ? '⭤' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft ==  'vimfiler'  ? vimfiler#get_status_string() :
        \  &ft ==  'unite'     ? unite#get_status_string() :
        \  &ft ==  'vimshell'  ? vimshell#get_status_string() :
        \  &ft =~? 'lingr'     ? lingr#status() :
        \  &ft ==  'tweetvim'  ? '' :
        \  &ft ==  'quickrun'  ? '' :
        \ ''  != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified()  ? ' ' . LightlineModified() : '')
endfunction

function! LightlineCurrentBranch()
  if &ft =~? s:lighline_no_disp_ft
    return ''
  endif

  if !s:is_in_git_branch()
    return ''
  endif

  if &ft !~? 'vimfiler'
    let _ = fugitive#head()
    return strlen(_) ? '⭠ ' . _ : ''
  endif

  return ''
endfunction

function! LightlineFileformat()
  if &ft =~? s:lighline_no_disp_ft
    return ''
  endif

  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  if &ft =~? s:lighline_no_disp_ft
    return ''
  endif

  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  if &ft =~? s:lighline_no_disp_ft
    return ''
  endif

  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

augroup MyAutoCmd
  autocmd CursorHold,CursorHoldI * call lightline#update()
augroup END

function! LightlineGitSummary()
  if winwidth(0) <= 70
    return ''
  endif

  if &ft =~? s:lighline_no_disp_ft
    return ''
  endif

  if !s:is_in_git_branch()
    return ''
  endif

  let summary = gitgutter#hunk#summary()

  return printf('%s%d %s%d %s%d',
        \ g:gitgutter_sign_added,    summary[0],
        \ g:gitgutter_sign_modified, summary[1],
        \ g:gitgutter_sign_removed,  summary[2])
endfunction
" }}}
" indentLine {{{
let g:indentLine_fileType = [
      \   'c',    'cpp',  'cs', 'go',
      \   'ruby', 'lua',  'python',
      \   'vim',
      \   'glsl', 'hlsl',
      \   'xml',  'json', 'markdown'
      \ ]
let g:indentLine_faster          = 1
let g:indentLine_color_term      = 0
let g:indentLine_indentLevel     = 20
let g:indentLine_char            = '⭟'
let g:indentLine_color_gui       = '#505050'
let g:indentLine_noConcealCursor = 1

augroup MyAutoCmd
  autocmd BufReadPost * IndentLinesEnable
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
" tcomment_vim {{{
if neobundle#tap('tcomment_vim')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': ['gc'],
        \     'commands': ['TComment']
        \   }
        \ })

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
        \     'commands': ['OverCommandLine']
        \   }
        \ })

  noremap <silent> <Leader>s :OverCommandLine<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:over_command_line_key_mappings = {
          \   "\<C-j>" : "\<Esc>",
          \ }
  endfunction

  augroup InitializeOver
    autocmd!
    autocmd FocusLost,CursorHold,CursorHoldI * call s:initialize_over()
  augroup END

  function! s:initialize_over()
    call over#load()

    augroup InitializeOver
      autocmd!
    augroup END
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-qfreplace {{{
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

  imap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'
  smap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'

  function! neobundle#hooks.on_source(bundle)
    let g:neosnippet#enable_snipmate_compatibility = 1
    let g:neosnippet#snippets_directory            = '$DOTVIM/snippets'

    if isdirectory(expand('$DOTVIM/snippets.local'))
      let g:neosnippet#snippets_directory = '$DOTVIM/snippets.local,' . g:neosnippet#snippets_directory
    endif

    call neocomplete#custom#source('neosnippet', 'rank', 1000)
  endfunction

  call neobundle#untap()
endif
" }}}
" Omnisharp {{{
if neobundle#tap('Omnisharp')
  call neobundle#config({
        \   'depends':  ['neocomplete.vim', 'vim-dispatch'],
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
    let g:omnicomplete_fetch_full_documentation = 1

    let g:Omnisharp_stop_server         = 0
    let g:OmniSharp_typeLookupInPreview = 0
  endfunction

  call neobundle#untap()
endif
" }}}
" codic-vim {{{
if neobundle#tap('codic-vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['Codic'],
        \     'function_prefix': 'codic'
        \   }
        \ })

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

    call altr#define('%.cpp',           '%.h')
    call altr#define('src/%.cpp',       'include/%.h')
    call altr#define('src/*/%.cpp',     'include/*/%.h')
    call altr#define('src/*/*/%.cpp',   'include/*/*/%.h')
    call altr#define('src/*/*/*/%.cpp', 'include/*/*/*/%.h')
  endfunction
  call neobundle#untap()
endif
" }}}
" }}}
" 検索 {{{
" vim-anzu {{{
nmap <silent> n <Plug>(anzu-n)zvzz:<C-u>call <SID>begin_display_anzu()<CR>:<C-u>call <SID>refresh_screen()<CR>
nmap <silent> N <Plug>(anzu-N)zvzz:<C-u>call <SID>begin_display_anzu()<CR>:<C-u>call <SID>refresh_screen()<CR>
nmap <silent> * <Plug>(anzu-star):<C-u>call  <SID>refresh_screen()<CR>
nmap <silent> # <Plug>(anzu-sharp):<C-u>call <SID>refresh_screen()<CR>

if neobundle#tap('vim-anzu')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': ['<Plug>(anzu']
        \   }
        \ })

  call neobundle#untap()
endif

augroup MyAutoCmd
  " 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
  " 検索ヒット数の表示を消去する
  autocmd CursorHold,CursorHoldI * call s:update_display_anzu()
  autocmd WinLeave,TabLeave      * call s:clear_display_anzu()

  " anzuを表示する時間
  let s:anzu_display_time = 2000

  let s:anzu_display_count = 0
  function! s:begin_display_anzu()
    let s:anzu_display_count = s:anzu_display_time / &updatetime
  endfunction

  function! s:update_display_anzu()
    if s:anzu_display_count >= 0
      let s:anzu_display_count = s:anzu_display_count - 1

      call s:continue_cursor_hold()
    else
      call s:clear_display_anzu()
    endif
  endfunction

  function! s:clear_display_anzu()
    " let s:anzu_display_count = 0
    call anzu#clear_search_status()
  endfunction
augroup END
" }}}
" clever-f.vim {{{
if neobundle#tap('clever-f.vim')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': ['<Plug>(clever-f']
        \   }
        \ })

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

    highlight default Clever_f_mark_char ctermfg=Green ctermbg=NONE cterm=underline guifg=Green guibg=NONE gui=underline
  endfunction

  call neobundle#untap()
endif
" }}}
" vim-easymotion {{{
if neobundle#tap('vim-easymotion')
  call neobundle#config({
        \   'autoload': {
        \     'mappings': ['<Plug>(easymotion-']
        \   }
        \ })

  map t <Plug>(easymotion-s2)

  function! neobundle#hooks.on_source(bundle)
    let g:EasyMotion_do_mapping  = 0
    let g:EasyMotion_smartcase   = 1
    let g:EasyMotion_keys        = 'ghfjtyrubnvmdkeiwoqp47382'
    let g:EasyMotion_startofline = 1
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
  " call neobundle#config({
  "       \   'autoload': {
  "       \     'filetypes':       ['cs', 'go', 'ruby'],
  "       \     'function_prefix': 'submode'
  "       \   }
  "       \ })
  call neobundle#config({
        \   'autoload': {
        \     'filetypes':       ['go', 'ruby'],
        \     'function_prefix': 'submode'
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoCmd
      autocmd BufWritePost *.{go,rb,py} call lightline#update()
    augroup END
  endfunction

  call neobundle#untap()
endif
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

    if s:is_windows
      let g:clang_user_options = '-I C:/Development/boost_1_55_0 -I "C:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include" -std=c++11 -fms-extensions -fmsc-version=1300 -fgnu-runtime -D__MSVCRT_VERSION__=0x700 -D_WIN32_WINNT=0x0500 2> NUL || exit 0"'
      let g:clang_library_path = 'C:/Development/llvm/build/bin/Release/'
    elseif s:is_mac
      let g:clang_user_options = '-std=c++11'
      let g:clang_library_path = '/Library/Developer/CommandLineTools/usr/lib/'
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
    if s:is_windows
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
        \     'commands':  [
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
          \   'cpp': 'clang-head',
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
if s:is_windows
  let g:gocomplete#system_function = 'vimproc#system'
endif

let g:go_fmt_autofmt  = 0
let g:go_fmt_commands = 0
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
    let g:markdown_fenced_languages = [
        \   'c',    'cpp', 'cs', 'go',
        \   'ruby', 'lua', 'python',
        \   'vim',
        \   'xml',  'json',
        \ ]
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
" https://github.com/kana/vim-textobj-user/wiki
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
" vim-textobj-xmlattr {{{
if neobundle#tap('vim-textobj-xmlattr')
  call neobundle#config({
        \   'depends':  ['vim-textobj-user'],
        \   'autoload': {
        \     'mappings': [['xo', 'ax'], ['xo', 'ix']]
        \   }
        \ })

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

  nmap R <Plug>(operator-replace)
  xmap R <Plug>(operator-replace)

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
if neobundle#tap('vim-rengbang')
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

  noremap <silent> [App]1 :<C-u>call <SID>toggle_lingr()<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:lingr_vim_say_buffer_height = 15

    augroup MyAutoCmd
      autocmd FileType lingr-rooms    call s:set_lingr()
      autocmd FileType lingr-members  call s:set_lingr()
      autocmd FileType lingr-messages call s:set_lingr()

      function! s:set_lingr()
        nnoremap <silent><buffer> q :<C-u>call <SID>toggle_lingr()<CR>

        setlocal nolist
      endfunction
    augroup END
  endfunction

  function! s:toggle_lingr()
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
        \   'autoload': {
        \     'insert':          1,
        \     'function_prefix': 'fugitive'
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoCmd
      autocmd FocusGained,FocusLost * call s:update_fugitive()
    augroup END
  endfunction

  call neobundle#untap()
endif

function! s:update_fugitive()
  call fugitive#detect(expand('<amatch>:p'))

  call lightline#update()
endfunction
" }}}
" vim-gitgutter {{{
if neobundle#tap('vim-gitgutter')
  call neobundle#config({
        \   'depends':  ['vim-shell'],
        \   'autoload': {
        \     'function_prefix': 'gitgutter'
        \   }
        \ })

  nmap <F7> <Plug>GitGutterNextHunkzvzz
  nmap <F8> <Plug>GitGutterPrevHunkzvzz

  function! neobundle#hooks.on_source(bundle)
    let g:gitgutter_map_keys  = 0
    let g:gitgutter_eager     = 0
    let g:gitgutter_diff_args = '-w'

    augroup MyAutoCmd
      autocmd FocusGained,FocusLost * GitGutter
    augroup END
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
        \   'depends':  ['vimproc', 'unite.vim'],
        \   'autoload': {
        \     'commands': ['VimFilerBufferDir'],
        \   }
        \ })

  noremap <silent> [App]f :<C-u>VimFilerBufferDir<CR>

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoCmd
      autocmd FileType vimfiler call s:set_vimfiler()

      " http://qiita.com/Linda_pp/items/f1cb09ac94202abfba0e
      autocmd FileType vimfiler nnoremap <silent><buffer> / :<C-u>Unite file -horizontal<CR>

      function! s:set_vimfiler()
        nmap <buffer><expr> <CR>  vimfiler#smart_cursor_map('<Plug>(vimfiler_cd_file)', '<Plug>(vimfiler_edit_file)')
        nmap <buffer><expr> <C-j> vimfiler#smart_cursor_map('<Plug>(vimfiler_exit)',    '<Plug>(vimfiler_exit)')

        nmap <silent><buffer> J :<C-u>Unite bookmark<CR>

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

  noremap <silent> [App]2 :<C-u>call <SID>toggle_tweetvim()<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:tweetvim_include_rts       = 1
    let g:tweetvim_display_separator = 0
    let g:tweetvim_tweet_per_page    = 30
    let g:tweetvim_display_icon      = 1

    augroup MyAutoCmd
      autocmd FileType tweetvim call s:set_tweetvim()

      function! s:set_tweetvim()
        nmap     <silent><buffer> rr <Plug>(tweetvim_action_reload)
        nnoremap <silent><buffer> q  :<C-u>call <SID>toggle_tweetvim()<CR>
      endfunction
    augroup END
  endfunction

  function! s:toggle_tweetvim()
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
" memolist {{{
if neobundle#tap('memolist.vim')
  call neobundle#config({
        \   'depends':  ['unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['memolist'],
        \     'commands':      ['MemoNew', 'MemoList', 'MemoGrep']
        \   }
        \ })

  noremap <silent> [App]mn :<C-u>MemoNew<CR>
  noremap <silent> [App]ml :<C-u>MemoList<CR>
  noremap <silent> [App]mg :<C-u>MemoGrep<CR>

  function! neobundle#hooks.on_source(bundle)
    let g:memolist_unite        = 1
    let g:memolist_memo_suffix  = 'md'
    let g:memolist_unite_source = 'memolist'
    let g:memolist_path         = expand('~/Dropbox/memo')

    call unite#custom#source('memolist', 'sorters', ['sorter_ftime', 'sorter_reverse'])
  endfunction

  call neobundle#untap()
endif
" }}}
" vinarise.vim {{{
if neobundle#tap('vinarise.vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['Vinarise']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" agit.vim {{{
if neobundle#tap('agit.vim')
  call neobundle#config({
        \   'autoload': {
        \     'commands': ['Agit']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" vim-icondrag {{{
let g:icondrag_auto_start = 1
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

  nnoremap <silent> [Unite]g  :<C-u>Unite grep -no-split -buffer-name=search-buffer<CR>
  nnoremap <silent> [Unite]pg :<C-u>call <SID>unite_grep_project('-no-split -buffer-name=search-buffer')<CR>
  nnoremap <silent> [Unite]r  :<C-u>UniteResume -no-split search-buffer<CR>

  nnoremap <silent> [Unite]f  :<C-u>Unite buffer<CR>
  nnoremap <silent> [Unite]j  :<C-u>Unite bookmark<CR>
  nnoremap <silent> [Unite]t  :<C-u>Unite tab<CR>
  nnoremap <silent> [Unite]l  :<C-u>Unite -no-split line<CR>
  nnoremap <silent> [Unite]o  :<C-u>Unite outline<CR>
  nnoremap <silent> [Unite]z  :<C-u>Unite fold<CR>
  nnoremap <silent> [Unite]c  :<C-u>Unite codic<CR>
  nnoremap <silent> [Unite]q  :<C-u>Unite -no-quit quickfix<CR>
  nnoremap <silent> [Unite]v  :<C-u>call <SID>execute_if_on_git_branch('Unite giti')<CR>
  nnoremap <silent> [Unite]b  :<C-u>call <SID>execute_if_on_git_branch('Unite giti/branch_all')<CR>

  if s:is_windows
    nnoremap <silent> [Unite]m  :<C-u>Unite -no-split neomru/file everything<CR>
  else
    nnoremap <silent> [Unite]m  :<C-u>Unite -no-split neomru/file<CR>
  endif

  nnoremap [Unite]uu :<C-u>NeoBundleUpdate<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>
  nnoremap [Unite]ui :<C-u>NeoBundleInstall<CR>:NeoBundleClearCache<CR>:NeoBundleUpdatesLog<CR>
  nnoremap [Unite]uc :<C-u>NeoBundleClearCache<CR>

  " http://sanrinsha.lolipop.jp/blog/2013/03/%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E5%86%85%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92unite-grep%E3%81%99%E3%82%8B.html
  function! s:unite_grep_project(...)
    let opts = (a:0 ? join(a:000, ' ') : '')
    let dir = unite#util#path2project_directory(expand('%'))
    execute 'Unite' opts 'grep:' . dir
  endfunction

  function! neobundle#hooks.on_source(bundle)
    let g:unite_force_overwrite_statusline = 0

    let g:unite_source_alias_aliases = {
          \   'memolist' : {'source': 'file'},
          \ }

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
    call unite#custom#source( 'file',    'matchers',   'matcher_default')

    call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
    call unite#custom_default_action('directory',                 'vimfiler')
    call unite#custom_default_action('neomru/directory',          'vimfiler')
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
        \     'unite_sources': ['neomru']
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
        \     'unite_sources': ['giti'],
        \     'commands':      [
        \       'Giti',                        'GitiWithConfirm',   'GitiFetch', 'GitiPush',
        \       'GitiPushWithSettingUpstream', 'GitiPushExpressly', 'GitiPull',  'GitiPullSquash',
        \       'GitiPullRebase',              'GitiPullExpressly', 'GitiDiff',  'GitiDiffCached',
        \       'GitiLog',                     'GitiLogLine'
        \     ]
        \   }
        \ })

  function! neobundle#hooks.on_source(bundle)
    augroup MyAutoCmd
      autocmd User UniteGitiGitExecuted call s:update_fugitive()
    augroup END
  endfunction

  call neobundle#untap()
endif
" }}}
" unite-codic.vim {{{
if neobundle#tap('unite-codic.vim')
  call neobundle#config({
        \   'depends':  ['unite.vim'],
        \   'autoload': {
        \     'unite_sources': ['codic']
        \   }
        \ })

  call neobundle#untap()
endif
" }}}
" unite-everything {{{
if s:is_windows
  if neobundle#tap('unite-everything')
    call neobundle#config({
          \   'depends':  ['unite.vim'],
          \   'autoload': {
          \     'unite_sources': ['everything']
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
" 初期設定 {{{
filetype plugin indent on

if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif
" }}}
" }}}
" ファイルタイプごとの設定 {{{
augroup MyAutoCmd
  autocmd BufEnter,WinEnter,BufWinEnter,BufWritePost *                         call s:update_all()
  autocmd BufReadPost                                *                         call s:clean_empty_buffers()
  autocmd BufNewFile,BufRead                         *.xaml                    setlocal ft=xml
  autocmd BufNewFile,BufRead                         *.json                    setlocal ft=json
  autocmd BufNewFile,BufRead                         *.{fx,fxc,fxh,hlsl,hlsli} setlocal ft=hlsl
  autocmd BufNewFile,BufRead                         *.{fsh,vsh}               setlocal ft=glsl
  autocmd BufNewFile,BufRead                         *.{md,mkd,markdown}       setlocal ft=markdown

  autocmd FileType *          call s:set_all()
  autocmd FileType ruby       call s:set_ruby()
  autocmd FileType vim        call s:set_vim()
  autocmd FileType qf         call s:set_quick_fix()
  autocmd FileType help       call s:set_help()
  autocmd FileType unite      call s:set_unite()
  autocmd FileType cs         call s:set_cs()
  autocmd FileType c,cpp      call s:set_cpp()
  autocmd FileType go         call s:set_go()
  autocmd FileType godoc      call s:set_godoc()
  autocmd FileType coffee     call s:set_coffee()
  autocmd FileType json       call s:set_json()
  autocmd FileType xml,html   call s:set_xml()
  autocmd FileType neosnippet call s:set_neosnippet()
  autocmd FileType markdown   call s:set_markdown()

  function! s:update_all()
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

    call s:set_all()
  endfunction

  function! s:set_all()
    setlocal formatoptions-=ro
    setlocal textwidth=0
  endfunction

  function! s:set_ruby()
    setlocal foldmethod=syntax
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal softtabstop=2
  endfunction

  function! s:set_vim()
    setlocal foldmethod=marker
    setlocal foldlevel=0
    setlocal foldcolumn=5

    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal softtabstop=2
  endfunction

  function! s:set_xml()
    " XMLの閉じタグを補完
    inoremap <buffer> </ </<C-x><C-o>

    let g:xml_syntax_folding = 1

    setlocal foldmethod=syntax
    setlocal foldlevel=99
    setlocal foldcolumn=5
  endfunction

  function! s:set_go()
    setlocal foldmethod=syntax
    setlocal shiftwidth=4
    setlocal noexpandtab
    setlocal tabstop=4

    nmap <silent><buffer> <Leader><C-k><C-k> :<C-u>Godoc<CR>zz:<C-u>call <SID>refresh_screen()<CR>
    nmap <silent><buffer> <C-]>              :<C-u>call GodefUnderCursor()<CR>zz:<C-u>call <SID>refresh_screen()<CR>
  endfunction

  function! s:set_godoc()
    nnoremap <silent><buffer> q :<C-u>close<CR>
  endfunction

  function! s:set_coffee()
    setlocal shiftwidth=2
  endfunction

  function! s:set_json()
    setlocal shiftwidth=2
  endfunction

  function! s:set_cpp()
    setlocal foldmethod=syntax

    map <silent><buffer> [App]r :<C-u>QuickRun cpp/wandbox<CR>
  endfunction

  function! s:set_cs()
    setlocal omnifunc=OmniSharp#Complete
    setlocal foldmethod=syntax

    nnoremap <silent><buffer> <C-]> :<C-u>call OmniSharp#GotoDefinition()<CR>zz:<C-u>call <SID>refresh_screen()<CR>
  endfunction

  function! s:set_unite()
    let unite = unite#get_current_unite()
    if unite.buffer_name =~# '^search'
      nmap <silent><buffer><expr> <C-r> unite#do_action('replace')
      imap <silent><buffer><expr> <C-r> unite#do_action('replace')
    endif

    nmap <silent><buffer> <C-v> <Plug>(unite_toggle_auto_preview)
    imap <silent><buffer> <C-v> <Plug>(unite_toggle_auto_preview)
    nmap <silent><buffer> <C-j> <Plug>(unite_exit)
  endfunction

  function! s:set_help()
    noremap <silent><buffer> q :<C-u>close<CR>
  endfunction

  function! s:set_neosnippet()
    setlocal noexpandtab
  endfunction

  function! s:set_markdown()
    nnoremap <silent><buffer> [App]v :<C-u>PrevimOpen<CR>
  endfunction

  function! s:set_quick_fix()
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
  " http://vim-jp.org/vim-users-jp/2009/12/27/Hack-112.html
  autocmd BufNewFile,BufReadPost * call s:load_vim_local(expand('<afile>:p:h'))

  function! s:load_vim_local(loc)
    let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
    for i in reverse(filter(files, 'filereadable(v:val)'))
      source `=i`
    endfor
  endfunction
  " }}}
augroup END
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
set cryptmethod=blowfish
set noimdisable

" MacVim-KaoriYa 自動IM on禁止
if s:is_mac
  set imdisableactivate
endif

nnoremap <silent> <F1> :<C-u>edit $MYVIMRC<CR>

noremap U J

" http://vim-jp.org/vim-users-jp/2011/01/16/Hack-195.html
nnoremap <expr> p (col('.') >= col('$') ? '$' : '') . 'p'

" ^Mを取り除く
command! RemoveCr call s:execute_keep_view('silent! %substitute/\r$//g | nohlsearch')

" 行末のスペースを取り除く
command! RemoveEolSpace call s:execute_keep_view('silent! %substitute/ \+$//g | nohlsearch')

" 整形
command! Format call s:smart_format()

" http://lsifrontend.hatenablog.com/entry/2013/10/11/052640
nmap     <silent> <C-CR> yy:<C-u>TComment<CR>p
vnoremap <silent> <C-CR> :<C-u>call <SID>copy_add_comment()<CR>

" http://qiita.com/akira-hamada/items/2417d0bcb563475deddb をもとに調整
function! s:copy_add_comment() range
  let selected_count = line("'>") - line("'<")

  " 選択中の行をyank
  normal! ""gvy

  " yankした物をPする
  normal P

  " 元のコードを選択
  if selected_count == 0
    execute 'normal V'
  else
    execute 'normal V' . selected_count . 'j'
  endif

  " コメントアウトする
  normal gc

  " ビジュアルモードからエスケープ
  execute "normal! \e\e"

  " 元の位置に戻る
  execute 'normal ' . (selected_count + 1) . 'j'
endfunction

" http://vim.wikia.com/wiki/Pretty-formatting_XML
function! s:xml_format() range
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
command! -range=% XmlFormat <line1>,<line2>call s:xml_format()

" 自動的にディレクトリを作成する
" http://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
augroup MyAutoCmd
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
set breakindent

vnoremap < <gv
vnoremap > >gv
" }}}
" 検索 {{{
set incsearch
set ignorecase
set smartcase

if executable('pt')
  set grepprg=pt\ --nogroup\ --nocolor\ -S
  set grepformat=%f:%l:%m
endif

" 日本語インクリメンタルサーチ
if has('migemo')
  set migemo

  if s:is_windows
    set migemodict=$VIM/dict/utf-8/migemo-dict
  elseif s:is_mac
    set migemodict=$VIMRUNTIME/dict/migemo-dict
  endif
endif

" 検索時のハイライトを解除
nnoremap <silent> <Leader>/   :<C-u>nohlsearch<CR>

" http://deris.hatenablog.jp/entry/2013/05/15/024932
" very magic
nnoremap / /\v

" *による検索時に初回は移動しない
nnoremap <silent> * viw:<C-u>call <SID>star_search()<CR>:<C-u>set hlsearch<CR>`<
vnoremap <silent> * :<C-u>call    <SID>star_search()<CR>:<C-u>set hlsearch<CR>
function! s:star_search()
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
set noshowmatch                   " 括弧の対応をハイライト
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
set updatetime=500
set previewheight=24
set laststatus=0
set cmdheight=4
set laststatus=2
set showtabline=2
set diffopt=vertical,filler
set noequalalways
set cursorline

set conceallevel=2
set concealcursor=i

augroup MyAutoCmd
  autocmd VimEnter * call s:disable_beep()

  function! s:disable_beep()
    set t_vb=
    set visualbell
    set errorbells
  endfunction
augroup END

" カーソル下の単語を移動するたびにハイライトする {{{
" http://d.hatena.ne.jp/osyo-manga/20140121/1390309901
augroup MyAutoCmd
  " autocmd CursorMoved  * call s:hl_cword()
  autocmd CursorHold  * call s:hl_cword()
  autocmd CursorMoved * call s:hl_clear()

  autocmd BufLeave    * call s:hl_clear()
  autocmd WinLeave    * call s:hl_clear()
  autocmd InsertEnter * call s:hl_clear()
  autocmd ColorScheme * highlight CursorWord guifg=Red

  function! s:hl_clear()
    if exists('b:highlight_cursor_word_id') && exists('b:highlight_cursor_word')
      silent! call matchdelete(b:highlight_cursor_word_id)
      unlet b:highlight_cursor_word_id
      unlet b:highlight_cursor_word
    endif
  endfunction

  function! s:hl_cword()
    let word = expand('<cword>')
    if word == ''
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
augroup END
" }}}
" カラースキーマ {{{
if !s:is_windows
  set t_Co=256
endif

colorscheme molokai

highlight Comment          guifg=#AEDEDE
highlight DiffText                       guibg=#4C4745 gui=bold
highlight Macro            guifg=#C4BE89               gui=none
highlight Special          guifg=#66D9EF guibg=bg      gui=none
highlight StorageClass     guifg=#FD971F               gui=none
highlight Tag              guifg=#F92672               gui=none
highlight FoldColumn       guifg=#465457 guibg=#242526
highlight Folded           guifg=#465457 guibg=#242526
highlight VertSplit        guifg=#202020 guibg=#202020 gui=bold    " 見えなくする

" タブ表示など
highlight SpecialKey       guifg=#303030 guibg=#121212 gui=none

" 日本語入力中のカーソルの色
highlight CursorIM         guifg=NONE    guibg=Red

function! s:set_color()
  syntax match InvisibleJISX0208Space '　' display containedin=ALL
  syntax match InvisibleTab           '\t' display containedin=ALL

  highlight InvisibleJISX0208Space guibg=#112233
  highlight InvisibleTab           guibg=#121212

  " ^M を非表示
  syntax match HideCtrlM /\r$/ conceal
endf

augroup MyAutoCmd
  autocmd BufNew,BufRead * call s:set_color()
augroup END
" }}}
" 半透明化 {{{
if s:is_mac
  augroup MyAutoCmd
    autocmd GuiEnter,FocusGained * set transparency=3   " アクティブ時の透過率
    autocmd FocusLost            * set transparency=48  " 非アクティブ時の透過率
  augroup END
endif
" }}}
" フォント設定 {{{
if s:is_gui_running
  if s:is_windows
    set guifont=Ricty\ Regular\ for\ Powerline:h12
    set renderoptions=type:directx,geom=1,renmode:6,taamode:0
  elseif s:is_mac
    set guifont=Ricty\ Regular\ for\ Powerline:h12
    set antialias
  elseif s:is_linux
    set guifont=Ricty\ for\ Powerline\ 10
  endif
endif

if s:is_windows
  " 一部のUCS文字の幅を自動計測して決める
  set ambiwidth=auto
else
  set ambiwidth=double
endif
" }}}
" 'cursorline' を必要な時にだけ有効にする {{{
" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup MyAutoCmd
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI   * call s:auto_cursorline('CursorHold')
  autocmd WinEnter                 * call s:auto_cursorline('WinEnter')
  autocmd WinLeave                 * call s:auto_cursorline('WinLeave')

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
" 補完 {{{
" http://sgur.tumblr.com/post/91906146884/codic-vim
inoremap <silent> <C-d> <C-R>=<SID>codic_complete()<CR>

function! s:codic_complete()
  let line = getline('.')
  let start = match(line, '\k\+$')
  let cand = s:codic_candidates(line[start :])
  call complete(start +1, cand)
  return ''
endfunction

function! s:codic_candidates(arglead)
  let cand = codic#search(a:arglead, 30)
  " error
  if type(cand) == type(0)
    return []
  endif
  " english -> english terms
  if a:arglead =~# '^\w\+$'
    return map(cand, '{"word": v:val["label"], "menu": join(map(copy(v:val["values"]), "v:val.word"), ",")}')
  endif
  " japanese -> english terms
  return s:reverse_candidates(cand)
endfunction

function! s:reverse_candidates(cand)
  let _ = []
  for c in a:cand
    for v in c.values
      call add(_, {"word": v.word, "menu": !empty(v.desc) ? v.desc : c.label })
    endfor
  endfor
  return _
endfunction
" }}}
" モード移行 {{{
inoremap <C-j> <Esc>
nnoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
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
nnoremap <silent> $     g$
nnoremap <silent> g$    $
nnoremap <silent> <C-e> <C-e>j
nnoremap <silent> <C-y> <C-y>k
vnoremap <silent> <C-e> <C-e>j
vnoremap <silent> <C-y> <C-y>k
nmap     <silent> gg    ggzvzz:<C-u>call <SID>refresh_screen()<CR>
nmap     <silent> G     Gzvzz:<C-u>call  <SID>refresh_screen()<CR>

noremap  <silent> <C-i> <C-i>zz:<C-u>call <SID>refresh_screen()<CR>
noremap  <silent> <C-o> <C-o>zz:<C-u>call <SID>refresh_screen()<CR>
map      <silent> <C-h> ^
map      <silent> <C-l> g$

nmap     <silent> <Tab> %
vmap     <silent> <Tab> %

nmap     <silent> <Leader>m `

function! s:up_cursor(repeat)
  call s:enable_virtual_cursor()

  let c = a:repeat
  while c > 0
    normal! gk
    let c -= 1
  endwhile
endfunction

function! s:down_cursor(repeat)
  call s:enable_virtual_cursor()

  let c = a:repeat
  while c > 0
    normal! gj
    let c -= 1
  endwhile
endfunction

function! s:left_cursor(repeat)
  call s:disable_virtual_cursor()

  let c = a:repeat
  while c > 0
    normal! h
    let c -= 1
  endwhile
endfunction

function! s:right_cursor(repeat)
  call s:disable_virtual_cursor()

  let c = a:repeat
  while c > 0
    normal! l
    let c -= 1
  endwhile

  if foldclosed(line('.')) != -1
    normal zv
  endif
endfunction

function! s:enable_virtual_cursor()
  set virtualedit=all
endfunction

function! s:disable_virtual_cursor()
  set virtualedit=block
endfunction

augroup MyAutoCmd
  autocmd InsertEnter * call s:disable_virtual_cursor()
augroup END
" }}}
" ウィンドウ操作 {{{
set splitbelow                    " 縦分割したら新しいウィンドウは下に
set splitright                    " 横分割したら新しいウィンドウは右に

nnoremap [Window]  <Nop>
nmap     <Leader>w [Window]

noremap <silent> [Window]x :<C-u>close<CR>

" アプリウィンドウ操作
if s:is_gui_running
  noremap <silent> [Window]e :<C-u>call <SID>toggle_v_split_wide()<CR>

  noremap <silent> [Window]H :<C-u>ResizeWin<CR>
  noremap <silent> [Window]J :<C-u>ResizeWin<CR>
  noremap <silent> [Window]K :<C-u>ResizeWin<CR>
  noremap <silent> [Window]L :<C-u>ResizeWin<CR>
  noremap <silent> [Window]h :<C-u>MoveWin<CR>
  noremap <silent> [Window]j :<C-u>MoveWin<CR>
  noremap <silent> [Window]k :<C-u>MoveWin<CR>
  noremap <silent> [Window]l :<C-u>MoveWin<CR>
  noremap <silent> [Window]f :<C-u>call <SID>full_window()<CR>
endif

" ウィンドウの位置とサイズを記憶する {{{
if s:is_gui_running
  " http://vim-jp.org/vim-users-jp/2010/01/28/Hack-120.html
  let s:save_window_file = expand('~/.vimwinpos')

  augroup MyAutoCmd
    autocmd VimLeavePre * call s:save_window()

    function! s:save_window()
      let options = [
            \ 'set columns=' . &columns,
            \ 'set lines=' . &lines,
            \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
            \ ]
      call writefile(options, s:save_window_file)
    endfunction
  augroup END

  if filereadable(s:save_window_file)
    exe 'source' s:save_window_file
  endif
endif
" }}}
" }}}
" タブ操作 {{{
nnoremap [Tab]     <Nop>
nmap     <Leader>t [Tab]

nnoremap <silent> [Tab]c :<C-u>tabnew<CR>
nnoremap <silent> [Tab]x :<C-u>tabclose<CR>

nnoremap <silent> K :<C-u>tabp<CR>
nnoremap <silent> J :<C-u>tabn<CR>

" Vimですべてのバッファをタブ化する
" http://qiita.com/kuwa72/items/deef2703af74d2d993ee
nnoremap <silent> [Tab]t :<C-u>call <SID>clean_empty_buffers()<CR>:<C-u>tab ba<CR>
" }}}
" バッファ操作 {{{
nnoremap [Buffer]  <Nop>
nmap     <Leader>b [Buffer]

nnoremap <silent> <Leader>x :<C-u>call <SID>delete_current_buffer()<CR>
" }}}
" Git {{{
nnoremap [Git]     <Nop>
nmap     <Leader>g [Git]

nnoremap <silent> [Git]b    :<C-u>call <SID>execute_if_on_git_branch('Gblame w')<CR>
nnoremap <silent> [Git]a    :<C-u>call <SID>execute_if_on_git_branch('Gwrite')<CR>
nnoremap <silent> [Git]c    :<C-u>call <SID>execute_if_on_git_branch('Gcommit')<CR>
nnoremap <silent> [Git]f    :<C-u>call <SID>execute_if_on_git_branch('GitiFetch')<CR>
nnoremap <silent> [Git]d    :<C-u>call <SID>execute_if_on_git_branch('Gdiff')<CR>
nnoremap <silent> [Git]s    :<C-u>call <SID>execute_if_on_git_branch('Gstatus')<CR>
nnoremap <silent> [Git]push :<C-u>call <SID>execute_if_on_git_branch('GitiPush')<CR>
nnoremap <silent> [Git]pull :<C-u>call <SID>execute_if_on_git_branch('GitiPull')<CR>
nnoremap <silent> [Git]g    :<C-u>call <SID>execute_if_on_git_branch('Agit')<CR>
" }}}
" ヘルプ {{{
nnoremap          <Leader><C-k>      :<C-u>help<Space>
nnoremap <silent> <Leader><C-k><C-k> :<C-u>help <C-r><C-w><CR>:<C-u>call <SID>refresh_screen()<CR>
vnoremap <silent> <Leader><C-k><C-k> :<C-u>help <C-r><C-w><CR>:<C-u>call <SID>refresh_screen()<CR>

set helplang=ja,en

if has('kaoriya')
  set rtp+=$VIM/plugins/vimdoc-ja
endif

" }}}
" 汎用関数 {{{
" CursorHold を継続させる{{{
function! s:continue_cursor_hold()
  " http://d.hatena.ne.jp/osyo-manga/20121102/1351836801
  call feedkeys(mode() ==# 'i' ? "\<C-g>\<Esc>" : "g\<Esc>", 'n')
endfunction
" }}}
" アプリケーションウィンドウを最大高さにする {{{
function! s:full_window()
  execute 'winpos' getwinposx() '0'
  execute 'set lines=9999'
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
  silent! execute 'botright vertical' s:base_columns 'split'
endf

function! s:close_v_split_wide()
  let s:depth_vsp -= 1
  let &columns = s:base_columns * s:depth_vsp
  silent! close

  if s:depth_vsp == 1
    silent! execute 'winpos' s:opend_left_vsp s:opend_top_vsp
  end
endf
" }}}
" 画面リフレッシュ{{{
function! s:refresh_screen()
  call s:force_show_cursorline()
endfunction
" }}}
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
    execute 'buffer ' . next_buf
  endwhile

  execute 'bdelete' . current_buf
  execute current_win . 'wincmd w'
endfunction
" }}}
" 空バッファを削除 {{{
" http://stackoverflow.com/questions/6552295/deleting-all-empty-buffers-in-vim
function! s:clean_empty_buffers()
  let buffers = filter(range(1, bufnr('$')), "buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && getbufvar(v:val, '&modified', 0)==0")
  if !empty(buffers)
    execute 'bdelete ' join(buffers, ' ')
  endif
endfunction
" }}}
" コマンド実行後の表示状態を維持する {{{
function! s:execute_keep_view(expr)
  let wininfo = winsaveview()
  execute a:expr
  call winrestview(wininfo)
endfunction
" }}}
" 整形 {{{
function! s:smart_format()
  if &ft == 'cpp'
    CppFormat
  elseif &ft == 'c'
    CppFormat
  elseif &ft == 'xml'
    XmlFormat
  elseif &ft == 'json'
    call s:json_format(0)
  elseif &ft == 'go'
    call s:golang_format(0)
  else
    echo 'smart_format : Not supported. : ' . &ft
  endif
endfunction
" }}}
" Unite 実行中か {{{
function! s:is_unite_running()
  return &ft == 'unite'
endfunction
" }}}
" Gitブランチ上にいるか {{{
function! s:is_in_git_branch()
  return fugitive#head() != ''
endfunction
" }}}
" Gitブランチ上であれば実行 {{{
function! s:execute_if_on_git_branch(line)
  if !s:is_in_git_branch()
    echo 'not in git branch : ' . a:line
    return
  endif

  execute a:line
endfunction
" }}}
" golang_format {{{
function! s:golang_format(is_silent)
  call s:filter_current('goimports', a:is_silent)
endfunction
" }}}
" json_format {{{
function! s:json_format(is_silent)
  call s:filter_current('jq .', a:is_silent)
endfunction
" }}}
" フィルタリング処理を行う {{{
function! s:filter_current(cmd, is_silent)
  let pos_save                     = getpos('.')
  let sel_save                     = &l:selection
  let &l:selection                 = 'inclusive'
  let [save_g_reg, save_g_regtype] = [getreg('g'), getregtype('g')]

  let temp = tempname()
  call writefile(getline(1, '$'), temp)

  try
    let formatted = vimproc#system(a:cmd . ' ' . substitute(temp, '\', '/', 'g'))

    if vimproc#get_last_status() == 0
      call setreg('g', formatted, 'v')
      silent keepjumps normal! ggVG"gp
    else
      if !a:is_silent
        echo 'filter_current : Error'
      endif
    endif
  finally
    call delete(temp)

    call setreg('g', save_g_reg, save_g_regtype)
    let &l:selection = sel_save
    call setpos('.', pos_save)
  endtry
endfunction
" }}}
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
