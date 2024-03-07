if has('gui_running')
    colorscheme NeoSolarized
endif

set background=dark
set belloff=all
set vb t_vb=

if &encoding ==# 'latin1'
    set encoding=utf-8
endif

let s:dir = has('win32') ? '~/AppData/Local/Vim' : match(system('uname'), "Darwin") > -1 ? '~/Library/Vim' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
if !isdirectory(expand(s:dir))
    call mkdir(expand(s:dir), "p", 0770)
endif
if !isdirectory(expand(s:dir) . '/swap')
    call mkdir(expand(s:dir) . '/swap', "p", 0700)
endif
if !isdirectory(expand(s:dir) . '/backup')
    call mkdir(expand(s:dir) . '/backup', "p", 0700)
endif
if !isdirectory(expand(s:dir) . '/undo')
    call mkdir(expand(s:dir) . '/undo', "p", 0700)
endif
if isdirectory(expand(s:dir))
    if &directory =~# '^\.,'
        let &directory = expand(s:dir) . '/swap//,' . &directory
    endif
    if &backupdir =~# '^\.,'
        let &backupdir = expand(s:dir) . '/backup//,' . &backupdir
    endif
    if exists('+undodir') && &undodir =~# '^\.\%(,\|$\)'
        let &undodir = expand(s:dir) . '/undo//,' . &undodir
    endif
endif
if exists('+undofile')
    set undofile
endif

set backspace=indent,eol,start
set complete=.,w,b,u,t
set cscopeverbose
set display=lastline
set formatoptions=jcroql
set history=10000
set hlsearch
set incsearch
set langnoremap
if has('langremap')
    set langremap
endif
set laststatus=2
set nocompatible
set nrformats=bin,hex
set ruler
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set showcmd
set sidescroll=1
set smarttab
set tabpagemax=50
set tags=./tags;,tags
set ttyfast
set viminfo=!,'100,<50,s10,h
set wildmenu
set go-=mTLe
if has('gui_running') && has('win32')
    set rop=type:directx
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

set clipboard=unnamed " yank to clipboard
if has('win32')
    vnoremap <C-C> "+y
endif

" Bindings
set tabstop=4 softtabstop=4 shiftwidth=4 shiftround
set nowrap textwidth=0
set autoread autowrite
set splitbelow splitright
set number
set hidden

" Config
set go-=m
set go-=T
set go-=L
set go-=e " graphical tabs off

set nomodeline
set sessionoptions+=resize,winpos

set statusline=%<%f\ 
set stl+=[%{&ff}]
set stl+=[%{&fenc==\"\"?&enc:&fenc}]
set stl+=%y%m%r%=
set stl+=%-14.(%l,%c%V%)\ %P

set listchars=tab:├─,space:·,trail:~,extends:→,precedes:←
set showbreak=→\ 

syntax on

" vim: set ft=vim ff=unix et sw=4:
