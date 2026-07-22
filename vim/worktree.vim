" worktree.vim — switch to a git worktree in its own tab.
"
" :Worktree            Pick a worktree from `git worktree list` (or jump to
"                       its tab if one is already open there).
" :Worktree <path>      Same, but skips the picker. Tab-completes worktree
"                       paths.
"
" Each worktree gets a tab-local cwd (:tcd) and its own NERDTree rooted at
" that path, so tabs stay independent of one another.

function! s:GitWorktreePaths() abort
  return systemlist("git worktree list | awk '{print $1}'")
endfunction

function! s:WorktreeComplete(ArgLead, CmdLine, CursorPos) abort
  return filter(s:GitWorktreePaths(), 'v:val =~ "^" . a:ArgLead')
endfunction

function! s:PickWorktree() abort
  let l:worktrees = s:GitWorktreePaths()
  if empty(l:worktrees)
    echoerr 'No git worktrees found (not inside a git repo?)'
    return ''
  endif
  let l:display = map(copy(l:worktrees), {idx, val -> (idx + 1) . '. ' . val})
  let l:choice = inputlist(['Select worktree:'] + l:display)
  if l:choice < 1 || l:choice > len(l:worktrees)
    return ''
  endif
  return l:worktrees[l:choice - 1]
endfunction

function! s:NormalizePath(path) abort
  return substitute(fnamemodify(a:path, ':p'), '/$', '', '')
endfunction

" If a tab is already tcd'd into this worktree, return its tab number.
function! s:FindWorktreeTab(path) abort
  let l:target = s:NormalizePath(a:path)
  for i in range(1, tabpagenr('$'))
    if s:NormalizePath(getcwd(-1, i)) ==# l:target
      return i
    endif
  endfor
  return -1
endfunction

function! s:OpenWorktreeTab(path) abort
  let l:path = empty(a:path) ? s:PickWorktree() : a:path
  if empty(l:path) || !isdirectory(l:path)
    return
  endif

  let l:existing = s:FindWorktreeTab(l:path)
  if l:existing != -1
    execute l:existing . 'tabnext'
    return
  endif

  tabnew
  execute 'tcd ' . fnameescape(l:path)
  execute 'NERDTree ' . fnameescape(l:path)
  wincmd p          " land in the edit window, not the NERDTree pane
endfunction

command! -nargs=? -complete=customlist,s:WorktreeComplete Worktree call s:OpenWorktreeTab(<q-args>)
