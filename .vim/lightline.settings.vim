let g:lightline#colorscheme#yoi#palette = {
      \   'inactive': {
      \     'left':     [['#585858', '#262626', 240, 235],
      \                  ['#585858', '#121212', 240, 233]],
      \     'right':    [['#262626', '#606060', 235, 241],
      \                  ['#585858', '#262626', 240, 235],
      \                  ['#585858', '#121212', 240, 233]]
      \   },
      \   'insert':   {
      \     'branch':   [['#FFFFFF', '#0087AF', 231,  31]],
      \     'left':     [['#005F5F', '#FFFFFF',  23, 231],
      \                  ['#87DFFF', '#005F87', 117,  24]],
      \     'middle':   [['#87DFFF', '#005F87', 117,  24]],
      \     'right':    [['#005F5F', '#87DFFF',  23, 117],
      \                  ['#87DFFF', '#0087AF', 117,  31],
      \                  ['#87DFFF', '#005F87', 117,  24]]
      \   },
      \   'normal':   {
      \     'branch':   [['#FFFFFF', '#585858', 231, 240]],
      \     'error':    [['#BCBCBC', '#FF0000', 250, 196]],
      \     'left':     [['#195E00', '#07AF00',  22,  34],
      \                  ['#8A8A8A', '#303030', 245, 236]],
      \     'middle':   [['#8A8A8A', '#303030', 245, 236]],
      \     'right':    [['#606060', '#D0D0D0', 241, 252],
      \                  ['#BCBCBC', '#585858', 250, 240],
      \                  ['#9E9E9E', '#303030', 247, 236]],
      \     'warning':  [['#262626', '#B58900', 235, 136]]
      \   },
      \   'replace':  {
      \     'left':     [['#FFFFFF', '#DF0000', 231, 160],
      \                  ['#FFFFFF', '#585858', 231, 240]],
      \     'middle':   [['#8A8A8A', '#303030', 245, 236]],
      \     'right':    [['#606060', '#D0D0D0', 241, 252],
      \                  ['#BCBCBC', '#585858', 250, 240],
      \                  ['#9E9E9E', '#303030', 247, 236]]
      \   },
      \   'tabline':  {
      \     'left':     [['#BCBCBC', '#585858', 250, 240]],
      \     'middle':   [['#303030', '#9E9E9E', 236, 247]],
      \     'right':    [['#BCBCBC', '#4E4E4E', 250, 239]],
      \     'tabsel':   [['#BCBCBC', '#262626', 250, 235]]
      \   },
      \   'visual':   {
      \     'branch':   [['#FFFFFF', '#AF0053', 231, 125]],
      \     'left':     [['#AB2362', '#FFFFFF', 125, 231],
      \                  ['#FF84BA', '#870036', 211,  89]],
      \     'middle':   [['#FF84BA', '#870036', 211,  89]],
      \     'right':    [['#75003D', '#FF87BB',  89, 211],
      \                  ['#FE86BB', '#AF0053', 211, 125],
      \                  ['#FF84BA', '#870036', 211,  89]]
      \   }
      \ }

let g:lightline = {
      \   'colorscheme': 'yoi',
      \   'active': {
      \     'left': [
      \       ['mode',   'paste'],
      \       ['branch', 'gitgutter', 'filename', 'submode']
      \     ],
      \     'right': [
      \       ['syntastic', 'lineinfo'],
      \       ['percent']
      \     ]
      \   },
      \   'component': {'percent': '⭡%3p%%'},
      \   'component_function': {
      \     'fileformat':   'YOI_lightline_fileformat',
      \     'filetype':     'YOI_lightline_filetype',
      \     'fileencoding': 'YOI_lightline_fileencoding',
      \     'modified':     'YOI_lightline_modified',
      \     'readonly':     'YOI_lightline_readonly',
      \     'filename':     'YOI_lightline_filename',
      \     'mode':         'YOI_lightline_mode',
      \     'lineinfo':     'YOI_lightline_lineinfo',
      \     'submode':      'submode#current'
      \   },
      \   'component_expand': {
      \     'syntastic':    'SyntasticStatuslineFlag',
      \     'branch':       'YOI_lightline_current_branch',
      \     'gitgutter':    'YOI_lightline_git_summary'
      \   },
      \   'component_type': {
      \     'syntastic':    'error',
      \     'branch':       'branch',
      \     'gitgutter':    'branch'
      \   },
      \   'separator': {   'left': '⮀', 'right': '⮂'},
      \   'subseparator': {'left': '⮁', 'right': '⮃'},
      \   'tabline': {
      \     'left':  [['tabs']],
      \     'right': [['filetype', 'fileformat', 'fileencoding']]
      \   },
      \   'tabline_separator': {   'left': '⮀', 'right': '⮂'},
      \   'tabline_subseparator': {'left': '⮁', 'right': '⮃'},
      \   'mode_map': {
      \     'n':      'N',
      \     'i':      'I',
      \     'R':      'R',
      \     'v':      'V',
      \     'V':      'VL',
      \     'c':      'C',
      \     "\<C-v>": 'VB',
      \     's':      'S',
      \     'S':      'SL',
      \     "\<C-s>": 'SB',
      \     't':      'T',
      \     '?':      ' '
      \   }
      \ }

function! YOI_lightline_mode()
  return  &filetype ==# 'quickrun' ? 'Quickrun' :
        \ &filetype ==# 'agit'     ? 'Agit'     :
        \ winwidth(0) > 50 ? lightline#mode() : ''
endfunction

function! YOI_lightline_modified()
  if s:is_lightline_no_disp_group()
    return ''
  endif

  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! YOI_lightline_readonly()
  if s:is_lightline_no_disp_filetype()
    return ''
  endif

  return &readonly ? '⭤' : ''
endfunction

function! YOI_lightline_filename()
  try
    return (empty(YOI_lightline_readonly()) ? '' : YOI_lightline_readonly() . ' ') .
          \ (&filetype ==# 'quickrun' ? ''      :
          \  empty(expand('%:t')) ? '[No Name]' : expand('%:t')) .
          \ (empty(YOI_lightline_modified()) ? '' : ' ' . YOI_lightline_modified())
  catch
    return ''
  endtry
endfunction

function! YOI_lightline_current_branch()
  if s:is_lightline_no_disp_filetype()
    return ''
  endif

  if empty(expand('%:p'))
    return ''
  endif

  try
    let branch = gitbranch#name()
    return empty(branch) ? '' : '⭠ ' . branch
  catch
    return ''
  endtry
endfunction

function! YOI_lightline_fileformat()
  if s:is_lightline_no_disp_group()
    return ''
  endif

  return &fileformat
endfunction

function! YOI_lightline_filetype()
  if s:is_lightline_no_disp_group()
    return ''
  endif

  return empty(&filetype) ? 'no filetype' : &filetype
endfunction

function! YOI_lightline_fileencoding()
  if s:is_lightline_no_disp_group()
    return ''
  endif

  return empty(&fileencoding) ? &encoding : &fileencoding
endfunction

function! YOI_lightline_git_summary()
  if s:is_lightline_no_disp_group()
    return ''
  endif

  if empty(expand('%:p'))
    return ''
  endif

  try
    let branch = gitbranch#name()
    if empty(branch)
      return ''
    endif

    let summary = GitGutterGetHunkSummary()
    return printf('%s%d %s%d %s%d',
          \ g:gitgutter_sign_added,    summary[0],
          \ g:gitgutter_sign_modified, summary[1],
          \ g:gitgutter_sign_removed,  summary[2])
  catch
    return ''
  endtry
endfunction

function! YOI_lightline_lineinfo()
  if winwidth(0) <= 50
    return ''
  endif

  return printf('%4d/%d : %-3d', line('.'), line('$'), col('.'))
endfunction

function! s:is_lightline_no_disp_filetype()
  return &filetype =~# 'quickrun\|agit'
endfunction

function! s:is_lightline_no_disp_group()
  if winwidth(0) <= 50
    return 1
  endif

  if s:is_lightline_no_disp_filetype()
    return 1
  endif

  return 0
endfunction

Autocmd CursorHold,CursorHoldI * call lightline#update()

