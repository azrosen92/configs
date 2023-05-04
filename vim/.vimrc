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
set clipboard+=unnamedplus

" Set leader to comma
let mapleader=","

""""""""""""""""""
" Custom mappings
""""""""""""""""""
nnoremap <Leader>s :split %<CR>
vnoremap <Leader>r "hy:%s/<C-r>h//g<left><left>
" Converts all strings to symbols, with confirmation
nnoremap <Leader>rs "hy:%s/"\(\w\+\)"/:\1/gc"

" Change vertical split to horizontal and vise versa
nnoremap <Leader>th <C-w>t<C-w>H
nnoremap <Leader>tk <C-w>t<C-w>K

" Set syntax highlighting for all groovy files – (Jenkins, gradle, etc)
au BufNewFile,BufRead Jenkinsfile setf groovy
au BufNewFile,BufRead *.gradle set filetype=groovy
au BufNewFile,BufRead *.gradle.kts set filetype=groovy

" Automatically remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

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

" Set ruby syntax highlighting for Vagrantfile
augroup SyntaxSettings
  autocmd!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
  au BufRead,BufNewFile Fastfile set filetype=ruby
  au BufRead,BufNewFile Podfile set filetype=ruby
  au Bufread,BufNewFile *.tsx set filetype=typescript.tsx
augroup END

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
let g:ale_fixers = {
\   'python': ['yapf'],
\   'elixir': ['mix_format'],
\}
let g:ale_linters = {
\	  'python': ['mypy', 'pylint'],
\   'elixir': ['mix_format'],
\   'ruby': ['rubocop'],
\   'slim': ['slimlint'],
\}
let g:ale_fix_on_save = 1
let g:ale_ruby_rubocop_executable = 'bundle'

" ~~~~~~~~ VIM Airline ~~~~~~~~~~
let g:airline_theme='snow_dark'

" ~~~~~~ Elixir stuff ~~~~~~

" Code formatting
"autocmd BufWritePost *.exs silent :!mix format %
"autocmd BufWritePost *.ex silent :!mix format %

set dictionary="/usr/dict/words"

" ~~~~~~~~~~~~~~ CSScomb ~~~~~~~~~~~~~~~~~~~~
autocmd BufWritePre,FileWritePre *.css,*.less,*.scss,*.sass silent! :CSScomb

" ~~~~~~~~~~~~~~ Fuzzy Finder ~~~~~~~~~~~~~~~~~~
nnoremap <C-p> :FZF<CR>

" ~~~~~~~~~~~~~~ Vim fugitive (git tool) ~~~~~~~~~~~~~~
noremap <leader>gd :Gvdiff<CR>
noremap <leader>gh :GBrowse<CR>

" ~~~~~~~~~~~~~ JSON stuff ~~~~~~~~~~
" Format json blob
noremap <leader>jf :%!jq .<CR>

" ~~~~~~~~~~~~~~ Coc.vim ~~~~~~~~~~~~~~
" https://github.com/neoclide/coc.nvim#example-vim-configuration
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
"" if exists('*complete_info')
""   inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"" else
""   imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"" endif
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
"
" Open references in split window
let g:coc_user_config = {}
let g:coc_user_config['coc.preferences.jumpCommand'] = ':vsp'
let g:coc_user_config['coc.preferences.formatOnSaveFiletypes'] = ['elixir', 'javascript', 'typescript', 'typescriptreact', 'json']
let g:coc_global_extensions = ['coc-json', 'coc-prettier', 'coc-solargraph', 'coc-tsserver']

" Trigger solargraph to format ruby code
let g:coc_user_config['solargraph.diagnostics'] = 'true'
let g:coc_user_config['solargraph.autoformat'] = 'true'
let g:coc_user_config['solargraph.formatting'] = 'true'

" ~~~~~~~~~~~~~~ VIM Plugs ~~~~~~~~~~~~~~~~~~
" Automatically installs vim-plugs if not installed on system
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" ~~~~~~~~~~~~~~~ Themes
Plug 'cocopon/iceberg.vim' " Winter
Plug 'YorickPeterse/Autumn.vim', { 'as': 'Autumn-vim' } " Fall
Plug 'rhysd/vim-color-spring-night' " Spring
Plug 'NLKNguyen/papercolor-theme' "Summer

Plug 'sonph/onehalf', { 'rtp': 'vim' }

" ~~~~~~~~~~~~~~~ LSP Client
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ~~~~~~~~~~~~~~~ Syntax highlighting
" Puppet syntax highlighting, etc.
Plug 'rodjek/vim-puppet'
" Pug syntax highlighting
Plug 'digitaltoad/vim-pug'
" Elixir syntax highlighting
Plug 'elixir-editors/vim-elixir'
Plug 'gabrielelana/vim-markdown'
Plug 'pangloss/vim-javascript'
" MJML Synta Highlighting
Plug 'amadeus/vim-mjml'

" ~~~~~~~~~~~~~~~ Useful tools
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'majutsushi/tagbar'
Plug 'editorconfig/editorconfig-vim'
Plug 'mileszs/ack.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-dadbod'

" ~~~~~~~~~~~~~~~ Other
Plug 'google/yapf'
Plug 'jparise/vim-graphql'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'dense-analysis/ale'

" SYNTAX HIGHLIGHTING
Plug 'rodjek/vim-puppet'
Plug 'digitaltoad/vim-pug'
Plug 'elixir-editors/vim-elixir'
Plug 'jasdel/vim-smithy'
Plug 'ekalinin/Dockerfile.vim'
Plug 'tfnico/vim-gradle'
Plug 'slim-template/vim-slim'
call plug#end()

colorscheme onehalfdark
