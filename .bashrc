[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

if [ -x "$(command -v atuin)" ]; then
  eval "$(atuin init bash)"
fi

if [ -x "$(command -v starship)" ]; then
  eval "$(starship init bash)"
fi

if [ -x "$(command -v zoxide)" ]; then
  eval "$(zoxide init bash --cmd cd)"
fi

source .commonrc

if [[ "$OSTYPE" == "darwin"* ]]
then
    export REQUESTS_CA_BUNDLE="$HOME/.mac-ca-roots"
    tmux new-session -A -s mac
else
    tmux new-session -A -s linux
fi