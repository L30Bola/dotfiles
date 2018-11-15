# shellcheck disable=SC1117 
# shellcheck disable=SC2034

if [[ $- == *i* ]]; then
    reset=$(tput sgr0)
    bold=$(tput bold)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    lime_yellow=$(tput setaf 190)
    yellow=$(tput setaf 3)
    powder_blue=$(tput setaf 153)
    blue=$(tput setaf 4)
    magenta=$(tput setaf 5)
    cyan=$(tput setaf 6)
    white=$(tput setaf 7)
    blink=$(tput blink)
    reverse=$(tput smso)
    underline=$(tput smul)
fi

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
export PYTHONSTARTUP=~/.pythonrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Use bash-completion, if available
# shellcheck disable=SC1091
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

LS_COLORS="di=1;34;40:ln=1;35;40:so=1;32;40:pi=1;33;40:ex=1;31;40:bd=1;34;46:cd=1;0;44:su=1;0;41:sg=1;0;46:tw=1;0;42:ow=1;0;43:"
export LS_COLORS

YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export YAOURT_COLORS

PS1="\[$reset\]\[$bold\][\[$blue\]\u\[$white\]@\[$green\]\h \[$red\]\A \[$magenta\]\W\[$white\]]:\$\[$reset\] "
export PS1

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
alias meuip="curl https://ipinfo.io/ip"
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias bashHist="vim ~/.bash_history"
alias vimrc="vim ~/.vimrc"
alias btime="/usr/bin/time --format='\n%C took %e seconds.'"
alias docker="btime docker"

# FUNCTIONS

function md5CrtlC() {
    echo -n "$1" | md5sum | awk '{ printf $1 }' | xsel -bi
}

function transfer() {
    if [ ! "$(command -v curl 2> /dev/null)" ]; then
        echo "cURL is not installed. Exiting...";
        return 1
    fi

    # check arguments
    if [ $# -eq 0 ]; then 
        printf "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md\n"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$(mktemp -t transferXXX)
    
    # upload stdin or file
    file=$1

    if tty -s; then 
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g') 

        if [ ! -e "$file" ]; then
            echo "File $file doesn't exists."
            return 1
        fi
        
        if [ -d "$file" ]; then
            # zip directory and transfer
            zipfile=$(mktemp -t transferXXX.zip)
            cd "$(dirname "$file")" && zip -r -q - "$(basename "$file")" >> "$zipfile"
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> "$tmpfile"
            rm -f "$zipfile"
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> "$tmpfile"
        fi
    else 
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> "$tmpfile"
    fi
   
    # cat output link
    cat "$tmpfile"

    # cleanup
    rm -f "$tmpfile"
}

function extract () {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function comp32() { 
    gcc -m32 -E -o "${1%.*}".i "$1"
    gcc -m32 -S -o "${1%.*}".s "${1%.*}".i
    gcc -m32 -c -o "${1%.*}".o "${1%.*}".s
    gcc -m32 -o "${1%.*}" "${1%.*}".o
}

function docker-cleasing() {
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

function countdown() {
    datesecstoend=$(( $(date +%s) + $1 )) 
    while [ "$datesecstoend" -ge "$(date +%s)" ]; do 
        echo -ne "$(date -u --date @$(( datesecstoend - $(date +%s) )) +%H:%M:%S)\r"
        sleep 0.1
    done
}

function stopwatch() {
    datesecs=$(date +%s)
    while true; do 
        echo -ne "$(date -u --date @$(( $(date +%s) - datesecs )) +%H:%M:%S)\r"
        sleep 0.1
    done
}

function __notification_prompt_command() { 
    local lastcommand
    lastcommand=$(HISTTIMEFORMAT='' history 1 | sed 's/^ *[0-9]\+ *//')
    lastcommand="${lastcommand//;/ }"
    printf "\033]777;notify;Command completed;%s\007" "${lastcommand}"
}

function generateUnicastMacAddress() {
    od -An -N6 -tx1 /dev/urandom | sed -e 's/^  *//' -e 's/  */:/g' -e 's/:$//' -e 's/^\(.\)[13579bdf]/\10/'
}

function copy2Clipboard() {
    cat "$@" | xsel -bi
}

# END FUNCTIONS

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
if [[ "${BASH_VERSINFO[0]}" -gt 4 ]] || ( [[ ${BASH_VERSINFO[0]} -eq 4 ]] && [[ ${BASH_VERSINFO[1]} -ge 3 ]] ); then
    export HISTSIZE=-1
else
    export HISTSIZE=
fi

# Number of lines or commands that are allowed to be stored on history file
if [[ "${BASH_VERSINFO[0]}" -gt 4 ]] || ( [[ ${BASH_VERSINFO[0]} -eq 4 ]] && [[ ${BASH_VERSINFO[1]} -ge 3 ]] ); then
    export HISTFILESIZE=-1
else
    export HISTFILESIZE=
fi

# Date and time added to history before each command is written on the history file
# It's formatted as: year/month/day - hour:minute:second
export HISTTIMEFORMAT="%Y/%m/%d - %T: "

# avoid duplicates..
# Comandos iguais não são adicionados e adicionados ao histórico
export HISTCONTROL=ignoreboth:erasedups

# append history entries..
# Sempre concatena os comandos inseridos no bash_history
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Verifica o comando do histórico sem utilizá-lo antes
shopt -s histverify

# After each command, save and reload history
# Após cada comando, o bash_history é salvo e "relido"
# Alguns programas não conseguem resolver essa variável
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export PATH="$PATH:/opt/mssql-tools/bin"

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if [ -f ~/.bashhub/bashhub.sh ]; then
    source ~/.bashhub/bashhub.sh
fi

