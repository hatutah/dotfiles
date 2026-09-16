#!/usr/bin/env bash
# Bootstrap a fresh Mac: Xcode Command Line Tools, Homebrew, GNU Stow, then
# link the dotfiles packages into $HOME. Safe to re-run; each step is skipped
# when already done.
#
#   ./setup.sh            link packages, refuse to overwrite existing files
#   ./setup.sh --adopt    move existing files into the repo, then link
#                         (check `git diff` afterwards)
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES=(zsh git tmux vim claude)
ADOPT=""
[ "${1:-}" = "--adopt" ] && ADOPT="--adopt"

log() { printf '\033[36m==>\033[0m %s\n' "$*"; }

[ "$(uname)" = "Darwin" ] || { echo "This script is for macOS." >&2; exit 1; }

# 1. Xcode Command Line Tools (needed by Homebrew)
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools (a dialog will appear)"
  xcode-select --install
  until xcode-select -p >/dev/null 2>&1; do sleep 10; done
fi

# 2. Xcode license, if full Xcode is installed and hasn't been accepted
if command -v xcodebuild >/dev/null 2>&1 && xcodebuild -version 2>&1 | grep -q 'license'; then
  log "Accepting the Xcode license (needs your password)"
  sudo xcodebuild -license accept
fi

# 3. Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  BREW=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
  BREW=/usr/local/bin/brew
else
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW=$([ "$(uname -m)" = arm64 ] && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew)
fi
eval "$("$BREW" shellenv)"

# 4. Homebrew packages listed in the Brewfile (only installs what's missing)
log "Installing Homebrew packages from Brewfile"
brew bundle --file="$DIR/Brewfile" --no-upgrade

# 5. Link packages
log "Linking: ${PACKAGES[*]}"
cd "$DIR"
if ! stow -n $ADOPT "${PACKAGES[@]}" 2>&1 | grep -q 'CONFLICT'; then
  stow -v $ADOPT "${PACKAGES[@]}"
else
  stow -n $ADOPT "${PACKAGES[@]}"
  echo
  echo "Some files already exist in \$HOME. Move them aside, or re-run with" >&2
  echo "  $0 --adopt" >&2
  echo "to pull them into the repo (then review with: git -C $DIR diff)." >&2
  exit 1
fi

log "Done. Open a new terminal window to pick up the linked shell config."
