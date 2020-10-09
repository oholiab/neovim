set nu
let mapleader=" "
nnoremap <leader>s :source ~/.config/nvim/init.vim<CR>
set timeoutlen=2000

" Statusline
"" File and filetype
set statusline=%f\ %y
"" Split to the left
set statusline+=%=
"" Current line out of total
set statusline+=%4l/%-4L

" Default preferences
set expandtab
set autoindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nohlsearch incsearch
syntax enable

" Markdown
au FileType markdown setlocal textwidth=79
au FileType markdown nnoremap <buffer> <leader>d V:s/\[ \]/[*]/<CR>
au FileType markdown nnoremap <buffer> <leader>o o*<space>[<space>]<space>
au FileType markdown hi UncheckedTodo ctermbg=yellow
au FileType markdown syn match UncheckedTodo /\[<space>\]/
au FileType markdown hi CheckedTodo ctermbg=green
au FileType markdown syn match CheckedTodo /\[\*\]/
au FileType markdown hi TodoTitle cterm=underline
au FileType markdown syn match TodoTitle /^TITLE: .\+$/

" Keybindings
" Window management
nnoremap <leader>w\| :vnew<CR>
nnoremap <leader>w- :new<CR>
nnoremap <leader>wd :bd<CR>
for i in ['h', 'j', 'k', 'l']
  execute "nnoremap <leader>w" . i . " <c-w>" . i . "<CR>"
endfor

"" File and buffer management
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>bh :History<CR>

"" Cut and paste
let osname = system("uname")
if osname == "Darwin"
  vnoremap <leader>y :w ! pbcopy<CR><CR>
elseif osname == "Linux"
  vnoremap <leader>y :w ! wl-copy<CR><CR>
endif

" Plugins
call plug#begin('~/.nvim/plugged')
cnoreabbrev PluginInstall PlugInstall
"" Navigation
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'

" Python
let g:python3_host_prog = '$HOME/.config/nvim/py37/bin/python'
Plug 'numirias/semshi', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
au FileType python set signcolumn=yes
au FileType python nnoremap <buffer> <leader>r  :Semshi rename<CR>
au FileType python nnoremap <buffer> <Tab>      :Semshi goto name next<CR>
au FileType python nnoremap <buffer> <S-Tab>    :Semshi goto name prev<CR>
au FileType python nnoremap <buffer> <leader>ge :Semshi goto error<CR>
au FileType python nnoremap <buffer> <leader>e  :Semshi error<CR>

""" Override default Semshi highlight to be less distracting
function CustomSemshiHighlights()
  hi semshiSelected ctermfg=161 cterm=underline
endfunction
au FileType python call CustomSemshiHighlights()

call plug#end()

" Trailing whitespace
highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/

echo "Loaded"
