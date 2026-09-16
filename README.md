# dotfiles

Personal macOS dotfiles for zsh (oh-my-zsh), git, tmux, vim and Zed.

| File | Installed to |
|------|--------------|
| `zsh/.zshrc`, `.zprofile`, `.zshenv`, `.profile` | `~/` |
| `git/gitconfig` | `~/.gitconfig` |
| `git/ignore` | `~/.config/git/ignore` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `vim/vimrc` | `~/.vimrc` |
| `zed/settings.json` | `~/.config/zed/settings.json` |

## Install

```bash
git clone git@github.com:hatutah/dotfiles.git ~/hatutah/dotfiles
~/hatutah/dotfiles/install.sh
```

`install.sh` symlinks each file into place and backs up anything already there as `*.bak.<timestamp>`.

Never commit secrets — keep tokens in 1Password or an untracked `~/.zshrc.local`.
