"環境吸収 {{{

set nocompatible				" VI互換をオフ
set encoding=utf-8
scriptencoding utf-8			" スクリプト内でutf-8を使用する

let s:isWindows   = has('win32') || has('win64')
let s:isMac       = has('mac')
let s:metaKey     = s:isWindows ? 'M' : 'D'
let g:baseColumns = s:isWindows ? 140 : 100
let $DOTVIM       = s:isWindows ? expand('~/vimfiles') : expand('~/.vim')
let mapleader     = ','

"}}}
"プラグイン {{{
"インストール{{{

if has('vim_starting')
	set runtimepath+=$DOTVIM/bundle/neobundle.vim/
endif

call neobundle#rc(expand('$DOTVIM/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'YankRing.vim'
NeoBundle 'bling/vim-bufferline'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'movewin.vim'
NeoBundle 'nishigori/vim-sunday'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'supasorn/vim-easymotion'
NeoBundle 'tomasr/molokai'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'LeafCage/foldCC'

NeoBundle 'Shougo/vimproc', {
			\	'build' : {
			\		'windows' : 'make -f make_mingw32.mak',
			\		'cygwin'  : 'make -f make_cygwin.mak',
			\		'mac'     : 'make -f make_mac.mak',
			\		'unix'    : 'make -f make_unix.mak',
			\	},
			\ }
NeoBundleLazy 'Shougo/neocomplete.vim', {
			\	'autoload' : {
			\		'insert' : 1,
			\	}
			\ }

NeoBundleLazy 'Shougo/neosnippet', {
			\	'autoload' : {
			\		'insert' : 1,
			\	}
			\ }

NeoBundleLazy 'h1mesuke/vim-alignta', {
			\   'autoload' : {
			\       'commands' : [ "Alignta" ]
			\   }
			\ }

NeoBundleLazy 'tsukkee/lingr-vim', {
			\   'autoload' : {
			\       'commands' : [ "LingrLaunch" ]
			\   }
			\ }

NeoBundleLazy 'rking/ag.vim', {
			\   'depends' : ["Shougo/unite.vim"],
			\   'autoload' : {
			\       'commands' : [ "Ag" ]
			\   }
			\ }

NeoBundleLazy 'Shougo/unite-outline', {
			\	"autoload" : {
			\		"unite_sources": ["outline"],
			\	}
			\ }

NeoBundleLazy 'mattn/benchvimrc-vim', {
			\   'autoload' : {
			\       'commands' : [ "BenchVimrc" ]
			\   }
			\ }

NeoBundleLazy 'vim-jp/vimdoc-ja', {
			\   'autoload' : {
			\       'commands' : [ "Help" ]
			\   }
			\ }

NeoBundleLazy "Shougo/unite.vim", {
			\   'autoload' : {
			\       'commands' : [ "Unite" ]
			\   }
			\ }

NeoBundleLazy 'Shougo/vimfiler', {
			\   'depends' : [ "Shougo/unite.vim" ],
			\   'autoload' : {
			\       'commands' : [ "VimFilerTab", "VimFiler", "VimFilerExplorer", "VimFilerBufferDir" ]
			\   }
			\ }

NeoBundleLazy 'Shougo/vimshell.vim', {
			\   'autoload' : {
			\       'commands' : [ "VimShell" ]
			\   }
			\ }

NeoBundleLazy 'majutsushi/tagbar', {
			\   'autoload' : {
			\       'commands' : [ "TagbarToggle" ]
			\   }
			\ }

NeoBundleLazy 'basyura/TweetVim', {
			\   'depends' : [ "Shougo/unite.vim", 'basyura/twibill.vim', 'tyru/open-browser.vim', 'mattn/webapi-vim', 'Shougo/unite-outline'],
			\   'autoload' : {
			\       'commands' : [ "TweetVimHomeTimeline", "TweetVimMentions", "TweetVimListStatuses", "TweetVimUserTimeline", "TweetVimSay", "TweetVimSearch" ]
			\   }
			\ }

NeoBundleLazy 'tyru/open-browser.vim'
NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'mattn/webapi-vim'

if s:isMac 
	NeoBundleLazy 'itchyny/dictionary.vim', {
				\   'autoload' : {
				\       'commands' : [ "Dictionary" ]
				\   }
				\ }

	NeoBundleLazy 'nosami/Omnisharp', {
				\	'autoload' : {
				\		'filetypes' : [ 'cs' ]
				\	},
				\	'build' : {
				\		'windows' : 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe server/OmniSharp.sln /p : Platform="Any CPU"',
				\		'mac'     : 'xbuild server/OmniSharp.sln',
				\		'unix'    : 'xbuild server/OmniSharp.sln',
				\	}
				\ }
endif

"}}}
"Unite {{{

" insert modeで開始
let g:unite_enable_start_insert = 1

nnoremap [unite]    <Nop>
nmap     <Leader>u [unite]

nnoremap <silent> [unite]g  :<C-u>Unite grep:. -auto-preview -buffer-name=search-buffer<CR>
nnoremap <silent> [unite]cg :<C-u>Unite grep:. -auto-preview -buffer-name=search-buffer<CR><C-R><C-W><CR>
nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer<CR>

nnoremap <silent> [unite]o  :<C-u>Unite -vertical -winwidth=40 -direction=rightbelow -no-quit outline<CR>
nnoremap <silent> [unite]m  :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]b  :<C-u>Unite buffer<CR>

" unite grep に ag(The Silver Searcher) を使う
if s:isMac
	if executable('ag')
		let g:unite_source_grep_command       = 'ag'
		let g:unite_source_grep_default_opts  = '--nogroup --nocolor --column'
		let g:unite_source_grep_recursive_opt = ''
	endif
endif
"}}}
"VimFiler {{{

let s:bundle = neobundle#get("vimfiler")
function! s:bundle.hooks.on_source(bundle)
	augroup vimrc
		autocmd!
		autocmd FileType vimfiler call s:vimfiler_my_settings()
	augroup END

	function! s:vimfiler_my_settings()
		nmap <buffer><expr> <Enter> vimfiler#smart_cursor_map(
			\  "\<Plug>(vimfiler_cd_file)",
			\  "\<Plug>(vimfiler_edit_file)")
	endfunction

	let g:vimfiler_as_default_explorer = 1
endfunction
unlet s:bundle

exe 'map  <silent> <'.s:metaKey.'-o> :VimFilerBufferDir<CR>'

"}}}
"Omnisharp {{{

nnoremap <F12>		:OmniSharpGotoDefinition<CR>zz
nnoremap <S-F12>	:OmniSharpFindUsages<CR>

"}}}
"Neocomplete {{{

let s:bundle = neobundle#get("neocomplete.vim")
function! s:bundle.hooks.on_source(bundle)
	let g:neocomplete#enable_at_startup  = 1
	let g:neocomplete#enable_ignore_case = 1
	let g:neocomplete#enable_smart_case  = 1
	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
	endif
	let g:neocomplete#force_omni_input_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
endfunction
unlet s:bundle

"}}}
"FoldCC {{{

set foldtext=foldCC#foldtext()
let g:foldCCtext_enable_autofdc_adjuster = 1

"}}}
"TagBar {{{

nmap		<F8>			:TagbarToggle<CR>

"}}}
"vim-easymotion {{{

" http://haya14busa.com/change-vim-easymotion-from-lokaltog-to-forked/
" https://github.com/supasorn/vim-easymotion

let g:EasyMotion_leader_key="<Space><Space>"
let g:EasyMotion_keys='hjklasdyuiopqwertnmzxcvb4738291056gf'
let g:EasyMotion_special_select_line = 0
let g:EasyMotiselect_phrase = 0

" カラー設定変更
hi EasyMotionTarget ctermbg=none ctermfg=red
hi easymotionshade  ctermbg=none ctermfg=blue

"}}}
"Tweetvim {{{

noremap		<silent><F10>		:call FlipTweetVim()<cr>

augroup tweetvim-vim
	autocmd!

	let g:isOpendTweetVim = 0
	function! FlipTweetVim()
		if g:isOpendTweetVim == 1
			call ExitTweetVim()
			let g:isOpendTweetVim = 0
		else
			call LaunchTweetVim()
			let g:isOpendTweetVim = 1
		endif
	endfunction

	function! LaunchTweetVim()
		tabnew
		TweetVimHomeTimeline
	endfunction

	function! ExitTweetVim()
		tabclose
	endfunction
augroup END
"}}}
"lingr.vim {{{

noremap			<silent><F9>		:call FlipLingr()<cr>

let s:bundle = neobundle#get("lingr-vim")
function! s:bundle.hooks.on_source(bundle)
	let g:vimrc_pass_file = expand('~/.vimrc_pass')

	if filereadable(g:vimrc_pass_file)
		exe 'source' g:vimrc_pass_file
	endif
endfunction
unlet s:bundle

augroup lingr-vim
	autocmd!
	autocmd FileType lingr-rooms    call SetLingrSetting()
	autocmd FileType lingr-members  call SetLingrSetting()
	autocmd FileType lingr-messages call SetLingrSetting()

	function! SetLingrSetting()
		" lingr.vim はSmartCloseを実行させない
		let b:disableSmartClose = 0
		let g:lingr_vim_say_buffer_height = 15
	endfunction

	let g:isOpendLingr = 0
	function! FlipLingr()
		if g:isOpendLingr == 1
			call ExitLingr()
			let g:isOpendLingr = 0
		else
			call LaunchLingr()
			let g:isOpendLingr = 1
		endif
	endfunction

	function! LaunchLingr()
		tabnew
		LingrLaunch 
	endfunction

	function! ExitLingr()
		LingrExit
	endfunction
augroup END

"}}}
"lightline {{{

" lightline用シンボル
let s:lightline_symbol_separator_left     = s:isWindows ? ''   : '⮀'
let s:lightline_symbol_separator_right    = s:isWindows ? ''   : '⮂'
let s:lightline_symbol_subseparator_left  = s:isWindows ? '|'  : '⮁'
let s:lightline_symbol_subseparator_right = s:isWindows ? '|'  : '⮃'
let s:lightline_symbol_line               = s:isWindows ? ''   : '⭡ '
let s:lightline_symbol_readonly           = s:isWindows ? 'ro' : '⭤'
let s:lightline_symbol_brunch             = s:isWindows ? ''   : '⭠ '

let g:lightline = {
			\	'mode_map': {'c': 'NORMAL'},
			\	'active': {
			\		'left'  : [	[ 'mode', 'paste' ],
			\					[ 'fugitive', 'filename', 'anzu'] ],
			\		'right' : [	[ 'lineinfo' ],
			\					[ 'percent' ],
			\					[ 'charcode', 'fileformat', 'fileencoding', 'filetype' ] ]
			\	},
			\	'component': {
			\		'lineinfo' : s:lightline_symbol_line . '%3l:%-2v',
			\	},
			\	'component_function': {
			\		'modified'          : 'MyModified',
			\		'readonly'          : 'MyReadonly',
			\		'fugitive'          : 'MyFugitive',
			\		'filename'          : 'MyFilename',
			\		'fileformat'        : 'MyFileformat',
			\		'filetype'          : 'MyFiletype',
			\		'fileencoding'      : 'MyFileencoding',
			\		'mode'              : 'MyMode',
			\		'anzu'              : 'anzu#search_status',
			\		'charcode'          : 'MyCharCode',
			\		'currentworkingdir' : 'CurrentWorkingDir',
			\	 },
			\	'separator': {
			\		'left'  : s:lightline_symbol_separator_left,
			\		'right' : s:lightline_symbol_separator_right
			\	},
			\	'subseparator': {
			\		'left'  : s:lightline_symbol_subseparator_left,
			\		'right' : s:lightline_symbol_subseparator_right
			\	},
			\	'tabline': {
			\		'left'  : [ [ 'tabs' ] ],
			\		'right' : [ [ 'currentworkingdir' ] ],
			\	},
			\	'tabline_separator': {
			\		'left'  : s:lightline_symbol_separator_left,
			\		'right' : s:lightline_symbol_separator_right
			\	},
			\	'tabline_subseparator': {
			\		'left'  : s:lightline_symbol_subseparator_left,
			\		'right' : s:lightline_symbol_subseparator_right
			\	},
			\}

function! MyModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? s:lightline_symbol_readonly : ''
endfunction

function! MyFilename()
	return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler'  ? vimfiler#get_status_string() :
				\  &ft == 'unite'     ? unite#get_status_string() :
				\  &ft == 'vimshell'  ? vimshell#get_status_string() :
				\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyBufferList()
	return winwidth(0) > 70 ? bufferline#get_echo_string() : ''
endfunction

function! MyFugitive()
	if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
		let _ = fugitive#head()

		return strlen(_) ? s:lightline_symbol_brunch . _ : ''
	endif
	return ''
endfunction

function! MyFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction"{{{"}}}

function! CurrentWorkingDir()
	return fnamemodify(getcwd(), ":~")
endfunction

function! MyCharCode()
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
"}}}
"vim-anzu {{{
"http://qiita.com/shiena/items/f53959d62085b7980cb5
nmap n <Plug>(anzu-n)zOzz
nmap N <Plug>(anzu-N)zOzz
nmap * <Plug>(anzu-star)
nmap # <Plug>(anzu-sharp)

augroup vim-anzu
	" 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
	" 検索ヒット数の表示を消去する
	autocmd!
	autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
augroup END
"}}}
"}}}
"基本設定 {{{
set viminfo+=!
set number                        " 行番号表示
set ignorecase                    " 検索パターンにおいて大文字と小文字を区別しない。
set smartcase                     " 検索パターンが大文字を含んでいたらオプション 'ignorecase' を上書きする。
set textwidth=0                   " 一行に長い文章を書いていても自動折り返しをしない
set tabstop=4                     " ファイル内の <Tab> が対応する空白の数。
set softtabstop=4                 " <Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数。
set shiftwidth=4                  " インデントの各段階に使われる空白の数。
set textwidth=0                   " 一行に長い文章を書いていても自動折り返しをしない
set tabstop=4                     " ファイル内の <Tab> が対応する空白の数。
set softtabstop=4                 " <Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数。
set shiftwidth=4                  " インデントの各段階に使われる空白の数。
set expandtab                     " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う。
set browsedir=buffer              " バッファで開いているファイルのディレクトリ
set showcmd                       " コマンドをステータス行に表示
set clipboard=unnamedplus,unnamed " クリップボードを使う
set modeline                      " モードラインを有効
set foldcolumn=1
set foldlevel=99
set autoindent
set smartindent
set splitbelow                    " 縦分割したら新しいウィンドウは下に
set splitright                    " 横分割したら新しいウィンドウは右に
set noexpandtab
set virtualedit=block
set helplang=ja,en
set autoread                      " 他で書き換えられたら自動で読み直す
set showmatch                     " 括弧の対応をハイライト
set noshowmode                    " モードを表示しない（ステータスラインで表示するため）
set cindent                       " Cプログラムファイルの自動インデントを始める
set incsearch                     " インクリメンタルサーチ
set whichwrap=b,s,h,l,<,>,[,]     " カーソルを行頭、行末で止まらないようにする
set wrap                          " ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
set shortmess+=I                  " 起動時のメッセージを表示しない
set wildmenu wildmode=list:full   " コマンドライン補完を便利に
set mouse=a                       " 全モードでマウスを有効化
set hidden                        " 変更中のファイルでも、保存しないで他のファイルを表示
set updatetime=1000               " スワップファイルが更新される時間
set swapfile                      " スワップファイルを使う
set directory=~/.vimswap          " スワップファイルをホームディレクトリに保存
set backup                        " バックアップファイルを使う
set backupdir=~/.vimbackup        " バックアップファイルをホームディレクトリに保存
set iminsert=0                    " 挿入モードでのデフォルトのIME状態設定
set imsearch=0                    " 検索モードでのデフォルトのIME状態設定
set keywordprg=                   " Kでhelpを開く
set lazyredraw                    " スクリプト実行中に画面を描画しない
syntax on                         " 構文ごとに色分けをする
filetype on                       " ファイルタイプごとの処理を有効
filetype indent on                " ファイルタイプごとのインデントを有効
filetype plugin on                " ファイルタイプごとのプラグインを有効

if has('migemo')
	set migemo                        " 日本語インクリメンタルサーチ
endif

"}}}
"ファイルタイプごとの設定 {{{
augroup file-setting
	autocmd! file-setting
	autocmd BufEnter			*			call SetCurrentDir()
	autocmd FileType			ruby		setlocal foldmethod=syntax tabstop=2 shiftwidth=2 softtabstop=2
	autocmd FileType			c,cpp,cs	setlocal foldmethod=syntax
	autocmd BufNewFile,BufRead	*.xaml		setf xml

	" ファイルの場所をカレントにする
	function! SetCurrentDir()
		if &ft != "" && &ft != "vimfiler"
			exe "lcd"  fnameescape(expand('%:p:h'))
		endif
	endfunction
augroup END
"}}}
"表示{{{
"全角スペースをハイライト {{{
" http://fifnel.com/2009/04/07/2300/
if has("syntax")
	function! ActivateInvisibleIndicator()
		syntax match InvisibleJISX0208Space "　" display containedin=ALL
		" highlight InvisibleJISX0208Space term=underline guibg=DodgerBlue2 
		highlight InvisibleJISX0208Space term=underline guibg=#112233 
		if has('gui_running')
			syntax match InvisibleTab "\t" display containedin=ALL
			highlight InvisibleTab term=underline ctermbg=Gray guibg=#121212
		endif
		" syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
		" highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=Red
	endf
	augroup invisible
		autocmd!
		autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
	augroup END
endif
"}}}
"カレントウィンドウにのみ罫線を引く {{{
" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup vimrc-auto-cursorline
	autocmd!
	autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
	autocmd CursorHold,CursorHoldI   * call s:auto_cursorline('CursorHold')
	autocmd WinEnter                 * call s:auto_cursorline('WinEnter')
	autocmd WinLeave                 * call s:auto_cursorline('WinLeave')

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
augroup END

"}}}
"}}}
"キーバインド {{{
"Vimっぽさ矯正 {{{

nnoremap	<Up>		<Nop>
nnoremap	<Down>		<Nop>
nnoremap	<Left>		<Nop>
nnoremap	<Right>		<Nop>
nnoremap	<BS>		<Nop>

vnoremap	<Up>		<Nop>
vnoremap	<Down>		<Nop>
vnoremap	<Left>		<Nop>
vnoremap	<Right>		<Nop>
vnoremap	<BS>		<Nop>

" todo:日本語入力がおかしくなる
" cnoremap	<Up>		<Nop>
" cnoremap	<Down>		<Nop>
" cnoremap	<Left>		<Nop>
" cnoremap	<Right>		<Nop>
" cnoremap	<BS>		<Nop>
" inoremap	<Up>		<Nop>
" inoremap	<Down>		<Nop>
" inoremap	<Left>		<Nop>
" inoremap	<Right>		<Nop>
" inoremap	<BS>		<Nop>

"}}}
"モード移行 {{{

inoremap		<C-j>		<Esc>
nnoremap		<C-j>		<Esc>
vnoremap		<C-j>		<Esc>

"}}}
"ウィンドウ操作 {{{

exe 'map  <silent> <'.s:metaKey.'-e> :call CloseVSplitWide()<cr>'
exe 'map  <silent> <'.s:metaKey.'-E> :call OpenVSplitWide()<cr>'
exe 'map  <silent> <'.s:metaKey.'-w> :call SmartClose()<CR>'

" アプリウィンドウの移動とリサイズ
if has('gui_running')
	noremap			<silent><Leader>H	:call ResizeWin()<CR>
	noremap			<silent><Leader>J	:call ResizeWin()<CR>
	noremap			<silent><Leader>K	:call ResizeWin()<CR>
	noremap			<silent><Leader>L	:call ResizeWin()<CR>
	noremap			<silent><Leader>h	:MoveWin<CR>
	noremap			<silent><Leader>j	:MoveWin<CR>
	noremap			<silent><Leader>k	:MoveWin<CR>
	noremap			<silent><Leader>l	:MoveWin<CR>
	exe 'noremap  <silent> <'.s:metaKey.'-f> :call FullWindow()<CR>'
endif

"}}}
"検索 {{{

"検索時のハイライトを解除
nnoremap	<silent><Leader>/		:nohlsearch<CR>

"}}}
"カーソル移動 {{{

nnoremap    <silent>k		gk
nnoremap    <silent>j		gj
vnoremap    <silent>k		gk
vnoremap    <silent>j		gj
nnoremap	<silent>0		g0
nnoremap	<silent>g0		0
nnoremap	<silent>$		g$
nnoremap	<silent>g$		$
nnoremap	<silent><C-e>	<C-e>j
nnoremap	<silent><C-y>	<C-y>k
vnoremap	<silent><C-e>	<C-e>j
vnoremap	<silent><C-y>	<C-y>k

"}}}
"補間 {{{

"中括弧補間
imap		<silent>{<CR>	{<CR>}<UP><CR>
"}

"}}}
"インデント {{{

vnoremap	<		<gv
vnoremap	>		>gv

"}}}
"折り畳み {{{

" http://vim.g.hatena.ne.jp/ka-nacht/20080630/1214799208
" map <expr> <C-h> col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : '<C-h>'
" map <expr> l foldclosed(line('.')) != -1 ? 'zo' : 'l'
map <expr> <C-h> foldlevel(line('.')) > 0 ? 'zc' : '<C-h>'
map <expr> <C-l> foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'

"}}}
"ファイル操作 {{{

"vimrc / gvimrc の編集 
nnoremap	<silent><F1>	:call SmartOpen($MYVIMRC)<CR>
nnoremap	<silent><F2>	:call SmartOpen($MYGVIMRC)<CR>

exe 'map  <silent> <'.s:metaKey.'-s> :write<cr>'

"}}}
"タブ {{{

" http://qiita.com/wadako111/items/755e753677dd72d8036d
nnoremap    [Tab]   <Nop>
nmap   <Leader>t  [Tab]

nnoremap <silent> [Tab]c :tabnew<CR>
nnoremap <silent> [Tab]x :tabclose<CR>

for n in range(1, 9)
	execute 'nnoremap <silent> [Tab]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

"}}}
"バッファ {{{

nnoremap    [Buffer]   <Nop>
nmap   <Leader>b  [Buffer]

nnoremap <silent>[Buffer]x	:bdelete<CR>

for n in range(1, 9)
	execute 'nnoremap <silent> [Buffer]'.n  ':<C-u>b'.n.'<CR>'
endfor

"}}}
"}}}
"サブ関数 {{{
"アプリケーションウィンドウサイズの変更 {{{
function! ResizeWin()
	let s:d1 = 1
	let s:d2 = 1

	let s:t = &titlestring
	let s:x = &columns
	let s:y = &lines
	let s:k = 'k'

	if s:x == -1 || s:y == -1
		echoerr 'Can not get window position'
	else
		while stridx('hjklHJKL', s:k) >= 0
			let &titlestring = 'Resizeing window: (' . s:x . ', ' . s:y . ')'
			redraw

			let s:k = nr2char(getchar())
			if s:k ==? 'h'
				let s:x = s:x - s:d1
				if s:k == 'h'
					let s:x = s:x - s:d2
				endif
			endif
			if s:k ==? 'j'
				let s:y = s:y + s:d1
				if s:k == 'j'
					let s:y = s:y + s:d2
				endif
			endif
			if s:k ==? 'k'
				let s:y = s:y - s:d1
				if s:k == 'k'
					let s:y = s:y - s:d2
				endif
			endif
			if s:k ==? 'l'
				let s:x = s:x + s:d1
				if s:k == 'l'
					let s:x = s:x + s:d2
				endif
			endif

			let &columns = s:x
			let &lines = s:y
		endwhile
	endif

	let &titlestring = s:t
	unlet s:k s:x s:y s:d1 s:d2 s:t
endfunction
"}}}
"アプリケーションウィンドウを最大高さにする {{{
function! FullWindow()
	exe 'winpos' getwinposx() '0'
	exe 'set lines=9999'
endf
"}}}
"縦分割する {{{
let s:depthVsp     = 1
let s:opendLeftVsp = 0
let s:opendTopVsp  = 0
function! OpenVSplitWide()
	
	if s:depthVsp == 1
		let s:opendLeftVsp = getwinposx()
		let s:opendTopVsp  = getwinposy()
	endif

	let s:depthVsp += 1
	let &columns = g:baseColumns * s:depthVsp
	exe 'botright vertical' g:baseColumns 'split'
endf

function! CloseVSplitWide()
	if s:depthVsp <= 1
		call OpenVSplitWide()
		return
	endif

	let s:depthVsp -= 1
	let &columns = g:baseColumns * s:depthVsp
	call SmartClose()

	if s:depthVsp == 1
		exe 'winpos' s:opendLeftVsp s:opendTopVsp
	end
endf
"}}}
"賢いクローズ {{{
" ウィンドウが１つかつバッファが一つかつ&columns が g:baseColumns            :quit
" ウィンドウが１つかつバッファが一つかつ&columns が g:baseColumnsでない      &columns = g:baseColumns
" 現在のウィンドウに表示しているバッファが他のウィンドウでも表示されてる     :close
"                                                           表示されていない :bdelete
function! SmartClose()

	if exists('b:disableSmartClose')
		return
	end

	let currentWindow           = winnr()
	let currentBuffer           = winbufnr(currentWindow)
	let isCurrentBufferModified = getbufvar(currentBuffer, '&modified')
	let tabCount                = tabpagenr('$')
	let windows                 = range(1, winnr('$'))

	if (len(windows) == 1) && (GetListedBufferCount() == 1) && (tabCount == 1)
		if  &columns == g:baseColumns
			if isCurrentBufferModified == 0
				quit
			elseif confirm('未保存です。閉じますか？', "&Yes\n&No", 1, "Question") == 1
				quit!
			endif
		else
			let &columns   = g:baseColumns
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
		elseif confirm('未保存です。閉じますか？', "&Yes\n&No", 1, "Question") == 1
			bdelete!
		endif
	endif
endfunction
"}}}
"賢いファイルオープン {{{
function! SmartOpen(filepath)

	" 新規タブであればそこに開く、そうでなければ新規新規タブに開く
	" if (&ft == "") && (GetIsCurrentBufferModified() == 0) && (GetCurrentBufferSize() == 0)
	" 	exe 'edit' a:filepath
	" else
	" 	exe 'tabnew' a:filepath
	" endif

	exe ':edit ' . a:filepath
	call CleanEmptyBuffers()
endfunction
"}}}
"読み込み済みのバッファ数を得る {{{
function! GetListedBufferCount()

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
"}}}
"現在のバッファが編集済みか？ {{{
function! GetIsCurrentBufferModified()
	let currentWindow           = winnr()
	let currentBuffer           = winbufnr(currentWindow)
	let isCurrentBufferModified = getbufvar(currentBuffer, '&modified')

	return isCurrentBufferModified
endfunction
"}}}
"カレントバッファのサイズを取得 {{{
function! GetCurrentBufferSize()
	let byte = line2byte(line('$') + 1)
	if byte == -1
		return 0
	else
		return byte - 1
	endif
endfunction
"}}}
"空バッファを削除 {{{
" http://stackoverflow.com/questions/6552295/deleting-all-empty-buffers-in-vim
function! CleanEmptyBuffers()
	let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
	if !empty(buffers)
		exe 'bd '.join(buffers, ' ')
	endif
endfunction
"}}}
"}}}

" vim: foldmethod=marker foldcolumn=3 foldlevel=0

