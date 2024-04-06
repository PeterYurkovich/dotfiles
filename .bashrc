# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
. "$HOME/.cargo/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree --depth 2'

alias tm='tmux'
alias tma='tmux attach'

alias vim='nvim'
alias k='kubectl'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'

eval "$(atuin init bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash --cmd cd)"

tmux new-session -A -s fedora

clear

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# fnm
export PATH="/home/pyn/.local/share/fnm:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
eval "`fnm env`"
