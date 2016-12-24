# dotfiles

Repositório com minhas configs pessoais do vim, bash e tmux.

Após clonar o repositório, devem ser feitos links simbólicos para as pastas/arquivos.

##### Plugins para o ViM:
pathogen.vim: https://github.com/tpope/vim-pathogen
syntastic: https://github.com/vim-syntastic/syntastic

##### Plugin para o TMUX:
tpm: https://github.com/tmux-plugins/tpm
tmux-battery: https://github.com/tmux-plugins/tmux-battery
tmux-continuum: https://github.com/tmux-plugins/tmux-continuum
tmux-copycat: https://github.com/tmux-plugins/tmux-copycat
tmux-logging: https://github.com/tmux-plugins/tmux-logging
tmux-online-status: https://github.com/tmux-plugins/tmux-online-status
tmux-prefix-highlight: https://github.com/tmux-plugins/tmux-prefix-highlight
tmux-resurrect: https://github.com/tmux-plugins/tmux-resurrect
tmux-sensible: https://github.com/tmux-plugins/tmux-sensible
tmux-sidebar: https://github.com/tmux-plugins/tmux-sidebar
tmux-yank: https://github.com/tmux-plugins/tmux-yank
vim-tmux: https://github.com/tmux-plugins/vim-tmux

Assumindo que você clone no seu `~/.vim`:
```bash
git clone http://github.com/username/dotvim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
ln -s ~/.vim/tmux.conf ~/.tmux.conf
ln -s ~/.vim/tmux ~/.tmux
```

E atualizar os plugins do ViM / TMUX:
```bash
git submodule foreach git pull origin master
```

##### Dependências de algum(ns) Plugins:
tmux-copy: `xclip` ou `xsel`
