#!/bin/sh

REPO_URL="https://github.com/jamfly/dotfiles"
REPO_NAME="dotfiles"

INSTALL_DIRECTORY=${INSTALL_DIRECTORY:-"$HOME/.$REPO_NAME"}
INSTALL_VERSION=${INSTALL_VERSION:-"master"}

askquestion() {
    printf "$1 [y/N] "

    read ans
    case $ans in
    [Yy*])
        return $(true)
        ;;
    *)
        return $(false)
        ;;
    esac
}

applyzsh() {
    # Check zsh
    if ! command -v zsh >/dev/null 2>&1; then
        echo "zsh is not installed."
        return $(false)
    fi

    if [ -f $HOME/.zshrc ]; then
        mv $HOME/.zshrc $HOME/.zshrc.bak
    fi

    if [ -f $HOME/.zimrc ]; then
        mv $HOME/.zimrc $HOME/.zimrc.bak
    fi

    # Install zim
    if ! [ -d $HOME/.zim ]; then
        if command -v curl >/dev/null 2>&1; then
            zsh -c "$(curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh)"
        else
            zsh -c "$(wget -nv -O - https://raw.githubusercontent.com/zimfw/install/master/install.zsh)"
        fi
    fi

    echo "export DOTFILES=$INSTALL_DIRECTORY" >> $HOME/.zshrc
    echo "source $INSTALL_DIRECTORY/zsh/.zshrc" >> $HOME/.zshrc
    cp $INSTALL_DIRECTORY/zsh/.zimrc $HOME
    # echo "source $INSTALL_DIRECTORY/zsh/.zimrc" >> $HOME/.zimrc

    echo "DEFAULT_USER=$USER" >> $HOME/.zshrc

    zsh -c "source ~/.zim/zimfw.zsh install"
}

applyvim() {
    # Check vim
    if ! command -v vim >/dev/null 2>&1; then
        echo "vim is not installed."
        return $(false)
    fi

    if [ -f $HOME/.vimrc ]; then
        mv $HOME/.vimrc $HOME/.vimrc.bak
    fi
    echo "source $INSTALL_DIRECTORY/vim/.vimrc" >>$HOME/.vimrc
}

applynvim() {
    # Check nvim
    if ! command -v nvim >/dev/null 2>&1; then
        echo "nvim is not installed."
        return $(false)
    fi

		cd ~/.config && ln -s ~/.dotfiles/nvim .
}

applytmux() {
    # Check tmux
    if ! command -v tmux >/dev/null 2>&1; then
        echo "tmux is not installed."
        return $(false)
    fi

    if [ -f $HOME/.tmux.conf ]; then
        mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
    fi
    echo "source $INSTALL_DIRECTORY/tmux/.tmux.conf" >>$HOME/.tmux.conf
}

main() {
    # Check Git
    if ! command -v git >/dev/null 2>&1; then
        echo "You must install git before using the installer."
        return $(false)
    fi

    # Remove old one
    if [ -d $INSTALL_DIRECTORY ]; then
        rm -rf $INSTALL_DIRECTORY
    fi

    # Clone repo to local
    git clone $REPO_URL $INSTALL_DIRECTORY
    if [ $? != 0 ]; then
        echo "Failed to clone $REPO_NAME."
        return 1
    fi
    cd $INSTALL_DIRECTORY
    git checkout $INSTALL_VERSION

    # Apply the config of zsh
    if askquestion "Do you want to apply the config of zsh?"; then
        applyzsh
    fi

    # Apply the config of vim
    if askquestion "Do you want to apply the config of vim?"; then
        applyvim
    fi

    # Apply the config of neovim
    if askquestion "Do you want to apply the config of neovim?"; then
        applynvim
    fi

    # Apply the config of tmux
    if askquestion "Do you want to apply the config of tmux?"; then
        applytmux
    fi

    # Finished
    echo
    echo "Done! $REPO_NAME:$INSTALL_VERSION is ready to go! Restart your shell to use it."
}

main
