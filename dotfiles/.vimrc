call plug#begin()
Plug '~/.vim/plugged/typescript-vim'
Plug '~/.vim/plugged/vim-airline'
Plug '~/.vim/plugged/lightline.vim'
Plug '~/.vim/plugged/vim-javascript'
Plug '~/.vim/plugged/vim-jsx'
Plug '~/.vim/plugged/vim-markdown'
Plug '~/.vim/plugged/dockerfile.vim'
Plug '~/.vim/plugged/php.vim'
Plug '~/.vim/plugged/python-syntax'
Plug '~/.vim/plugged/nerdtree'
Plug '~/.vim/plugged/vim-five'
Plug '~/.vim/plugged/vim-prettier'
Plug '~/.vim/plugged/vim-sensible'
Plug '~/.vim/plugged/editorconfig-vim'
Plug '~/.vim/plugged/vimgutter'
Plug '~/.vim/plugged/vim-surround'
Plug '~/.vim/plugged/vim-carbon-now-sh'
Plug '~/.vim/plugged/vim-multiple-cursors'
Plug '~/.vim/plugged/ale'
Plug '~/.vim/plugged/fzf'
Plug '~/.vim/plugged/fzf.vim'
Plug '~/.vim/plugged/coc.nvim'
Plug '~/.vim/plugged/syntastic'
Plug '~/.vim/plugged/vim-devicons'
Plug '~/.vim/plugged/zoxide.vim'
Plug '~/.vim/plugged/vim-go'
Plug '~/.vim/plugged/ansible-vim', {'do': './UltiSnips/generate.sh'}

syntax enable
set background=dark
colorscheme betelgeuse

" Settings for plugin https://github.com/neoclide/coc.nvim.git
autocmd FileType json syntax match Comment +\/\/.\+$+

" Settings for plugin https://github.com/vim-syntastic/syntastic.git
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Settings for plugin https://github.com/ryanoasis/vim-devicons.git
set encoding=UTF-8
