#!/bin/bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/llstarscreamll/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap is for macOS only." >&2
  exit 1
fi

# Homebrew (also pulls Xcode CLT / git on a fresh Mac)
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Resolve source: local checkout vs curl | bash
SOURCE="${BASH_SOURCE[0]:-$0}"
if [[ -f "$SOURCE" && -f "$(cd "$(dirname "$SOURCE")" && pwd)/Brewfile" ]]; then
  ROOT="$(cd "$(dirname "$SOURCE")" && pwd)"
else
  if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
    echo "Cloning ${REPO_URL} → ${DOTFILES_DIR}..."
    git clone "${REPO_URL}" "${DOTFILES_DIR}"
  else
    echo "Updating ${DOTFILES_DIR}..."
    git -C "${DOTFILES_DIR}" pull --ff-only
  fi
  ROOT="${DOTFILES_DIR}"
fi

# chezmoi
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Installing chezmoi..."
  brew install chezmoi
fi

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi"
mkdir -p "${CONF_DIR}"
cat > "${CONF_DIR}/chezmoi.toml" <<EOF
sourceDir = "${ROOT}"
EOF

echo "Applying dotfiles from ${ROOT}..."
chezmoi apply --source="${ROOT}" --verbose

echo "Done. Open Ghostty (or a new shell) to pick up mise + fonts."
