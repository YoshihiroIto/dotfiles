set encoding=utf-8
scriptencoding utf-8
" 基本 {{{
let g:YOI_dotvim_dir   = expand('~/.vim')
let g:YOI_cache_dir    = expand('~/.cache')
let g:YOI_dropbox_dir  = expand('~/Dropbox')

let s:is_windows       = has('win32')
let s:is_mac           = has('mac') || has('macunix')
let s:has_vim_starting = has('vim_starting')
let s:has_gui_running  = has('gui_running')
let s:has_kaoriya      = has('kaoriya')
let s:base_columns     = 120
let g:mapleader        = ','

let s:vim_plugin_toml  = expand('~/vim_plugin.toml')
let s:plugin_dir       = g:YOI_cache_dir . '/plugin'

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

" メニューを読み込まない
let g:did_install_default_menus = 1

" ヘルプ
set helplang=ja,en
set keywordprg=
if s:has_kaoriya
  set runtimepath+=$VIM/plugins/vimdoc-ja
endif

" キー
nnoremap [App] <Nop>
nmap     ;     [App]

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

" 場所ごとに設定を用意する
" http://vim-jp.org/vim-users-jp/2009/12/27/Hack-112.html
Autocmd BufNewFile,BufReadPost * let s:files =
      \  findfile('.vimrc.local', escape(expand('<afile>:p:h'), ' ') . ';', -1)
      \| for s:i in reverse(filter(s:files, 'filereadable(v:val)'))
      \|   source `=s:i`
      \| endfor

" 遅延初期化
" ※なぜaugroupを使わないか
" 特定条件で設定がされないことがあるため。
" 引数で.csファイルを指定してvimを起動した時にOmniSharp で複数slnがあるときに再現。
" augroup を使わないと問題が起きないため。
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

  if executable('jvgrep')
    set grepprg=jvgrep
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

  call dein#source([
        \ 'vimproc',
        \ 'vim-textobj-ifdef',
        \ 'vim-textobj-comment',
        \ 'textobj-wiw',
        \ 'vim-textobj-entire',
        \ 'vim-textobj-indent',
        \ 'vim-textobj-line',
        \ 'vim-textobj-anyblock',
        \ 'vim-textobj-word-column',
        \ 'vim-textobj-parameter',
        \ 'vim-textobj-between',
        \ 'vim-textobj-xmlattr'])

  let s:lazy_initialized = 1
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
Autocmd BufWritePost                  *                         call s:update_numberwidth()
Autocmd BufNewFile,BufRead            *.xaml                    setlocal filetype=xml
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

AutocmdFT go         setlocal shiftwidth=4
AutocmdFT go         setlocal noexpandtab
AutocmdFT go         setlocal tabstop=4
AutocmdFT go         nnoremap <silent><buffer> K      :<C-u>Godoc<CR>
      \                                               zz
      \                                               :call YOI_refresh_screen()<CR>
AutocmdFT go         nnoremap <silent><buffer> <C-]>  :<C-u>call GodefUnderCursor()<CR>
      \                                               zz
      \                                               :call YOI_refresh_screen()<CR>
AutocmdFT c,cpp      nnoremap <silent><buffer> [App]r :<C-u>QuickRun cpp/wandbox<CR>
AutocmdFT c,cpp      nnoremap <silent><buffer> <C-]>  :<C-u>UniteWithCursorWord
      \                                                     -immediately -buffer-name=tag tag<CR>

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

" 行番号表示幅を設定する
" http://d.hatena.ne.jp/osyo-manga/20140303/1393854617
function! s:update_numberwidth()
  let w = len(line('$')) + 2
  if w < 5
    let w = 5
  endif

  let &l:numberwidth = w
endfunction
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
    if expand('%:e') ==# 'xaml'
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
command! CopyFilepath     call setreg('*', expand('%:t'), 'v')
command! CopyFullFilepath call setreg('*', expand('%:p'), 'v')

command! Guid call <SID>gen_guid()

function! s:gen_guid()
  call setreg('g', vimproc#system('GuidGen'), 'v')
  silent keepjumps normal! "gp
endfunction

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

" マウス中クリックペースト無効
map  <MiddleMouse>   <Nop>
imap <MiddleMouse>   <Nop>
map  <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map  <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map  <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>
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
set listchars=tab:\»\ ,eol:↲,extends:»,precedes:«,nbsp:%
set breakindent
" }}}
" 検索 {{{
set incsearch
set ignorecase
set smartcase
set hlsearch

" 日本語インクリメンタルサーチ
if s:has_kaoriya
  set migemo
  set migemodict=$VIMRUNTIME/dict/migemo-dict
endif

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
set synmaxcol=2000          " ハイライトする文字数を制限する
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
execute "set colorcolumn=" . join(range(101, 999), ',')

if s:has_gui_running
  set lines=100
  let &columns = s:base_columns
endif

Autocmd VimEnter * set t_vb=
Autocmd VimEnter * set visualbell
Autocmd VimEnter * set errorbells

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
    highlight InvisibleJISX0208Space guibg=#112233
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
  set guifont=Ricty\ Regular\ for\ Powerline:h11
endif

set printfont=Ricty\ Regular\ for\ Powerline:h11

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

let g:vimsyn_folding     = 'af'
let g:xml_syntax_folding = 1

nnoremap <expr> zh foldlevel(line('.'))  >  0  ? 'zc' : '<C-h>'
nnoremap <expr> zl foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'
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
nnoremap <silent> gg    ggzv:<C-u>call YOI_refresh_screen()<CR>
nnoremap <silent> G     Gzv:<C-u>call  YOI_refresh_screen()<CR>

noremap <expr> <C-b>
      \ max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
noremap <expr> <C-f>
      \ max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
nmap <expr> <C-y> (line('w0') <= 1         ? 'k' : "\<C-y>k")
nmap <expr> <C-e> (line('w$') >= line('$') ? 'j' : "\<C-e>j")

nnoremap <silent> <C-i> <C-i>zz:<C-u>call YOI_refresh_screen()<CR>
nnoremap <silent> <C-o> <C-o>zz:<C-u>call YOI_refresh_screen()<CR>
nnoremap <silent> <C-h> ^:<C-u>set virtualedit=all<CR>
nnoremap <silent> <C-l> $:<C-u>set virtualedit=all<CR>

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
" }}}
" アプリウィンドウ操作 {{{
if s:has_gui_running
  noremap <silent> ,we :<C-u>call <SID>toggle_v_split_wide()<CR>
  noremap <silent> ,wf :<C-u>call <SID>full_window()<CR>

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
  endfunction

  function! s:close_v_split_wide()
    let s:depth_vsp -= 1
    let &columns = s:base_columns * s:depth_vsp
    only

    if s:depth_vsp == 1
      execute 'winpos' s:opend_left_vsp s:opend_top_vsp
    endif
  endfunction
  " }}}
endif
" }}}
" Git {{{
nnoremap [Git]     <Nop>
nmap     <Leader>g [Git]

nnoremap <silent> [Git]b  :<C-u>call YOI_execute_if_on_git_branch('Gblame w')<CR>
nnoremap <silent> [Git]a  :<C-u>call YOI_execute_if_on_git_branch('Gwrite')<CR>:GitGutter<CR>
nnoremap <silent> [Git]c  :<C-u>call YOI_execute_if_on_git_branch('Gcommit')<CR>:GitGutter<CR>
nnoremap <silent> [Git]f  :<C-u>call YOI_execute_if_on_git_branch('GitiFetch')<CR>:GitGutter<CR>
nnoremap <silent> [Git]d  :<C-u>call YOI_execute_if_on_git_branch('Gdiff')<CR>
nnoremap <silent> [Git]s  :<C-u>call YOI_execute_if_on_git_branch('Gstatus')<CR>
nnoremap <silent> [Git]ps :<C-u>call YOI_execute_if_on_git_branch('Gpush')<CR>:GitGutter<CR>
nnoremap <silent> [Git]pl :<C-u>call YOI_execute_if_on_git_branch('Gpull')<CR>:GitGutter<CR>
nnoremap <silent> [Git]g  :<C-u>call YOI_execute_if_on_git_branch('Agit')<CR>
nnoremap <silent> [Git]h  :<C-u>call YOI_execute_if_on_git_branch('GitGutterPreviewHunk')<CR>
" }}}
" 汎用関数 {{{
" 画面リフレッシュ {{{
function! YOI_refresh_screen()
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
function! YOI_is_in_git_branch()
  try
    return !empty(fugitive#head())
  catch
    return 0
  endtry
endfunction
" }}}
" Gitブランチ上であれば実行 {{{
function! YOI_execute_if_on_git_branch(line)
  if !YOI_is_in_git_branch()
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
      let out = vimproc#system2(
            \ printf(a:cmd, normalized_current_tempfile, normalized_output_tempfile))
    else
      let out = vimproc#system(
            \ printf(a:cmd, normalized_current_tempfile, normalized_output_tempfile))
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
