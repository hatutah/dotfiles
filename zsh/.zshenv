# Read by every zsh (login, interactive, scripts). Keep it minimal.
typeset -U PATH path       # drop duplicate PATH entries automatically
. "$HOME/.cargo/env"       # rustup toolchain
