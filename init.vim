set nu
let mapleader=" "
nnoremap <leader>s :source ~/.config/nvim/init.vim<CR>
set timeoutlen=2000
set signcolumn=yes

" Auto-reload changes from disk
set autoread
au CursorHold * checktime

" Hide buffers instead of closing them
set hidden

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
au FileType markdown set conceallevel=2
au FileType markdown call matchadd('Conceal', '\(https:\/\/.+\)', 10, 99, {'conceal': '()'})

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
nnoremap <leader>fh :History<CR>
nnoremap <leader>fF :Files<CR>
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fr :Rg<CR>
nnoremap <leader><leader> <c-^>
nnoremap <leader>ze :e $HOME/.config/nvim/init.vim<CR>
nnoremap <leader>gb :Git blame<CR>

"" Text reflow
""" Reflow current paragraph
nnoremap <leader>pr vipgq<CR>

"" Cut and paste
vnoremap <space> <Nop>
if has("macunix")
  vnoremap <leader>y y:call system("pbcopy", @")<CR>:echo "Copied"<CR>
elseif has("unix")
  vnoremap <leader>y y:call system("wl-copy", @")<CR>:echo "Copied"<CR>
endif

"" Meta
""" Display syntax features under cursor
nnoremap <leader>h :echom "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Plugins
call plug#begin('~/.nvim/plugged')
cnoreabbrev PluginInstall PlugInstall
"" Navigation
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'

"" Python
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
au FileType python set signcolumn=yes

"" Language server???
Plug 'neovim/nvim-lspconfig'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

"" Clojure
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

"" Puppet :(
Plug 'rodjek/vim-puppet', {'for': 'puppet' }

"" Golang
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries' }

"" Terraform
Plug 'hashivim/vim-terraform', {'for': 'tf'}

"" XML
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END

Plug 'scrooloose/syntastic'
call plug#end()

set completeopt=menu,menuone,noselect
lua <<EOF

-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- require'lspconfig'.pyright.setup{}
-- require'lspconfig'.vimls.setup{}

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['vimls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['puppet'].setup {
    capabilities = capabilities
  }
EOF

" Trailing whitespace
highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/

echo "Loaded"
