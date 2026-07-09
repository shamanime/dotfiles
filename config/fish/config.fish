# vi: ft=fish

if test -f ~/.sensitive.fish
    source ~/.sensitive.fish
end

fish_add_path --global --prepend /opt/homebrew/bin /opt/homebrew/sbin $HOME/.local/bin

if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

if command -q mise
    mise activate fish | source
end

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
    /usr/local/sbin

if test (uname) = Darwin; and command -q ssh-add
    ssh-add --apple-load-keychain -q >/dev/null 2>&1
end

fish_vi_key_bindings

set -gx GPG_TTY (tty)

if command -q gh
    set -gx GITHUB_TOKEN (gh auth token 2>/dev/null)
end

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
alias up='mise -C $HOME/.dotfiles run update'
alias jq='jaq'

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
