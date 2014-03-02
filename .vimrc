set nocompatible
scriptencoding utf-8

" 基本 {{{
set encoding=utf-8

let s:isWindows    = has('win32') || has('win64')
let s:isMac        = has('mac')
let s:isGuiRunning = has('gui_running')
let s:baseColumns  = s:isWindows ? 140 : 120
let s:vimrc_local  = expand('~/.vimrc_local')
let g:mapleader    = ','
let $DOTVIM        = s:isWindows ? expand('~/vimfiles') : expand('~/.vim')
set viminfo+=!

nnoremap    [App]    <Nop>
nmap        ;        [App]

if !s:isGuiRunning
    let $MYGVIMRC = expand('~/.gvimrc')
endif

let s:rightWindowWidth = 40     " 右ウィンドウ幅

if filereadable(s:vimrc_local)
    exe 'source' s:vimrc_local
endif
" golang {{{
set rtp+=/usr/local/Cellar/go/1.2/libexec/misc/vim
exe "set rtp+=" . globpath($GOPATH, "src/github.com/nsf/gocode/vim")
exe "set rtp+=" . globpath($GOPATH, "src/github.com/golang/lint/misc/vim")
" }}}
" NeoBundle {{{
if has('vim_starting')
    if !isdirectory(expand("$DOTVIM/bundle/neobundle.vim/"))
        echo "install neobundle..."
        call system("git clone git://github.com/Shougo/neobundle.vim $DOTVIM/bundle/neobundle.vim")
    endif

    set rtp+=$DOTVIM/bundle/neobundle.vim/
endif

call neobundle#rc(expand('$DOTVIM/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
" }}}
" }}}
" プラグイン {{{
" 表示 {{{
" インストール {{{
NeoBundle 'tomasr/molokai'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'Yggdroot/indentLine'

NeoBundleLazy 'majutsushi/tagbar', {
            \   'autoload': {
            \       'commands': [ 'TagbarToggle' ]
            \   }
            \ }

NeoBundleLazy 'LeafCage/foldCC', {
            \   'autoload': {
            \       'filetypes': [ 'vim' ]
            \   }
            \ }
" }}}
" TagBar {{{
noremap   <silent><F8>    :<C-u>call <SID>ToggleTagBar()<CR>

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
            \       'left':  [ [ 'mode', 'paste' ],
            \                  [ 'fugitive', 'filename', 'anzu'] ],
            \       'right': [ [ 'lineinfo' ],
            \                  [ 'percent' ],
            \                  [ 'charcode', 'fileformat', 'fileencoding', 'filetype' ] ]
            \   },
            \   'component': {
            \       'lineinfo': s:lightline_symbol_line . '%4l/%L : %-3v',
            \   },
            \   'component_function': {
            \       'modified':          'MyModified',
            \       'readonly':          'MyReadonly',
            \       'fugitive':          'MyFugitive',
            \       'filename':          'MyFilename',
            \       'fileformat':        'MyFileformat',
            \       'filetype':          'MyFiletype',
            \       'fileencoding':      'MyFileencoding',
            \       'mode':              'MyMode',
            \       'charcode':          'MyCharCode',
            \       'currentworkingdir': 'MyCurrentWorkingDir',
            \       'anzu':              'anzu#search_status',
            \    },
            \   'separator': {
            \       'left':  s:lightline_symbol_separator_left,
            \       'right': s:lightline_symbol_separator_right
            \   },
            \   'subseparator': {
            \       'left':  s:lightline_symbol_subseparator_left,
            \       'right': s:lightline_symbol_subseparator_right
            \   },
            \   'tabline': {
            \       'left':  [ [ 'tabs' ] ],
            \       'right': [ [ ] ],
            \   },
            \   'tabline_separator': {
            \       'left':  s:lightline_symbol_separator_left,
            \       'right': s:lightline_symbol_separator_right
            \   },
            \   'tabline_subseparator': {
            \       'left':  s:lightline_symbol_subseparator_left,
            \       'right': s:lightline_symbol_subseparator_right
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
    if &ft !~? 'vimfiler\|gundo'
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
" indentLine {{{
let g:indentLine_fileType   = ['c', 'cpp', 'cs', 'vim', 'rb', 'go', 'glsl', 'hlsl', 'xml', 'json']
let g:indentLine_color_gui  = '#383838'
let g:indentLine_color_term = 239
" }}}
" }}}
" 編集 {{{
" インストール {{{
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'

NeoBundleLazy 'LeafCage/yankround.vim', {
            \   'autoload': {
            \       'mappings': [ '<Plug>(yankround-' ],
            \   }
            \ }

NeoBundleLazy 'kana/vim-smartinput', {
            \   'autoload': {
            \       'insert': 1,
            \   }
            \ }

NeoBundleLazy 'cohama/vim-smartinput-endwise', {
            \   'autoload': {
            \       'insert': 1,
            \   }
            \ }

NeoBundleLazy 'nishigori/increment-activator', {
            \   'autoload': {
            \       'mappings': [
            \           '<C-x>',
            \           '<C-a>',
            \       ]
            \   }
            \ }

NeoBundleLazy 'thinca/vim-qfreplace', {
            \   'autoload': {
            \       'filetypes': ['unite', 'quickfix'],
            \       'commands':  ['Qfreplace']
            \   }
            \ }

NeoBundleLazy 'junegunn/vim-easy-align', {
            \   'autoload': {
            \     'commands': [ 'EasyAlign', 'LiveEasyAlign' ],
            \     'mappings': [
            \       '<Plug>(EasyAlignOperator)',
            \       ['sxn', '<Plug>(EasyAlign)'],
            \       ['sxn', '<Plug>(LiveEasyAlign)'],
            \       ['sxn', '<Plug>(EasyAlignRepeat)']
            \     ]
            \   }
            \ }
" }}}
" vim-easy-align {{{
nmap <Leader>m <Plug>(EasyAlign)
vmap <Leader>m <Plug>(EasyAlign)

nmap <silent><Leader>a=       vii<Leader>m=
nmap <silent><Leader>a:       vii<Leader>m:
nmap <silent><Leader>a,       vii<Leader>m*,
nmap <silent><Leader>a<Space> vii<Leader>m*<Space>
xmap <silent><Leader>a=       <Leader>m=
xmap <silent><Leader>a:       <Leader>m:
xmap <silent><Leader>a,       <Leader>m*,
xmap <silent><Leader>a<Space> <Leader>m*<Space>

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
nmap P     <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
" }}}
" increment-activator {{{
let g:increment_activator_filetype_candidates =
            \ {
            \   '_': [
            \     ['width', 'height'],
            \   ],
            \   'cs': [
            \     ['private', 'protected', 'public', 'internal'],
            \   ],
            \   'cpp': [
            \     ['private', 'protected', 'public'],
            \   ],
            \ }

" }}}
" vim-over {{{
noremap <silent> <Leader>s :OverCommandLine<CR>

let g:over_command_line_key_mappings = {
            \   "\<C-j>" : "\<Esc>",
            \}
" }}}
" }}}
" 補完 {{{
" インストール {{{
NeoBundleLazy 'Shougo/neocomplete.vim', {
            \   'autoload': {
            \       'insert': 1,
            \   }
            \ }

NeoBundleLazy 'honza/vim-snippets'

NeoBundleLazy 'Shougo/neosnippet', {
            \   'depends': [ 'honza/vim-snippets' ],
            \   'autoload': {
            \       'insert': 1,
            \   }
            \ }

NeoBundleLazy "Shougo/neosnippet-snippets", {
            \   'depends': [ 'honza/vim-snippets' ],
            \   'autoload': {
            \       'insert': 1,
            \   }
            \ }

NeoBundleLazy 'nosami/Omnisharp', {
            \   'depends': [ 'Shougo/neocomplete.vim' ],
            \   'autoload': {
            \       'filetypes': [ 'cs' ]
            \   },
            \   'build': {
            \       'windows': 'C:/Windows/Microsoft.NET/Framework/v4.0.30319/MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
            \       'mac':     'xbuild server/OmniSharp.sln',
            \       'unix':    'xbuild server/OmniSharp.sln',
            \   }
            \ }
" }}}
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

    if !exists('g:neocomplete#sources#dictionary#dictionaries')
        let g:neocomplete#sources#dictionary#dictionaries = {}
    endif
    let g:neocomplete#sources#dictionary#dictionaries.default  = ''
    let g:neocomplete#sources#dictionary#dictionaries.vimshell = $HOME . '/.vimshell_hist'

    if !exists('g:neocomplete#sources#vim#complete_functions')
        let g:neocomplete#sources#vim#complete_functions = {}
    endif
    let g:neocomplete#sources#vim#complete_functions.Unite               = 'unite#complete_source'
    let g:neocomplete#sources#vim#complete_functions.VimShellExecute     = 'vimshell#vimshell_execute_complete'
    let g:neocomplete#sources#vim#complete_functions.VimShellInteractive = 'vimshell#vimshell_execute_complete'
    let g:neocomplete#sources#vim#complete_functions.VimShellTerminal    = 'vimshell#vimshell_execute_complete'
    let g:neocomplete#sources#vim#complete_functions.VimShell            = 'vimshell#complete'
    let g:neocomplete#sources#vim#complete_functions.VimFiler            = 'vimfiler#complete'

    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    " 日本語は収集しない
    let g:neocomplete#keyword_patterns._ = '\h\w*'

    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.c    = '\%(\.\|->\)\h\w*'
    let g:neocomplete#sources#omni#input_patterns.cpp  = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.cs   = '[a-zA-Z0-9.]\{2\}'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_omni_input_patterns.c      = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.cpp    = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.objc   = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.cs     = '[^.[:digit:] *\t]\%(\.\)\w*\|\h\w*::\w*'

    if !exists('g:neocomplete#delimiter_patterns')
        let g:neocomplete#delimiter_patterns = {}
    endif
    let g:neocomplete#delimiter_patterns.c   = ['.', '->']
    let g:neocomplete#delimiter_patterns.cpp = [' ::', '.']
    let g:neocomplete#delimiter_patterns.cs  = ['.']
    let g:neocomplete#delimiter_patterns.vim = ['#', '.']

    if !exists('g:neocomplete#sources#file_include#exts')
        let g:neocomplete#sources#file_include#exts = {}
    endif
    let g:neocomplete#sources#file_include#exts.c   = ['', 'h']
    let g:neocomplete#sources#file_include#exts.cpp = ['', 'h', 'hpp', 'hxx']
    let g:neocomplete#sources#file_include#exts.cs  = ['', 'Designer.cs']
endfunction
unlet s:bundle

" }}}
" neosnippet {{{
let s:bundle = neobundle#get('neosnippet')
function! s:bundle.hooks.on_source(bundle)

    let g:neosnippet#enable_snipmate_compatibility = 1
    let g:neosnippet#snippets_directory            = '$DOTVIM/bundle/vim-snippets/snippets,$DOTVIM/snippets'

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
" 検索 {{{
" インストール {{{
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'matchit.zip'
NeoBundle 'vimtaku/hl_matchit.vim'

NeoBundleLazy 'rhysd/clever-f.vim', {
            \   'autoload': {
            \       'mappings': 'f',
            \   }
            \ }

NeoBundleLazy 'Lokaltog/vim-easymotion', {
            \   'autoload': {
            \       'mappings': [
            \           '<Plug>(easymotion-',
            \       ]
            \   }
            \ }

NeoBundleLazy 'thinca/vim-visualstar', {
            \   'autoload': {
            \       'mappings': [ '<Plug>(visualstar-' ]
            \   }
            \ }

NeoBundleLazy 'osyo-manga/vim-over', 
            \ {
            \   "autoload": {
            \     "commands": ["OverCommandLineNoremap", "OverCommandLine"]
            \   }
            \ }

NeoBundleLazy 'deris/parajump', {
            \   'autoload': {
            \     'mappings': [
            \       ['sxno', '<Plug>(parajump-']
            \     ]
            \   }
            \ }
" }}}
" clever-f.vim {{{
let g:clever_f_ignore_case           = 1
let g:clever_f_smart_case            = 1
let g:clever_f_across_no_line        = 1
let g:clever_f_use_migemo            = 1
let g:clever_f_chars_match_any_signs = ';'
" }}}
" machit{{{
let s:bundle = neobundle#get('matchit.zip')
function! s:bundle.hooks.on_source(bundle)

    silent! execute 'doautocmd Filetype' &filetype

endfunction
unlet s:bundle
" }}}
" hl_matchit.vim {{{
let g:hl_matchit_enable_on_vim_startup = 1
let g:hl_matchit_hl_groupname          = 'MatchParen'
" }}}
" vim-visualstar {{{
map *  <Plug>(visualstar-*)
map #  <Plug>(visualstar-#)
map g* <Plug>(visualstar-g*)
map g# <Plug>(visualstar-g#)
" }}}
" vim-easymotion {{{
" http://haya14busa.com/vim-lazymotion-on-speed/
let g:EasyMotion_leader_key          = '<Leader>'
let g:EasyMotion_keys                = 'hlasdyuiopqwertnmzxcvbgfkj'
let g:EasyMotion_special_select_line = 0
let g:EasyMotion_select_phrase       = 1
let g:EasyMotion_smartcase           = 1
let g:EasyMotion_startofline         = 1
" let g:EasyMotion_use_migemo          = 1

nmap r    <Plug>(easymotion-s)
vmap r    <Plug>(easymotion-s)
omap r    <Plug>(easymotion-s)
" }}}
" vim-anzu {{{
" http://qiita.com/shiena/items/f53959d62085b7980cb5
nmap <silent> n <Plug>(anzu-n)zOzz:call <SID>BeginDisplayAnzu()<CR>:<C-u>call <SID>RefreshScreen()<CR>
nmap <silent> N <Plug>(anzu-N)zOzz:call <SID>BeginDisplayAnzu()<CR>:<C-u>call <SID>RefreshScreen()<CR>
nmap <silent> * <Plug>(anzu-star):<C-u>call <SID>RefreshScreen()<CR>
nmap <silent> # <Plug>(anzu-sharp):<C-u>call <SID>RefreshScreen()<CR>

let s:bundle = neobundle#get('vim-anzu')
function! s:bundle.hooks.on_source(bundle)

    augroup vim-anzu
        " 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
        " 検索ヒット数の表示を消去する
        autocmd!
        autocmd CursorHold,CursorHoldI * call s:UpdateDisplayAnzu()
        autocmd WinLeave,TabLeave      * call s:ClearDisplayAnzu()

        " anzuを表示する時間
        let s:anzuDisplayTime = 1000

        let s:anzuDisplayCount = 0
        function! s:BeginDisplayAnzu()
            let s:anzuDisplayCount = s:anzuDisplayTime / &updatetime
        endfunction

        function! s:UpdateDisplayAnzu()
            if s:anzuDisplayCount >= 0
                let s:anzuDisplayCount -= 1
                call s:ContinueCursorHold()
            else
                call s:ClearDisplayAnzu()
            endif
        endfunction

        function! s:ClearDisplayAnzu()
            let s:anzuDisplayCount = 0
            call anzu#clear_search_status()
        endfunction
    augroup END
endfunction
unlet s:bundle
" }}}
" parajump {{{
map { <Plug>(parajump-backward)
map } <Plug>(parajump-forward)
" }}}
" }}}
" 言語 {{{
" インストール {{{
NeoBundleLazy 'vim-jp/cpp-vim', {
            \   'autoload': {
            \       'filetypes': [ 'cpp' ]
            \   }
            \ }

NeoBundleLazy 'Mizuchi/STL-Syntax', {
            \   'autoload': {
            \       'filetypes': [ 'cpp' ]
            \   }
            \ }

NeoBundleLazy 'beyondmarc/hlsl.vim', {
            \   'autoload': {
            \       'filetypes': [ 'hlsl' ]
            \   }
            \ }

NeoBundleLazy 'tikhomirov/vim-glsl', {
            \   'autoload': {
            \       'filetypes': [ 'glsl' ]
            \   }
            \ }

NeoBundleLazy 'Rip-Rip/clang_complete', {
            \   'autoload': {
            \       'filetypes': [ 'c', 'cpp', 'objc' ]
            \   }
            \ }

NeoBundleLazy 'rhysd/vim-clang-format', {
            \   'depends' : 'kana/vim-operator-user',
            \   'autoload': {
            \       'filetypes': [ 'c', 'cpp', 'objc' ]
            \   }
            \ }

NeoBundleLazy 'vim-ruby/vim-ruby', {
            \   'autoload': {
            \       'filetypes': [ 'rb' ]
            \   }
            \ }

NeoBundleLazy 'vim-scripts/JSON.vim', {
            \   'autoload': {
            \       'filetypes': [ 'json' ]
            \   }
            \ }

NeoBundleLazy 'rhysd/wandbox-vim', {
            \   "autoload": {
            \     "commands": [
            \       {
            \         "name":     "WandboxAsync",
            \         "complete": "customlist,wandbox#complete_command"
            \       },
            \       {
            \         "name":     "WandboxSync",
            \         "complete": "customlist,wandbox#complete_command"
            \       },
            \       {
            \         "name":     "Wandbox",
            \         "complete": "customlist,wandbox#complete_command"
            \       },
            \       "WandboxOptionList",
            \       "WandboxOpenBrowser",
            \       "WandboxOptionListAsync",
            \       "WandboxAbortAsyncWorks"
            \     ]
            \   }
            \ }

NeoBundleLazy 'thinca/vim-quickrun', {
            \   'depends' : [
            \       'osyo-manga/shabadou.vim',
            \       'rhysd/wandbox-vim'
            \    ],
            \    'autoload': {
            \        'mappings': [['sxn', '<Plug>(quickrun']],
            \        'commands': [{'complete': 'customlist,quickrun#complete', 'name': 'QuickRun'}]
            \    }
            \ }

NeoBundleLazy 'osyo-manga/shabadou.vim', {}
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
                \ 'AccessModifierOffset':                -4,
                \ 'ColumnLimit':                         120,
                \ 'AllowShortIfStatementsOnASingleLine': 'true',
                \ 'AlwaysBreakTemplateDeclarations':     'true',
                \ 'Standard':                            'C++11',
                \ 'BreakBeforeBraces':                   'Stroustrup',
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
map <silent>[App]r    :<C-u>QuickRun<CR>

let s:bundle = neobundle#get('vim-quickrun')
function! s:bundle.hooks.on_source(bundle)

    " http://d.hatena.ne.jp/osyo-manga/20120919/1348054752
    let g:quickrun_config = {
                \   '_': {
                \       'hook/close_unite_quickfix/enable_hook_loaded': 1,
                \       'hook/unite_quickfix/enable_failure':           1,
                \       'hook/close_quickfix/enable_exit':              1,
                \       'hook/close_buffer/enable_failure':             1,
                \       'hook/close_buffer/enable_empty_data':          1,
                \       'outputter':                                    'multi:buffer:quickfix',
                \       'outputter/buffer/split':                       ':botright 16sp',
                \       'runner':                                       'vimproc',
                \       'runner/vimproc/updatetime':                    40,
                \   },
                \   'cpp': {
                \       'runner':                                       'wandbox',
                \       'runner/wandbox/compiler':                      'clang-head',
                \       'runner/wandbox/options':                       'warning,c++1y,boost-1.55',
                \   },
                \   'json': {
                \       'command':                                      'jq',
                \       'exec':                                         "%c '.' %s"
                \   },
                \ }
endfunction
unlet s:bundle
" }}}
" }}}
" テキストオブジェクト {{{
" http://d.hatena.ne.jp/osyo-manga/20130717/1374069987
" インストール {{{
NeoBundleLazy 'kana/vim-textobj-user'

NeoBundleLazy 'kana/vim-textobj-entire', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'ae'], ['xo', 'ie']]
            \   }
            \ }

NeoBundleLazy 'kana/vim-textobj-indent', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']]
            \   }
            \ }

NeoBundleLazy 'kana/vim-textobj-fold', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'az'], ['xo', 'iz']]
            \   }
            \ }

NeoBundleLazy 'kana/vim-textobj-line', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'al'], ['xo', 'il']]
            \   }
            \ }

NeoBundleLazy 'rhysd/vim-textobj-word-column', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'av'], ['xo', 'aV'], ['xo', 'iv'], ['xo', 'iV']]
            \   }
            \ }

NeoBundleLazy 'thinca/vim-textobj-comment', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'ac'], ['xo', 'ic']]
            \   }
            \ }

NeoBundleLazy 'sgur/vim-textobj-parameter', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', '<Plug>(textobj-parameter']]
            \   }
            \ }
xmap aa <Plug>(textobj-parameter-a)
xmap ia <Plug>(textobj-parameter-i)
omap aa <Plug>(textobj-parameter-a)
omap ia <Plug>(textobj-parameter-i)

NeoBundleLazy 'rhysd/vim-textobj-anyblock', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'ab'], ['xo', 'ib']]
            \   }
            \ }

NeoBundleLazy 'anyakichi/vim-textobj-ifdef', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'a#'], ['xo', 'i#']]
            \   }
            \ }

NeoBundleLazy 'thinca/vim-textobj-between', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', 'af'], ['xo', 'if']]
            \   }
            \ }

NeoBundleLazy 'h1mesuke/textobj-wiw', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \       'mappings': [['xo', '<Plug>(textobj-wiw']]
            \   }
            \ }
xmap a. <Plug>(textobj-wiw-a)
xmap i. <Plug>(textobj-wiw-i)
omap a. <Plug>(textobj-wiw-a)
omap i. <Plug>(textobj-wiw-i)

NeoBundleLazy 'osyo-manga/vim-operator-jump_side', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload': {
            \     'mappings': [
            \       '<Plug>(operator-jump-head)',
            \       '<Plug>(operator-jump-tail)',
            \     ],
            \   }
            \ }
" map <expr> <Leader><Leader> <SID>GetOnBraceChar() == 1 ?
"             \    '<Plug>(operator-jump-tail)ab:<C-u>call <SID>RefreshScreen()<CR>' :
"             \    '<Plug>(operator-jump-head)ab:<C-u>call <SID>RefreshScreen()<CR>'
map  <Leader><Leader> <Plug>(operator-jump-head)ai:<C-u>call <SID>RefreshScreen()<CR>

" }}}
" }}}
" オペレータ {{{
" http://qiita.com/rbtnn/items/a47ed6684f1f0bc52906
" インストール {{{
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace',  {'depends': 'kana/vim-operator-user', 'autoload': {'mappings': [['nx', '<Plug>(operator-replace)']]}}
NeoBundleLazy 'tyru/operator-camelize.vim', {'depends': 'kana/vim-operator-user', 'autoload': {'mappings': [['nx', '<Plug>(operator-camelize-toggle)']]}}
NeoBundleLazy 'emonkak/vim-operator-sort',  {'depends': 'kana/vim-operator-user', 'autoload': {'mappings': [['nx', '<Plug>(operator-sort']]}}
NeoBundleLazy 'deris/vim-rengbang',         {'depends': 'kana/vim-operator-user', 'autoload': {'mappings': [['nx', '<Plug>(operator-rengbang']], 'commands': ['RengBang']}}
" }}}
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
" }}}
" アプリ {{{
" インストール {{{
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
            \       'commands': [ 'LingrLaunch' ]
            \   }
            \ }

NeoBundleLazy 'mattn/benchvimrc-vim', {
            \   'autoload': {
            \       'commands': [ 'BenchVimrc' ]
            \   }
            \ }

NeoBundleLazy 'Shougo/vimfiler', {
            \   'depends': [ 'Shougo/unite.vim', 'Shougo/vimshell.vim' ],
            \   'autoload': {
            \       'commands': [ 'VimFilerBufferDir' ]
            \   }
            \ }

NeoBundleLazy 'Shougo/vimshell.vim', {
            \   'autoload': {
            \       'commands': [ 'VimShell', 'VimShellPop' ]
            \   }
            \ }

NeoBundleLazy 'basyura/TweetVim', {
            \   'depends': [
            \       'basyura/twibill.vim',
            \       'tyru/open-browser.vim',
            \       'mattn/webapi-vim',
            \   ],
            \   'autoload': {
            \       'commands': [ 'TweetVimHomeTimeline', 'TweetVimUserStream' ]
            \   }
            \ }

NeoBundleLazy 'tpope/vim-fugitive', {
            \   'autoload': {
            \       'function_prefix': 'fugitive'
            \   }
            \ }

NeoBundleLazy 'mattn/gist-vim', {
            \   'depends': [
            \       'mattn/webapi-vim',
            \   ],
            \   'autoload': {
            \       'commands': [ 'Gist' ]
            \   }
            \ }

NeoBundleLazy 'ynkdir/vim-vimlparser', {}

NeoBundleLazy 'syngan/vim-vimlint', {
            \   'depends': 'ynkdir/vim-vimlparser',
            \   'autoload': {
            \        'functions': 'vimlint#vimlint'
            \   }
            \ }

if s:isMac
    NeoBundleLazy 'itchyny/dictionary.vim', {
                \   'autoload': {
                \       'commands': [ 'Dictionary' ]
                \   }
                \ }
endif
" }}}
" lingr.vim {{{
noremap <silent>[App]s :<C-u>VimShellPop<CR>
" }}}
" VimFiler {{{
noremap  <silent>[App]f :VimFilerBufferDir<CR>

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
        nmap <buffer><expr> J vimfiler#smart_cursor_map(
            \  "\<Plug>(easymotion-j)",
            \  "\<Plug>(easymotion-j)")
        nmap <buffer><expr> K vimfiler#smart_cursor_map(
            \  "\<Plug>(easymotion-k)",
            \  "\<Plug>(easymotion-k)")
    endfunction

    let g:vimfiler_as_default_explorer = 1
endfunction
unlet s:bundle
" }}}
" lingr.vim {{{
noremap <silent>[App]l :<C-u>call <SID>ToggleLingr()<CR>

let s:bundle = neobundle#get('lingr-vim')
function! s:bundle.hooks.on_source(bundle)

    let g:lingr_vim_say_buffer_height = 15

    augroup lingr-vim
        autocmd!
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
noremap <silent>[App]t :<C-u>call <SID>ToggleTweetVim()<CR>

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

    augroup TweetVimSetting
        autocmd!
        autocmd FileType tweetvim     call s:SetTweetVim()

        function! s:SetTweetVim()
            nmap     <silent><buffer>         rr <Plug>(tweetvim_action_reload)
            nnoremap <silent><buffer> q  :<C-u>call <SID>ToggleTweetVim()<CR>
        endfunction
    augroup END
endfunction
unlet s:bundle
" }}}
" vimlint {{{
command! VimLint call vimlint#vimlint(expand('%:p'))
" }}}
" }}}
" Unite {{{
" インストール {{{
NeoBundleLazy 'Shougo/unite.vim', {
            \   'autoload': {
            \       'commands': [ 'Unite', 'UniteResume', 'UniteWithCursorWord' ]
            \   }
            \ }

NeoBundleLazy 'Shougo/unite-outline', {
            \   'autoload': {
            \       'unite_sources': [ 'outline' ],
            \   }
            \ }

NeoBundleLazy 'osyo-manga/unite-fold', {
            \   'autoload': {
            \       'unite_sources': [ 'fold' ],
            \   }
            \ }

NeoBundleLazy 'tsukkee/unite-tag', {
            \   'autoload': {
            \       'unite_sources': [ 'tag' ],
            \   }
            \ }

NeoBundleLazy 'osyo-manga/unite-quickfix', {
            \   'autoload': {
            \       'unite_sources': [ 'quickfix' ],
            \   }
            \ }

NeoBundle 'Shougo/neomru.vim'
" }}}

nnoremap [Unite] <nop>
xnoremap [Unite] <nop>
nmap     <Space> [Unite]
xmap     <Space> [Unite]

nnoremap <silent> [Unite]g   :<C-u>Unite               grep -auto-preview -no-split -buffer-name=search-buffer<CR>
nnoremap <silent> [Unite]cg  :<C-u>UniteWithCursorWord grep -auto-preview -no-split -buffer-name=search-buffer<CR>

nnoremap <silent> [Unite]pg  :<C-u>call <SID>unite_grep_project('-auto-preview -no-split -buffer-name=search-buffer')<CR>
nnoremap <silent> [Unite]cpg :<C-u>call <SID>unite_grep_project('-auto-preview -no-split -buffer-name=search-buffer')<CR><C-R><C-W><CR>
nnoremap <silent> [Unite]r   :<C-u>UniteResume -no-split search-buffer<CR>

nnoremap <silent> [Unite]m   :<C-u>Unite -no-split neomru/file<CR>
nnoremap <silent> [Unite]f   :<C-u>Unite -no-split file<CR>
nnoremap <silent> [Unite]b   :<C-u>Unite -no-split buffer<CR>
nnoremap <silent> [Unite]t   :<C-u>Unite -no-split tab<CR>
nnoremap <silent> [Unite]l   :<C-u>Unite -no-split line<CR>
nnoremap <silent> [Unite]o   :<C-u>Unite -no-split outline<CR>
nnoremap <silent> [Unite]z   :<C-u>Unite -no-split fold<CR>
nnoremap <silent> [Unite]q   :<C-u>Unite -no-quit -horizontal quickfix<CR>

nnoremap          [Unite]uu  :<C-u>NeoBundleUpdate<CR>:NeoBundleUpdatesLog<CR>
nnoremap          [Unite]ui  :<C-u>NeoBundleInstall<CR>:NeoBundleUpdatesLog<CR>

" http://sanrinsha.lolipop.jp/blog/2013/03/%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E5%86%85%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92unite-grep%E3%81%99%E3%82%8B.html
function! s:unite_grep_project(...)
    let opts = (a:0 ? join(a:000, ' ') : '')
    let dir = unite#util#path2project_directory(expand('%'))
    execute 'Unite' opts 'grep:' . dir
endfunction

let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)

    " let g:unite_winwidth = s:rightWindowWidth

    let g:unite_enable_split_vertically         = 1
    let g:unite_split_rule                      = 'rightbelow'

    " insert modeで開始
    let g:unite_enable_start_insert             = 1

    let g:neomru#update_interval                = 60
    let g:neomru#file_mru_limit                 = 500

    " call unite#custom#source('fold,neomru/file', 'matchers', 'matcher_migemo')
    call unite#custom#source('fold', 'matchers', 'matcher_migemo')

    " http://blog.monochromegane.com/blog/2014/01/16/the-platinum-searcher/
    if executable('pt')
        let g:unite_source_grep_command       = 'pt'
        let g:unite_source_grep_default_opts  = '--nogroup --nocolor -S'
        let g:unite_source_grep_recursive_opt = ''
    endif
endfunction
unlet s:bundle
" }}}
" その他 {{{
" インストール {{{
NeoBundleLazy 'Shougo/vimproc', {
            \   'autoload': {
            \       'function_prefix': 'vimproc',
            \   },
            \   'build': {
            \       'windows': 'make -f make_mingw32.mak',
            \       'cygwin':  'make -f make_cygwin.mak',
            \       'mac':     'make -f make_mac.mak',
            \       'unix':    'make -f make_unix.mak',
            \   },
            \ }

NeoBundleLazy 'mattn/webapi-vim', {
            \   'autoload': {
            \       'function_prefix': 'webapi'
            \   }
            \ }

NeoBundleLazy 'open-browser.vim', {
            \   'autoload': {
            \       'mappings':        ['<Plug>(open-browser-wwwsearch)', '<Plug>(openbrowser-open)'],
            \       'function_prefix': 'openbrowser',
            \       'commands':        ['OpenBrowserSearch', 'OpenBrowser', 'OpenBrowserSmartSearch']
            \   }
            \ }

NeoBundleLazy 'movewin.vim', {
            \   'autoload': {
            \       'commands': [ 'MoveWin' ]
            \   }
            \ }

if s:isWindows
    NeoBundle 'YoshihiroIto/vim-icondrag'
endif
" }}}
" icondrag {{{
let g:icondrag_auto_start = 1
" }}}
" NeoBundleLazy したプラグインをフォーカスが外れている時に自動的に読み込む {{{
" http://d.hatena.ne.jp/osyo-manga/20140212

" Lazy しているプラグイン名をリストアップ
function! s:get_lazy_plugins()
    " 先に source したいプラグインをリストの先頭に追加する
    return [
\       "unite.vim",
\       "vimfiler.vim",
\   ] + map(filter(neobundle#config#get_neobundles(), "v:val.lazy"), "v:val.name")
endfunction

function! s:is_not_sourced(source)
    return neobundle#config#is_installed(a:source) && !neobundle#config#is_sourced(a:source)
endfunction

function! s:source()
    let sources = map(filter(s:get_lazy_plugins(), "s:is_not_sourced(v:val)"), "v:val")

    for s in sources
        echom "source:" . s
        call neobundle#source(s)
        " echom "sourced:" . s
    endfor

    augroup auto-source
        autocmd!
    augroup END

    echom ""
endfunction

augroup auto-source
    autocmd!
    autocmd FocusLost * call s:source()
augroup END

" }}}
" }}}
" }}}
" キー無効 {{{
" Vimっぽさ矯正
nnoremap    <Up>        <Nop>
nnoremap    <Down>      <Nop>
nnoremap    <Left>      <Nop>
nnoremap    <Right>     <Nop>

vnoremap    <Up>        <Nop>
vnoremap    <Down>      <Nop>
vnoremap    <Left>      <Nop>
vnoremap    <Right>     <Nop>

" todo:日本語入力がおかしくなる
" cnoremap  <Up>        <Nop>
" cnoremap  <Down>      <Nop>
" cnoremap  <Left>      <Nop>
" cnoremap  <Right>     <Nop>
" inoremap  <Up>        <Nop>
" inoremap  <Down>      <Nop>
" inoremap  <Left>      <Nop>
" inoremap  <Right>     <Nop>
" inoremap  <BS>        <Nop>
" cnoremap  <BS>        <Nop>

" Vimを閉じない
nnoremap    ZZ          <Nop>
nnoremap    ZQ          <Nop>

" ミス操作で削除してしまうため
nnoremap    dh          <nop>
nnoremap    dj          <nop>
nnoremap    dk          <nop>
nnoremap    dl          <nop>

" よくミスるため
vnoremap    u           <nop>
onoremap    u           <nop>
" }}}
" ファイルタイプごとの設定 {{{
filetype on                       " ファイルタイプごとの処理を有効
filetype plugin on                " ファイルタイプごとのプラグインを有効
filetype indent on                " ファイルタイプごとのインデントを有効

augroup file-setting
    autocmd!
    autocmd BufEnter            *                   call s:SetCurrentDir()
    autocmd BufNewFile,BufRead  *.xaml              setf xml
    autocmd BufNewFile,BufRead  *.{fx,fxc,fxh,hlsl} setf hlsl
    autocmd BufNewFile,BufRead  *.{fsh,vsh}         setf glsl

    autocmd FileType *     setlocal formatoptions-=ro " コメント補完しない
    autocmd FileType ruby  setlocal foldmethod=syntax tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType vim   setlocal foldmethod=marker foldlevel=0 foldcolumn=4
    autocmd FileType qf    call     s:SetQuickFix()
    autocmd FileType help  call     s:SetHelp()
    autocmd FileType unite call     s:SetUnite()
    autocmd FileType cs    call     s:SetCs()
    autocmd FileType c,cpp call     s:SetCpp()

    " Hack #22: XMLの閉じタグを補完する
    " http://vim-users.jp/2009/06/hack22/
    autocmd FileType xml,html  inoremap <buffer> </ </<C-x><C-o>

    function! s:SetCpp()
        setlocal foldmethod=syntax

        map <silent><buffer><Leader>x <Plug>(operator-clang-format)
    endfunction

    function! s:SetCs()
        setlocal omnifunc=OmniSharp#Complete
        setlocal foldmethod=syntax

        nnoremap <buffer><F12>      :<C-u>OmniSharpGotoDefinition<CR>zz
        nnoremap <buffer><S-F12>    :<C-u>OmniSharpFindUsages<CR>
    endfunction

    function! s:SetUnite()
        let unite = unite#get_current_unite()
        if unite.buffer_name =~# '^search'
            nmap <silent><buffer><expr> <C-r>     unite#do_action('replace')
            imap <silent><buffer><expr> <C-r>     unite#do_action('replace')
        endif

        nmap <buffer> <C-v>     <Plug>(unite_toggle_auto_preview)
        imap <buffer> <C-v>     <Plug>(unite_toggle_auto_preview)
        nmap <buffer> <C-j>     <Plug>(unite_exit)
    endfunction

    function! s:SetHelp()
        noremap  <silent><buffer> q     :<C-u>close<CR>
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
" set completeopt=longest,menuone,preview
set completeopt=longest,menuone

inoremap    ¥   \
inoremap    \   ¥
cnoremap    ¥   \
cnoremap    \   ¥
noremap     U   J

" ^Mを取り除く
command! RemoveCr call s:ExecuteKeepView('silent! %substitute/\r$//g | nohlsearch')

" 行末のスペースを取り除く
command! RemoveEolSpace call s:ExecuteKeepView('silent! %substitute/ \+$//g | nohlsearch')

" http://lsifrontend.hatenablog.com/entry/2013/10/11/052640
nmap     <silent> <C-CR> yy:<C-u>TComment<CR>p

vnoremap <silent> <C-CR> :<C-u>call CopyAddComment()<CR>

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

" http://vim.wikia.com/wiki/Pretty-formatting_XML
function! DoFormatXML() range
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
command! -range=% XmlFormat <line1>,<line2>call DoFormatXML()

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
" インデント {{{
set autoindent
" set smartindent
set cindent                       " Cプログラムファイルの自動インデントを始める

set list
set listchars=tab:\¦\ ,eol:↲,extends:»,precedes:«,nbsp:%

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
let s:mirrorDir = expand('$DOTVIM/mirror')
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
set incsearch                     " インクリメンタルサーチ
set ignorecase                    " 検索パターンにおいて大文字と小文字を区別しない。
set smartcase                     " 検索パターンが大文字を含んでいたらオプション 'ignorecase' を上書きする。

if executable('pt')
    set grepprg=pt\ --nogroup\ --nocolor\ -S
    set grepformat=%f:%l:%m
endif

" 日本語インクリメンタルサーチ
if has('migemo')
    set migemo

    if s:isWindows
        set migemodict=$VIM/dict/utf-8/migemo-dict
    endif
endif

" 検索時のハイライトを解除
nnoremap    <silent>  <Leader>/   :nohlsearch<CR>

" http://deris.hatenablog.jp/entry/2013/05/15/024932
" very magic
nnoremap /  /\v

" *による検索時に初回は移動しない
nnoremap <silent>* viw:<C-u>call <SID>StarSearch()<CR>:<C-u>set hlsearch<CR>`<
vnoremap <silent>* :<C-u>call    <SID>StarSearch()<CR>:<C-u>set hlsearch<CR>
function! s:StarSearch()
    let orig = @"
    normal! gvy
    let text = @"
    let @/ = '\V' . substitute(escape(text, '\/'), '\n', '\\n', 'g')
    let @" = orig
endfunction
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
set synmaxcol=500                 " ハイライトする文字数を制限する
set updatetime=220
set previewheight=24
" 'cursorline' を必要な時にだけ有効にする {{{
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

    augroup invisible
        autocmd!
        autocmd BufNew,BufRead * call s:ActivateInvisibleIndicator()
    augroup END
endif
" }}}
" Vim でカーソル下の単語を移動するたびにハイライトする{{{
" http://d.hatena.ne.jp/osyo-manga/20140121/1390309901
let g:enable_highlight_cursor_word = 1

augroup highlight-cursor-word
    autocmd!

    " autocmd CursorMoved              * call s:hl_cword()
    autocmd CursorHold               * call s:hl_cword()

    autocmd BufLeave                 * call s:hl_clear()
    autocmd WinLeave                 * call s:hl_clear()
    autocmd InsertEnter              * call s:hl_clear()
    autocmd CursorMoved,CursorMovedI * call s:hl_clear()

    autocmd ColorScheme * highlight CursorWord guifg=Red

    function! s:hl_clear()
        if exists("b:highlight_cursor_word_id") && exists("b:highlight_cursor_word")
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

nnoremap <silent> zo    zR
nnoremap <silent> zc    zM

nnoremap <expr> zh foldlevel(line('.')) > 0 ? 'zc' : '<C-h>'
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
nnoremap <silent> k     gk
nnoremap <silent> j     gj
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
nmap     <silent> gg    ggzOzz:<C-u>call <SID>RefreshScreen()<CR>
nmap     <silent> G     GzOzz:<C-u>call <SID>RefreshScreen()<CR>

noremap <C-i> <C-i>zz:<C-u>call <SID>RefreshScreen()<CR>
noremap <C-o> <C-o>zz:<C-u>call <SID>RefreshScreen()<CR>
map     [[    [[zz:<C-u>call <SID>RefreshScreen()<CR>
map     ]]    ]]zz:<C-u>call <SID>RefreshScreen()<CR>
map     H     ^:<C-u>call <SID>RefreshScreen()<CR>
map     L     $:<C-u>call <SID>RefreshScreen()<CR>
map     J     }zz:<C-u>call <SID>RefreshScreen()<CR>
map     K     {zz:<C-u>call <SID>RefreshScreen()<CR>
" }}}
" ウィンドウ操作 {{{
set splitbelow                    " 縦分割したら新しいウィンドウは下に
set splitright                    " 横分割したら新しいウィンドウは右に

nnoremap    [Window]    <Nop>
nmap        <Leader>w   [Window]

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
set showtabline=2                   " タブライン常時表示

nnoremap    [Tab]       <Nop>
nmap        <Leader>t   [Tab]

nnoremap <silent> [Tab]c :tabnew<CR>
nnoremap <silent> [Tab]x :tabclose<CR>

for s:n in range(1, 9)
    exe 'nnoremap <silent> [Tab]' . s:n  ':<C-u>tabnext' . s:n . '<CR>'
endfor
" }}}
" バッファ操作 {{{
nnoremap    [Buffer]    <Nop>
nmap        <Leader>b   [Buffer]

nnoremap <silent>  [Buffer]x  :bdelete<CR>

for s:n in range(1, 9)
    exe 'nnoremap <silent> [Buffer]' . s:n  ':<C-u>b' . s:n . '<CR>'
endfor
" }}}
" ファイル操作 {{{
" vimrc / gvimrc の編集
nnoremap    <silent>   <F1>    :<C-u>call <SID>SmartOpen($MYVIMRC)<CR>
nnoremap    <silent>   <F2>    :<C-u>call <SID>SmartOpen($MYGVIMRC)<CR>
nnoremap    <silent>   <F3>    :<C-u>source $MYVIMRC<CR>:source $MYGVIMRC<CR>
" }}}
" マーク {{{
nmap        <silent>   <Leader>m  `
" }}}
" ヘルプ {{{
set helplang=ja,en

nnoremap <Leader><C-k>      :<C-u>help<Space>
nnoremap <Leader><C-k><C-k> :<C-u>help <C-r><C-w><CR>
" }}}
" 汎用関数 {{{
" SID取得 {{{
function! s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfunction
" }}}
" CursorHold を継続させる{{{
function! s:ContinueCursorHold()
    call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n')
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

    if exists('b:isableSmartClose')
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
" ファイルの場所をカレントにする{{{
function! s:SetCurrentDir()

    if &ft != '' && &ft != 'vimfiler'
        silent! exe 'lcd'  fnameescape(expand('%:p:h'))
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
        throw 'Not supported.'
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
" コマンド実行後の表示状態を維持する {{{
function! s:ExecuteKeepView(expr)

    let wininfo = winsaveview()
    execute a:expr
    call winrestview(wininfo)
endfunction
" }}}
" カーソル位置のn文字前を取得する {{{
" http://d.hatena.ne.jp/eagletmt/20100623/1277289728
function! s:GetPrevCursorChar(n)
    let chars = split(getline('.')[0 : col('.')-1], '\zs')
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
    let s:openBraces  = [ '(', '{', '[', '<', '"', "'"]
    let s:closeBraces = [ ')', '}', ']', '>']

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
" }}}
" コンソール用 {{{
if !s:isGuiRunning
    source $MYGVIMRC
endif
" }}}
" メモ{{{
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

