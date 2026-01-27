# Fedora Dotfiles

This repository contains setup scripts and configuration files for my Fedora Linux development environment.

## Usage

### Full Setup

To run the complete setup process, which installs all software, configurations, and tools:

```bash
./setup.sh
```

### Partial Setup

You can run individual parts of the setup by passing the function name as an argument.

Example: Only install Visual Studio Code
```bash
./setup.sh install_vscode
```

Example: Only link configuration files
```bash
./setup.sh link_config_files
```

To see a list of available commands, run with an invalid argument (like `help`):
```bash
./setup.sh help
```

## Structure

- **setup.sh**: The main entry point. Orchestrates the installation.
- **utils.sh**: Helper functions (logging, formatting).
- **installers/**: Modular installation scripts.
  - `misc.sh`: Fonts, codecs, udev rules.
  - `shell.sh`: Shell utilities, vim, dotfile linking.
  - `ide.sh`: VSCode, Sublime, Cursor, JetBrains.
  - `dev.sh`: Docker, Mise, GitFlow, VPN, NPM global packages.
  - `web.sh`: Browsers, communication apps (Slack, Telegram).
- **config/**: Configuration files (bash, git, udev, etc.) to be linked.
- **tests/**: Bats tests to ensure scripts work as expected.

## Testing

This project uses [bats-core](https://github.com/bats-core/bats-core) for testing.

Run all tests:
```bash
bats tests/
```
