# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS EXTENDED_HISTORY

# Completion
autoload -Uz compinit && compinit

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
