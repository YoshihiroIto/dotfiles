" 基本 {{{
set noimdisable

" MacVim-KaoriYa 自動IM on禁止
if IsMac()
  set imdisableactivate
endif
" }}}
" カラースキーマ {{{
set t_Co=256
colorscheme molokai

hi Comment          guifg=#AEDEDE
hi DiffText                       guibg=#4C4745 gui=bold
hi Macro            guifg=#C4BE89               gui=none
hi Special          guifg=#66D9EF guibg=bg      gui=none
hi StorageClass     guifg=#FD971F               gui=none
hi Tag              guifg=#F92672               gui=none
hi FoldColumn       guifg=#465457 guibg=#242526
hi Folded           guifg=#465457 guibg=#242526
hi VertSplit        guifg=#202020 guibg=#202020 gui=bold    " 見えなくする

" タブ表示など
hi SpecialKey       guifg=#303030 guibg=#121212 gui=none

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
if IsMac()
  augroup Transparency
    autocmd!
    autocmd GuiEnter,FocusGained * set transparency=3   " アクティブ時の透過率
    autocmd FocusLost            * set transparency=48  " 非アクティブ時の透過率
  augroup END
endif
" }}}
" フォント設定 {{{
if IsGuiRunning()
  if IsWindows()
    " set rop=type:directx
    " set guifont=MeiryoKe_Gothic_SZ:h9:cSHIFTJIS
    set guifont=Ricty\ Regular\ for\ Powerline:h11
  elseif IsMac()
    set guifont=Ricty\ Regular\ for\ Powerline:h12
    set antialias
  endif
endif

if IsWindows()
  " 一部のUCS文字の幅を自動計測して決める
  set ambiwidth=auto
elseif IsMac()
  set ambiwidth=double
endif
" }}}
" ウィンドウの位置とサイズを記憶する {{{
if IsGuiRunning()
  " http://vim-jp.org/vim-users-jp/2010/01/28/Hack-120.html
  let s:save_window_file = expand('~/.vimwinpos')

  augroup SaveWindow
    autocmd!
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
" vim: set ts=2 sw=2 sts=2 et :

