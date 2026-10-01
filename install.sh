#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FULL=0
for arg in "$@"; do
  case "$arg" in
    --full)
      FULL=1
      ;;
    -h | --help)
      cat <<USAGE
Usage: ./install.sh [--full]

  (no flags)  Shell setup only. Installs Homebrew, zsh, pure, nvm and
              oh-my-zsh, then symlinks the shell config. This is what you
              want if you're here for the prompt and shell settings.

  --full      Additionally installs everything in Brewfile: the full dev
              toolchain, desktop apps and 55 VS Code extensions. This is
              tailored to one specific machine — read Brewfile first.
USAGE
      exit 0
      ;;
    *)
      echo "Unknown option: $arg (try --help)" >&2
      exit 1
      ;;
  esac
done

echo "Installing dotfiles from $DOTFILES..."

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "  installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages
if [ "$FULL" -eq 1 ]; then
  echo "  installing full Homebrew bundle (this takes a while)..."
  brew bundle --file="$DOTFILES/Brewfile"
else
  echo "  installing shell dependencies..."
  brew bundle --file="$DOTFILES/Brewfile.shell"
fi

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Symlink shell config files
ln -sf "$DOTFILES/.zshrc" ~/.zshrc
echo "  linked .zshrc"

ln -sf "$DOTFILES/.zprofile" ~/.zprofile
echo "  linked .zprofile"

mkdir -p ~/.config/ghostty
if [ -f "$DOTFILES/.config/ghostty/config" ]; then
  ln -sf "$DOTFILES/.config/ghostty/config" ~/.config/ghostty/config
  echo "  linked ghostty config"
else
  echo "  skipped ghostty config (none found)"
fi

echo ""
echo "Done. Open a new terminal session to apply changes."
echo "Note: copy .zshrc.secrets.example to ~/.zshrc.secrets and fill in your tokens"
echo "      before starting a new shell."
if [ "$FULL" -eq 0 ]; then
  echo "      Run ./install.sh --full to also install the full dev toolchain."
fi
