# shellcheck disable=SC2034
reset=$(tput sgr0)
# shellcheck disable=SC2034
bold=$(tput bold)
# shellcheck disable=SC2034
red=$(tput setaf 1)
# shellcheck disable=SC2034
green=$(tput setaf 2)
# shellcheck disable=SC2034
lime_yellow=$(tput setaf 190)
# shellcheck disable=SC2034
yellow=$(tput setaf 3)
# shellcheck disable=SC2034
powder_blue=$(tput setaf 153)
# shellcheck disable=SC2034
blue=$(tput setaf 4)
# shellcheck disable=SC2034
magenta=$(tput setaf 5)
# shellcheck disable=SC2034
cyan=$(tput setaf 6)
# shellcheck disable=SC2034
white=$(tput setaf 7)
# shellcheck disable=SC2034
blink=$(tput blink)
# shellcheck disable=SC2034
reverse=$(tput smso)
# shellcheck disable=SC2034
underline=$(tput smul)

LANG="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="pt_BR.UTF-8"
LC_TIME="pt_BR.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="pt_BR.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="pt_BR.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="pt_BR.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
export LANG LC_TYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT LC_IDENTIFICATION

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Use bash-completion, if available
# shellcheck disable=SC1091
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

LS_COLORS="di=1;34;40:ln=1;35;40:so=1;32;40:pi=1;33;40:ex=1;31;40:bd=1;34;46:cd=1;0;44:su=1;0;41:sg=1;0;46:tw=1;0;42:ow=1;0;43:"
export LS_COLORS

YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export YAOURT_COLORS

export PS1
PS1="\[$bold\][\[$blue\]\[$bold\]\u\[$reset\]\[$bold\]@\[$bold\]\[$green\]\h \[$bold\]\[$red\]\A \[$magenta\]\[$bold\]\W\[$reset\]\[$bold\]]\[$bold\]:\$\[$(tput sgr0)\] "

#export TERM=gnome

# ALIASES
alias ls='ls --color=auto'
alias grep='grep --color=always'
alias dockerm="docker rm \$(docker ps -a -q)"
alias dockermi="docker rmi \$(docker images -q)"
# http://blog.pixelastic.com/2015/09/29/better-listing-of-docker-images-and-container/
alias netalyzr="java -jar ~/.NetalyzrCLI.jar"
alias apgdiff="java -jar ~/.apgdiff-2.4.jar"
alias tmux="tmux -2"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias vimrc="vim ~/.vimrc"
alias btime="/usr/bin/time --format='\n%C took %e seconds.'"
alias docker="btime docker"
alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}' \${CID}"

# FUNCTIONS
extract () {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

comp32 () { 
    gcc -m32 -E -o "${1%.*}".i "$1"
    gcc -m32 -S -o "${1%.*}".s "${1%.*}".i
    gcc -m32 -c -o "${1%.*}".o "${1%.*}".s
    gcc -m32 -o "${1%.*}" "${1%.*}".o
}

docker-cleasing () {
# shellcheck disable=SC2046
    docker kill $(docker ps -q)
# shellcheck disable=SC2046
    docker rm -v -f $(docker ps -a -q -f status=exited)
# shellcheck disable=SC2046
    docker rmi -f $(docker images -a -q)
# shellcheck disable=SC2046
    docker volume rm $(docker volume ls -qf dangling=true)
    sudo rm -rf /var/lib/docker/tmp/*
}


case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

case ${TERM} in

    screen*)

        # user command to change default pane title on demand
        function title { TMUX_PANE_TITLE="$*"; }

        # function that performs the title update (invoked as PROMPT_COMMAND)
        function update_title { printf "\033]2;%s\033\\" "${1:-$TMUX_PANE_TITLE}"; }

        # default pane title is the name of the current process (i.e. 'bash')
        TMUX_PANE_TITLE=$(ps -o comm $$ | tail -1)

        # Reset title to the default before displaying the command prompt
        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'update_title'   

        # Update title before executing a command: set it to the command
        trap 'update_title "$BASH_COMMAND"' DEBUG

        ;;

esac

## BASH configs

# Number of lines or commands to be added to history file
export HISTSIZE=50000

# Number of lines or commands that are allowed to be stored on history file
export HISTFILESIZE=50000

# Date and time added to history before each command is written on the history file
# It's formatted as: year/month/day - hour:minute:second
export HISTTIMEFORMAT="%Y/%m/%d - %T: "

# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

# append history entries..
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

