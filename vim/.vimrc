source $VIMRUNTIME/vimrc_example.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" ~~~~~ General stuff ~~~~~
set ts=2
set number
set shiftwidth=2
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

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" ~~~~~~~~~~~~~~~~~ PUT VUNDLEs HERE ~~~~~~~~~~~~~~~~~

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
