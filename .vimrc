set encoding=utf-8
scriptencoding utf-8
" 基本 {{{
let g:YOI_dotvim_dir   = expand('~/.vim')
let g:YOI_dropbox_dir  = expand('~/Dropbox')

let s:has_gui_running  = has('gui_running')
let s:base_columns     = 140
let s:is_vscode        = exists('g:vscode')

let g:mapleader        = ' '

if !s:is_vscode
  let g:python3_host_prog = 'C:/Users/yoi/AppData/Local/Programs/Python/Python310/python.exe'
endif
" 自動コマンド
augroup MyAutoCmd
  autocmd!
augroup END
command! -nargs=* Autocmd   autocmd MyAutoCmd <args>
command! -nargs=* AutocmdFT autocmd MyAutoCmd FileType <args>

" ローカル設定
let s:vimrc_local = expand('~/.vimrc.local')
if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif
" }}}
" プラグイン {{{
call plug#begin('~/.vim_plugged')

if !s:is_vscode
  Plug 'vim-jp/vimdoc-ja', { 'on': [] }

  Plug 'YoshihiroIto/molokai'
  Plug 'YoshihiroIto/vim-icondrag', { 'on': [] }

  Plug 'itchyny/vim-gitbranch', { 'on': [] }
  Plug 'airblade/vim-gitgutter', { 'on': [] }
  let g:gitgutter_map_keys = 0
  let g:gitgutter_grep     = ''

  Plug 'lambdalisue/vim-rplugin', { 'on': [] }
  Plug 'lambdalisue/lista.nvim', {'on': 'Lista'}
  nnoremap <silent> <leader>l   :<C-u>Lista<CR>
    let g:lista#custom_mappings = [
          \ ['<C-j>', '<Esc>'],
          \ ['<C-p>', '<S-Tab>'],
          \ ['<C-n>', '<Tab>'],
          \]

  Plug 'cocopon/vaffle.vim', {'on': 'Vaffle'}
  let g:vaffle_show_hidden_files = 1
  noremap <silent> <leader>f :<C-u>Vaffle<CR>

  Plug 'itchyny/vim-autoft'
  let g:autoft_config = [
        \   {'filetype': 'cs',
        \    'pattern': '^\s*using'},
        \   {'filetype': 'cpp',
        \    'pattern': '^\s*#\s*\%(include\|define\)\>'},
        \   {'filetype': 'go',
        \    'pattern': '^import ('},
        \   {'filetype': 'html',
        \    'pattern': '<\%(!DOCTYPE\|html\|head\|script\|meta\|link|div\|span\)\>\|^html:5\s*$'},
        \   {'filetype': 'xml',
        \    'pattern': '<[0-9a-zA-Z]\+'},
        \ ]

  " Plug 'beyondmarc/hlsl.vim', {'for': 'hlsl'}
  " Plug 'posva/vim-vue', {'for': 'vue'}

  Plug 'glidenote/memolist.vim', {'on': ['MemoNew', 'MemoList'] }
  noremap <silent> <leader>n :<C-u>MemoNew<CR>
  noremap <silent> <leader>k :execute "CtrlP" g:memolist_path<CR>
  let g:memolist_memo_suffix  = 'md'
  let g:memolist_path         = g:YOI_dropbox_dir . '/memo'

  Plug 'mattn/vim-lsp-settings'
  let g:lsp_settings_servers_dir = expand("~/lsp_server")

  Plug 'prabirshrestha/vim-lsp'
  let g:lsp_diagnostics_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
  nmap <silent> <C-]> :<C-u>LspDefinition<CR>
  nmap <silent> ;e    :<C-u>LspRename<CR>

  Plug 'ctrlpvim/ctrlp.vim', {'on':  ['CtrlP', 'CtrlPMRUFiles']}

  Plug 'itchyny/lightline.vim'
  execute 'source' expand('~/.vim/lightline.settings.vim')

  Plug 'kana/vim-submode', { 'on': [] }

  Plug 'prabirshrestha/asyncomplete.vim', { 'on': [] }
  Plug 'prabirshrestha/asyncomplete-lsp.vim', { 'on': [] }
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim', { 'on': [] }
  Plug 'prabirshrestha/asyncomplete-buffer.vim', { 'on': [] }

  Plug 'SirVer/ultisnips', { 'on': [] }
  let g:UltiSnipsSnippetDirectories  = [g:YOI_dotvim_dir . '/UltiSnips']
  let g:UltiSnipsJumpForwardTrigger  = "<Tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
  let g:UltiSnipsListSnippets        = "<S-Tab>"
  let g:UltiSnipsExpandTrigger       = "<C-e>"
endif

Plug 'andymass/vim-matchup', { 'on': [] }
let g:matchup_matchparen_status_offscreen = 0

Plug 'haya14busa/vim-asterisk', { 'on': [] }

Plug 'tomtom/tcomment_vim', { 'on': [] }
Plug 'cohama/lexima.vim', { 'on': [] }

Plug 'kana/vim-textobj-user', { 'on': [] }
Plug 'kana/vim-operator-user', { 'on': [] }

Plug 'glts/vim-textobj-comment', { 'on': [] }
Plug 'kana/vim-textobj-indent', { 'on': [] }
Plug 'kana/vim-textobj-entire', { 'on': [] }
Plug 'kana/vim-textobj-line', { 'on': [] }
Plug 'rhysd/vim-textobj-word-column', { 'on': [] }
Plug 'whatyouhide/vim-textobj-xmlattr', { 'on': [] }

Plug 'sgur/vim-textobj-parameter', {'on': ['<Plug>(textobj-parameter-a)', '<Plug>(textobj-parameter-i)']}
xmap aa <Plug>(textobj-parameter-a)
xmap ia <Plug>(textobj-parameter-i)
omap aa <Plug>(textobj-parameter-a)
omap ia <Plug>(textobj-parameter-i)

Plug 'rhysd/vim-textobj-wiw', {'on': ['<Plug>(textobj-wiw-a)', '<Plug>(textobj-wiw-i)']}
xmap a. <Plug>(textobj-wiw-a)
xmap i. <Plug>(textobj-wiw-i)
omap a. <Plug>(textobj-wiw-a)
omap i. <Plug>(textobj-wiw-i)

Plug 'YoshihiroIto/vim-operator-tcomment', {'on': '<Plug>(operator-tcomment)'}
nmap t  <Plug>(operator-tcomment)
xmap t  <Plug>(operator-tcomment)

Plug 'kana/vim-operator-replace', {'on': '<Plug>(operator-replace)'}
map R  <Plug>(operator-replace)

Plug 'rhysd/vim-operator-surround', {'on': ['<Plug>(operator-surround-append)', '<Plug>(operator-surround-delete)', '<Plug>(operator-surround-replace)']}
map  S  <Plug>(operator-surround-append)
nmap Sd <Plug>(operator-surround-delete)ab
nmap Sr <Plug>(operator-surround-replace)ab
let g:operator#surround#blocks = {
      \   '-': [
      \     {
      \       'block':      ["{\<CR>", "\<CR>}"],
      \       'motionwise': ['line'            ],
      \       'keys':       ['{', '}'          ]
      \     }
      \   ]
      \ }

Plug 'junegunn/vim-easy-align', { 'on': [] }
nmap <silent> <Leader>a=       v<Plug>(textobj-indent-i)<Plug>(EasyAlign)=
nmap <silent> <Leader>a:       v<Plug>(extobj-indent-i)<Plug>(EasyAlign):
nmap <silent> <Leader>a,       v<Plug>(textobj-indent-i)<Plug>(EasyAlign)*,
nmap <silent> <Leader>a<Space> v<Plug>(textobj-indent-i)<Plug>(EasyAlign)*<Space>
nmap <silent> <Leader>a\|      v<Plug>(textobj-indent-i)<Plug>(EasyAlign)*\|
xmap <silent> <Leader>a=       <Plug>(EasyAlign)=
xmap <silent> <Leader>a:       <Plug>(EasyAlign):
xmap <silent> <Leader>a,       <Plug>(EasyAlign)*,
xmap <silent> <Leader>a<Space> <Plug>(EasyAlign)*<Space>
xmap <silent> <Leader>a\|      <Plug>(EasyAlign)*\|

" function! Cond(Cond, ...)
"   let opts = get(a:000, 0, {})
"   return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
" endfunction
" Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" Plug 'asvetliakov/vim-easymotion', Cond(!exists('g:vscode'), { 'as': 'vsc-easymotion' })

if !s:is_vscode
  Plug 'easymotion/vim-easymotion'
else
  Plug 'asvetliakov/vim-easymotion'
endif

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase  = 1
let g:EasyMotion_keys       = 'asdghklqwertyuiopzxcvbnmfj'
map  s <Plug>(easymotion-s2)
nmap s <Plug>(easymotion-s2)

Plug 'tyru/open-browser.vim', {'on': '<Plug>(openbrowser-smart-search)'}
let g:openbrowser_no_default_menus = 1
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

Plug 'YoshihiroIto/vim-closetag', {'on': '<Plug>closetag'}
let g:closetag_filenames = '*.{html,xhtml,xml,xaml}'

Plug 'haya14busa/is.vim', { 'on': [] }
map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)

call plug#end()

" Load Event
function! s:load_plug(timer)
    if !s:is_vscode
        call plug#load(
                    \ 'vimdoc-ja',
                    \ 'vim-icondrag',
                    \ 'vim-submode',
                    \ 'vim-gitbranch',
                    \ 'vim-gitgutter',
                    \ 'vim-rplugin',
                    \ 'vim-lsp-settings',
                    \ 'vim-lsp',
                    \ 'asyncomplete.vim',
                    \ 'asyncomplete-lsp.vim',
                    \ 'asyncomplete-ultisnips.vim',
                    \ 'asyncomplete-buffer.vim',
                    \ 'ultisnips',
                    \ )

        execute 'source' expand('~/.vim/ctrlp.settings.vim')
        execute 'source' expand('~/.vim/submode.settings.vim')

        call icondrag#enable()
        call gitgutter#enable()

        call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
                    \ 'name': 'ultisnips',
                    \ 'whitelist': ['*'],
                    \ 'priority': 10,
                    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
                    \ }))
        call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                    \ 'name': 'buffer',
                    \ 'whitelist': ['*'],
                    \ 'priority': 30,
                    \ 'completor': function('asyncomplete#sources#buffer#completor'),
                    \ 'config': {
                        \    'max_buffer_size': 5000000,
                        \  },
                        \ }))
    endif

    call plug#load(
                \ 'vim-matchup',
                \ 'vim-asterisk',
                \ 'tcomment_vim',
                \ 'lexima.vim',
                \ 'is.vim',
                \ 'vim-easy-align',
                \ 'vim-textobj-user',
                \ 'vim-operator-user',
                \ 'vim-textobj-comment',
                \ 'vim-textobj-indent',
                \ 'vim-textobj-entire',
                \ 'vim-textobj-line',
                \ 'vim-textobj-word-column',
                \ 'vim-textobj-xmlattr',
                \ )
endfunction

" 500ミリ秒後にプラグインを読み込む
call timer_start(500, function("s:load_plug"))

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

AutocmdFT vue        setlocal tabstop=2
AutocmdFT vue        setlocal shiftwidth=2
AutocmdFT vue        setlocal softtabstop=2

AutocmdFT vim        setlocal foldmethod=marker
AutocmdFT vim        setlocal foldlevel=0
AutocmdFT vim        setlocal foldcolumn=5
AutocmdFT vim        setlocal tabstop=2
AutocmdFT vim        setlocal shiftwidth=2
AutocmdFT vim        setlocal softtabstop=2

AutocmdFT xml,html   setlocal foldlevel=99
AutocmdFT xml,html   setlocal foldcolumn=5
AutocmdFT xml,html   setlocal foldmethod=syntax
AutocmdFT xml,html   inoremap <silent><buffer> >  ><Esc>:call closetag#CloseTagFun()<CR>

AutocmdFT json       setlocal foldmethod=syntax
AutocmdFT json       setlocal shiftwidth=2
AutocmdFT json       noremap  <silent><buffer><expr> <leader>p jsonpath#echo()
AutocmdFT json       command! Format %!jq

AutocmdFT help       nnoremap <silent><buffer> q  :<C-u>close<CR>

function! s:update_all()
  setlocal formatoptions-=r
  setlocal formatoptions-=o
  setlocal textwidth=0

  " ファイルの場所をカレントにする
  silent! execute 'lcd' fnameescape(expand('%:p:h'))
endfunction
" }}}
" 表示 {{{
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
  set updatetime=250
  set previewheight=24
  set cmdheight=4
  set laststatus=2
  set showtabline=2
  set noequalalways
  set cursorline
  set display=lastline
  " set conceallevel=2
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

  if s:has_gui_running
    set guifont=Ricty\ Regular\ for\ Powerline:h11
    set renderoptions=type:directx
  endif

  set printfont=Ricty\ Regular\ for\ Powerline:h11

  set ambiwidth=double
endif
" }}}
" 初期化 {{{
autocmd VimEnter,FocusLost,CursorHold,CursorHoldI * call s:initialize()

function! s:initialize()
  " 実行ファイル位置を$PATHに最優先で含める
  let $PATH = $VIM . ';' . $PATH

  Autocmd BufWinEnter,ColorScheme .vimrc highlight def link myVimAutocmd vimAutoCmd
  Autocmd BufWinEnter,ColorScheme .vimrc syntax match vimAutoCmd /\<\(Autocmd\|AutocmdFT\)\>/

  " .vimrc {{{
  function! s:edit_vimrc()
    let dropbox_vimrc = g:YOI_dropbox_dir . '/dotfiles/.vimrc'
    if filereadable(dropbox_vimrc)
      execute 'edit' dropbox_vimrc
    else
      execute 'edit' $MYVIMRC
    endif
  endfunction

  nnoremap <silent> <F1> :<C-u>call <SID>edit_vimrc()<CR>
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
  set backspace=indent,eol,start
  set noswapfile
  set nobackup
  set formatoptions+=j
  set nofixeol
  set tags=tags,./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
  set diffopt=internal,filler,algorithm:histogram,indent-heuristic
  set splitbelow              " 縦分割したら新しいウィンドウは下に
  set splitright              " 横分割したら新しいウィンドウは右に

  if s:is_vscode
    nnoremap <silent> u :<C-u>call VSCodeNotify('undo')<CR>
    nnoremap <silent> <C-r> :<C-u>call VSCodeNotify('redo')<CR>
  endif

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

  if !s:is_vscode
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
  endif
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
  nnoremap <silent> gg    ggzv
  nnoremap <silent> G     Gzv

  noremap <expr> <C-b>    max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
  noremap <expr> <C-f>    max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
  nmap    <expr> <C-y>    (line('w0') <= 1         ? 'k' : "\<C-y>k")
  nmap    <expr> <C-e>    (line('w$') >= line('$') ? 'j' : "\<C-e>j")

  nnoremap <silent> <C-i> <C-i>zz
  nnoremap <silent> <C-o> <C-o>zz

  " 折り畳み
  nnoremap <expr> zh foldlevel(line('.'))  >  0  ? 'zc' : '<C-h>'
  nnoremap <expr> zl foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'
  " }}}
  " ターミナル {{{
  if !s:is_vscode
    command! Terminal terminal ++curwin
    tnoremap <Esc> <C-w>N
    tnoremap <C-j> <C-w>N
  endif
  "}}}
  " アプリウィンドウ操作 {{{
  if s:has_gui_running && !s:is_vscode
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
endfunction
" }}}
" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab
