set encoding=utf-8
scriptencoding utf-8
" 基本 {{{
let g:YOI_dotvim_dir   = expand('~/.vim')
let g:YOI_cache_dir    = expand('~/.cache')
let g:YOI_dropbox_dir  = expand('~/Dropbox')

let s:has_vim_starting = has('vim_starting')
let s:has_gui_running  = has('gui_running')
let s:base_columns     = 140

let s:vim_plugin_toml  = expand('~/vim_plugin.toml')
let s:plugin_dir       = g:YOI_cache_dir . '/plugin'

let g:mapleader        = ' '

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
        \| echomsg 'startuptime:' reltimestr(s:startuptime)
endif

" ローカル設定
let s:vimrc_local = expand('~/.vimrc.local')
if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif
" }}}
" プラグイン {{{
if s:has_vim_starting
  execute 'set runtimepath^=' . s:plugin_dir . '/repos/github.com/Shougo/dein.vim/'
  let g:dein#install_process_timeout = 10*60
  let g:dein#install_max_processes   = 16
endif

if dein#load_state(s:plugin_dir)
  call dein#begin(s:plugin_dir)
  call dein#load_toml(s:vim_plugin_toml)
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
" }}}
" ファイルタイプごとの設定 {{{
Autocmd BufEnter,WinEnter,BufWinEnter *                         call s:update_all()
Autocmd BufNewFile,BufRead            *.xaml                    setlocal filetype=xml
Autocmd BufNewFile,BufRead            *.cake                    setlocal filetype=cs
Autocmd BufNewFile,BufRead            *.json                    setlocal filetype=json
Autocmd BufNewFile,BufRead            *.{fx,fxc,fxh,hlsl,hlsli} setlocal filetype=hlsl
Autocmd BufNewFile,BufRead            *.{fsh,vsh}               setlocal filetype=glsl
Autocmd BufNewFile,BufRead            *.{md,mkd,markdown}       setlocal filetype=markdown

AutocmdFT ruby       setlocal tabstop=2
AutocmdFT ruby       setlocal shiftwidth=2
AutocmdFT ruby       setlocal softtabstop=2

AutocmdFT vim        setlocal foldmethod=marker
AutocmdFT vim        setlocal foldlevel=0
AutocmdFT vim        setlocal foldcolumn=5
AutocmdFT vim        setlocal tabstop=2
AutocmdFT vim        setlocal shiftwidth=2
AutocmdFT vim        setlocal softtabstop=2

AutocmdFT toml       setlocal foldmethod=marker
AutocmdFT toml       setlocal foldlevel=0
AutocmdFT toml       setlocal foldcolumn=5

AutocmdFT xml,html   setlocal foldlevel=99
AutocmdFT xml,html   setlocal foldcolumn=5
AutocmdFT xml,html   setlocal foldmethod=syntax
AutocmdFT xml,html   inoremap <silent><buffer> >  ><Esc>:call closetag#CloseTagFun()<CR>

AutocmdFT json       setlocal shiftwidth=2
AutocmdFT help       nnoremap <silent><buffer> q         :<C-u>close<CR>
AutocmdFT markdown   nnoremap <silent><buffer> <leader>v :<C-u>PrevimOpen<CR>

function! s:update_all()
  setlocal formatoptions-=r
  setlocal formatoptions-=o
  setlocal textwidth=0

  " ファイルの場所をカレントにする
  silent! execute 'lcd' fnameescape(expand('%:p:h'))
endfunction
" }}}
" 表示 {{{
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
set updatetime=250
set previewheight=24
set cmdheight=4
set laststatus=2
set showtabline=2
set noequalalways
set cursorline
set display=lastline
set conceallevel=2
set concealcursor=i
set signcolumn=yes
set list
set listchars=tab:\»\ ,eol:↲,extends:»,precedes:«,nbsp:%
set breakindent
set foldcolumn=0
set foldlevel=99

let g:vimsyn_folding     = 'af'
let g:xml_syntax_folding = 1

if s:has_gui_running
  set lines=100
  let &columns = s:base_columns
endif

Autocmd VimEnter * set t_vb=
Autocmd VimEnter * set visualbell
Autocmd VimEnter * set errorbells
Autocmd VimEnter * filetype detect
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
    highlight InvisibleJISX0208Space guibg=#112233
  endif
endfunction
" }}}
" フォント {{{
if s:has_gui_running
  set guifont=Ricty\ Regular\ for\ Powerline:h11
  " set renderoptions=type:directx
endif

set printfont=Ricty\ Regular\ for\ Powerline:h11

set ambiwidth=double
" }}}
" 遅延初期化 {{{
if s:has_vim_starting
  let s:lazy_initialized = 0
  autocmd VimEnter,FocusLost,CursorHold,CursorHoldI * call s:lazy_initialize()
endif

let s:lazy_initialize = 2*1
function! s:lazy_initialize()
  if s:lazy_initialized
    return
  endif

  let s:lazy_initialize -= 1
  if s:lazy_initialize > 0
    return
  endif

  " 実行ファイル位置を$PATHに最優先で含める
  let $PATH = $VIM . ';' . $PATH

  " ローカル設定
  let s:vimrc_local = expand('~/.vimrc_local')
  if filereadable(s:vimrc_local)
    execute 'source' s:vimrc_local
  endif

  Autocmd BufWinEnter,ColorScheme .vimrc highlight def link myVimAutocmd vimAutoCmd
  Autocmd BufWinEnter,ColorScheme .vimrc syntax match vimAutoCmd /\<\(Autocmd\|AutocmdFT\)\>/

  call gitgutter#enable()

  call dein#source([
        \ 'vimdoc-ja',
        \ 'vim-icondrag',
        \ 'vim-autoft',
        \ 'vim-auto-mirroring',
        \ 'vim-matchup',
        \ 'ctrlp.vim',
        \ 'vim-textobj-comment',
        \ 'textobj-wiw',
        \ 'vim-textobj-entire',
        \ 'vim-textobj-indent',
        \ 'vim-textobj-line',
        \ 'vim-textobj-word-column',
        \ 'vim-textobj-parameter',
        \ 'vim-textobj-xmlattr'])

  " .vimrc {{{
  function! s:edit_vimrc()
    let dropbox_vimrc = g:YOI_dropbox_dir . '/dotfiles/.vimrc'
    if filereadable(dropbox_vimrc)
      execute 'edit' dropbox_vimrc
    else
      execute 'edit' $MYVIMRC
    endif
  endfunction

  function! s:edit_vim_plugin_toml()
    let dropbox_vim_plugin_toml = g:YOI_dropbox_dir . '/dotfiles/vim_plugin.toml'
    if filereadable(dropbox_vim_plugin_toml)
      execute 'edit' dropbox_vim_plugin_toml
    else
      execute 'edit' s:vim_plugin_toml
    endif
  endfunction

  nnoremap <silent> <F1> :<C-u>call <SID>edit_vimrc()<CR>
  nnoremap <silent> <F2> :<C-u>call <SID>edit_vim_plugin_toml()<CR>
  nnoremap          <F3> :<C-u>call dein#clear_state()<CR>:call dein#update()<CR>
  " }}}
  " 検索 {{{
  set incsearch
  set ignorecase
  set smartcase
  set hlsearch
  set grepprg=jvgrep
  set iskeyword=@,48-57,_,128-167,224-235

  " ヘルプ
  set helplang=ja,en
  set keywordprg=

  " 複数Vimで検索を同期する
  if s:has_gui_running
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
  set diffopt=internal,filler,algorithm:histogram,indent-heuristic
  set splitbelow              " 縦分割したら新しいウィンドウは下に
  set splitright              " 横分割したら新しいウィンドウは右に

  " タブ・インデント
  set autoindent
  set cindent
  set tabstop=4       " ファイル内の <Tab> が対応する空白の数
  set softtabstop=4   " <Tab> の挿入や <BS> の使用等の編集操作をするときに <Tab> が対応する空白の数
  set shiftwidth=4    " インデントの各段階に使われる空白の数
  set expandtab       " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う

  if exists('+cryptmethod')
    set cryptmethod=blowfish2
  endif

  augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter [/\?] :set hlsearch
    autocmd CmdlineLeave [/\?] :set nohlsearch
  augroup END

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

  function! s:execute_keep_view(expr)
    let wininfo = winsaveview()
    execute a:expr
    call winrestview(wininfo)
  endfunction

  " 現在のファイルパスをクリップボードへコピーする
  command! CopyFilepath     call setreg('*', expand('%:t'), 'v')
  command! CopyFullFilepath call setreg('*', expand('%:p'), 'v')

  command! -nargs=1 -complete=file Diff call <SID>toggle_v_wide() | vertical diffsplit <args>
  Autocmd WinEnter * if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&diff')) == 1 | diffoff | call <SID>toggle_v_wide() | endif

  nnoremap Y y$

  vnoremap <C-a> <C-a>gv
  vnoremap <C-x> <C-x>gv

  " 日本語考慮r
  xnoremap <expr> r {'v': "\<C-v>r", 'V': "\<C-v>0o$r", "\<C-v>": 'r'}[mode()]

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
  " カーソル下の単語を移動するたびにハイライトする {{{
  " http://d.hatena.ne.jp/osyo-manga/20140121/1390309901
  Autocmd CursorHold                                * call s:hl_cword()
  Autocmd CursorMoved,BufLeave,WinLeave,InsertEnter * call s:hl_clear()
  Autocmd ColorScheme                               * highlight CursorWord guifg=Red

  highlight CursorWord guifg=Red

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
  " 'cursorline' を必要な時にだけ有効にする {{{
  " http://d.hatena.ne.jp/thinca/20090530/1243615055
  Autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  Autocmd CursorHold,CursorHoldI   * call s:auto_cursorline('CursorHold')
  Autocmd WinEnter                 * call s:auto_cursorline('WinEnter')
  Autocmd WinLeave                 * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
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
    setlocal cursorline
    let s:cursorline_lock = 1
  endfunction
  " }}}
  " モード移行 {{{
  inoremap <C-j> <Esc>
  nnoremap <C-j> <Esc>
  vnoremap <C-j> <Esc>
  cnoremap <C-j> <Esc>
  " }}}
  " カーソル移動 {{{
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
  nnoremap <silent> gg    ggzv:<C-u>call <SID>force_show_cursorline()<CR>
  nnoremap <silent> G     Gzv:<C-u>call  <SID>force_show_cursorline()<CR>

  noremap <expr> <C-b>    max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
  noremap <expr> <C-f>    max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
  nmap    <expr> <C-y>    (line('w0') <= 1         ? 'k' : "\<C-y>k")
  nmap    <expr> <C-e>    (line('w$') >= line('$') ? 'j' : "\<C-e>j")

  nnoremap <silent> <C-i> <C-i>zz:<C-u>call <SID>force_show_cursorline()<CR>
  nnoremap <silent> <C-o> <C-o>zz:<C-u>call <SID>force_show_cursorline()<CR>

  " 折り畳み
  nnoremap <expr> zh foldlevel(line('.'))  >  0  ? 'zc' : '<C-h>'
  nnoremap <expr> zl foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'
  " }}}
  " ターミナル {{{
  command! Terminal terminal ++curwin
  tnoremap <Esc> <C-w>N
  tnoremap <C-j> <C-w>N
  "}}}
  " アプリウィンドウ操作 {{{
  if s:has_gui_running
    noremap <silent> <leader>we :<C-u>call <SID>toggle_v_split_wide()<CR>
    noremap <silent> <leader>wf :<C-u>call <SID>full_window()<CR>

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
    " }}}
  endif
  " }}}

  let s:lazy_initialized = 1
endfunction
" }}}
" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab
