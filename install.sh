#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES..."

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "  installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install all packages from Brewfile
echo "  installing Homebrew packages..."
brew bundle --file="$DOTFILES/Brewfile"

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
