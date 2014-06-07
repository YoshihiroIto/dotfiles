" 基本 {{{
let s:isWindows    = has('win32') || has('win64')
let s:isMac        = has('mac')
let s:isGuiRunning = has('gui_running')

set noimdisable

" MacVim-KaoriYa 自動IM on禁止
if s:isMac
    set imdisableactivate
endif
" }}}
" カラースキーマ {{{
set t_Co=256
colorscheme molokai

hi Comment          guifg=#AEDEDE
hi DiffText                       guibg=#4C4745 gui=bold
hi Macro            guifg=#C4BE89               gui=none
hi SpecialKey       guifg=#66D9EF               gui=none
hi Special          guifg=#66D9EF guibg=bg      gui=none
hi StorageClass     guifg=#FD971F               gui=none
hi Tag              guifg=#F92672               gui=none
hi FoldColumn       guifg=#465457 guibg=#242526
hi Folded           guifg=#465457 guibg=#242526
hi VertSplit        guifg=#202020 guibg=#202020 gui=bold "見えなくする

" タブ表示など
" hi SpecialKey       guifg=#383838 guibg=#121212 gui=none
" hi SpecialKey       guifg=#D0D0D0 guibg=#121212 gui=none

if s:isMac
    hi SpecialKey       guifg=#303030 guibg=#121212 gui=none
else
    hi SpecialKey       guifg=#B0D0F0 guibg=#121212 gui=none
endif


" vim-indent-guides
hi IndentGuidesOdd                guibg=#181818
hi IndentGuidesEven               guibg=#181818

" 日本語入力中のカーソルの色
hi CursorIM         guifg=NONE    guibg=Red

" }}}
" 見た目 {{{
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

" ビープをならさない
set visualbell
set t_vb=

" 半透明化
augroup transparency
    autocmd!
    if s:isMac
        autocmd GuiEnter,FocusGained * set transparency=3   " アクティブ時の透過率
        autocmd FocusLost            * set transparency=48  " 非アクティブ時の透過率
    endif
augroup END
" }}}
" フォント設定 {{{
if s:isGuiRunning
    if s:isWindows
        " set rop=type:directx
        " set guifont=MeiryoKe_Gothic_SZ:h9:cSHIFTJIS
        set guifont=Ricty\ Regular\ for\ Powerline:h11
        set linespace=0
    elseif s:isMac
        set guifont=Ricty\ Regular\ for\ Powerline:h12
        set antialias
    endif
endif

if s:isWindows
    " 一部のUCS文字の幅を自動計測して決める
    set ambiwidth=auto
elseif s:isMac
    set ambiwidth=double
endif
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
