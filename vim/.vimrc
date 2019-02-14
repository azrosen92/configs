source $VIMRUNTIME/vimrc_example.vim

set nobackup
set noswapfile
set nocompatible              " be iMproved, required
set noundofile
filetype off                  " required

" ~~~~~ General stuff ~~~~~
set colorcolumn=120
set tw=79
set number

" Tabs inserted as 2 spaces.
set tabstop=2
set shiftwidth=2
set expandtab

syntax on
filetype indent plugin on
set autoread
au FocusGained,BufEnter * :checktime
" Open new vim windows to the right and bottom
set splitbelow
set splitright

nnoremap <Leader>s :split %<CR>

" Set syntax highlighting for Jenkinsfile.
au BufNewFile,BufRead Jenkinsfile setf groovy

" Set leader to space bar.
let mapleader=","

" Ignore gutter and line numbers when highlighting with mouse.
set mouse=a 
" Set jk to escape in insert mode
inoremap jk <esc>

let g:ackprg = 'ag --nogroup --nocolor --column'

" File extensions to check for when using gf
set suffixesadd+=.js,.jsx,.ts,.tsx,.scss,.css,.py,.json;
" Ignore compiled files, module folders, and repo folders
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico,*.pyc,*.o,*~
set wildignore+=*.pdf,*.psd
set wildignore+=**/node_modules/**

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

" ~~~~~~~ NerdTree ~~~~~~~ 
" Open NerdTree when opening vim with no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NerdTree when opening vim with a directory specified.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Open NerdTree with ctrl-n
map <C-n> :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<Enter>
" Close vim if only open window is NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
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


" ~~~~~~ ALE stuff ~~~~~
" Maps tsx and jsx files to their javscript and typescript counterparts so
" stylelint can be applied to both.
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    au BufNewFile,BufRead *.tsx set filetype=typescript.tsx
augroup END
let g:ale_fixers = {
\   'python': ['yapf'],
\	  'typescript': ['prettier', 'tslint'],
\ 	'javascript': ['prettier'],
\ 	'scss': ['stylelint']
\}
let g:ale_linter_aliases = {
\   'jsx': ['css', 'javascript'],
\   'tsx': ['css', 'typescript'],
\}
let g:ale_linters = {
\	  'python': ['mypy', 'pylint'],
\   'javascript': ['eslint'],
\   'jsx': ['eslint', 'stylelint'],
\ 	'typescript': ['tslint', 'eslint'],
\   'tsx': ['tslint', 'eslint', 'stylelint'],
\}
let g:ale_fix_on_save = 1

" ~~~~~~~~ VIM Airline ~~~~~~~~~~
let g:airline_theme='snow_dark'

" ~~~~~~ TypeScript stuff ~~~~~
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']

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

inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
set dictionary="/usr/dict/words"

let g:ts_path_to_plugin = '~/.vim/plugged/vim-typescript'
let g:ts_auto_open_quickfix = 1

let g:tsuquyomi_disable_quickfix = 1
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>
autocmd FileType typescript nmap <buffer> <Leader>e :TsuquyomiRenameSymbol<CR>

" ~~~~~~~~~~~~~~ CSScomb ~~~~~~~~~~~~~~~~~~~~
autocmd BufWritePre,FileWritePre *.css,*.less,*.scss,*.sass silent! :CSScomb

" ~~~~~~~~~~~~~~ Fuzzy Finder ~~~~~~~~~~~~~~~~~~
nnoremap <C-p> :FZF<CR>

" ~~~~~~~~~~~~~~ Vim fugitive (git tool) ~~~~~~~~~~~~~~ 
noremap <leader>gd :Gvdiff<CR>

" ~~~~~~~~~~~~~~ VIM Plugs ~~~~~~~~~~~~~~~~~~
" Automatically installs vim-plugs if not installed on system
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ~~~~~~~~~~~~~~ tagbar ~~~~~~~~~~~~~~~~~~
nnoremap <Leader>t :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tabar_autofocus = 1

call plug#begin('~/.vim/plugged')
" ~~~~~~~~~~~~~~~ Themes
Plug 'KKPMW/sacredforest-vim'
Plug 'YorickPeterse/Autumn.vim', { 'as': 'Autumn-vim' }
Plug 'nightsense/snow'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sensible'
Plug 'elixir-editors/vim-elixir'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'mxw/vim-jsx'
Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
Plug 'google/yapf'
Plug 'csscomb/vim-csscomb'
Plug 'mxw/vim-jsx'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'gabrielelana/vim-markdown'
Plug 'jparise/vim-graphql'
" TypeScript stuff.
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'Quramy/tsuquyomi'
call plug#end()

set background=dark
colorscheme snow
