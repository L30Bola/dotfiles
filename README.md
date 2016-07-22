# dotfiles

Repositório com minhas configs pessoais do vim, bash e tmux.

Após clonar o repositório, devem ser feitos links simbólicos para as pastas/arquivos. 

Assumindo que você clone no seu `~/.vim`:
```bash
git clone http://github.com/username/dotvim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
ln -s ~/.vim/tmux.conf ~/.tmux.conf
ln -s ~/.vim/tmux ~/.tmux
```

E atualizar os plugins do ViM:
```bash
git submodule foreach git pull origin master
```
