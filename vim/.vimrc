source $VIMRUNTIME/vimrc_example.vim

set nobackup
set noswapfile
set nocompatible              " be iMproved, required
set noundofile
filetype off                  " required

" ~~~~~ General stuff ~~~~~
set tw=79
set ts=4
set number
set shiftwidth=2
syntax on
filetype indent plugin on
set autoread
au FocusGained,BufEnter * :checktime
" Open new vim windows to the right and bottom
set splitbelow
set splitright

" Set leader to space bar.
let leader="/<space>"

" Set jk to escape in insert mode
inoremap jk <esc>

" ~~~~~~ Elixir stuff ~~~~~~

" Code formatting
autocmd BufWritePost *.exs silent :!mix format %
autocmd BufWritePost *.ex silent :!mix format %

" ~~~~~~~~~~~~~~~ TAB autocomplete ~~~~~~~~~~~~~
function! Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
      return "\<C-N>"
    else
      return "\<Tab>"
    endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
:set dictionary="/usr/dict/words"

" ~~~~~~~~~~~~~~ VIM Plugs ~~~~~~~~~~~~~~~~~~
" Automatically installs vim-plugs if not installed on system
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sensible'
Plug 'elixir-editors/vim-elixir'
call plug#end()
