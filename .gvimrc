" カラースキーマ
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
hi VertSplit       guifg=#202020 guibg=#202020 gui=bold	"見えなくする

" 幅
let &columns=g:baseColumns

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

" フォント
if has("gui_win32")
	" set ambiwidth=single
	" set rop=type:directx
	set guifont=MeiryoKe_Gothic_SZ:h9:cSHIFTJIS
	" set guifont=Inconsolata\ for\ Powerline:h10:cSHIFTJIS

	set linespace=0
elseif has("gui_macvim")
	" set guifont=Ricty:h13
	set guifont=Ricty\ Regular\ for\ Powerline:h13
	" set guifont=MeiryoKe_Gothic_SZ\ for\ Powerline:h13:cSHIFTJIS

	set antialias
endif

" 日本語入力中のカーソルの色
highlight CursorIM guifg=NONE guibg=Red

" ビープをならさない
set visualbell t_vb=

" タブラインを常時表示
set showtabline=2

" ウィンドウの位置とサイズを記憶する
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
	execute 'source' g:save_window_file
endif

" コマンドキーのショートカットを削除する
if has('gui_macvim')
	macm File.New\ Window								key=<nop>
	macm File.New\ Tab									key=<nop>
	macm File.Open\.\.\.								key=<nop>
	macm File.Open\ Tab\.\.\.<Tab>:tabnew				key=<nop>
	macm File.Close\ Window<Tab>:qa						key=<nop>
	macm File.Close										key=<nop>
	macm File.Save<Tab>:w								key=<nop>
	macm File.Save\ All									key=<nop>
	macm File.Save\ As\.\.\.<Tab>:sav					key=<nop>
	macm File.Print										key=<nop>

	macm Edit.Undo<Tab>u								key=<nop>
	macm Edit.Redo<Tab>^R								key=<nop>
	macm Edit.Cut<Tab>"+x								key=<nop>
	macm Edit.Copy<Tab>"+y								key=<nop>
	macm Edit.Paste<Tab>"+gP							key=<nop>
	macm Edit.Select\ All<Tab>ggVG						key=<nop>
	macm Edit.Find.Find\.\.\.							key=<nop>
	macm Edit.Find.Find\ Next							key=<nop>
	macm Edit.Find.Find\ Previous						key=<nop>
	macm Edit.Find.Use\ Selection\ for\ Find			key=<nop>
	macm Edit.Font.Bigger								key=<nop>
	macm Edit.Font.Smaller								key=<nop>
	macm Edit.Special\ Characters\.\.\.					key=<nop>

	macm Tools.Spelling.To\ Next\ error<Tab>]s			key=<nop>
	macm Tools.Spelling.Suggest\ Corrections<Tab>z=		key=<nop>
	macm Tools.Make<Tab>:make							key=<nop>
	macm Tools.List\ Errors<Tab>:cl						key=<nop>
	macm Tools.Next\ Error<Tab>:cn						key=<nop>
	macm Tools.Previous\ Error<Tab>:cp					key=<nop>
	macm Tools.Older\ List<Tab>:cold					key=<nop>
	macm Tools.Newer\ List<Tab>:cnew					key=<nop>

	macm Window.Minimize								key=<nop>
	macm Window.Minimize\ All							key=<nop>
	macm Window.Zoom									key=<nop>
	macm Window.Zoom\ All								key=<nop>
	macm Window.Toggle\ Full\ Screen\ Mode				key=<nop>
	macm Window.Select\ Next\ Tab						key=<nop>
	macm Window.Select\ Previous\ Tab					key=<nop>
	macm ウインドウ.前のウインドウ						key=<nop>
	macm ウインドウ.次のウインドウ						key=<nop>

	macm Help.MacVim\ Help								key=<nop>
endif

