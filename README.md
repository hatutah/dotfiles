# dotfiles

Personal macOS dotfiles (zsh, git, tmux, vim, Claude Code), managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level folder is a stow package whose contents mirror `$HOME`.

| Package | Links |
|---------|-------|
| `zsh`  | `~/.zshrc`, `~/.zprofile`, `~/.zshenv`, `~/.local/bin/zsh-history-clean` |
| `git`  | `~/.gitconfig`, `~/.config/git/ignore` |
| `tmux` | `~/.tmux.conf` |
| `vim`  | `~/.vimrc` |
| `starship` | `~/.config/starship.toml` |
| `ghostty` | `~/.config/ghostty/config` |
| `claude` | `~/.claude/skills/<skill>` → `skills/<skill>` |

## Install

```bash
git clone git@github.com:hatutah/dotfiles.git ~/hatutah/dotfiles
~/hatutah/dotfiles/setup.sh
```

`setup.sh` installs the Xcode Command Line Tools and Homebrew if they are
missing, installs everything in the `Brewfile` (stow, tmux, asdf, fzf, zoxide,
worktrunk, gh, lazygit, direnv, uv and more), installs
[zsh-history-cleaner](https://github.com/haidaraM/zsh-history-cleaner) with
cargo if `zhc` is missing, then links every package. To add
a tool, add a line to the `Brewfile` and re-run `setup.sh`. Work or
machine-only packages go in an untracked `Brewfile.local` next to it, which
`setup.sh` also installs when present. Homebrew refuses to load formulae from
third-party taps until you trust them once per machine, so if `Brewfile.local`
uses one, run `brew trust <user>/<tap>` first. It refuses to overwrite files already
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

## Daily history cleanup

`zsh/.local/bin/zsh-history-clean` runs `zhc`, which removes duplicate commands
from `~/.zsh_history` (the shell's own `HIST_IGNORE_DUPS` only catches
back-to-back repeats), and deletes the `.zsh_history.zhc_backup_*` files zhc
writes once they are a week old. `.zshrc` runs it from the first shell you open
each day, using `~/.cache/zsh/history-clean.date` to remember the last run, so
no cron or launchd is involved. Output goes to `~/.cache/zsh/history-clean.log`.

```bash
zsh-history-clean                     # clean now
rm ~/.cache/zsh/history-clean.date    # make the next shell run it again
```

`zhc` is a cargo crate, so `setup.sh` needs `cargo` on `PATH` (rust is managed
with asdf here, not Homebrew) and skips it with a note otherwise.

## Claude Code skills

Skills live in the top-level `skills/` folder, one folder per skill:

```
skills/
  my-skill/
    SKILL.md
```

`~/.claude/skills` is a real directory that Claude Code owns (it also holds
company-synced skills), so the `claude` package does not replace it. Instead
`claude/.claude/skills/` holds one relative symlink per skill, pointing back at
`skills/`, and stow links each of those into `~/.claude/skills/` alongside
whatever else is there.

To add a skill, create it in `skills/`, add the matching link, and restow:

```bash
mkdir skills/my-skill && $EDITOR skills/my-skill/SKILL.md
ln -s ../../../skills/my-skill claude/.claude/skills/my-skill
stow -R claude
```

Editing an existing skill needs no restow.

Only `skills` is tracked from `~/.claude`; `settings.json`, history, projects,
caches and sessions stay local and per machine.

## Checks

`./lint.sh` runs the static checks CI runs on every pull request
(`.github/workflows/lint.yml`, on Linux): shell syntax and shellcheck for
`setup.sh` and the scripts, `zsh -n` on the rc files, parse checks for the git,
tmux, vim and starship configs, one link per skill, and a real `stow` into a
scratch directory with a scan for broken links. It installs nothing and does
not touch `$HOME`. It cannot tell whether the tools the configs load exist or
whether a shell actually starts cleanly; that still needs a Mac.

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

## Per-machine git settings

`git/.gitconfig` holds the shared config (SSH signing via 1Password, default
branch) and ends with an `[include]` of `~/.gitconfig.local`, which is not
tracked. Your identity goes there, so each machine can use its own name, email
and signing key:

```ini
[user]
	name = Your Name
	email = you@example.com
	signingkey = ssh-ed25519 AAAA...
```

Git ignores the include if the file is missing, but commits will fail until
it exists because `commit.gpgsign` needs a key.

Never commit secrets — keep tokens in 1Password or an untracked `~/.zshrc.local`.
