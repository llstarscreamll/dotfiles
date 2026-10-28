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

Agent skills (Claude Code, Cursor, opencode): add a `<repo> <skill>` line to [`Skillfile`](Skillfile) and run `chezmoi apply`.

AWS skills and the AWS MCP server come from `aws configure agent-toolkit --yes` (run once by `chezmoi apply`). Update them with `aws agent-toolkit update-skill --all`; find more with `aws agent-toolkit search-skills --search-query <query> --region us-east-1`.

Own skills live in [`dot_agents/skills/`](dot_agents/skills/) (`~/.agents/skills/`, read by Cursor and opencode). Claude Code needs a matching symlink in [`dot_claude/skills/`](dot_claude/skills/): a `symlink_<skill>` file containing `../../.agents/skills/<skill>`.

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

## SSH key (GitHub / Bitbucket)

Last step, after bootstrap. Generates a key, stores the passphrase in the macOS Keychain, and copies the public key to the clipboard:

```bash
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname -s)" -f ~/.ssh/id_ed25519
cat >> ~/.ssh/config <<'CFG'
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
CFG
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
```

Paste it in [GitHub → SSH keys](https://github.com/settings/ssh/new) or [Bitbucket → SSH keys](https://bitbucket.org/account/settings/ssh-keys/), then verify:

```bash
ssh -T git@github.com
ssh -T git@bitbucket.org
```
