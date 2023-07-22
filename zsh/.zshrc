export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
export TERM="xterm-256color"
export GPG_TTY=$(tty)
export PATH=/opt/homebrew/bin:$PATH

zstyle ':zim:zmodule' use 'degit'

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

source ${ZIM_HOME}/init.zsh
source ${ZDOTDIR:-${HOME}}/.zlogin

source $DOTFILES/zsh/alias.zsh
source $DOTFILES/zsh/function.zsh
source $DOTFILES/zsh/.p10k.zsh