map <Space> <Leader>

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'vimwiki/vimwiki'
Plug 'mzlogin/vim-markdown-toc'
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ap/vim-css-color'
Plug 'lervag/vimtex'
Plug 'SirVer/ultisnips'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
Plug 'dense-analysis/ale'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

set title
set bg=dark
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" Some basics:
    nnoremap c "_c
    " remap jk as Esc
    inoremap jk <Esc>
    " reverse jump next and jump last
    nnoremap <C-i> <C-o>
    nnoremap <C-o> <C-i>
    set nocompatible
    filetype plugin on
    syntax on
    set encoding=utf-8
    set number relativenumber
" Enable autocompletion:
    set wildmode=longest,list,full
" Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
    vnoremap . :normal .<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
    map <leader>o :setlocal spell! spelllang=en_us<CR>
" Space indentation instead of tab indentation
    :set tabstop=4
    :set shiftwidth=4
    :set expandtab


" nvim-gdb, VimEnter used because nvim-gdb does not provide a way to overide <leader>dp
    autocmd VimEnter * map <leader>dp :GdbStartPDB python -m pdb %<CR>


" for save, quit & edit vim config
    map <leader>q :wqa<CR>
    map <leader>gg :e $XDG_CONFIG_HOME/nvim/init.vim<CR>


" ALE
    let g:ale_linters = {'python': ['flake8']}
    let g:ale_fixers = {'*': [], 'python': ['black']}


" Vimtex
    let g:vimtex_delim_toggle_mod_list = [
      \ ['\left', '\right'],
      \ ['\bigl', '\bigr'],
      \ ['\Bigl', '\Bigr'],
      \ ['\biggl', '\biggr'],
      \ ['\Biggl', '\Biggr'],
      \]
    let g:vimtex_view_method = 'zathura'


" Nvim-R
    let R_assign = 2    " press '_' 2 times (instead of 1 time) for ->


" UltiSnips
    let g:UltiSnipsExpandTrigger = '<tab>'
    let g:UltiSnipsListSnippets = '<c-s>'
    let g:UltiSnipsJumpForwardTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" FZF
    map <c-f> :FZF<CR>


" Nerd tree
    map <leader>n :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif


" Shortcutting split navigation, saving a keypress:
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l


" Replace ex mode with gq
    map Q gq


" Check file in shellcheck:
    map <leader>s :!clear && shellcheck -x %<CR>


" " Upload to google drive
"     map <leader>g :w \| !drive push $GDRIVE<CR>


" Open my bibliography file in split
    map <leader>b :vsp<space>$BIB<CR>
    map <leader>r :vsp<space>$REFER<CR>


" Replace all is aliased to S.
    nnoremap S :%s//g<Left><Left>


" Open corresponding .pdf/.html or preview
    map <leader>p :!opout <c-r>%<CR><CR>


" Runs a script that cleans out tex build files whenever I close out of a .tex file.
    autocmd VimLeave *.tex !texclear %


" Vimwiki related, make sure all markdown files are read properly
    let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
    let g:vimwiki_list = [{'path': '~/OneDrive/quick-drive/vimwiki', 'syntax': 'markdown', 'list_margin': 0, 'ext': '.md'}]
    autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
    autocmd BufRead,BufNewFile *.tex set filetype=tex
    let g:vimwiki_markdown_link_ext = 1  " generate links with file.md instead of file
    " silently convert saved vimwiki md files into html files using build-notes
    autocmd BufWritePost */vimwiki/*md silent !build-notes %:p

" Save file as sudo on files that require root permission
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!


" Automatically deletes all trailing whitespace and newlines at end of file on save.
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\n\+\%$//e


" When shortcut files are updated, renew bash and ranger configs with new material:
    autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
    autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults
    autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
    autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }


" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif


" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>
