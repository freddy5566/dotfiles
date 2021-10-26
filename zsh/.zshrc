export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
export TERM="xterm-256color"
export GPG_TTY=$(tty)
export PATH=/opt/homebrew/bin:$PATH

[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

source ${ZDOTDIR:-${HOME}}/.zlogin
source $DOTFILES/zsh/alias.zsh
source $DOTFILES/zsh/function.zsh
source $DOTFILES/zsh/.p10k.zsh