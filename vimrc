runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()

set encoding=utf-8
set fileencoding=utf-8
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
set number
set backspace=indent,eol,start

" F3 enables and disables the line numbering inside ViM
noremap <F3> :set invnumber<CR>
inoremap <F3> <C-O>:set invnumber<CR>

syntax on
filetype plugin indent on
set background=dark

" vim-latex-live-preview settings
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'evince'

" START: auto paste-mode when pasting in INSERT mode with support for TMUX
" Source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" END: auto paste-mode when pasting in INSERT mode with support for TMUX

" syntastic
set statusline+=%{FugitiveStatusline()}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
