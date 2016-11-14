nmap <space> :
set nocompatible    " Compatible with the old vi. Don't want to be compatible. Want to use the new features
filetype off

"------Plugin section begin------
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'

Plugin 'scrooloose/nerdtree'

Plugin 'Raimondi/delimitMate'

Plugin 'klen/python-mode'

call vundle#end()

nmap ? :NERDTree<CR>

" Filetype identification
filetype on
filetype plugin on
filetype plugin indent on
syntax on
syntax enable

" Indentation management
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set autoindent

set incsearch   " Set full-text search to begin searching from current position
set hlsearch    " Highlight results
set ignorecase

" Miscellaneous helpful configurations
set showcmd
set smartcase
set mousehide
set showmatch
set hidden
set ruler
set laststatus=2
set exrc
set secure
set backspace=2
set backspace=indent,eol,start  " Manually enable backspsace, since PyMode sometimes conflicts

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%81v.*/
    autocmd FileType python set nowrap
    augroup END
