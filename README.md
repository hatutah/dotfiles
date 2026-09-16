# dotfiles

Personal macOS dotfiles (zsh, git, tmux, vim, Claude Code), managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level folder is a stow package whose contents mirror `$HOME`.

| Package | Links |
|---------|-------|
| `zsh`  | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` |
| `git`  | `~/.gitconfig`, `~/.config/git/ignore` |
| `tmux` | `~/.tmux.conf` |
| `vim`  | `~/.vimrc` |
| `starship` | `~/.config/starship.toml` |
| `ghostty` | `~/.config/ghostty/config` |
| `claude` | `~/.claude/settings.json`, `~/.claude/skills` → `skills/` |

## Install

```bash
git clone git@github.com:hatutah/dotfiles.git ~/hatutah/dotfiles
~/hatutah/dotfiles/setup.sh
```

`setup.sh` installs the Xcode Command Line Tools and Homebrew if they are
missing, installs everything in the `Brewfile` (stow, tmux, asdf, fzf, zoxide,
worktrunk, gh, lazygit, direnv, uv and more), then links every package. To add
a tool, add a line to the `Brewfile` and re-run `setup.sh`. It refuses to overwrite files already
in `$HOME`; run `setup.sh --adopt` to pull those into the repo instead, then
review with `git diff`. Re-running it is safe.

To do the stow step by hand:

```bash
brew install stow
cd ~/hatutah/dotfiles
stow -t ~ zsh git tmux vim starship ghostty claude
```

`-t ~` is needed because the repo isn't directly inside `$HOME`
(a `.stowrc` in this repo sets it, so plain `stow <pkg>` also works).

If real files already exist in `$HOME`, stow refuses to overwrite them. Either
move them aside, or run `stow --adopt <pkg>` to pull them into the repo and then
check `git diff`.

## Claude Code skills

Skills live in the top-level `skills/` folder, one folder per skill:

```
skills/
  my-skill/
    SKILL.md
```

`claude/.claude/skills` is a relative symlink to `../../skills`, so stowing the
`claude` package makes `~/.claude/skills` point at this folder. Add or edit a
skill in `skills/` and Claude Code picks it up, with no restow needed.

Only `settings.json` and `skills` are tracked from `~/.claude`; history,
projects, caches and sessions stay local.

## Common commands

```bash
stow <pkg>        # link a package
stow -D <pkg>     # unlink
stow -R <pkg>     # relink (after adding/removing files)
stow -n -v <pkg>  # dry run
```

## Adding a new file

Place it in a package at the same path it has under `$HOME`, e.g.
`~/.config/foo/config` → `foo/.config/foo/config`, then `stow -R foo`.

Never commit secrets — keep tokens in 1Password or an untracked `~/.zshrc.local`.
