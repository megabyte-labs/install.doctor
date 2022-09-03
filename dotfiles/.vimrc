call plug#begin()
Plug 'https://github.com/leafgarland/typescript-vim.git'
Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/itchyny/lightline.vim.git'
Plug 'https://github.com/pangloss/vim-javascript.git'
Plug 'https://github.com/mxw/vim-jsx.git'
Plug 'https://github.com/plasticboy/vim-markdown.git'
Plug 'https://github.com/ekalinin/dockerfile.vim.git'
Plug 'https://github.com/stanangeloff/php.vim.git'
Plug 'https://github.com/hdima/python-syntax.git'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/prettier/vim-prettier.git'
Plug 'https://github.com/tpope/vim-sensible.git'
Plug 'https://github.com/editorconfig/editorconfig-vim.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/kristijanhusak/vim-carbon-now-sh.git'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/dense-analysis/ale.git'
Plug 'https://github.com/junegunn/fzf.git'
Plug 'https://github.com/junegunn/fzf.vim.git'
Plug 'https://github.com/neoclide/coc.nvim.git', {'branch': 'release'}
Plug 'https://github.com/vim-syntastic/syntastic.git'
Plug 'https://github.com/ryanoasis/vim-devicons.git'
Plug 'https://github.com/nanotee/zoxide.vim.git'
Plug 'https://github.com/fatih/vim-go.git'
Plug 'https://github.com/ycm-core/YouCompleteMe.git'
Plug 'https://github.com/pearofducks/ansible-vim.git', {'do': './UltiSnips/generate.sh'}

" Settings for plugin https://github.com/altercation/vim-colors-solarized.git
syntax enable
set background=dark
colorscheme themer

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
