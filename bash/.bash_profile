source $HOME/.dotfiles/alias
source $HOME/.dotfiles/env_vars
source $HOME/.dotfiles/golang
source $HOME/.dotfiles/path
source $HOME/.dotfiles/custom_scripts

# Simlink everything in $HOME/Documents/code/bash to /usr/sbin.
ln -s -f $DEV_DIRECTORY/bash/* /usr/local/sbin

export VISUAL=vim
export EDITOR=$VISUAL

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
else
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  . ~/.git-completion.bash
fi
if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
  GIT_PROMPT_THEME=Single_line
  source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
fi

##
# Pebble development stuff.
##
export PEBBLE_PHONE="192.168.1.3"
alias pebbleinstall="pebble build && pebble install"

export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

if ssh-add -l | grep "The agent has no identities."; then
	ssh-add -k ~/.ssh/id_rsa
fi

if [ -f $HOME/.bash_local ]; then
  source $HOME/.bash_local
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
