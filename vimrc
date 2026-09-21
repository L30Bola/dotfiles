" Installs vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Init vim-plug and the plugins
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ekalinin/dockerfile.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-scriptease'
Plug 'tmux-plugins/vim-tmux'
Plug 'hashivim/vim-terraform'
Plug 'glench/vim-jinja2-syntax'
Plug 'towolf/vim-helm'
Plug 'stephpy/vim-yaml'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" coc.nvim essentials
" Setup: https://cocnvim.com/install
" Reference: https://cocnvim.com/docs and :help coc.txt
let g:coc_global_extensions = [
      \'coc-yaml',
      \'coc-vimlsp',
      \'coc-sh',
      \'coc-pyright',
      \'coc-markdownlint',
      \'coc-json',
      \'coc-go',
      \'coc-docker',
      \'coc-yank',
      \'coc-snippets',
      \'coc-highlight',
      \'coc-git'
      \]

" Recommended runtime options. A fixed sign column prevents diagnostic signs
" from shifting the buffer left and right.
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set laststatus=2

" Show coc.nvim status, including extension installation progress. Keep this
" idempotent so sourcing vimrc does not prepend the item repeatedly.
if stridx(&statusline, '%{coc#status()}') == -1
  set statusline^=%{coc#status()}
endif

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Trigger completion with Tab and navigate the completion menu.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \ : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

" Diagnostics and code navigation.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)

filetype plugin indent on
set encoding=utf-8
set fileencoding=utf-8
set tabstop=2
set softtabstop=0
set expandtab
set shiftwidth=2
set smarttab
set number
set backspace=indent,eol,start
set background=dark
set hlsearch
set incsearch
set autoindent
set smartindent
set mouse=nicr
set mousehide
set hidden
set t_Co=256

" Persist yanked and deleted text between sessions. Vim's defaults only keep
" 50 lines per register and skip registers larger than 10 KiB.
set viminfo='100,<1000,s1000,h

highlight Pmenu ctermfg=Black ctermbg=DarkGray
highlight PmenuSel ctermfg=White ctermbg=Gray cterm=underline,bold
highlight PmenuSbar ctermfg=NONE ctermbg=DarkGray
highlight PmenuThumb ctermfg=Gray ctermbg=NONE

set list                    " Show invisible characters using listchars
set listchars=""            " Reset the listchars
set listchars=tab:›\        " show tabs as lsaquos
set listchars+=trail:·      " show trailing spaces as dots
set listchars+=nbsp:·       " show trailing non-breaking-spaces as dots
set listchars+=extends:❯    " The character in the last column when the line continues right
set listchars+=precedes:❮   " The character in the first column when the line continues left

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" F3 enables and disables the line numbering inside ViM
noremap <F3> :set invnumber<CR>
inoremap <F3> <C-O>:set invnumber<CR>

nnoremap <C-Left> :bprevious<CR>
nnoremap <C-Right> :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

nnoremap <F4> :call ToggleSignColumn()<CR>

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Toggle signcolumn. Works only on vim>=8.0 or NeoVim
function! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        let b:signcolumn_on=0
    else
        set signcolumn=auto
        let b:signcolumn_on=1
    endif
endfunction

" Save cursor pointer location
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Put plugins and dictionaries in this dir
let vimDir = '$HOME/.vim'

if stridx(&runtimepath, expand(vimDir)) == -1
  " vimDir is not on runtimepath, add it
  let &runtimepath.=','.vimDir
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    silent call system('mkdir -p ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

"" START: auto paste-mode when pasting in INSERT mode with support for TMUX
"" Source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
"function! WrapForTmux(s)
"  if !exists('$TMUX')
"    return a:s
"  endif
"
"  let tmux_start = "\<Esc>Ptmux;"
"  let tmux_end = "\<Esc>\\"
"
"  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
"endfunction
"
"let &t_SI .= WrapForTmux("\<Esc>[?2004h")
"let &t_EI .= WrapForTmux("\<Esc>[?2004l")
"
"function! XTermPasteBegin()
"  set pastetoggle=<Esc>[201~
"  set paste
"  return ""
"endfunction
"
"inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
"" END: auto paste-mode when pasting in INSERT mode with support for TMUX
