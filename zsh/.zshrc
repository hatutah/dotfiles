# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS EXTENDED_HISTORY

# Completion
autoload -Uz compinit && compinit

# Aliases (the oh-my-zsh core set worth keeping)
alias l='ls -lah' ll='ls -lh' la='ls -lAh'
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS   # bare dir name cd's; every cd feeds the stack for 1-9
alias -- -='cd -'
for i in 1 2 3 4 5 6 7 8 9; do alias "$i"="cd -$i"; done; unset i
alias -g ...='../..' ....='../../..' .....='../../../..'

# PATH
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# Prompt
eval "$(starship init zsh)"

# Tools
eval "$(zoxide init zsh)"
source <(fzf --zsh)
source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Machine/work-specific config, untracked
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
