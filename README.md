# Dotfiles (macOS)

Minimal [chezmoi](https://www.chezmoi.io/) setup for a new Mac: Homebrew packages, Ghostty (Catppuccin light/dark), mise, and a few OS defaults.

## Bootstrap (fresh Mac)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/llstarscreamll/dotfiles/master/bootstrap.sh)"
```

That installs Homebrew (if needed), clones this repo to `~/.dotfiles`, installs chezmoi, and runs `chezmoi apply`.

Already cloned locally? `./bootstrap.sh` from the repo root works the same.

## Day-1 packages

| Package | Via |
|---------|-----|
| mise | brew |
| Ghostty | brew cask |
| JetBrainsMono Nerd Font | brew cask |

Ghostty uses **Catppuccin Mocha** (dark) / **Latte** (light) and follows the system appearance.

Also applies: faster key repeat, disables Ctrl+Arrow Mission Control shortcuts, clears the Dock.

## Add more tools later

1. Edit [`Brewfile`](Brewfile) (e.g. `cask "cursor"`, `brew "neovim"`).
2. Run `chezmoi apply` (re-runs brew bundle; also updates `~/Brewfile`).

Managed configs live as chezmoi source files (`dot_zshrc`, `dot_config/...`). Add new ones with:

```bash
chezmoi add ~/.config/herdr/config.toml
```

## Useful commands

```bash
chezmoi diff
chezmoi apply
chezmoi cd          # open source dir
chezmoi source-path
```
