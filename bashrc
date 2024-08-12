# shellcheck disable=SC1117
# shellcheck disable=SC2034

# If not running interactively, don't do anything
[ -z "$PS1" ] && [[ $- != *i* ]] && return

if [ -f ~/.local/share/blesh/ble.sh ]; then
  source ~/.local/share/blesh/ble.sh --noattach
fi

LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 begin="${EPOCHREALTIME}"

## ENVVARS

PATH="${PATH}:${HOME}/.local/bin:${HOME}/bin:${HOME}/go/bin:${HOME}/.kube/plugins/jordanwilson230"
PATH="${PATH}:${HOME}/.krew/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
export PATH

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

#if command -v gnome-keyring-daemon > /dev/null; then
#    if ! ps aux | grep --silent '[g]nome-keyring-daemon'; then
#      export "$(gnome-keyring-daemon --daemonize --start)"
#    fi
#fi

BAT_THEME="Coldark-Dark"
BAT_PAGER="delta"
PAGER="delta"
LANG="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_MONETARY="pt_BR.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MEASUREMENT="pt_BR.UTF-8"
LC_NAME="en_US.UTF-8"
LC_NUMERIC="pt_BR.UTF-8"
LC_PAPER="pt_BR.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_TIME="pt_BR.UTF-8"
export BAT_THEME \
       BAT_PAGER \
       PAGER \
       LANG \
       LC_TYPE \
       LC_NUMERIC \
       LC_TIME \
       LC_COLLATE \
       LC_MONETARY \
       LC_MESSAGES \
       LC_PAPER \
       LC_NAME \
       LC_ADDRESS \
       LC_TELEPHONE \
       LC_MEASUREMENT \
       LC_IDENTIFICATION

export PYTHONSTARTUP=~/.pythonrc

EDITOR=vim
export EDITOR

if uname | grep --silent "Darwin"; then
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
fi

LS_COLORS="di=1;34;40:ln=1;35;40:so=1;32;40:pi=1;33;40:ex=1;31;40:bd=1;34;46:cd=1;0;44:su=1;0;41:sg=1;0;46:tw=1;0;42:ow=1;0;43:"
export LS_COLORS

YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export YAOURT_COLORS

PS1="\[$reset\]\[$bold\][\[$blue\]\u\[$white\]@\[$green\]\h \[$red\]\t \[$magenta\]\W\[$white\]]:\\$\[$reset\] "
export PS1

HSTR_CONFIG=hicolor,case-sensitive,keywords-matching,raw-history-view,prompt-bottom
export HSTR_CONFIG

NVM_DIR="$HOME/.nvm"
export NVM_DIR

GOBIN="${HOME}/go/bin"
export GOBIN

if [ -f "/usr/lib/ssh/gnome-ssh-askpass4" ] ; then
  SSH_ASKPASS="/usr/lib/ssh/gnome-ssh-askpass4"
  SSH_AUTH_SOCK=/run/user/1000/gcr/ssh
  export SSH_ASKPASS SSH_AUTH_SOCK
fi

## END ENVVARS

## COMPLETIONS

if [ -f /opt/asdf-vm/asdf.sh ]; then
  source /opt/asdf-vm/asdf.sh
fi

if [ -f ~/.asdf/asdf.sh ]; then
  source ~/.asdf/asdf.sh
  source ~/.asdf/completions/asdf.bash
fi

if [ -f ~/projetos/local/z/z.sh ]; then
  source ~/projetos/local/z/z.sh
fi

# Use bash-completion, if available
# shellcheck disable=SC1091
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

_ble_contrib_fzf_base=$(asdf where fzf)

if [[ ${BLE_VERSION-} ]]; then
  ble-import -d integration/fzf-completion
  ble-import -d integration/fzf-key-bindings
else
  source "$(asdf where fzf)/shell/completion.bash" 2> /dev/null
fi

if command -v brew > /dev/null; then
  # bash_completion
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
      . "$(brew --prefix)/etc/bash_completion"
  fi
  # bash_completion@2
  [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && \
    . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

if command -v ketall > /dev/null; then
  source <(ketall completion bash)
fi

if command -v helm > /dev/null; then
  source <(helm completion bash)
fi

if command -v helm diff completion bash > /dev/null; then
  source <(helm diff completion bash)
fi

if command -v bigbang > /dev/null; then
  source <(bigbang completion bash)
fi

if command -v terraform > /dev/null; then
  complete -C "/var/lib/tfenv/versions/$(tfenv version-name)/terraform" terraform
  complete -C "/var/lib/tfenv/versions/$(tfenv version-name)/terraform" tf
fi

if command -v mc > /dev/null; then
  complete -C "$(command -v mc)" mc
fi

if command -v vault > /dev/null; then
  complete -C "$(command -v vault)" vault
fi

if command -v aws_completer > /dev/null; then
  complete -C "$(command -v aws_completer)" aws
fi

if command -v fluxctl > /dev/null; then
  source <(fluxctl completion bash)
fi

#if command -v cmctl > /dev/null; then
#  source <(cmctl completion bash)
#fi

if command -v vcluster > /dev/null; then
  source <(vcluster completion bash)
fi

if command -v kops > /dev/null; then
  source <(kops completion bash)
fi

if command -v kind > /dev/null; then
  source <(kind completion bash)
fi

if command -v cilium > /dev/null; then
  source <(cilium completion bash)
fi

if command -v tilt > /dev/null; then
  source <(tilt completion bash)
fi

if command -v kubectl > /dev/null; then
  source <(kubectl completion bash)
fi

if command -v kyverno > /dev/null; then
  source <(kyverno completion bash)
fi

if command -v glab > /dev/null; then
  source <(glab completion bash)
fi

if command -v flux > /dev/null; then
  source <(flux completion bash)
fi

if [[ -d ~/.kubech/ ]]; then
  source ~/.kubech/kubech
  source ~/.kubech/completion/kubech.bash
fi

if command -v hubble > /dev/null; then
  source <(hubble completion bash)
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## END COMPLETIONS

# ALIASES
alias ls='ls --color=auto'
#alias grep='grep --color=always'
alias dockerm="docker rm \$(docker ps -a -q)"
alias dockermi="docker rmi \$(docker images -q)"
# http://blog.pixelastic.com/2015/09/29/better-listing-of-docker-images-and-container/
alias netalyzr="java -jar ~/.NetalyzrCLI.jar"
alias apgdiff="java -jar ~/.apgdiff-2.4.jar"
alias tmux="tmux -2"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias meuip="curl -w '\n' ipinfo.io/ip"
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias blerc="vim ~/.blerc && source ~/.bashrc"
alias bashHist="vim ~/.bash_history"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"
if uname | grep -q "Darwin"; then
    alias btime="/usr/local/opt/gnu-time/libexec/gnubin/time --format='\n%C took %e seconds.'"
else
    alias btime="/usr/bin/time --format='\n%C took %e seconds.'"
fi
alias docker="btime docker"
alias wttr="curl wttr.in"
alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"
alias kch="kubech"
alias g="git"
alias tf="terraform"
alias tg="terragrunt"
alias bb="bigbang"
alias ka="kube-auth --auth-only"
alias hh="hstr"
alias d="docker"
alias inputrc="vim ~/.inputrc && exec bash"
alias sshconfig="vim ~/.ssh/config"
alias watch="watch "
alias bfg="java -jar ~/.local/lib/bfg-1.14.0.jar"
alias docker-compose="docker compose"
alias h="helm"
alias f="flux"
alias ky="kyverno"

# FUNCTIONS
source "${HOME}/.vim/work/wls.sh"

function home() {
  export CDPATH="$HOME"
}

function unhome() {
  unset CDPATH
}

function sidt() {
  curl -LSs 'https://shouldideploy.today/api?tz=America%2FSao_Paulo'
  printf "\n"
}

if uname | grep --silent "Darwin"; then
  function flush-dns() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  }
fi

function hsbattery() {
  local headset_status headset_emoji
  headset_status="$(headsetcontrol -b)"
  headset_emoji="🎧"
  headset_lightning="⚡"
  headset_not="🚫"
  if echo "${headset_status}" | grep --quiet "Charging"; then
    echo "${headset_emoji}  ${headset_lightning}"
  elif echo "${headset_status}" | grep --quiet "%"; then
    echo "${headset_emoji} $(ag % <<< "${headset_status}" | awk '{ print $2 }')"
  elif echo "${headset_status}" | grep --quiet "Failed to request battery."; then
    echo "${headset_emoji}  ${headset_not}"
  fi
}

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

    echo

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
    datesecstoend=$(( $(date +%s) + "$@" )) 
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

function generateUnicastMacAddress() {
    od -An -N6 -tx1 /dev/urandom | sed -e 's/^  *//' -e 's/  */:/g' -e 's/:$//' -e 's/^\(.\)[13579bdf]/\10/'
}

function copy2Clipboard() {
    cat "$@" | xsel -bi
}

function cheat-sheet() {
    curl "https://cheat.sh/$@"
}

# https://unix.stackexchange.com/a/83927/100610
function __wget() {
    : ${DEBUG:=0}
    local URL=$1
    local tag="Connection: close"
    local mark=0

    if [ -z "${URL}" ]; then
        printf "Usage: %s \"URL\" [e.g.: %s http://www.google.com/]" \
               "${FUNCNAME[0]}" "${FUNCNAME[0]}"
        return 1;
    fi
    read proto server path <<<$(echo ${URL//// })
    DOC=/${path// //}
    HOST=${server//:*}
    PORT=${server//*:}
    [[ x"${HOST}" == x"${PORT}" ]] && PORT=80
    [[ $DEBUG -eq 1 ]] && echo "HOST=$HOST"
    [[ $DEBUG -eq 1 ]] && echo "PORT=$PORT"
    [[ $DEBUG -eq 1 ]] && echo "DOC =$DOC"

    exec 3<>/dev/tcp/${HOST}/$PORT
    echo -en "GET ${DOC} HTTP/1.1\r\nHost: ${HOST}\r\n${tag}\r\n\r\n" >&3
    while read line; do
        [[ $mark -eq 1 ]] && echo $line
        if [[ "${line}" =~ "${tag}" ]]; then
            mark=1
        fi
    done <&3
    exec 3>&-
}

function histCount() {
  local count="$1"
  HISTTIMEFORMAT="" history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n "${count:-10}"
}

function _authy() {
  sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
  sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
  sudo systemctl start snapd.apparmor.service
  /var/lib/snapd/snap/bin/authy
}

function checkRpgMode() {
  if [[ "${RPG_MODE}" == 'true' ]]; then
    true
  else
    false
  fi
}

#if command -v rpg-cli > /dev/null; then
#  function cd () {
#    if [[ "$#" -eq 0 ]]; then
#      rpg-cli "${HOME}"
#    else
#      rpg-cli "$1"
#    fi
#    builtin cd "$(rpg-cli --pwd)"
#  }
#fi

function ho() {
  tmux new-session -d -s hubble
  tmux split-window -h -t hubble
  tmux send -t hubble.1 \
    "cilium hubble port-forward" \
  ENTER
  tmux send -t hubble.2 \
    "sleep 3; hubble observe -t $1 -f" \
  ENTER
  tmux attach-session -t hubble
}

function lk() {
  cd "$(walk --icons "$@")" || return
}

function kgetall() {
  namespace=$1
  context=$2
  if [[ "$namespace" == "" ]]; then
    namespace=$(kubens -c)
  fi
  if [[ "$context" == "" ]]; then
    context=$(kubectx -c)
  fi
  echo "cluster: $context"
  echo "namespace: $namespace"
  mapfile -t namespaced_resources < <(kubectl api-resources --verbs=list --namespaced -o name --context "$context" | grep -v events | sort)
  for namespaced_resource in "${namespaced_resources[@]}"; do
    kubectl get --show-kind --ignore-not-found -n "${namespace}" "${namespaced_resource}" --context "$context"
  done
}

function delk8s() {
  cluster_name="$1"

  kubectl config unset "users.$cluster_name"
  kubectl config unset "contexts.$cluster_name"
  kubectl config unset "clusters.$cluster_name"
}

sort_history() {
  # /^$/d            # skip blank lines
  # /^#/N            # append next line to timestamp
  # /^#/!s/^/#0\n/   # command without timestamp - prefix with #0
  # s/#//            # remove initial #
  # y/\n/ /          # convert newline to space
  # s/(\S+) /#\1\n/  # restore the timestamp

  sed -e '/^$/d' -e '/^#/N' -e '/^#/!s/^/#0\n/' \
      -e 's/#//' -e 'y/\n/ /' <<<"$in" \
    | sort -n | sed -e 's/\(\S\+\) /#\1\n/'
}


# END FUNCTIONS

## BASH configs

if [[ -n "${TMUX}" ]]; then
  export TERM="xterm-256color"
fi

# Number of lines or commands to be added to history file
export HISTSIZE=-1

# Number of lines or commands that are allowed to be stored on history file
export HISTFILESIZE=-1

# Date and time added to history before each command is written on the history file
# It's formatted as: year/month/day - hour:minute:second
export HISTTIMEFORMAT="%Y/%m/%d - %T: "

# avoid duplicates..
# Comandos iguais não são adicionados e adicionados ao histórico
HISTCONTROL="ignoreboth"
export HISTCONTROL

HISTIGNORE="&,'[ ]*',history:hstr:bashHist"
export HISTIGNORE

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
#PROMPT_COMMAND="history -a; history -c; history -r"
#export PROMPT_COMMAND

if uname | grep --silent "Darwin"; then
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-time/libexec/gnubin:$PATH:${HOME}/.local/bin:/var/lib/snapd/snap/bin"
fi

## END BASH configs

## Binds

if [[ $- =~ .*i.* ]]; then
  bind '"\M-e": "\C-ahstr -- \C-j"'
  ble-bind -m 'emacs' -x "C-b" '__atuin_history --keymap-mode=emacs'
fi

LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 end="${EPOCHREALTIME}"

echo "duration: $(calc -p "$end" - "$begin") seconds."

[[ ${BLE_VERSION-} ]] && ble-attach

eval "$(atuin init bash --disable-up-arrow)"
