call plug#begin('~/.local/share/nvim/site/autoload/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'scrooloose/nerdcommenter'

Plug 'christoomey/vim-tmux-navigator'
Plug 'dracula/vim', { 'as': 'dracula'}

Plug 'vim-airline/vim-airline'

" Initialize plugin system
call plug#end()
