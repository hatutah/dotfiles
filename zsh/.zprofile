# Login shells only: environment and PATH. Interactive config lives in .zshrc.
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

ulimit -n 65536
ulimit -f unlimited

# 1Password SSH agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# OrbStack command-line tools
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
