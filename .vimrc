" 基本 {{{

set nocompatible                " VI互換をオフ
set encoding=utf-8
scriptencoding utf-8            " スクリプト内でutf-8を使用する

let s:isWindows    = has('win32') || has('win64')
let s:isMac        = has('mac')
let s:isGuiRunning = has('gui_running')
let g:baseColumns  = s:isWindows ? 140 : 100
let $DOTVIM        = s:isWindows ? expand('~/vimfiles') : expand('~/.vim')
let mapleader      = ' '
set viminfo+=!

if !s:isGuiRunning
    let $MYGVIMRC = expand('~/.gvimrc')
endif

" }}}
" プラグイン {{{
" インストール {{{

if has('vim_starting')
    set runtimepath+=$DOTVIM/bundle/neobundle.vim/
endif

call neobundle#rc(expand('$DOTVIM/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" 表示 {{{

NeoBundle 'tomasr/molokai'
NeoBundle 'bling/vim-bufferline'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'LeafCage/foldCC'
NeoBundleLazy 'Shougo/unite-outline', {
            \   'autoload' : {
            \       'unite_sources' : [ 'outline' ],
            \   }
            \ }
NeoBundleLazy 'majutsushi/tagbar', {
            \   'autoload' : {
            \       'commands' : [ 'TagbarToggle' ]
            \   }
            \ }

" }}}
" 編集 {{{

NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'YankRing.vim'
NeoBundleLazy 'Shougo/neocomplete.vim', {
            \   'autoload' : {
            \       'insert' : 1,
            \   }
            \ }
NeoBundleLazy 'honza/vim-snippets'
NeoBundleLazy 'Shougo/neosnippet', {
            \   'depends' : [ 'honza/vim-snippets' ],
            \   'autoload' : {
            \       'insert' : 1,
            \   }
            \ }
NeoBundleLazy 'kana/vim-smartinput', {
            \   'autoload' : {
            \       'insert' : 1,
            \   }
            \ }
NeoBundleLazy 'h1mesuke/vim-alignta', {
            \   'autoload' : {
            \       'unite_sources' : [ 'alignta' ],
            \       'commands'      : [ 'Alignta' ]
            \   }
            \ }
NeoBundleLazy 'rhysd/vim-clang-format', {
            \   'depends'  : 'kana/vim-operator-user',
            \   'autoload' : {
            \       'filetypes' : ['c', 'cpp', 'objc']
            \   }
            \ }
NeoBundleLazy 'Rip-Rip/clang_complete', {
            \   'autoload' : {
            \       'filetypes' : ['c', 'cpp', 'objc']
            \   }
            \ }

" }}}
" 検索 {{{

NeoBundle 'supasorn/vim-easymotion'
NeoBundle 'tmhedberg/matchit'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'othree/eregex.vim'
NeoBundleLazy 'rking/ag.vim', {
            \   'depends' : [ 'Shougo/unite.vim' ],
            \   'autoload' : {
            \       'commands' : [ 'Ag' ]
            \   }
            \ }

" }}}
" オペレータ {{{
" http://qiita.com/rbtnn/items/a47ed6684f1f0bc52906

NeoBundle 'kana/vim-operator-user'
NeoBundle 'tyru/operator-camelize.vim'
NeoBundle 'kana/vim-operator-replace'

" }}}
" テキストオブジェクト {{{
" http://d.hatena.ne.jp/osyo-manga/20130717/1374069987

NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'kana/vim-textobj-entire'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundle 'anyakichi/vim-textobj-ifdef'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'thinca/vim-textobj-comment'

" }}}
" アプリ {{{

NeoBundle 'tpope/vim-fugitive'
NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'tsukkee/lingr-vim', {
            \   'autoload' : {
            \       'commands' : [ 'LingrLaunch' ]
            \   }
            \ }
NeoBundleLazy 'mattn/benchvimrc-vim', {
            \   'autoload' : {
            \       'commands' : [ 'BenchVimrc' ]
            \   }
            \ }
NeoBundleLazy 'Shougo/vimfiler', {
            \   'depends' : [ 'Shougo/unite.vim', 'Shougo/vimshell.vim' ],
            \   'autoload' : {
            \       'commands' : [ 'VimFilerBufferDir' ]
            \   }
            \ }
NeoBundleLazy 'Shougo/vimshell.vim', {
            \   'autoload' : {
            \       'commands' : [ 'VimShell' ]
            \   }
            \ }
NeoBundleLazy 'basyura/TweetVim', {
            \   'depends' : [ 
            \       'basyura/twibill.vim',
            \       'tyru/open-browser.vim',
            \       'mattn/webapi-vim',
            \   ],
            \   'autoload' : {
            \       'commands' : [ 'TweetVimHomeTimeline', 'TweetVimUserStream' ]
            \   }
            \ }

" }}}
" ヘルプ {{{

NeoBundleLazy 'vim-jp/vimdoc-ja', {
            \   'autoload' : {
            \       'commands' : [ 'Help' ]
            \   }
            \ }
NeoBundleLazy 'tsukkee/unite-help', { 
            \   'autoload' : {
            \       'unite_sources' : [ 'help' ],
            \   }
            \ }

" }}}
" その他 {{{

NeoBundle 'YoshihiroIto/vim-icondrag'
NeoBundle 'movewin.vim'
NeoBundle 'Shougo/vimproc', {
            \   'build' : {
            \       'windows' : 'make -f make_mingw32.mak',
            \       'cygwin'  : 'make -f make_cygwin.mak',
            \       'mac'     : 'make -f make_mac.mak',
            \       'unix'    : 'make -f make_unix.mak',
            \   },
            \ }
NeoBundleLazy 'Shougo/unite.vim', {
            \   'autoload' : {
            \       'commands' : [ 'Unite', 'UniteResume', 'UniteWithCursorWord' ]
            \   }
            \ }
NeoBundleLazy 'mattn/webapi-vim'
NeoBundleLazy 'open-browser.vim', {
            \   'autoload' : {
            \        'mappings'        : ['<Plug>(open-browser-wwwsearch)', '<Plug>(openbrowser-open)'],
            \        'function_prefix' : 'openbrowser',
            \        'functions'       : ['openbrowser#open'],
            \        'commands'        : ['OpenBrowserSearch', 'OpenBrowser', 'OpenBrowserSmartSearch']
            \   }
            \ }
if s:isMac 
    NeoBundleLazy 'itchyny/dictionary.vim', {
                \   'autoload' : {
                \       'commands' : [ 'Dictionary' ]
                \   }
                \ }

    NeoBundleLazy 'nosami/Omnisharp', {
                \   'autoload' : {
                \       'filetypes' : [ 'cs' ]
                \   },
                \   'build' : {
                \       'windows' : 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe server/OmniSharp.sln /p : Platform="Any CPU"',
                \       'mac'     : 'xbuild server/OmniSharp.sln',
                \       'unix'    : 'xbuild server/OmniSharp.sln',
                \   }
                \ }
endif
" }}}
" }}}
" Unite {{{

nnoremap [Unite]    <Nop>
xnoremap [Unite]    <Nop>
nmap     <Leader>u  [Unite]
xmap     <Leader>u  [Unite]

nnoremap <silent> [Unite]g    :<C-u>Unite grep:. -auto-preview -buffer-name=search-buffer<CR>
nnoremap <silent> [Unite]cg   :<C-u>Unite grep:. -auto-preview -buffer-name=search-buffer<CR><C-R><C-W><CR>
nnoremap <silent> [Unite]r    :<C-u>UniteResume search-buffer<CR>

nnoremap <silent> [Unite]o    :<C-u>Unite -vertical -winwidth=40 -direction=rightbelow -no-quit outline<CR>
nnoremap <silent> [Unite]m    :<C-u>Unite file_mru<CR>
nnoremap <silent> [Unite]b    :<C-u>Unite bookmark<CR>
nnoremap <silent> [Unite]h    :<C-u>UniteWithCursorWord help<CR>
nnoremap <silent> [Unite]l    :<C-u>Unite -auto-preview line<CR>
xnoremap <silent> [Unite]a    :<C-u>Unite -vertical -winwidth=40 -direction=rightbelow alignta:arguments<CR>
nnoremap <silent> [Unite]f    :<C-u>Unite menu:fix<CR>

let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)

    " insert modeで開始
    let g:unite_enable_start_insert = 1

    " 無指定にすることで高速化
    let g:unite_source_file_mru_filename_format = ''

    " most recently used のリストサイズ
    let g:unite_source_file_mru_limit = 100

    " unite grep に ag(The Silver Searcher) を使う
    if s:isMac
        if executable('ag')
            let g:unite_source_grep_command       = 'ag'
            let g:unite_source_grep_default_opts  = '--nogroup --nocolor --column'
            let g:unite_source_grep_recursive_opt = ''
        endif
    endif
endfunction
unlet s:bundle

" }}}
" VimFiler {{{

noremap  <silent> <Leader>o :VimFilerBufferDir<CR>

let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)

    augroup vimrc
        autocmd!
        autocmd FileType vimfiler call s:vimfiler_my_settings()
    augroup END

    function! s:vimfiler_my_settings()
        nmap <buffer><expr> <Enter> vimfiler#smart_cursor_map(
            \  "\<Plug>(vimfiler_cd_file)",
            \  "\<Plug>(vimfiler_edit_file)")

        nmap <buffer><expr> <S-Space> vimfiler#smart_cursor_map(
            \  "\<Plug>(vimfiler_toggle_mark_current_line)",
            \  "\<Plug>(vimfiler_toggle_mark_current_line)")
    endfunction

    let g:vimfiler_as_default_explorer = 1
endfunction
unlet s:bundle

" }}}
" VimShell {{{

let s:bundle = neobundle#get('vimshell.vim')
function! s:bundle.hooks.on_source(bundle)

    let g:vimshell_prompt_expr = 'getcwd().">"'
    let g:vimshell_prompt_pattern = '^\f\+>'
endfunction
unlet s:bundle

" }}}
" Omnisharp {{{

nnoremap <F12>      :OmniSharpGotoDefinition<CR>zz
nnoremap <S-F12>    :OmniSharpFindUsages<CR>

" }}}
" neocomplete {{{

let s:bundle = neobundle#get('neocomplete.vim')
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

" }}}
" neosnippet {{{

let s:bundle = neobundle#get('neosnippet')
function! s:bundle.hooks.on_source(bundle)

    " Enable snipMate compatibility feature.
    let g:neosnippet#enable_snipmate_compatibility = 1

    " Tell Neosnippet about the other snippets
    let g:neosnippet#snippets_directory='$DOTVIM/bundle/vim-snippets/snippets'

    " Plugin key-mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <c-k>     <plug>(neosnippet_expand_or_jump)

    " supertab like snippets behavior.
    imap <expr><tab> neosnippet#expandable() <bar><bar> neosnippet#jumpable() ? "\<plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<c-n>" : "\<tab>"
    smap <expr><tab> neosnippet#expandable() <bar><bar> neosnippet#jumpable() ? "\<plug>(neosnippet_expand_or_jump)" : "\<tab>"

    " for snippet_complete marker.
    if has('conceal')
        set conceallevel=2 concealcursor=i
    endif
endfunction
unlet s:bundle

" }}}
" TagBar {{{

noremap        <F8>            :TagbarToggle<CR>

" }}}
" vim-easymotion {{{

" http://haya14busa.com/change-vim-easymotion-from-lokaltog-to-forked/
" https://github.com/supasorn/vim-easymotion

let g:EasyMotion_leader_key          = '<Space><Space>'
let g:EasyMotion_keys                = 'hjklasdyuiopqwertnmzxcvb4738291056gf'
let g:EasyMotion_special_select_line = 0
let g:EasyMotiselect_phrase          = 0

" hi link EasyMotionTarget ErrorMsg
" hi link EasyMotionShade  Comment

" }}}
" lingr.vim {{{

noremap     <silent><F9>        :<C-u>call <SID>ToggleLingr()<CR>

let s:bundle = neobundle#get('lingr-vim')
function! s:bundle.hooks.on_source(bundle)

    let g:lingr_vim_say_buffer_height = 15

    let g:vimrc_pass_file = expand('~/.vimrc_pass')

    if filereadable(g:vimrc_pass_file)
        exe 'source' g:vimrc_pass_file
    endif

    augroup lingr-vim
        autocmd!
        autocmd FileType lingr-rooms    call s:SetLingrSetting()
        autocmd FileType lingr-members  call s:SetLingrSetting()
        autocmd FileType lingr-messages call s:SetLingrSetting()

        function! s:SetLingrSetting()
            let b:disableSmartClose = 0

            noremap  <buffer><silent> <Leader>w :<C-u>call <SID>ToggleLingr()<CR>
        endfunction
    augroup END
endfunction
unlet s:bundle

function! s:ToggleLingr()
    if bufnr('lingr-messages') == -1
        tabnew
        LingrLaunch 
    else
        LingrExit
    endif
endfunction

" }}}
" Tweetvim {{{

noremap     <silent><F10>       :<C-u>call <SID>ToggleTweetVim()<CR>

let s:bundle = neobundle#get('TweetVim')
function! s:bundle.hooks.on_source(bundle)

    let g:tweetvim_include_rts       = 1
    let g:tweetvim_display_separator = 0
    let g:tweetvim_tweet_per_page    = 35
    let g:tweetvim_display_icon      = 1

    function! s:ToggleTweetVim()
        if bufnr("tweetvim") == -1
            tabnew
            TweetVimHomeTimeline
        else
            silent! exe 'bwipeout tweetvim'
        endif
    endfunction

    augroup TweetVimSetting
        autocmd!
        autocmd FileType tweetvim     nmap     <buffer>rr        <Plug>(tweetvim_action_reload)
    augroup END
endfunction
unlet s:bundle

" }}}
" lightline {{{

" lightline用シンボル
let s:lightline_symbol_separator_left     = s:isWindows ? ''   : '⮀'
let s:lightline_symbol_separator_right    = s:isWindows ? ''   : '⮂'
let s:lightline_symbol_subseparator_left  = s:isWindows ? '|'  : '⮁'
let s:lightline_symbol_subseparator_right = s:isWindows ? '|'  : '⮃'
let s:lightline_symbol_line               = s:isWindows ? ''   : '⭡ '
let s:lightline_symbol_readonly           = s:isWindows ? 'ro' : '⭤'
let s:lightline_symbol_brunch             = s:isWindows ? ''   : '⭠ '

let g:lightline = {
            \   'mode_map': {'c': 'NORMAL'},
            \   'active': {
            \       'left'  : [ [ 'mode', 'paste' ],
            \                   [ 'fugitive', 'filename', 'anzu'] ],
            \       'right' : [ [ 'lineinfo' ],
            \                   [ 'percent' ],
            \                   [ 'charcode', 'fileformat', 'fileencoding', 'filetype' ] ]
            \   },
            \   'component': {
            \       'lineinfo' : s:lightline_symbol_line . '%4l:%-3v',
            \   },
            \   'component_function': {
            \       'modified'          : 'MyModified',
            \       'readonly'          : 'MyReadonly',
            \       'fugitive'          : 'MyFugitive',
            \       'filename'          : 'MyFilename',
            \       'fileformat'        : 'MyFileformat',
            \       'filetype'          : 'MyFiletype',
            \       'fileencoding'      : 'MyFileencoding',
            \       'mode'              : 'MyMode',
            \       'charcode'          : 'MyCharCode',
            \       'currentworkingdir' : 'MyCurrentWorkingDir',
            \       'anzu'              : 'anzu#search_status',
            \    },
            \   'separator': {
            \       'left'  : s:lightline_symbol_separator_left,
            \       'right' : s:lightline_symbol_separator_right
            \   },
            \   'subseparator': {
            \       'left'  : s:lightline_symbol_subseparator_left,
            \       'right' : s:lightline_symbol_subseparator_right
            \   },
            \   'tabline': {
            \       'left'  : [ [ 'tabs' ] ],
            \       'right'  : [ [ ] ],
            \   },
            \   'tabline_separator': {
            \       'left'  : s:lightline_symbol_separator_left,
            \       'right' : s:lightline_symbol_separator_right
            \   },
            \   'tabline_subseparator': {
            \       'left'  : s:lightline_symbol_subseparator_left,
            \       'right' : s:lightline_symbol_subseparator_right
            \   },
            \ }

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

function! MyFugitive()
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
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
endfunction

function! MyCurrentWorkingDir()
    return fnamemodify(getcwd(), ':~')
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
" }}}
" vim-anzu {{{

let s:bundle = neobundle#get('vim-anzu')
function! s:bundle.hooks.on_source(bundle)

    " http://qiita.com/shiena/items/f53959d62085b7980cb5
    nmap <silent> n <Plug>(anzu-n)zOzz:<C-u>call     <SID>RefreshScreen()<CR>
    nmap <silent> N <Plug>(anzu-N)zOzz:<C-u>call     <SID>RefreshScreen()<CR>
    nmap <silent> * <Plug>(anzu-star)zOzz:<C-u>call  <SID>RefreshScreen()<CR>
    nmap <silent> # <Plug>(anzu-sharp)zOzz:<C-u>call <SID>RefreshScreen()<CR>

    augroup vim-anzu
        " 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
        " 検索ヒット数の表示を消去する
        autocmd!
        autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
    augroup END
endfunction
unlet s:bundle

" }}}
" eregex.vim {{{

let g:eregex_default_enable = 0

let s:bundle = neobundle#get('eregex.vim')
function! s:bundle.hooks.on_source(bundle)

    nnoremap [eregex]    <nop>
    nmap     <leader>e [eregex]

    nnoremap [eregex]t :<c-u>call eregex#toggle()<cr>
endfunction
unlet s:bundle

" }}}
" vim-alignta {{{

let g:unite_source_alignta_preset_arguments = [
            \     ["Align at '='", '=>\='],
            \     ["Align at ':'", ':'],
            \     ["Align at '|'", '|'],
            \     ["Align at '/'", '/\//'],
            \     ["Align at ','", ','],
            \ ]

" }}}
" icondrag {{{

let g:icondrag_auto_start = 1

" }}}
" operator-camelize.vim {{{

map <Leader>c <Plug>(operator-camelize-toggle)

" }}}
" vim-operator-replace {{{

map R  <Plug>(operator-replace)

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
                \ 'AccessModifierOffset'                : -4,
                \ 'ColumnLimit'                         : 120,
                \ 'AllowShortIfStatementsOnASingleLine' : 'true',
                \ 'AlwaysBreakTemplateDeclarations'     : 'true',
                \ 'Standard'                            : 'C++11',
                \ 'BreakBeforeBraces'                   : 'Stroustrup',
                \ }

    let g:clang_format#code_style = "Chromium"

    augroup clang-format-setting
        autocmd!
        autocmd FileType c,cpp map <buffer><Leader>x <Plug>(operator-clang-format)
    augroup END
endfunction
unlet s:bundle

" }}}
" clang_complete {{{

let s:bundle = neobundle#get('clang_complete')
function! s:bundle.hooks.on_source(bundle)

    let g:clang_use_library   = 1
    let g:clang_complete_auto = 0
    let g:clang_auto_select   = 0

    if s:isWindows
        let g:clang_user_options = '-I c:/Development/boost/boost_1_47 -I "C:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/include" -std=c++11 -fms-extensions -fmsc-version=1300 -fgnu-runtime -D__MSVCRT_VERSION__=0x700 -D_WIN32_WINNT=0x0500 2> NUL || exit 0"'
        let g:clang_library_path = 'C:/Development/llvm/build/bin/Release/'
    elseif s:isMac
        let g:clang_user_options = '-std=c++11'
    endif

    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif

    let g:neocomplete#force_overwrite_completefunc     = 1
    let g:neocomplete#force_omni_input_patterns.c      = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.cpp    = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.objc   = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endfunction
unlet s:bundle

" }}}
" }}}
" キー無効 {{{

" Vimっぽさ矯正
nnoremap    <Up>        <Nop>
nnoremap    <Down>      <Nop>
nnoremap    <Left>      <Nop>
nnoremap    <Right>     <Nop>
nnoremap    <BS>        <Nop>

vnoremap    <Up>        <Nop>
vnoremap    <Down>      <Nop>
vnoremap    <Left>      <Nop>
vnoremap    <Right>     <Nop>
vnoremap    <BS>        <Nop>

" todo:日本語入力がおかしくなる
" cnoremap  <Up>        <Nop>
" cnoremap  <Down>      <Nop>
" cnoremap  <Left>      <Nop>
" cnoremap  <Right>     <Nop>
" cnoremap  <BS>        <Nop>
" inoremap  <Up>        <Nop>
" inoremap  <Down>      <Nop>
" inoremap  <Left>      <Nop>
" inoremap  <Right>     <Nop>
" inoremap  <BS>        <Nop>

" Vimを閉じない
nnoremap    ZZ          <Nop>
nnoremap    ZQ          <Nop>

" ミス操作で削除してしまうため
nnoremap    dh          <Nop>
nnoremap    dj          <Nop>
nnoremap    dk          <Nop>
nnoremap    dl          <Nop>

" }}}
" ファイルタイプごとの設定 {{{

filetype on                       " ファイルタイプごとの処理を有効
filetype plugin on                " ファイルタイプごとのプラグインを有効

augroup file-setting
    autocmd!
    autocmd BufEnter            *           call s:SetCurrentDir()
    autocmd BufNewFile,BufRead  *.xaml      setf xml
    autocmd FileType            *           setlocal formatoptions-=ro      " コメント補完しない
    autocmd FileType            ruby        setlocal foldmethod=syntax tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType            c,cpp,cs    setlocal foldmethod=syntax
    autocmd FileType            vim         setlocal foldmethod=marker foldlevel=0 foldcolumn=4
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

inoremap    ¥   \
inoremap    \   ¥
cnoremap    ¥   \
cnoremap    \   ¥

" http://lsifrontend.hatenablog.com/entry/2013/10/11/052640
nmap <silent> <C-CR> yy:<C-u>TComment<CR>p
vnoremap <silent> <C-CR> :call CopyAddComment()<CR>

" http://qiita.com/akira-hamada/items/2417d0bcb563475deddb をもとに調整
function! CopyAddComment() range
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

" 自動的にディレクトリを作成する
" http://vim-users.jp/2011/02/hack202/
augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir) && (a:force ||
                    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END

" }}}
" 定型文 {{{

command! -nargs=0 -bar InsertCurrentFilepath      call s:InsertTextAtCurrent(expand('%:p:t'))
command! -nargs=0 -bar InsertCurrentFilefullpath  call s:InsertTextAtCurrent(expand('%:p'))

let g:unite_source_menu_menus = {}

let g:unite_source_menu_menus.fix = {
      \     'description'        : '定型文',
      \     'command_candidates' : [
      \         ['Current Filename Only',     'InsertCurrentFilepath'     ],
      \         ['Current Filename Fullpath', 'InsertCurrentFilefullpath' ],
      \     ]
      \ } 

" }}}
" インデント {{{

filetype indent on                " ファイルタイプごとのインデントを有効

set autoindent
set smartindent
set cindent                       " Cプログラムファイルの自動インデントを始める

vnoremap    <       <gv
vnoremap    >       >gv

" }}}
" タブ {{{

set tabstop=4                     " ファイル内の <Tab> が対応する空白の数。
set softtabstop=4                 " <Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数。
set expandtab                     " Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う。

" }}}
" バックアップ・スワップファイル {{{

set noswapfile                    " スワップファイルを作らない
set backup                        " バックアップファイルを使う
set backupdir=~/.vimbackup        " バックアップファイルをホームディレクトリに保存

" 自動ミラーリング {{{
let s:mirrorDir = expand('~/vimmirror')
let s:mirrorMaxHistory = 7
augroup auto-mirror
    autocmd!
    autocmd VimEnter    * call s:TrimMirrorDirs()
    autocmd BufWritePre * call s:MirrorCurrentFile()

    "古いミラーディレクトリを削除する 
    function! s:TrimMirrorDirs()

        let mirrorDirs = sort(split(glob(s:mirrorDir . '/*'),  '\n'))

        while len(mirrorDirs) > s:mirrorMaxHistory 
            let dir = remove(mirrorDirs, 0)
            call s:RemoveDir(dir)
        endwhile
    endfunction

    "カレントファイルをミラーリングする
    function! s:MirrorCurrentFile()

        let sourceFilepath = expand('%:p') 

        if filereadable(sourceFilepath)
            " ファイルパス作成
            let currentMirrorDir = s:mirrorDir . '/' . strftime('%Y%m%d')
            let currentPostfix   = strftime('%H%M%S')
            let filename = expand('%:p:t:r')
            let ext      = expand('%:p:t:e')
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

set incsearch                     " インクリメンタルサーチ
set ignorecase                    " 検索パターンにおいて大文字と小文字を区別しない。
set smartcase                     " 検索パターンが大文字を含んでいたらオプション 'ignorecase' を上書きする。
set nowrapscan                    " 検索をファイルの先頭へループしない

if has('migemo')
    set migemo                        " 日本語インクリメンタルサーチ
endif

" 検索時のハイライトを解除
nnoremap    <silent><Leader>/   :nohlsearch<CR>

" }}}
" 表示{{{

syntax on                         " 構文ごとに色分けをする

set number                        " 行番号表示
set shiftwidth=4                  " インデントの各段階に使われる空白の数。
set textwidth=0                   " 一行に長い文章を書いていても自動折り返しをしない
set showcmd                       " コマンドをステータス行に表示
set showmatch                     " 括弧の対応をハイライト
set wrap                          " ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
set noshowmode                    " モードを表示しない（ステータスラインで表示するため）
set shortmess+=I                  " 起動時のメッセージを表示しない
set lazyredraw                    " スクリプト実行中に画面を描画しない
set wildmenu
set wildmode=list:full            " コマンドライン補完を便利に
set wildignorecase                " 補完時に大文字小文字を区別しない
set showfulltag
set wildoptions=tagfile
set fillchars=vert:\              " 縦分割の境界線

set updatetime=1000

" 全角スペースをハイライト {{{

" http://fifnel.com/2009/04/07/2300/
if has('syntax')
    function! s:ActivateInvisibleIndicator()
        syntax match InvisibleJISX0208Space '　' display containedin=ALL
        highlight InvisibleJISX0208Space term=underline guibg=#112233 

        " if s:isGuiRunning
            syntax match InvisibleTab '\t' display containedin=ALL
            highlight InvisibleTab term=underline ctermbg=Gray guibg=#121212
        " endif
    endf

    augroup invisible
        autocmd!
        autocmd BufNew,BufRead * call s:ActivateInvisibleIndicator()
    augroup END
endif

" }}}
" カレントウィンドウにのみ罫線を引く {{{

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

    function! s:ForceShowCursolLine()
        setlocal cursorline
        let s:cursorline_lock = 1
    endfunction
augroup END

" }}}
" }}}
" 折り畳み {{{

let g:foldCCtext_enable_autofdc_adjuster = 1

set foldcolumn=0
set foldlevel=99
set foldtext=foldCC#foldtext()

nnoremap    [Folding]       <Nop>
nmap        <Leader>f   [Folding]

nnoremap <silent> [Folding]o    zR
nnoremap <silent> [Folding]c    zM

nmap <expr> <C-h> foldlevel(line('.')) > 0 ? 'zc' : '<C-h>'
nmap <expr> <C-l> foldclosed(line('.')) != -1 ? 'zo' : '<C-l>'

" 折り畳み外であれば何もしない
nnoremap <expr> zO foldclosed(line('.')) != -1 ? 'zO' : ''

" }}}
" モード移行 {{{

inoremap        <C-j>       <Esc>
nnoremap        <C-j>       <Esc>
vnoremap        <C-j>       <Esc>

" }}}
" ウィンドウ操作 {{{

set splitbelow                    " 縦分割したら新しいウィンドウは下に
set splitright                    " 横分割したら新しいウィンドウは右に

noremap  <silent> <Leader>e :<C-u>call <SID>ToggleVSplitWide()<CR>
noremap  <silent> <Leader>w :<C-u>call <SID>SmartClose()<CR>

" アプリウィンドウの移動とリサイズ
if s:isGuiRunning
    noremap         <silent>,H  :<C-u>call <SID>ResizeWin()<CR>
    noremap         <silent>,J  :<C-u>call <SID>ResizeWin()<CR>
    noremap         <silent>,K  :<C-u>call <SID>ResizeWin()<CR>
    noremap         <silent>,L  :<C-u>call <SID>ResizeWin()<CR>
    noremap         <silent>,h  :MoveWin<CR>
    noremap         <silent>,j  :MoveWin<CR>
    noremap         <silent>,k  :MoveWin<CR>
    noremap         <silent>,l  :MoveWin<CR>
    noremap         <silent>,ff :<C-u>call <SID>FullWindow()<CR>
endif

" }}}
" カーソル移動 {{{

nnoremap    <silent>k       gk
nnoremap    <silent>j       gj
vnoremap    <silent>k       gk
vnoremap    <silent>j       gj
nnoremap    <silent>0       g0
nnoremap    <silent>g0      0
nnoremap    <silent>$       g$
nnoremap    <silent>g$      $
nnoremap    <silent><C-e>   <C-e>j
nnoremap    <silent><C-y>   <C-y>k
vnoremap    <silent><C-e>   <C-e>j
vnoremap    <silent><C-y>   <C-y>k
nmap        <silent>gg      ggzOzz:<C-u>call <SID>RefreshScreen()<CR>
nmap        <silent>GG      GGzOzz:<C-u>call <SID>RefreshScreen()<CR>

nmap     <silent><Leader>h  ^
nmap     <silent><Leader>l  $
nmap     <silent><Leader>m  %

" }}}
" タブライン操作 {{{

" タブライン常時表示
set showtabline=2

nnoremap    [Tab]       <Nop>
nmap        <Leader>t   [Tab]

nnoremap <silent> [Tab]c :tabnew<CR>
nnoremap <silent> [Tab]x :tabclose<CR>

nnoremap <C-J>       :tabnext<CR>  
nnoremap <C-K>       :tabprev<CR>

for s:n in range(1, 9)
    exe 'nnoremap <silent> [Tab]' . s:n  ':<C-u>tabnext' . s:n . '<CR>'
endfor

" }}}
" バッファ操作 {{{

nnoremap    [Buffer]    <Nop>
nmap        <Leader>b   [Buffer]

nnoremap <silent>[Buffer]x  :bdelete<CR>

noremap  <Leader>j :bnext<CR>
noremap  <Leader>k :bprev<CR>

for s:n in range(1, 9)
    exe 'nnoremap <silent> [Buffer]' . s:n  ':<C-u>b' . s:n . '<CR>'
endfor

" }}}
" ファイル操作 {{{

" vimrc / gvimrc の編集 
nnoremap    <silent><F1>    :<C-u>call <SID>SmartOpen($MYVIMRC)<CR>
nnoremap    <silent><F2>    :<C-u>call <SID>SmartOpen($MYGVIMRC)<CR>
nnoremap    <silent><F3>    :<C-u>source $MYVIMRC<CR>:source $MYGVIMRC<CR>

" }}}
" ヘルプ {{{

set helplang=ja,en

nnoremap    K   :<C-u>help 
nnoremap    KK  :<C-u>help <C-r><C-w><CR>

" }}}
" 汎用関数 {{{
" SID取得 {{{
function! s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfunction
" }}}
" アプリケーションウィンドウサイズの変更 {{{
function! s:ResizeWin()

    let d1 = 1
    let d2 = 1

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
    let &columns = g:baseColumns * s:depthVsp
    exe 'botright vertical' g:baseColumns 'split'
endf

function! s:CloseVSplitWide()

    let s:depthVsp -= 1
    let &columns = g:baseColumns * s:depthVsp
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
" ウィンドウが１つかつバッファが一つかつ&columns が g:baseColumns            :quit
" ウィンドウが１つかつバッファが一つかつ&columns が g:baseColumnsでない      &columns = g:baseColumns
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
        if  &columns == g:baseColumns
            if isCurrentBufferModified == 0
                quit
            elseif confirm('未保存です。閉じますか？', "&Yes\n&No", 1, 'Question') == 1
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
" ファイルの場所をカレントにする{{{
function! s:SetCurrentDir()

    if &ft != '' && &ft != 'vimfiler'
        exe 'lcd'  fnameescape(expand('%:p:h'))
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
        throw 'Not supported. 
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
            throw 'Not supported.' 
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
" }}}
" コンソール用 {{{

if !s:isGuiRunning
    source $MYGVIMRC 
endif

" }}}
