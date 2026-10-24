# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS EXTENDED_HISTORY
setopt SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_SPACE HIST_VERIFY   # tabs share; " cmd" stays out; !! shows before running
setopt INTERACTIVE_COMMENTS   # allow trailing # comments on the command line

# Completion
autoload -Uz compinit && compinit
setopt COMPLETE_IN_WORD ALWAYS_TO_END AUTO_MENU
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'   # case/-_ insensitive
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"

# Aliases (the oh-my-zsh core set worth keeping)
alias l='ls -lah' ll='ls -lh' la='ls -lAh'
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS   # bare dir name cd's; every cd feeds the stack for 1-9
alias -- -='cd -'
for i in 1 2 3 4 5 6 7 8 9; do alias "$i"="cd -$i"; done; unset i
alias -g ...='../..' ....='../../..' .....='../../../..'
alias a='claude agents'                         # background-agent list

# Colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
alias ls='ls -G' grep='grep --color=auto'

# Safe paste: escape URL chars as you paste, don't run multi-line pastes early
autoload -Uz url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

# Vi keys (must precede starship init, which wraps zle-keymap-select for its mode symbol)
bindkey -v
export KEYTIMEOUT=20   # 0.2s for Esc to register as a lone key
bindkey -M viins '^?' backward-delete-char   # backspace over text typed before the last Esc
bindkey -M viins '^H' backward-delete-char
_vi_cursor() { [[ $KEYMAP == vicmd ]] && printf '\e[2 q' || printf '\e[6 q' }   # block in cmd, beam in insert
zle-keymap-select() { _vi_cursor }
zle-line-init()     { _vi_cursor }
zle -N zle-keymap-select
zle -N zle-line-init

# Keys: Up/Down search history by what you've typed; Home/End; Shift-Tab back through menus
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for m in viins vicmd; do
  bindkey -M $m '^[[A' up-line-or-beginning-search
  bindkey -M $m '^[[B' down-line-or-beginning-search
  [[ -n ${terminfo[kcuu1]} ]] && bindkey -M $m "${terminfo[kcuu1]}" up-line-or-beginning-search
  [[ -n ${terminfo[kcud1]} ]] && bindkey -M $m "${terminfo[kcud1]}" down-line-or-beginning-search
  [[ -n ${terminfo[khome]} ]] && bindkey -M $m "${terminfo[khome]}" beginning-of-line
  [[ -n ${terminfo[kend]}  ]] && bindkey -M $m "${terminfo[kend]}"  end-of-line
  [[ -n ${terminfo[kcbt]}  ]] && bindkey -M $m "${terminfo[kcbt]}"  reverse-menu-complete
done; unset m

# Terminal title: current dir, or the running command
autoload -Uz add-zsh-hook
_title_precmd()  { print -Pn '\e]0;%~\a' }
_title_preexec() { print -n "\e]0;${1[(w)1]}\a" }
add-zsh-hook precmd  _title_precmd
add-zsh-hook preexec _title_preexec

# PATH
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# Dedupe history once a day, in the first shell of the day (zhc via ~/.local/bin/zsh-history-clean)
_hc_stamp=~/.cache/zsh/history-clean.date
if [[ ! -f $_hc_stamp || $(<$_hc_stamp) != $(date +%F) ]] && command -v zhc >/dev/null 2>&1; then
  zsh-history-clean && date +%F >| $_hc_stamp
fi
unset _hc_stamp

# Prompt
eval "$(starship init zsh)"

# Tools
eval "$(zoxide init zsh)"
source <(fzf --zsh)
source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Machine/work-specific config, untracked
# Put local settings in ~/.zshrc.local, e.g.
#
#   # GitHub token via 1Password, fetched on first use instead of at startup.
#   # gh itself also has a keyring login; the wrapper matters for the
#   # package registries used by npm/pnpm.
#   # Run __gh_token before npm/pnpm if gh hasn't fetched the token yet.
#   __gh_token() {
#     [[ -n $GITHUB_TOKEN ]] && return 0
#     local t; t=$(op read 'op://Your Vault/GitHub Personal Access Token/token') || return 1
#     export GITHUB_TOKEN=$t GH_TOKEN=$t
#   }
#   gh()   { __gh_token && command gh   "$@" }
#
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
