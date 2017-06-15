set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'jiangmiao/auto-pairs'
Plugin 'tomasr/molokai'
Plugin 'klen/python-mode'
Plugin 'restore_view.vim'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'tpope/vim-markdown'
Plugin 'shime/vim-livedown'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'majutsushi/tagbar'
Plugin 'coot/CRDispatcher'
Plugin 'coot/EnchantedVim'
Plugin 'jacquesbh/vim-showmarks'

call vundle#end()            " required
filetype plugin indent on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Use spaces, not tabs
set expandtab
set shiftwidth=4
set tabstop=4

set smartindent
set relativenumber
set number

" Fix backspace on mac
set backspace=indent,eol,start

" Make it pretty
syntax on
colorscheme molokai
set foldmethod=syntax
set foldclose=all
set foldlevelstart=0
set foldnestmax=1

" Airline options
set laststatus=2
let g:airline#extensions#tabline#enabled = 1

" Mark options
let g:showmarks_marks = "abcdefghijklmnopqrstuvwxyz."
autocmd TextChanged * DoShowMarks
autocmd TextChangedI * DoShowMarks

" YouCompleteMe options
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_seed_identifiers_with_syntax = 1
"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_python_binary_path = 'python'

" Pymode options
let g:pymode_lint = 0
let g:pymode_lint_checkers = []

" Livedown options
let g:livedown_open = 0
let g:livedown_port = 1337
let g:livedown_browser = "google-chrome-stable"
autocmd BufEnter *.md LivedownPreview
autocmd BufLeave *.md LivedownKill

" Tablemode options
let g:table_mode_corner="|"
autocmd BufEnter *.md silent! TableModeEnable
autocmd BufLeave *.md silent! TableModeDisable

" Key mappings for buffers
nnoremap <C-j> :bp!<CR>
nnoremap <C-k> :bn!<CR>
inoremap <C-j> <esc>:bp!<CR>
inoremap <C-k> <esc>:bn!<CR>

" Autoreload vimrc
autocmd! bufwritepost .vimrc source %

" Color column on 81 to highlight end of line
call matchadd('ColorColumn', '\%81v', 100)

" Show whitespace
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" Persistent undo
set undodir=~/.vim/undo
set undofile

" Use semicolon for commands
nnoremap ; :

" Autocenter
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz

" Smart tab alignment function
function! Align()
    let l:before = strlen(getline("."))
    execute "normal! ^d0?\\v[^ \\t\\n\\r]\<CR>"
    execute "normal! ^y0$/\\v[^ \\t\\n\\r]\<CR>P"
    let l:after = strlen(getline("."))
    if l:before == l:after
        execute "normal! >>"
    endif
endfunction
nnoremap <Tab> :call Align()<CR>

" Enable hex editing via xxd
function! ToXXD()
    execute ":%!xxd"
endfunction
command! ToXXD call ToXXD()
function! FromXXD()
    execute ":%!xxd -r"
endfunction
command! FromXXD call FromXXD()
