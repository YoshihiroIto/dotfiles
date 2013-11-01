" 基本 {{{

let s:isWindows    = has('win32') || has('win64')
let s:isMac        = has('mac')
let s:isGuiRunning = has('gui_running')

" }}}
" カラースキーマ {{{

set t_Co=256
colorscheme molokai

hi Comment         guifg=#AEDEDE
hi DiffText                      guibg=#4C4745 gui=bold
hi Macro           guifg=#C4BE89               gui=none
hi SpecialKey      guifg=#66D9EF               gui=none
hi Special         guifg=#66D9EF guibg=bg      gui=none
hi SpecialKey      guifg=#888A85               gui=none
hi StorageClass    guifg=#FD971F               gui=none
hi Tag             guifg=#F92672               gui=none
hi FoldColumn      guifg=#465457 guibg=#242526
hi Folded          guifg=#465457 guibg=#242526
hi VertSplit       guifg=#202020 guibg=#202020 gui=bold "見えなくする

" }}}
" 見た目 {{{

" ツールバー削除
set guioptions-=T

" メニューバー削除
set guioptions-=m
set guioptions+=M

" スクロールバー削除
set guioptions-=r
set guioptions-=l
set guioptions-=R
set guioptions-=L

"テキストベースタブ
set guioptions-=e

" ビープをならさない
set visualbell
set t_vb=

" }}}
" フォント設定 {{{

if s:isGuiRunning
    if s:isWindows
        " set ambiwidth=single
        " set rop=type:directx
        set guifont=MeiryoKe_Gothic_SZ:h9:cSHIFTJIS
        " set guifont=Inconsolata\ for\ Powerline:h10:cSHIFTJIS
        set linespace=0
    elseif s:isMac
        " set guifont=Ricty:h13
        set guifont=Ricty\ Regular\ for\ Powerline:h13
        " set guifont=MeiryoKe_Gothic_SZ\ for\ Powerline:h13:cSHIFTJIS

        set antialias
    endif
endif

" }}}
" 日本語入力中のカーソルの色 {{{

highlight CursorIM guifg=NONE guibg=Red

" }}}
" ウィンドウの位置とサイズを記憶する {{{

if s:isGuiRunning
    " http://vim-users.jp/2010/01/hack120/
    let g:save_window_file = expand('~/.vimwinpos')
    augroup SaveWindow
        autocmd!
        autocmd VimLeavePre * call s:save_window()

        function! s:save_window()
            let options = [
                        \ 'set columns=' . &columns,
                        \ 'set lines=' . &lines,
                        \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
                        \ ]
            call writefile(options, g:save_window_file)
        endfunction
    augroup END

    if filereadable(g:save_window_file)
        exe 'source' g:save_window_file
    endif
endif

" }}}
" コマンドキーのショートカットを削除する {{{

if s:isGuiRunning && s:isMac
    macm File.New\ Window                               key=<Nop>
    macm File.New\ Tab                                  key=<Nop>
    macm File.Open\.\.\.                                key=<Nop>
    macm File.Open\ Tab\.\.\.<Tab>:tabnew               key=<Nop>
    macm File.Close\ Window<Tab>:qa                     key=<Nop>
    macm File.Close                                     key=<Nop>
    macm File.Save<Tab>:w                               key=<Nop>
    macm File.Save\ All                                 key=<Nop>
    macm File.Save\ As\.\.\.<Tab>:sav                   key=<Nop>
    macm File.Print                                     key=<Nop>

    macm Edit.Undo<Tab>u                                key=<Nop>
    macm Edit.Redo<Tab>^R                               key=<Nop>
    macm Edit.Cut<Tab>"+x                               key=<Nop>
    macm Edit.Copy<Tab>"+y                              key=<Nop>
    macm Edit.Paste<Tab>"+gP                            key=<Nop>
    macm Edit.Select\ All<Tab>ggVG                      key=<Nop>
    macm Edit.Find.Find\.\.\.                           key=<Nop>
    macm Edit.Find.Find\ Next                           key=<Nop>
    macm Edit.Find.Find\ Previous                       key=<Nop>
    macm Edit.Find.Use\ Selection\ for\ Find            key=<Nop>
    macm Edit.Font.Bigger                               key=<Nop>
    macm Edit.Font.Smaller                              key=<Nop>
    macm Edit.Special\ Characters\.\.\.                 key=<Nop>

    macm Tools.Spelling.To\ Next\ error<Tab>]s          key=<Nop>
    macm Tools.Spelling.Suggest\ Corrections<Tab>z=     key=<Nop>
    macm Tools.Make<Tab>:make                           key=<Nop>
    macm Tools.List\ Errors<Tab>:cl                     key=<Nop>
    macm Tools.Next\ Error<Tab>:cn                      key=<Nop>
    macm Tools.Previous\ Error<Tab>:cp                  key=<Nop>
    macm Tools.Older\ List<Tab>:cold                    key=<Nop>
    macm Tools.Newer\ List<Tab>:cnew                    key=<Nop>

    macm Window.Minimize                                key=<Nop>
    macm Window.Minimize\ All                           key=<Nop>
    macm Window.Zoom                                    key=<Nop>
    macm Window.Zoom\ All                               key=<Nop>
    macm Window.Toggle\ Full\ Screen\ Mode              key=<Nop>
    macm Window.Select\ Next\ Tab                       key=<Nop>
    macm Window.Select\ Previous\ Tab                   key=<Nop>
    macm ウインドウ.前のウインドウ                      key=<Nop>
    macm ウインドウ.次のウインドウ                      key=<Nop>

    macm Help.MacVim\ Help                              key=<Nop>
endif

" }}}
