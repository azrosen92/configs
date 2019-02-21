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
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
call plug#end()

set background=dark
colorscheme snow

" ~~~~~~~~~~~~~~~ Tsuquyomi ~~~~~~~~~~~~~~~~~
let g:tsuquyomi_disable_quickfix = 1
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>
autocmd FileType typescript nmap <buffer> <Leader>e :TsuquyomiRenameSymbol<CR>


" ~~~~~~~~~~~~~~ Fuzzy Finder ~~~~~~~~~~~~~~~~~~
nnoremap <C-p> :FZF<CR>

" ~~~~~~~ NerdTree ~~~~~~~ 
" Open NerdTree when opening vim with no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NerdTree when opening vim with a directory specified.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Close vim if only open window is NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NerdTree with ctrl-n
map <C-n> :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<Enter>
let g:NERDTreeDirArrowExpandable = '📪'
let g:NERDTreeDirArrowCollapsible = '📫'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowHidden = 1

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtrej highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

