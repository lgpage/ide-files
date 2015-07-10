set nocompatible | filetype indent plugin on | syn on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show whitespace
" Must be inserted before the colorscheme command
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufEnter * if &ft != 'help' | match ExtraWhitespace /\s\+$/ | endif
autocmd BufEnter * if &ft == 'help' | match none /\s\+$/ | endif

" Color Scheme
set t_Co=256
colorscheme jellybeans

" Enable syntax highlighting
syntax on
filetype on
filetype plugin indent on

" Spaces instead of TABs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Folding
set foldmethod=indent
nnoremap f za
nnoremap F zi

" Showing line numbers and length
set number " show line numbers
set tw=79  " width of document
set nowrap " dont auto wrap text on load
set fo-=t  " dont auto wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=red

" Auto reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" Copy & Paste
set pastetoggle=<F2>
set clipboard=unnamed
set clipboard=unnamedplus

" Mouse and backspace
set mouse=a
set bs=2

" Rebind <Leader> key
let mapleader = ","

" Quick quit command
noremap <Leader>q :wq<CR>
noremap <Leader>Q :q!<CR>

" Bind Ctrl + <movement> keys to move around window, instead of using
" Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" Map sort function to a key
vnoremap <Leader>s :sort<CR>

" Easierm moving of code blocks
vnoremap < <gv " better indetation
vnoremap > >gv " better indetation

" Usefull settings
set history=700
set undolevels=700

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable backup and swap files
set nobackup
set nowritebackup
set noswapfile

" Ctags
set tags=./tags,~/.vim/tags/OF230/tags


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Add-on Manager Setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! EnsureVamIsOnDisk(plugin_root_dir)
    " windows users may want to use http://mawercer.de/~marc/vam/index.php
    " to fetch VAM, VAM-known-repositories and the listed plugins
    " without having to install curl, 7-zip and git tools first
    " -> BUG [4] (git-less installation)
    let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
    if isdirectory(vam_autoload_dir)
        return 1
    else
        if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
            " I'm sorry having to add this reminder. Eventually it'll pay off.
            call confirm("Remind yourself that most plugins ship with ".
                        \"documentation (README*, doc/*.txt). It is your ".
                        \"first source of knowledge. If you can't find ".
                        \"the info you're looking for in reasonable ".
                        \"time ask maintainers to improve documentation")
            call mkdir(a:plugin_root_dir, 'p')
            execute '!git clone --depth=1 https://github.com/MarcWeber/vim-addon-manager '.
                   \shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
            " VAM runs helptags automatically when you install or update plugins
            exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
        endif
        return isdirectory(vam_autoload_dir)
    endif
endfun

fun! SetupVAM()
    " VAM install location:
    let c = get(g:, 'vim_addon_manager', {})
    let g:vim_addon_manager = c
    let g:vim_addon_manager = {'scms': {'git': {}}}
        fun! MyGitCheckout(repository, targetDir)
            let a:repository.url = substitute(a:repository.url, '^git://github', 'http://github', '')
            return vam#utils#RunShell('git clone --depth=1 $.url $p', a:repository, a:targetDir)
        endfun
    let g:vim_addon_manager.scms.git.clone=['MyGitCheckout']
    let c.plugin_root_dir = expand('$HOME/.vim/vim-addons', 1)
    if !EnsureVamIsOnDisk(c.plugin_root_dir)
        echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
        return
    endif
    let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'

    let addons = []

    let addons += ["ctrlp"]
    let addons += ["github:lokaltog/vim-powerline"]
    let addons += ["github:scrooloose/nerdtree"]
    let addons += ["github:scrooloose/nerdcommenter"]

    let addons += ["github:vim-scripts/LycosaExplorer"]
    let addons += ["github:Valloric/YouCompleteMe"]

    " let addons += ["snipmate"]
    " let addons += ["vim-snippets"]
    " let addons += ["github:klen/python-mode"]
    " let addons += ["github:ervandew/supertab"]

    call vam#ActivateAddons(addons, {'auto_install' : 0})
endfun
call SetupVAM()

" Ctrlp Settings
let g:crtlp_max_height = 30
set wildignore += "*.pyc"
set wildignore += "*_build/*"
set wildignore += "*/coverage/*"

" Powerline Settings
set laststatus=2

" NERD Tree Settings
" autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <Leader>t :NERDTreeToggle<CR>

" Python-mode Settings
" let g:pymode_run_bind = "<Leader>r"
" let g:pymode_rope_goto_definition_bind = "<Leader>g"
" let g:pymode_rope_organize_imports_bind = "<Leader>oi"
" let g:pymode_rope_rename_bind = "<Leader>rn"
" let g:pymode_doc_bind = "<Leader>d"

" let ropevim_enable_shortcuts = 1
" let g:pymode_rope_goto_def_newwin = "vnew"
" let g:pymode_rope_extended_complete = 1
" let g:pymode_breakpoint = 0
" let g:pymode_syntax = 1
" let g:pymode_syntax_builtin_objs = 1
" let g:pymode_syntax_builtin_funcs = 1
" map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

" Vim-Latex Settings
let g:tex_flavor='latex'

" Better navigation through omni-complete option list
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfun

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Python folding/editing Settings
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim
" http://www.vim.org/scripts/download_script.php?src_id=5492
set nofoldenable

" LycosaExplorer Settings
set hidden

" YouCompleteMe Settings
let g:ycm_goto_buffer_command = 'new-tab'
nnoremap <leader>gt :YcmCompleter GoTo<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gi :YcmCompleter GoToImprecise<CR>
