" ---------------------------- Plugin Manager ---------------------------------
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
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

if has("nvim")
  " Debug Adapter Protocol client implementation for Neovim
  Plug 'mfussenegger/nvim-dap'
endif

call plug#end()


" ---------------------------- General ----------------------------------------
set nocompatible
syntax on

set termguicolors
set noswapfile
set nobackup
set number
set relativenumber  
set nowrap
set incsearch
set hlsearch
set wildmenu
"set wildmode=list:longest
set scrolloff=8

colorscheme gruvbox
if (&background == "light")
  set bg=dark
endif

hi Normal guibg=NONE ctermbg=NONE
hi NormalFloat guibg=NONE ctermbg=NONE

set cursorcolumn
hi CursorColumn cterm=NONE ctermbg=239
set cursorline
hi CursorLine cterm=NONE ctermbg=235
set colorcolumn=80
hi ColorColumn ctermbg=lightgrey guibg=lightgrey
hi Conceal ctermbg=DarkBlue

hi Pmenu ctermfg=Black ctermbg=238
hi PmenuSel ctermfg=Grey ctermbg=Black
hi PmenuSbar ctermbg=Black
hi PmenuThumb ctermbg=DarkGrey

set expandtab
set smartcase
set smartindent
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Presist undo tree for every file when closed and reopened later.
if has("persistent_undo")
  let target_path = expand('~/.undodir')

  " create the directory and any parent directories
  " if the location does not exist.
  if !isdirectory(target_path)
    call mkdir(target_path, "p", 0700)
  endif

  let &undodir=target_path
  set undofile
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


" **************************** coc.nvim ***************************************
" Remove comment to disable vim version recommendation warning for older
" versions of ubuntu.
let g:coc_disable_startup_warning = 1


" **************************** ultiSnips **************************************
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<C-M-space>"
let g:UltiSnipsJumpForwardTrigger="<C-b>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"


" ---------------------------- Mappings ---------------------------------------
let mapleader = " "

" **************************** General ****************************************
nnoremap <leader>pv :Ex<CR>

" Move higlighted lines.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Cursor at the beginning when previous line is appended to the current line.
nnoremap J mzJ`z

" Keep the cursor in the middle when half scrolling or while searching.
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Copy text to system clipboard.
function! IsWSL()
  if has("unix")
    let lines = readfile("/proc/version")
    if lines[0] =~ "[Mm]icrosoft"
      return 1
    endif
  endif
  return 0
endfunction

if (IsWSL())
  " Copy (write) highlighted text to .vimbuffer
  vnoremap <leader>y y:new ~/.vimbuffer<CR>VGp:x<CR> \| :!cat ~/.vimbuffer \| clip.exe <CR><CR>
  " Paste from buffer
  nnoremap <leader>p :r ~/.vimbuffer<CR>
else
  nnoremap <leader>y """*y"
  vnoremap <leader>y """*y"
  nnoremap <leader>Y """*Y"
  nnoremap <leader>p """*p"
endif

" Don't retain deleted text in the numbered register.
nnoremap <leader>d """_d"
vnoremap <leader>d """_d"

" When overwritting, presist the copied text and remove the overwritten text.
xnoremap <leader>p "_dP

" Search and replace the text under the cursor.
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Make the current file an executable.
nnoremap <leader>x <cmd>silent !chmod +x %<CR>


" **************************** coc.nvim ***************************************
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <C-space> coc#refresh()

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)


" **************************** nvim.dap ***************************************
if has("nvim")
  nnoremap <silent> <F5> <cmd>lua require'dap'.continue()<CR>
  nnoremap <silent> <F10> <cmd>lua require'dap'.step_over()<CR>
  nnoremap <silent> <F11> <cmd>lua require'dap'.step_into()<CR>
  nnoremap <silent> <F12> <cmd>lua require'dap'.step_out()<CR>
  nnoremap <silent> <leader>b <cmd>lua require'dap'.toggle_breakpoint()<CR>
  nnoremap <silent> <leader>B <cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
  nnoremap <silent> <leader>lp <cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
  nnoremap <silent> <leader>dr <cmd>lua require'dap'.repl.open()<CR>
  nnoremap <silent> <leader>dl <cmd>lua require'dap'.run_last()<CR>
endif

" **************************** vimspector *************************************
" If set to 'HUMAN' disable the rest below as to not pollute the keyspace.
" let g:vimspector_enable_mappings = 'HUMAN'

" Breakpoints.
nnoremap <leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dT :call vimspector#ClearBreakpoints()<CR>

" Initialization.
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>df :call vimspector#RunToCursor()<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>
nnoremap <leader>dc :call vimspector#Continue()<CR>

" Navigation.
nmap <leader>dk <Plug>VimspectorRestart
nmap <leader>dh <Plug>VimspectorStepOut
nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver


" **************************** nerdtree ***************************************
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>


" **************************** undotree ***************************************
nnoremap <leader>u :UndotreeToggle<CR>


" **************************** vim-fugitive ***********************************
nnoremap <leader>gs :Git<CR>


" ---------------------------- Config -----------------------------------------
" **************************** nvim.dap ***************************************
if has("nvim")
lua <<EOF
  local dap = require('dap')
  dap.adapters.node = {
    type = 'executable',
    command = 'node',
    -- Install vscode-node-debug2 on the specified path.
    args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
  }
  dap.configurations.javascript = {
    {
      name = 'Launch',
      type = 'node',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = 'node',
      request = 'attach',
      processId = require'dap.utils'.pick_process,
    },
  }
EOF
endif
