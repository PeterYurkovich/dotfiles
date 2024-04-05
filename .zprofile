
if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2024-03-05 14:51:52
export PATH="$PATH:$HOME/.local/bin"

if [[ "$OSTYPE" == "darwin"* ]]; then
  PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
  export PATH
fi;
