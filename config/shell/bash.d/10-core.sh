# Core bash behavior.

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33;40:cd=1;33;40:su=1;32;40:sg=1;32;40:tw=1;32;40:ow=1;32;40'
export CLICOLOR=1
export TERM=xterm-256color

if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell
shopt -s globstar

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi