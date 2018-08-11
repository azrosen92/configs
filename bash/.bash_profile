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

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
 	# https://github.com/magicmonty/bash-git-prompt/blob/master/README.md
  GIT_PROMPT_THEME=Single_line
  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
fi

##
# Pebble development stuff.
##
export PEBBLE_PHONE="192.168.1.3"
alias pebbleinstall="pebble build && pebble install"

export NVM_DIR="/Users/AaronRosen/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

if ssh-add -l | grep "The agent has no identities."; then
	ssh-add -k ~/.ssh/id_rsa
fi

source $HOME/.bash_local
