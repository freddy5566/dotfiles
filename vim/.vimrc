syntax on
set autochdir
set backspace=2
set encoding=utf-8
set fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
set mouse=a
set nocompatible
set t_Co=256
set laststatus=2

set cindent
set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4

nnoremap <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>
set cursorline
set foldmethod=syntax
set number
set ruler
set showcmd
set showmode
set statusline=[%{expand('%:p')}][%{strlen(&fenc)?&fenc:&enc},\ %{&ff},\ %{strlen(&filetype)?&filetype:'plain'}]%{FileSize()}%{IsBinary()}%=%c,%l/%L\ [%3p%%]

autocmd FileType make setlocal noexpandtab

function IsBinary()
    if (&binary == 0)
        return ""
    else
        return "[Binary]"
    endif
    endfunction

    function FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return "[Empty]"
    endif
    if bytes < 1024
        return "[" . bytes . "B]"
    elseif bytes < 1048576
        return "[" . (bytes / 1024) . "KB]"
    else
        return "[" . (bytes / 1048576) . "MB]"
    endif
endfunction

command W w !sudo tee %
