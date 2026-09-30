#!/bin/sh
# Dotfiles installer: Ghostty + herdr + zsh + Claude Code (macOS).
set -eu

REPO_URL="https://github.com/freddy5566/dotfiles"
INSTALL_DIRECTORY=${INSTALL_DIRECTORY:-"$HOME/.dotfiles"}

info() { printf '==> %s\n' "$1"; }

# Symlink $1 (in repo) to $2 (in $HOME), backing up whatever is there.
link() {
    src=$1
    dest=$2
    mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        return
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mv "$dest" "$dest.bak"
        info "backed up $dest -> $dest.bak"
    fi
    ln -s "$src" "$dest"
    info "linked $dest"
}

# Use this checkout if the script runs from inside one; otherwise clone.
if [ -f "$(dirname "$0")/ghostty/config" ] 2>/dev/null; then
    INSTALL_DIRECTORY=$(cd "$(dirname "$0")" && pwd)
elif [ -d "$INSTALL_DIRECTORY/.git" ]; then
    git -C "$INSTALL_DIRECTORY" pull --ff-only
else
    command -v git >/dev/null 2>&1 || { echo "git is required."; exit 1; }
    git clone "$REPO_URL" "$INSTALL_DIRECTORY"
fi

# Ghostty + font (Homebrew)
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required: https://brew.sh"
    exit 1
fi
if [ ! -d /Applications/Ghostty.app ]; then
    info "installing Ghostty"
    brew install --cask ghostty
fi
if ! brew list --cask font-meslo-lg-nerd-font >/dev/null 2>&1; then
    info "installing MesloLGS Nerd Font"
    brew install --cask font-meslo-lg-nerd-font
fi

# herdr
if ! command -v herdr >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/herdr" ]; then
    info "installing herdr"
    curl -fsSL https://herdr.dev/install.sh | sh
fi

# Configs
link "$INSTALL_DIRECTORY/ghostty/config" "$HOME/.config/ghostty/config"
link "$INSTALL_DIRECTORY/herdr/config.toml" "$HOME/.config/herdr/config.toml"

# zsh (zim + powerlevel10k): ~/.zshrc sources the repo's zsh/.zshrc
if command -v zsh >/dev/null 2>&1; then
    if ! grep -qs "export DOTFILES=" "$HOME/.zshrc"; then
        [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
        {
            echo "export DOTFILES=$INSTALL_DIRECTORY"
            echo "source $INSTALL_DIRECTORY/zsh/.zshrc"
        } >> "$HOME/.zshrc"
        info "hooked zsh config into ~/.zshrc"
    fi
    if [ ! -d "$HOME/.zim" ]; then
        info "installing zim"
        curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    fi
    link "$INSTALL_DIRECTORY/zsh/.zimrc" "$HOME/.zimrc"
    zsh -c "source ~/.zim/zimfw.zsh install"
fi

# Claude Code settings are copied, not linked: Claude Code and herdr edit
# this file themselves (hooks, auto mode), and that should stay per machine.
if [ ! -f "$HOME/.claude/settings.json" ]; then
    mkdir -p "$HOME/.claude"
    cp "$INSTALL_DIRECTORY/claude/settings.json" "$HOME/.claude/settings.json"
    info "copied Claude Code settings"
else
    info "~/.claude/settings.json exists; compare with: diff ~/.claude/settings.json $INSTALL_DIRECTORY/claude/settings.json"
fi

# herdr's Claude Code integration (adds its hook to ~/.claude/settings.json)
if command -v claude >/dev/null 2>&1; then
    PATH="$HOME/.local/bin:$PATH" herdr integration install claude || true
fi

echo
echo "Done! Open Ghostty and run: herdr"
