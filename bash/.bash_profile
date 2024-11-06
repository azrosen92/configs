source $HOME/.dotfiles/alias
source $HOME/.dotfiles/env_vars
source $HOME/.dotfiles/path
source $HOME/.dotfiles/custom_scripts

export VISUAL=vim
export EDITOR=$VISUAL

if [ -f $HOME/.bash_local ]; then
  source $HOME/.bash_local
fi

##
# NVM setup (depends on NPM_TOKEN in bash_local)
##
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

##
# Setup pyenv, if available.
##
if command -v pyenv 1>/dev/null 2>&1; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"

  # setup path for pipenv
  export PATH="$(python -m site --user-base)/bin:$PATH"
fi

##
# Completion for git machete
eval "$(git machete completion zsh)"

