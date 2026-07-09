## dotfiles

### Bootstrap

1. Install [mise](https://mise.jdx.dev)

```sh
curl https://mise.run | sh
```

2. Install Git

```sh
MISE_EXPERIMENTAL=1 ~/.local/bin/mise bootstrap packages install brew:git --yes --update
```

3. Bootstrap

```sh
git clone git@github.com:shamanime/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
~/.local/bin/mise trust "$PWD/config/mise/config.toml"
MISE_GLOBAL_CONFIG_FILE="$PWD/config/mise/config.toml" ~/.local/bin/mise bootstrap --yes --force-dotfiles
```
