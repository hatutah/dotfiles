#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Existing files are moved to *.bak.<timestamp>.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
TS="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$DIR/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok      $dest"; return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak.$TS"; echo "backup  $dest -> $dest.bak.$TS"
  fi
  ln -s "$src" "$dest"; echo "linked  $dest"
}

link zsh/.zshrc        "$HOME/.zshrc"
link zsh/.zprofile     "$HOME/.zprofile"
link zsh/.zshenv       "$HOME/.zshenv"
link zsh/.profile      "$HOME/.profile"
link git/gitconfig     "$HOME/.gitconfig"
link git/ignore        "$HOME/.config/git/ignore"
link tmux/tmux.conf    "$HOME/.tmux.conf"
link vim/vimrc         "$HOME/.vimrc"
link zed/settings.json "$HOME/.config/zed/settings.json"
