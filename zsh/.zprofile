#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

#ls
alias ls="ls -1 --color=tty"


eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

export PATH="$PATH:/Users/hatutah/development/flutter/bin"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

ulimit -n 65536 200000
ulimit -f unlimited

#rust
. "$HOME/.cargo/env"

# 1pass ssh
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock


# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# rust
. "$HOME/.cargo/env"


# Added by Antigravity CLI installer
export PATH="/Users/hatutah/.local/bin:$PATH"

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
