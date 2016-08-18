reset=$(tput sgr0)
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
        . /usr/share/bash-completion/bash_completion

LS_COLORS="di=1;34;40:ln=1;35;40:so=1;32;40:pi=1;33;40:ex=1;31;40:bd=1;34;46:cd=1;0;44:su=1;0;41:sg=1;0;46:tw=1;0;42:ow=1;0;43:"
export LS_COLORS

YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export YAOURT_COLORS

export PS1="\[$bold\][\[$blue\]\[$bold\]\u\[$reset\]\[$bold\]@\[$bold\]\[$green\]\h \[$bold\]\[$red\]\A \[$magenta\]\[$bold\]\W\[$reset\]\[$bold\]]\[$bold\]:\\$\[$(tput sgr0)\] "

#export TERM=gnome

# ALIASES
alias ls='ls --color=auto'
alias grep='grep --color=always'
alias dockerm="docker rm $(docker ps -a -q)"
alias dockermi="docker rmi $(docker images -q)"
# http://blog.pixelastic.com/2015/09/29/better-listing-of-docker-images-and-container/
alias netalyzr="java -jar ~/.NetalyzrCLI.jar"
alias apgdiff="java -jar ~/.apgdiff-2.4.jar"
alias tmux="tmux -2"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias btime="/usr/bin/time --format='\n%C took %e seconds.'"
alias docker="btime docker"

# FUNCTIONS
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

# append history entries..
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


