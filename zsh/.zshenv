# Read by every zsh (login, interactive, scripts). Keep it minimal.
typeset -U PATH path       # drop duplicate PATH entries automatically
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"   # rustup toolchain (installed by setup.sh)
