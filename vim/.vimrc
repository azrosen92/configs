" ~~~~~ General stuff ~~~~~
set ts=2
syntax on
filetype indent plugin on
set autoread

" Set leader to space bar.
let leader="/<space>"

" Set jk to escape in insert mode
inoremap jk <esc>

" ~~~~~~ Elixir stuff ~~~~~~ 

" Code formatting
autocmd BufWritePost *.exs silent :!mix format %
autocmd BufWritePost *.ex silent :!mix format %

"	~~~~~~ Plugins ~~~~~~

call plug#begin('~/.vim/plugged')

Plug 'elixir-editors/vim-elixir'

call plug#end()

