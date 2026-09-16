# dotfiles

Personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level folder is a stow package whose contents mirror `$HOME`.

| Package | Links |
|---------|-------|
| `zsh`  | `~/.zshrc`, `~/.zprofile`, `~/.zshenv`, `~/.profile` |
| `git`  | `~/.gitconfig`, `~/.config/git/ignore` |
| `tmux` | `~/.tmux.conf` |
| `vim`  | `~/.vimrc` |
| `zed`  | `~/.config/zed/settings.json` |

## Install

```bash
brew install stow
git clone git@github.com:hatutah/dotfiles.git ~/hatutah/dotfiles
cd ~/hatutah/dotfiles
stow -t ~ zsh git tmux vim zed
```

`-t ~` is needed because the repo isn't directly inside `$HOME`
(a `.stowrc` in this repo sets it, so plain `stow <pkg>` also works).

If real files already exist in `$HOME`, stow refuses to overwrite them. Either
move them aside, or run `stow --adopt <pkg>` to pull them into the repo and then
check `git diff`.

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
