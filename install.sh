#!/bin/sh

# https://github.com/thoughtbot/dotfiles/blob/master/install.sh

function install() {
  for name in *; do
    target="$HOME/.$name"

    if [ "$name" != 'install.sh' ] && [ "$name" != 'README.md' ] && [ "$name" != 'oh-my-zsh' ] && [ "$name" != 'vscode' ]; then
      rm -rf "$target"
      echo "ln -s "$PWD/$name" "$target""
      ln -s "$PWD/$name" "$target"
    fi
  done

  touch ~/.sensitive
  mkdir -p ~/.tmux/plugins
  mkdir -p ~/.tmux/themes
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
}

install
