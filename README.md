# dotfiles

Repositório com minhas configs pessoais do vim, bash e tmux.

Após clonar o repositório, devem ser feitos links simbólicos para as pastas/arquivos.

#### Docker
Imagem Docker disponível, contendo minhas dotFiles:
```
docker pull l30bola/dotFiles
```

##### Plugins para o ViM:
pathogen: https://github.com/tpope/vim-pathogen <br>
syntastic: https://github.com/vim-syntastic/syntastic <br>
Dockerfile: https://github.com/ekalinin/Dockerfile.vim <br>
eunuch: https://github.com/tpope/vim-eunuch <br>
surround: https://github.com/tpope/vim-surround <br>
fugitive: https://github.com/tpope/vim-fugitive <br>
tbone: https://github.com/tpope/vim-tbone <br>

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

Assumindo que você clone no seu `~/.vim`:
```bash
git clone git@github.com:L30Bola/dotfiles.git ~/.vim || git clone https://github.com/L30Bola/dotfiles.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
ln -s ~/.vim/tmux.conf ~/.tmux.conf
ln -s ~/.vim/tmux ~/.tmux
ln -s ~/.vim/bash_profile ~/.bash_profile
ln -s ~/.vim/gitconfig ~/.gitconfig
cd ~/.vim
git submodule init
git submodule update --recursive
```
Ou simplesmente execute o prepareHome.sh, que faz exatamente a mesma coisa:
```
~/.vim/prepareHome.sh
```

E atualizar os plugins do ViM / TMUX:
```bash
git submodule foreach git pull origin master
```

##### Dependências de algum(ns) Plugins:
tmux-copy: `xclip` ou `xsel`
