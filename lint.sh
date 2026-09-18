#!/usr/bin/env bash
# Static checks: shell syntax, shellcheck, config parsing, stow layout. Installs
# nothing and touches nothing in $HOME, so it runs anywhere with the tools below;
# CI runs it on Linux (.github/workflows/lint.yml). Needs bash, zsh, stow, git,
# tmux, vim, python3 and (optionally) shellcheck.
# shellcheck disable=SC2317   # the *_parse/*_layout functions only run via check(), which looks unreachable
set -uo pipefail
cd "$(dirname "$0")" || exit 1
eval "$(grep '^PACKAGES=' setup.sh)"   # same list setup.sh links

fail=0
check() {   # check <name> <cmd...>: print ok/FAIL, show output only on failure
  local name=$1 out; shift
  if out=$("$@" 2>&1); then
    printf 'ok    %s\n' "$name"
  else
    printf 'FAIL  %s\n' "$name"; printf '%s\n' "$out" | sed 's/^/      /'; fail=1
  fi
}

zsh_syntax() { local f; for f in "$@"; do zsh -n "$f" || return 1; done; }
toml_parse() { python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$1"; }
tmux_parse() {   # a throwaway server (needs a session to stay up); source-file reports syntax errors
  tmux -L lint -f /dev/null new-session -d && tmux -L lint source-file "$PWD/$1"
  local rc=$?; tmux -L lint kill-server 2>/dev/null; return "$rc"
}
skill_links() {   # every skills/<x> needs claude/.claude/skills/<x> -> ../../../skills/<x>
  local s rc=0
  for s in skills/*/; do
    s=$(basename "$s")
    [ -L "claude/.claude/skills/$s" ] || { echo "missing link claude/.claude/skills/$s"; rc=1; }
  done; return "$rc"
}
stow_layout() {   # stow for real into a scratch target and look for broken links
  local t rc=0; t=$(mktemp -d)
  mkdir -p "$t/.claude/skills" "$t/.local/bin"   # real dirs on a Mac, as setup.sh makes them
  stow -t "$t" "${PACKAGES[@]}" || rc=1
  local broken; broken=$(find "$t" -type l ! -exec test -e {} \; -print)
  [ -z "$broken" ] || { echo "broken links:"; echo "$broken"; rc=1; }
  rm -rf "$t"; return "$rc"
}

check "bash syntax"      bash -n setup.sh lint.sh
check "sh syntax"        sh -n zsh/.local/bin/zsh-history-clean
check "zsh syntax"       zsh_syntax zsh/.zshrc zsh/.zshenv zsh/.zprofile
if command -v shellcheck >/dev/null 2>&1; then
  check "shellcheck"     shellcheck setup.sh lint.sh zsh/.local/bin/zsh-history-clean
else
  echo "skip  shellcheck (not installed)"
fi
check "gitconfig parses" git config -f git/.gitconfig --list
check "tmux.conf parses" tmux_parse tmux/.tmux.conf
check "vimrc loads"      vim -es -u vim/.vimrc +'qa!'
check "starship.toml"    toml_parse starship/.config/starship.toml
check "skill links"      skill_links
check "stow layout"      stow_layout

exit $fail
