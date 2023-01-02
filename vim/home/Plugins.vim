" Initialize plugin system
call plug#begin()

" Full language server protocol. (Also works for vim)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ["coc-sh"] " Install basic LSPs

" Mappings to easily delete, change and add \"surroundings\" in pairs.
Plug 'tpope/vim-surround'

" A multi language graphical debugger for Vim.
Plug 'puremourning/vimspector'

" A dark Vim/Neovim color scheme.
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = "hard"

" Status/tabline for vim/nvim.
Plug 'vim-airline/vim-airline'

" A file system explorer.
Plug 'scrooloose/nerdtree'

" Enables NERDTree to open, delete, move, or copy multiple files at once.
Plug 'PhilRunninger/nerdtree-visual-selection'

" A plugin of NERDTree showing git status flags.
Plug 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeGitStatusShowClean = 1

" A snippets manager for vim.
Plug 'SirVer/ultisnips'
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Repository containing snippets files for various programming languages.
Plug 'honza/vim-snippets'

" Browse undo history and switch between different undo branches.
Plug 'mbbill/undotree'

" Vim plugin for Git.
Plug 'tpope/vim-fugitive'

" (Do)cumentation (Ge)nerator which will generate a proper documentation.
" If post-update hook error, restart vim and ':call doge#install()' manually.
Plug 'kkoomen/vim-doge'

call plug#end()
