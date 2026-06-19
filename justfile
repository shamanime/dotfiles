default:
    @just --list

install: link-root link-config yazi-theme apps-osx apps-mise apps-npm

update:
    #!/usr/bin/env zsh
    source ~/.shell/zinit
    brew upgrade
    brew cleanup
    rtk init -g --opencode --auto-patch
    zinit self-update
    zinit update
    mise plugins up
    mise up
    mise exec just -- just apps-npm

clean:
    #!/usr/bin/env zsh
    set -euo pipefail

    read "confirm?Run cleanup? This deletes caches, unused mise tool versions, Docker artifacts, and node_modules under $HOME/code. [y/N] "
    case "$confirm" in
        [yY]) ;;
        *) echo "Cancelled."; exit 0 ;;
    esac

    echo "==> Homebrew"
    brew autoremove
    brew cleanup --prune=all

    echo "==> mise"
    mise cache prune
    mise prune

    echo "==> npm"
    npm cache verify
    npx --yes npkill --directory "$HOME/code" --exclude-sensitive --delete-all -y

    echo "==> mac-cleaner-cli"
    echo "Leave browser categories unselected. mac-cleaner-cli has no non-interactive browser skip flag."
    npx --yes mac-cleaner-cli

    echo "==> Cargo"
    if ! command -v cargo-cache >/dev/null; then
        cargo install cargo-cache
    fi
    cargo cache --autoclean

    echo "==> Docker"
    if command -v docker >/dev/null && docker info >/dev/null 2>&1; then
        docker system prune --all --force
        docker builder prune --all --force
    else
        echo "Docker is not running; skipping."
    fi

link-root:
    #!/usr/bin/env bash
    for name in *; do
        case "$name" in
            justfile|README.md|config|.git) continue ;;
            gnupg)
                target="$HOME/.gnupg"
                echo "$target"
                mkdir -p "$target"
                chmod 700 "$target"
                for file in "$PWD/$name"/*; do
                    link_target="$target/$(basename "$file")"
                    rm -f "$link_target"
                    ln -s "$file" "$link_target"
                done
                continue
                ;;
        esac
        target="$HOME/.$name"
        echo "$target"
        rm -rf "$target"
        ln -s "$PWD/$name" "$target"
    done

link-config:
    #!/usr/bin/env bash
    for name in config/*; do
        target="$HOME/.$name"
        echo "$target"
        mkdir -p "$(dirname "$target")"
        rm -rf "$target"
        ln -s "$PWD/$name" "$target"
    done

yazi-theme:
    #!/usr/bin/env bash
    set -euo pipefail

    theme_dir="$HOME/.config/yazi/flavors/dracula.yazi"

    mkdir -p "$(dirname "$theme_dir")"

    if [ -d "$theme_dir/.git" ]; then
        git -C "$theme_dir" pull --ff-only
    elif [ -e "$theme_dir" ]; then
        echo "$theme_dir exists but is not a git checkout; remove it and rerun." >&2
        exit 1
    else
        git clone https://github.com/dracula/yazi.git "$theme_dir"
    fi

supercmd-sync:
    #!/usr/bin/env bash
    set -euo pipefail

    sync_dir="$HOME/.config/supercmd"
    app_support_dir="$HOME/Library/Application Support/SuperCmd"
    pointer_path="$app_support_dir/settings-location.json"

    mkdir -p "$sync_dir"
    mkdir -p "$app_support_dir"

    if [ ! -f "$sync_dir/settings.json" ] && [ -f "$app_support_dir/settings.json" ]; then
        cp "$app_support_dir/settings.json" "$sync_dir/settings.json"
    fi

    printf '{\n  "path": "%s"\n}\n' "$sync_dir" > "$pointer_path"

    if pgrep -x "SuperCmd" >/dev/null 2>&1; then
        killall SuperCmd
        open -a "SuperCmd"
    fi

apps-osx:
    brew update
    brew bundle install --file=Brewfile
    brew cleanup
    rtk init -g --opencode --auto-patch

apps-mise:
    mise plugins install neovim
    mise install

apps-npm:
    npm install -g @fsouza/prettierd
    npm install -g @github/copilot-language-server

check:
    #!/usr/bin/env bash
    echo "Checking dotfiles installation..."
    echo ""
    echo "Binaries:"
    binaries=(nvim zsh git fzf zoxide eza bat fd rg lazygit mise)
    for bin in "${binaries[@]}"; do
        if command -v "$bin" &> /dev/null; then
            echo "  ✓ $bin"
        else
            echo "  ✗ $bin"
        fi
    done

    echo ""
    echo "Git:"
    git config --global user.name &> /dev/null && echo "  ✓ user.name: $(git config --global user.name)" || echo "  ✗ user.name"
    git config --global user.email &> /dev/null && echo "  ✓ user.email: $(git config --global user.email)" || echo "  ✗ user.email"

    echo ""
    echo "Checking Homebrew env..."
    brew doctor
