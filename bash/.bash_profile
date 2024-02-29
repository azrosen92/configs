source $HOME/.dotfiles/alias
source $HOME/.dotfiles/env_vars
source $HOME/.dotfiles/path
source $HOME/.dotfiles/custom_scripts

export VISUAL=vim
export EDITOR=$VISUAL

if [ ! -d ~/.zsh ]; then
  # Create the folder structure
  mkdir -p ~/.zsh

  # Download the scripts
  curl -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  curl -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
fi

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_THEME=Single_line
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

##
# Pebble development stuff.
##
export PEBBLE_PHONE="192.168.1.3"
alias pebbleinstall="pebble build && pebble install"


if ssh-add -l | grep "The agent has no identities."; then
	ssh-add -k ~/.ssh/id_ed25519
fi

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
# Set up asdf for version management
##
. "$(brew --prefix asdf)/libexec/asdf.sh"
. "$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"

##
# Completion for git machete
eval "$(git machete completion zsh)"

