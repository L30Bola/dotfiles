execute pathogen#infect()
execute pathogen#helptags()

set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

syntax on
filetype plugin indent on

" vim-latex-live-preview settings
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'evince'
