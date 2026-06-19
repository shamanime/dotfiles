# vi: ft=fish

if test -f ~/.sensitive.fish
    source ~/.sensitive.fish
end

fish_add_path --global --prepend /opt/homebrew/bin /opt/homebrew/sbin

if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

if command -q mise
    mise activate fish | source
end

set -gx COREUTILS_BIN /opt/homebrew/opt/coreutils/libexec/gnubin
set -gx GPG_BIN /opt/homebrew/opt/gnupg/bin
set -gx GNU_SED_BIN /opt/homebrew/opt/gnu-sed/libexec/gnubin
set -gx FLYCTL_HOME $HOME/.fly
set -gx CARGO_BIN $HOME/.cargo/bin
set -gx OPENJDK_BIN /opt/homebrew/opt/openjdk/bin
set -gx POSTGRES_BIN /Applications/Postgres.app/Contents/Versions/latest/bin
set -gx OPENCODE_BIN $HOME/.opencode/bin

fish_add_path --global --append \
    $HOME/.bin \
    $HOME/.local/bin \
    ./bin \
    $COREUTILS_BIN \
    $GPG_BIN \
    $GNU_SED_BIN \
    $FLYCTL_HOME/bin \
    $CARGO_BIN \
    $OPENJDK_BIN \
    /usr/local/bin \
    $POSTGRES_BIN \
    $OPENCODE_BIN \
    /usr/local/lib \
    /usr/local/sbin \
    /usr/bin \
    /usr/sbin \
    /bin \
    /sbin

set -gx MANPATH /usr/local/opt/gnu-sed/libexec/gnuman $MANPATH

if test (uname) = Darwin; and command -q ssh-add
    ssh-add --apple-load-keychain -q >/dev/null 2>&1
end

fish_vi_key_bindings

set -gx EDITOR zed
set -gx GIT_EDITOR zed
set -gx VISUAL $EDITOR
set -gx MANPAGER 'less -X'
set -gx GPG_TTY (tty)

set -gx ERL_AFLAGS '-kernel shell_history enabled'
set -gx KERL_BUILD_DOCS yes

set -gx ELIXIR_EDITOR 'zed __FILE__:__LINE__'
set -gx PLUG_EDITOR $ELIXIR_EDITOR
set -gx ECTO_EDITOR $ELIXIR_EDITOR
set -gx MIX_OS_DEPS_COMPILE_PARTITION_COUNT 5

if command -q gh
    set -gx GITHUB_TOKEN (gh auth token 2>/dev/null)
end

set -gx GH_TELEMETRY false
set -gx DO_NOT_TRACK true
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/ripgreprc

alias asdf='mise'
alias cc='claude --allow-dangerously-skip-permissions'
alias oc='opencode'
alias cx='codex'
alias df='df -h'
alias dns_reset='dscacheutil -flushcache && killall -HUP mDNSResponder'
alias du='du -h'
alias e='zed'
alias g='git'
alias gg='lazygit'
alias l='ls'
alias ll='eza --long --icons --sort modified --reverse --git'
alias ls='eza --icons --sort modified --reverse --git'
alias m='gemini'
alias mc='mix compile'
alias mdg='mix deps.get'
alias mdc='mix deps.clean --unused'
alias mf='mix format'
alias mis='iex -S mix'
alias mphx='iex -S mix phx.server'
alias mt='mix test'
alias mtd='mix test --stale'
alias mtf='mix test --failed'
alias rm='rm -i'
alias tf='terraform'
alias ts='tree-sitter'
alias up='just --working-directory $HOME/.dotfiles update'

abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'

if command -q fzf
    fzf --fish | source
end

if command -q zoxide
    zoxide init --cmd j fish | source
end

if command -q direnv
    direnv hook fish | source
end

function fish_title
    set -l directory (basename $PWD)

    if git rev-parse --git-dir >/dev/null 2>&1
        set -l branch (git branch --show-current 2>/dev/null)

        if test -n "$argv"
            echo "$argv in $directory [$branch]"
        else
            echo "$directory [$branch]"
        end
    else
        if test -n "$argv"
            echo "$argv in $directory"
        else
            echo "$directory"
        end
    end
end

function y
    set -l tmp (mktemp -t 'yazi-cwd.XXXXXX')

    yazi $argv --cwd-file=$tmp

    set -l cwd (command cat -- $tmp 2>/dev/null)
    if test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- $cwd
    end

    rm -f -- $tmp
end

function web_server
    set -l port 8000
    if test (count $argv) -gt 0
        set port $argv[1]
    end

    sleep 1; and open "http://localhost:$port/" &
    python -m http.server $port
end
