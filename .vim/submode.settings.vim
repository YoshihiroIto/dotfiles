function! YOI_submode_snap(value, scale)
  return a:value / a:scale * a:scale
endfunction

function! YOI_submode_resize_appwin(x, y)
  let scale = get(g:, 'yoi_resize_appwin_size', 8)

  if a:x != 0
    let &columns = YOI_submode_snap(&columns, scale) + a:x * scale
  endif

  if a:y != 0
    let &lines   = YOI_submode_snap(&lines,   scale) + a:y * scale
  endif
endfunction

function! YOI_submode_move_appwin(x, y)
  let scale = get(g:, 'yoi_move_appwin_size', 64)
  let win_x = getwinposx()
  let win_y = getwinposy()

  if a:x == 0
    let x = win_x
  else
    let x = win_x + a:x * scale

    if win_x != YOI_submode_snap(win_x, scale)
      let x = YOI_submode_snap(x, scale)
    endif
  endif

  if a:y == 0
    let y = win_y
  else
    let y = win_y + a:y * scale

    if win_y != YOI_submode_snap(win_y, scale)
      let y = YOI_submode_snap(y, scale)
    endif
  endif

  execute 'winpos' x y
endfunction

let g:submode_timeout          = 0
let g:submode_keep_leaving_key = 1

call submode#enter_with('git_hunk', 'n', 's', 'ghj', ':<C-u>GitGutterEnable<CR>:GitGutterNextHunk<CR>zvzz')
call submode#enter_with('git_hunk', 'n', 's', 'ghk', ':<C-u>GitGutterEnable<CR>:GitGutterPrevHunk<CR>zvzz')
call submode#map(       'git_hunk', 'n', 's', 'j',   ':<C-u>GitGutterEnable<CR>:GitGutterNextHunk<CR>zvzz')
call submode#map(       'git_hunk', 'n', 's', 'k',   ':<C-u>GitGutterEnable<CR>:GitGutterPrevHunk<CR>zvzz')

call submode#enter_with('winsize', 'n', 's', 'gwh', '8<C-w>>')
call submode#enter_with('winsize', 'n', 's', 'gwl', '8<C-w><')
call submode#enter_with('winsize', 'n', 's', 'gwj', '4<C-w>-')
call submode#enter_with('winsize', 'n', 's', 'gwk', '4<C-w>+')
call submode#map(       'winsize', 'n', 's', 'h',   '8<C-w>>')
call submode#map(       'winsize', 'n', 's', 'l',   '8<C-w><')
call submode#map(       'winsize', 'n', 's', 'j',   '4<C-w>-')
call submode#map(       'winsize', 'n', 's', 'k',   '4<C-w>+')

let call_resize_appwin = ':<C-u>call YOI_submode_resize_appwin'
let call_move_appwin   = ':<C-u>call YOI_submode_move_appwin'

call submode#enter_with('appwinsize', 'n', 's', '<leader>wH', call_resize_appwin . '(-1, 0)<CR>')
call submode#enter_with('appwinsize', 'n', 's', '<leader>wL', call_resize_appwin . '(+1, 0)<CR>')
call submode#enter_with('appwinsize', 'n', 's', '<leader>wJ', call_resize_appwin . '(0, +1)<CR>')
call submode#enter_with('appwinsize', 'n', 's', '<leader>wK', call_resize_appwin . '(0, -1)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'H',   call_resize_appwin . '(-1, 0)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'L',   call_resize_appwin . '(+1, 0)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'J',   call_resize_appwin . '(0, +1)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'K',   call_resize_appwin . '(0, -1)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'h',   call_resize_appwin . '(-1, 0)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'l',   call_resize_appwin . '(+1, 0)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'j',   call_resize_appwin . '(0, +1)<CR>')
call submode#map(       'appwinsize', 'n', 's', 'k',   call_resize_appwin . '(0, -1)<CR>')

call submode#enter_with('appwinpos',  'n', 's', '<leader>wh', call_move_appwin   . '(-1, 0)<CR>')
call submode#enter_with('appwinpos',  'n', 's', '<leader>wl', call_move_appwin   . '(+1, 0)<CR>')
call submode#enter_with('appwinpos',  'n', 's', '<leader>wj', call_move_appwin   . '(0, +1)<CR>')
call submode#enter_with('appwinpos',  'n', 's', '<leader>wk', call_move_appwin   . '(0, -1)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'H',   call_move_appwin   . '(-1, 0)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'L',   call_move_appwin   . '(+1, 0)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'J',   call_move_appwin   . '(0, +1)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'K',   call_move_appwin   . '(0, -1)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'h',   call_move_appwin   . '(-1, 0)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'l',   call_move_appwin   . '(+1, 0)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'j',   call_move_appwin   . '(0, +1)<CR>')
call submode#map(       'appwinpos',  'n', 's', 'k',   call_move_appwin   . '(0, -1)<CR>')

