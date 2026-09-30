# dotfiles

My macOS setup: [Ghostty](https://ghostty.org) + [herdr](https://herdr.dev), plus Claude Code settings.

iTerm2, vim, neovim and tmux are no longer used. Their old configs are still in git history.

## What's in here

| Path | Linked/copied to | Notes |
| --- | --- | --- |
| `ghostty/config` | `~/.config/ghostty/config` (symlink) | Dracula theme, MesloLGS NF 22, Option as Alt |
| `herdr/config.toml` | `~/.config/herdr/config.toml` (symlink) | prefix `alt+a`, detach `prefix+d` |
| `zsh/` | sourced from `~/.zshrc` | zim + powerlevel10k, aliases and functions |
| `claude/settings.json` | `~/.claude/settings.json` (copy, only if missing) | model, plugins, marketplaces, TUI mode |

## Requirements

- macOS
- [Homebrew](https://brew.sh)
- `git`, `curl`

## Install

```sh
# One line (clones to ~/.dotfiles)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/freddy5566/dotfiles/master/install.sh)"

# Or from a checkout
git clone https://github.com/freddy5566/dotfiles ~/developer/dotfiles
~/developer/dotfiles/install.sh
```

The script installs whatever is missing, then links the configs (existing files are moved to `*.bak`):

1. **Ghostty**: `brew install --cask ghostty`
2. **Font**: `brew install --cask font-meslo-lg-nerd-font` (the config uses `MesloLGS NF`)
3. **herdr**: `curl -fsSL https://herdr.dev/install.sh | sh` (installs to `~/.local/bin`; make sure that is on your `PATH`; update later with `herdr update`)
4. **zsh**: installs [zim](https://zimfw.sh) and appends `export DOTFILES=...` / `source .../zsh/.zshrc` to `~/.zshrc` (the old one is saved as `.zshrc.bak`)
5. **Claude Code settings**, then `herdr integration install claude` if `claude` is installed

Claude Code itself is not installed by this script: see <https://docs.claude.com/en/docs/claude-code/setup>.

## After installing

- Open Ghostty and run `herdr`. Detach with Opt+a, `d`; run `herdr` again to reattach.
- The herdr prefix is `alt+a`, which needs Option to act as Alt. This is already set in the Ghostty config (`macos-option-as-alt = true`). Option-typed characters like `å` no longer work.
- Reload after editing configs: Ghostty with Cmd+Shift+, ; herdr with `herdr server reload-config`. Validate herdr with `herdr config check`.

## Claude Code settings

`claude/settings.json` holds only the portable parts. Machine-specific bits stay local:

- the herdr hook, added by `herdr integration install claude`
- `autoMode` rules and `settings.local.json` permissions
- skills and plugin caches under `~/.claude`

It is copied rather than symlinked because Claude Code and herdr edit the live file. To sync changes back, compare and copy by hand:

```sh
diff ~/.claude/settings.json claude/settings.json
```
