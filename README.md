# dotfiles

Repositório com minhas configs pessoais do vim, bash e tmux.

Após clonar o repositório, devem ser feitos links simbólicos para as pastas/arquivos.

##### Plugins para o ViM:
pathogen.vim: https://github.com/tpope/vim-pathogen <br>
syntastic: https://github.com/vim-syntastic/syntastic

##### Plugin para o TMUX:
tpm: https://github.com/tmux-plugins/tpm <br>
tmux-battery: https://github.com/tmux-plugins/tmux-battery <br>
tmux-continuum: https://github.com/tmux-plugins/tmux-continuum <br>
tmux-copycat: https://github.com/tmux-plugins/tmux-copycat <br>
tmux-logging: https://github.com/tmux-plugins/tmux-logging <br>
tmux-online-status: https://github.com/tmux-plugins/tmux-online-status <br>
tmux-prefix-highlight: https://github.com/tmux-plugins/tmux-prefix-highlight <br>
tmux-resurrect: https://github.com/tmux-plugins/tmux-resurrect <br>
tmux-sensible: https://github.com/tmux-plugins/tmux-sensible <br>
tmux-sidebar: https://github.com/tmux-plugins/tmux-sidebar <br>
tmux-yank: https://github.com/tmux-plugins/tmux-yank <br>
vim-tmux: https://github.com/tmux-plugins/vim-tmux <br>

Assumindo que você clone no seu `~/.vim`:
```bash
git clone https://github.com/L30Bola/dotfiles.git ~/.vim OU git clone git@github.com:L30Bola/dotfiles.git ~/.vim
cd ~/.vim
git submodule init
git submodule update --recursive
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
ln -s ~/.vim/tmux.conf ~/.tmux.conf
ln -s ~/.vim/tmux ~/.tmux
ln -s ~/.vim/bash_profile ~/.bash_profile
```

E atualizar os plugins do ViM / TMUX:
```bash
git submodule foreach git pull origin master
```

##### Dependências de algum(ns) Plugins:
tmux-copy: `xclip` ou `xsel`
