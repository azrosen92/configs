source $VIMRUNTIME/vimrc_example.vim


" ~~~~~ General stuff ~~~~~
" Removes annoying swap files.
set nobackup
set noswapfile
set nocompatible              " be iMproved, required
set noundofile
set colorcolumn=120
set tw=79
set number
" Tabs inserted as 2 spaces.
set tabstop=2
set shiftwidth=2
set expandtab
" Enables syntax highlighting.
syntax on
" Turns on filetype detection, filetype plugin, and indentation.
filetype indent plugin on
" Check if file was edited by another client, if it has then reload.
au FocusGained,BufEnter * :checktime
set autoread
" Open new vim windows to the right and bottom
set splitbelow
set splitright
" Ignore gutter and line numbers when highlighting with mouse.
set mouse=a 

" Set jk to escape in insert mode
inoremap jk <esc>
" Set leader to space bar.
let mapleader=","

" Auto save everytime buffer is modified.
function! s:save_buffer() abort
  if empty(&buftype) && !empty(bufname(''))
    let l:savemarks = {
          \ "'[": getpos("'["),
          \ "']": getpos("']")
          \ }

    silent! update

    for [l:key, l:value] in items(l:savemarks)
      call setpos(l:key, l:value)
    endfor
  endif
endfunction
augroup save_buffer
  autocmd!
  autocmd InsertLeave,TextChanged * nested call s:save_buffer()
  autocmd FocusGained,BufEnter,CursorHold * silent! checktime
augroup end

" ~~~~~~~~~~~~~~ VIM Plugs ~~~~~~~~~~~~~~~~~~
" Automatically installs vim-plugs if not installed on system
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'nightsense/snow'
Plug 'tpope/vim-sensible'
call plug#end()

set background=dark
colorscheme snow
