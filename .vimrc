" ---------------------------- General ----------------------------------------
set nocompatible
syntax on
set number
set incsearch
set hlsearch
set wildmenu
"set wildmode=list:longest

set cursorcolumn
hi CursorColumn cterm=NONE ctermbg=239
set cursorline
hi CursorLine cterm=NONE ctermbg=235
set colorcolumn=80
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

hi Pmenu ctermfg=Black ctermbg=238
hi PmenuSel ctermfg=Grey ctermbg=Black
hi PmenuSbar ctermbg=Black
hi PmenuThumb ctermbg=DarkGrey

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartcase

" **************************** Plug coc.nvim **********************************
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

"                             
" ---------------------------- Plugin Manager ---------------------------------
" Initialize plugin system
call plug#begin()

" Full language server protocol
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Mappings to easily delete, change and add \"surroundings\" in pairs.
Plug 'tpope/vim-surround'

call plug#end()


" ---------------------------- Mappings ---------------------------------------
" **************************** Plug coc.nvim **********************************
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

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<Leader>aap` for current paragraph
xmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <Leader>cl  <Plug>(coc-codelens-action)

