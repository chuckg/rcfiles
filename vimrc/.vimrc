" required for several plugins
set nocompatible

" -----------------------------------------------------------------------------
" leader (of men)
" -----------------------------------------------------------------------------
let mapleader = ","


" -----------------------------------------------------------------------------
" appearance
" -----------------------------------------------------------------------------

syntax on
colors elflord
set background=dark     " Set to 'light' if you use a light background

highlight Comment       ctermfg=DarkCyan
highlight LineNr        ctermfg=DarkRed

" Terminal Color Settings
set t_Co=16

" Try doing some color
" if has("terminfo")
"     set t_Co=16
"     set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
"     set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
" else
"     set t_Co=16
"     set t_Sf=[3%dm
"     set t_Sb=[4%dm
" endif

:cwindow             " Open a quick fix window whenever there is something to put in it.

set title
set ruler            " Show location of cursor in status bar
set showcmd          " Show multi-char cmds as you type; bottom right
set number           " Show line numbers
set scrolloff=2      " Cursors stays 2 lines below/above top/bottom
set laststatus=2     " Always put a status line at the bottem of the window.

" Status line includes git branch
set statusline=[%n]\ %<%.99f\ %h%w%y%r%m\ %{ETry('fugitive#statusline')}%#ErrorMsg#%*%=%-16(line\ %l\ of\ %L,\ col\ %c,\ %)%P

set nolist
set listchars=tab:»·,trail:·

let loaded_matchparen = 1     " Don't load the match paren plugin.
set noerrorbells              " No noise
set visualbell                " Flash the screen
set linebreak                 " Affects how wrapped text is displayed
set nowrap                    " Turn off wrapping by default.
set foldmethod=manual

" Display current cursor position.  This simply makes it more verbose.
nnoremap <c-g> 2<c-g>

match todo /@@@/


" -----------------------------------------------------------------------------
" interaction
" -----------------------------------------------------------------------------

set confirm                        " Ask user before aborting action
set history=500                    " Remember this many commands / searches
set noautowrite                    " Do not write automatically
set esckeys                        " Function keys that start with an <Esc>
                                   " are recognized in insert mode.

set mouse=a                        " Turn mouse support on
set ttymouse=xterm2                " Enable window-split drag-to-resize. (esp. in
                                   " screen which defaults to 'xterm')
set ttyfast                        " performance boost for vim's display

set backspace=indent,eol,start     " Allows <BS> and ilk to wrap across lines.
set whichwrap=<,>,h,l,[,]          " Allow these movement keys to move to netx line.
set	switchbuf=useopen              " Jump to an existing buffer for files that are
                                   " already open.

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" Tab completion when browsing files.
set wildignore=*.o,*.r,*.so,*.tar,*.tgz
set wildmode=list:longest,full


" -----------------------------------------------------------------------------
" search
" -----------------------------------------------------------------------------

set smartcase     " Make search case-smart; not case-insensitive.
set incsearch     " Show matches while typing.
set hlsearch      " Highlight the search
set showmatch
set gdefault      " Apply substitutions globally by default.

" clear current search
nnoremap <leader><space> :noh<cr>

" Hitting '#' in visual mode does a search on the current selection. Will not
" work with multi-line selection.
vnoremap # <esc>:let save_reg=@"<cr>gvy:let @/=@"<cr>:let @"=save_reg<cr>?<cr>


" -----------------------------------------------------------------------------
" formatting
" -----------------------------------------------------------------------------

set autoindent             " New lines with indentation of previous line.
set expandtab              " Insert spaces when <tab> is pressed
set tabstop=4              " Render <tab> visually using this many spaces
set shiftwidth=4           " Indentation amount for < and > commands (& cindent)
set softtabstop=4          " Indentation amount while in insert mode.
set smartindent
set smarttab               " Make <Tab> and <BS> deal with indentation properly.

set textwidth=78           " Where to auto-wrap long lines.

set formatoptions=cqrt     " Auto-format options for formatting comments.
" set formatlistpat="^\s*\(\d\+[\]:.)}\t -]|\*\|-)\s*"

set comments=b:#,:%,:\",://,fb:-,n:>,n:),s1:/*,mb:*,ex:*/
" set comments=b:#,:%,://,fb:-,n:>,n:),s1:/*,mb:*,ex:*/

set	cindent
"set	cinkeys=0{,0},:,!,o,O,e
"set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,+s,(0,u0,)20,*30,g0
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,+s,(s,us,)20,*30,g0


" -----------------------------------------------------------------------------
" saving/loading files
" -----------------------------------------------------------------------------

set nobackup
set noswapfile
set autoread     " Auto reload files that have been changed outside of VIM when
                 " it has not been changed inside.


" -----------------------------------------------------------------------------
" insert completion
" -----------------------------------------------------------------------------

set infercase                 " For insert completion
set noshowfulltag             " Do not show the full command (wonky with Ruby)
                              " Turning on showfulltag shows c function args

set	complete=.,w,b,u,t,i
" <c-x><c-u> -- user defined completions
" Tag completion
inoremap <c-]> <c-x><c-]>
" Line completion
inoremap <c-l> <c-x><c-l>

" Omni complete (or intellisense for IDE nerds), but start with no completion
" selected instead of the first match.
inoremap <silent> <s-tab> <c-x><c-o><c-p>

" -----------------------------------------------------------------------------
" mappings: copy and pasting
" -----------------------------------------------------------------------------

" Y to yank from the cursor to the end of the line.
map Y y$

" Enable paste in visual mode.
vmap p d"0P

" paste while in insert mode (cmd-v on mac).  This isn't so easy to make hapen
" in nmap mode (someday).
imap <d-v> <c-o>:set paste<cr><c-r>*<c-o>:set nopaste<cr>

" toggle paste mode, (though this shouldn't be needed (on macs) because of the
" 'inoremap <d-v>' above).
nmap <Leader>sp :set paste!<bar>set paste?<cr>

" Middle mouse button turns on pasting.
inoremap <MiddleMouse> <C-O>:set paste<cr><MiddleMouse><C-O>:set nopaste<CR>


" -----------------------------------------------------------------------------
" mappings: window/buffer
" -----------------------------------------------------------------------------

" vim has a bug where it cannot distinguish CTRL-i from <tab>.  I want to use
" CTRL-i and CTRL-o but also I want <tab> to match bracket pairs.  I can't do
" both, so I remap CTRL-p to function as CTRL-i. 
nnoremap <C-p> <C-i>
xnoremap <C-p> <C-i>

" Toggle wrapping
nmap <C-H> :set wrap!<bar>set wrap?<CR>

" Toggle line numbers
nmap <C-N> :set number!<bar>set number?<CR>

" Cycle through the buffers
map  <F7>  :bp<CR>
map  <F8>  :bn<CR>

" Move and maximize horizontal buffers.
set winminheight=0        " Allow windows not visible to have 0 height
map  <C-J> <C-W>j<C-W>_
map  <C-K> <C-W>k<C-W>_

" Buffer resizing mappings (shift + arrow key)
nnoremap <S-Up> <c-w>+
nnoremap <S-Down> <c-w>-
nnoremap <S-Left> <c-w><
nnoremap <S-Right> <c-w>>

" Decrease the number of keystrokes required.
nmap <Leader>q :q<cr>
nmap <Leader>Q :qa<cr>
nmap <Leader>w :w<cr>
nmap <Leader>W :wa<cr>

" Escape by jj, no more reaching out to never never land for the escape key.
imap jj <esc>
imap jJ <esc>
imap Jj <esc>
imap JJ <esc>

" Because, when I don't use the mappings above, I fuck up all the time.
cmap Wq wq
cmap WQ wq

" For when you want to make sure you're not over 80 columns of text.
" toggle colored right border at textwidth +1
nnoremap <Leader>s8 :call <SID>ToggleColorColumn()<cr>
autocmd BufRead * let b:color_column_old='+1'
function! s:ToggleColorColumn()
    echo ':set colorcolumn='b:color_column_old
    if b:color_column_old == ''
        let b:color_column_old = &colorcolumn
        let &colorcolumn=''
    else
        let &colorcolumn=b:color_column_old
        let b:color_column_old=''
    endif
endfunction
" highlight ColorColumn ctermbg=darkgrey guibg=darkgrey
highlight ColorColumn ctermbg=52 guibg=DarkRed


" -----------------------------------------------------------------------------
" mappings: text manipulation/navigation
" -----------------------------------------------------------------------------

" Treat wrapped lines like real lines.
nmap <Up> gk
nmap <Down> gj
nmap k gk
nmap j gj

" use tab keys to match bracket pairs
nmap <tab> %
vmap <tab> %

" insert blank lines without going into insert mode
nmap go o<esc>
nmap gO O<esc>

" select the lines which were just pasted
noremap vv `[V`]

" strip all trailing whitespace
nnoremap <leader>sW :%s/\s\+$//<cr>:let @/=''<CR>


" -----------------------------------------------------------------------------
" mappings: misc
" -----------------------------------------------------------------------------

" Turn off F1 help; always hit this shit when I'm going for the escape key.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Open an edit command with the path of the currently edited file filled in.
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Open the current file in a new tab.
map <Leader>et :tab split<CR>

" Inserts the path of the currently edited file into a command
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" cd/lcd to the directory for the current file in buffer and tell the user
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>lcd :lcd %:p:h<CR>:pwd<CR>


" -----------------------------------------------------------------------------
" abbreviations
" -----------------------------------------------------------------------------

iab Ydatekey <C-R>=strftime("%Y%m%d")<CR>
  " Example: 20100101
iab Ydate <C-R>=strftime("%Y-%m-%d")<CR>
  " Example: 2010-01-01
iab Ytime <C-R>=strftime("%H:%M")<CR>
  " Example: 14:28
iab Ydt   <C-R>=strftime("%Y-%m-%d %T")<CR>
  " Example: 2013-04-30 12:00:00
iab Ystamp <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
  " Example: Tue Dec 16 12:07:00 CET 1997
  "
iab teh the
iab tehy they
iab durring during
iab untill until
iab allways always


" -----------------------------------------------------------------------------
" (vim)diff options...
" -----------------------------------------------------------------------------
set diffopt=iwhite,filler

set diffexpr=MyDiff()
function! MyDiff()
   let opt = ""
   if &diffopt =~ "icase"
"     let opt = opt . "-i "
     let opt = opt . "-wBi "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-b "
   endif
   silent execute "!diff -a " . opt . v:fname_in . " " . v:fname_new .
    \  " > " . v:fname_out
endfunction

" -----------------------------------------------------------------------------
" menus in console vim
" -----------------------------------------------------------------------------

"  press F3 to bring up menus in console-vim
if ! has("gui_running")
    set wildmenu wildcharm=<C-Z>
    nmap <F3> :runtime menu.vim<cr>:emenu <C-Z>
endif

" Misc menu
amenu Misc.Toggle\ case\ for\ searching<Tab>F4      :set ignorecase!<cr>:set ignorecase?<cr>
amenu Misc.Remove\ &trailing\ white-space<Tab>F10   :%s/\s\+$//<cr>:let @/=''<cr>``
amenu Misc.Toggle\ highlight\ search\ results       :set hlsearch!<cr>:set hlsearch?<cr>
amenu Misc.&Save\ Viminfo                           :set viminfo='7,n./viminfo<cr>:wv<cr>:set viminfo=<cr>

" -----------------------------------------------------------------------------
" plugins
" -----------------------------------------------------------------------------

" filetype must be off to load vundle properly; it's re-enabled further down.
filetype off

" Load Vundle. Self sexify.
set runtimepath+=$HOME/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" ack
Bundle 'mileszs/ack.vim'
nnoremap <leader>a :Ack<space>

" file:line
" Allows opening a file directly to a line in the following way: 
" :e file/path.txt:12
Bundle 'bogado/file-line'

" fugitive: sexy git wrapper
Bundle 'fugitive.vim'
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gg :Ggrep
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gm :Gmove

" fuzzyfinder
Bundle 'L9'
Bundle 'FuzzyFinder'
let g:fuf_file_exclude         = '\v\~$|\.(o|exe|dll|bak|orig|sw[po])$|(^|[/\\])\.?(hg|git|bzr|vendor)($|[/\\])'
let g:fuf_coveragefile_exclude = '\v\~$|\.(o|exe|dll|bak|orig|sw[po])$|(^|[/\\])\.?(hg|git|bzr|vendor)($|[/\\])'
let g:fuf_dir_exclude          = '\v(^|[/\\])\.?(hg|git|bzr|vendor)($|[/\\])'
nnoremap <leader>t :FufFile **/<CR>
nnoremap <leader>T :FufRenewCache<CR>

" indent-guides
Bundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size  = 1
nnoremap <leader>ig :IndentGuidesToggle<CR>

" matchit
Bundle 'edsono/vim-matchit'

"Bundle 'scrooloose/nerdcommenter'
Bundle 'The-NERD-Commenter'
" comment/uncomment: mappings to nerdcommenter
nmap - :call NERDComment(0, 'nested')<CR>
nmap _ :call NERDComment(0, 'uncomment')<CR>
vmap - :call NERDComment(1, 'nested')<CR>
vmap _ :call NERDComment(0, 'uncomment')<CR>

" rails
Bundle 'tpope/vim-rails'
let g:rails_ctags_arguments = "--languages=-javascript"
let g:rails_ctags_arguments .= " --extra=+f"
let g:rails_ctags_arguments .= " --exclude=.git --exclude=log"
"let g:rails_ctags_arguments .= " `bundle show rails`/../*"
let g:rails_ctags_arguments .= " `ruby -rrubygems -e 'p Gem.path.collect {|p| [\"gems\", File.join(\"bundler\", \"gems\")].collect {|d| File.join(p, d)} }.join(\" \")' | sed 's/\"//g'`"

" scratch
Bundle 'scratch.vim'
"nnoremap <leader>s :Sscratch<CR>
"nnoremap <leader>S :Scratch<CR>

" surround
Bundle 'tpope/vim-surround'

" Tabular
Bundle 'godlygeek/tabular'
function! CustomTabularPatterns()
    if exists('g:tabular_loaded')
        AddTabularPattern! assignment      / = /l0
        AddTabularPattern! chunks          / \S\+/l0
        AddTabularPattern! colon           /:\zs /l0
        AddTabularPattern! comma           /^[^,]*,/l1
        AddTabularPattern! hash            /^[^>]*\zs=>/
        AddTabularPattern! options_hashes  /:\w\+ =>/
        AddTabularPattern! symbol          /^[^:]*\zs:/l1r0
        AddTabularPattern! symbols         / :/l0
        AddTabularPattern! doublequote     /"/l5c1
        AddTabularPattern! first_bracket   /^[^{]*\zs{/l1
    endif
endfunction
autocmd VimEnter * call CustomTabularPatterns()
map <leader>e= :Tabularize assignment<CR>
map <leader>e: :Tabularize colon<CR>
map <leader>e, :Tabularize comma<CR>
map <leader>e> :Tabularize hash<CR>
map <leader>e" :Tabularize doublequote<CR>

" textobj-rubyblock
" http://vimcasts.org/blog/2010/12/a-text-object-for-ruby-blocks/
"   var - visual all ruby block
"   vir - visual inner ruby block
"   ar  - all ruby block
"   ir  - inner ruby block
" textobj-user is required by rubyblock
Bundle 'textobj-user'
Bundle 'textobj-rubyblock'

" -----------------------------------------------------------------------------
" colors
" -----------------------------------------------------------------------------

Bundle 'tpope/vim-vividchalk'

" -----------------------------------------------------------------------------
" filetype  (special things for special file types)
" -----------------------------------------------------------------------------

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" For all text files set 'textwidth' to 78 characters.
au FileType text setlocal tw=78

" Perl Test::More file format.
autocmd BufRead,BufNewFile *.t set ft=perl

" Thorfile, Rakefile, Vagrantfile, and Gemfile are Ruby
autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

" JSON is JS
autocmd BufNewFile,BufRead *.json set ai filetype=javascript

" md, markdown, and mk are markdown and define buffer-local preview
autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} set ft=markdown

" Setup proper tabs per file type.
autocmd FileType ruby setl tabstop=2 shiftwidth=2 softtabstop=2

" -----------------------------------------------------------------------------
" tags
" -----------------------------------------------------------------------------

" vim-rails creates tags in `tmp/tags` when you generate using :Rtags
set tags=./tags,tags,tmp/tags

" -----------------------------------------------------------------------------
" syntax
" -----------------------------------------------------------------------------

Bundle "vim-ruby/vim-ruby"
Bundle "tpope/vim-markdown"
Bundle "vim-coffee-script"

" http://www.vim.org/scripts/script.php?script_id=2075
Bundle "indenthtml.vim"
" Force the following tags to indent children as well
let g:html_indent_inctags = 'head,body'

" -----------------------------------------------------------------------------
" functions
" -----------------------------------------------------------------------------

" Attempts to call a function and return the result, otherwise it does nothing.
function! ETry(function, ...)
    if exists('*'.a:function)
        return call(a:function, a:000)
    else
        return ''
    endif
endfunction


" -----------------------------------------------------------------------------
" Load local configuration options
" -----------------------------------------------------------------------------

if filereadable(expand("~/.vimrc_local"))
    source ~/.vimrc_local
endif
