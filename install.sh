#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES..."

ln -sf "$DOTFILES/.zshrc" ~/.zshrc
echo "  linked .zshrc"

ln -sf "$DOTFILES/.zprofile" ~/.zprofile
echo "  linked .zprofile"

ln -sf "$DOTFILES/.p10k.zsh" ~/.p10k.zsh
echo "  linked .p10k.zsh"

mkdir -p ~/.config/ghostty
if [ -f "$DOTFILES/.config/ghostty/config" ]; then
  ln -sf "$DOTFILES/.config/ghostty/config" ~/.config/ghostty/config
  echo "  linked ghostty config"
else
  echo "  skipped ghostty config (none found)"
fi

echo "Done."
