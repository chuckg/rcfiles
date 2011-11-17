filetype on

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " For all text files set 'textwidth' to 78 characters.
    au FileType text setlocal tw=78

    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

    " Autosave changes when focus is lost. Commented out because this really
    " wreaks havoc if you're doing any kind of branching with git and leave the
    " file buffers open.
    " autocmd FocusLost * :wa

    " Perl Test::More file format.
    autocmd BufRead,BufNewFile *.t set ft=perl

    " Thorfile, Rakefile, Vagrantfile, and Gemfile are Ruby
    autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby
    
    " JSON is JS
    autocmd BufNewFile,BufRead *.json set ai filetype=javascript

    " md, markdown, and mk are markdown and define buffer-local preview
    autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} set ft=markdown
endif

" -----------------------------------------------------------------------------
" Appearance
" -----------------------------------------------------------------------------

colors elflord

syntax on

:cwindow        " open a quick fix window whenever there is something to put in it.

" -----------------------------------------------------------------------------
" Load plugins
" -----------------------------------------------------------------------------

" man
runtime ftplugin/man.vim

" ack
set runtimepath+=$HOME/.vim/plugins/ack

" fugitive: sexy git wrapper
set runtimepath+=$HOME/.vim/plugins/fugitive

" fuzzyfinder
" l9 is required by fuzzy finder
set runtimepath+=$HOME/.vim/plugins/l9
set runtimepath+=$HOME/.vim/plugins/fuzzyfinder

" Added exclude for vendor directory
let g:fuf_file_exclude         = '\v\~$|\.(o|exe|dll|bak|orig|sw[po])$|(^|[/\\])\.?(hg|git|bzr|vendor)($|[/\\])'
let g:fuf_coveragefile_exclude = '\v\~$|\.(o|exe|dll|bak|orig|sw[po])$|(^|[/\\])\.?(hg|git|bzr|vendor)($|[/\\])'
let g:fuf_dir_exclude          = '\v(^|[/\\])\.?(hg|git|bzr|vendor)($|[/\\])'

" matchit
set runtimepath+=$HOME/.vim/plugins/matchit

" NERDcommenter: easy comments
set runtimepath+=$HOME/.vim/plugins/nerdcommenter

" ruby_focused_unit_test
set runtimepath+=$HOME/.vim/plugins/ruby_focused_unit_test

" scratch
set runtimepath+=$HOME/.vim/plugins/scratch

" textobj-rubyblock
" http://vimcasts.org/blog/2010/12/a-text-object-for-ruby-blocks/
"   var - visual all ruby block
"   vir - visual inner ruby block
"   ar  - all ruby block
"   ir  - inner ruby block
" textobj-user is required by rubyblock
set runtimepath+=$HOME/.vim/plugins/vim-textobj-user
set runtimepath+=$HOME/.vim/plugins/vim-textobj-rubyblock


" -----------------------------------------------------------------------------
" Basics
" -----------------------------------------------------------------------------
let loaded_matchparen = 1
set confirm
set autoindent
set mouse=a
set noautowrite
set title
set nocompatible
set esckeys
set backspace=indent,eol,start
set nobackup
set noswapfile
set noerrorbells
set magic

set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set smarttab

set smartcase
set infercase
set textwidth=79
set visualbell
set ruler
set showcmd
set showfulltag

set foldmethod=manual

" tab completion
set wildignore=*.o,*.r,*.so,*.tar,*.tgz
set wildmode=list:longest,full

set updatetime=400  "this makes Tlist update which function you are in much faster.

set nowrap
set linebreak

set history=50
set formatoptions=cqrt
set nolist
set listchars=tab:»·,trail:·
set whichwrap=<,>,h,l,[,]

set number
set comments=b:#,:%,://,fb:-,n:>,n:),s1:/*,mb:*,ex:*/

" always put a status line at the bottem of the window.
set laststatus=2  

" cursors stays 2 lines below/above top/bottom
set scrolloff=2				

" Status line includes git branch
set statusline=[%n]\ %<%.99f\ %h%w%y%r%m\ %{ETry('fugitive#statusline')}%#ErrorMsg#%*%=%-16(line\ %l\ of\ %L,\ col\ %c,\ %)%P

" jump to an existing buffer for files that are already open
set	switchbuf=useopen

" allows windows not visible to have 0 height
set winminheight=0


" -----------------------------------------------------------------------------
" leader (of men)
" -----------------------------------------------------------------------------
let mapleader = ","

" ack
" Use ACK_OPTIONS to place options by default or check the manpage to use .ackrc
nnoremap <leader>a :Ack

" fugitive
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gg :Ggrep
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gm :Gmove

" fuzzyfinder
" - search
nnoremap <leader>t :FufFile **/<CR>
" - clear cache
nnoremap <leader>T :FufRenewCache<CR>

" ruby_focused_unit_test
nnoremap <Leader>ra :wa<CR> :RunAllRubyTests<CR>
nnoremap <Leader>rc :wa<CR> :RunRubyFocusedContext<CR>
nnoremap <Leader>rf :wa<CR> :RunRubyFocusedUnitTest<CR>
nnoremap <Leader>rl :wa<CR> :RunLastRubyTest<CR>

" scratch
nnoremap <leader>s :Sscratch<CR>
nnoremap <leader>S :Scratch<CR>

" strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" shortcut to save all
nmap <Leader>ss :wa<cr>

" open an edit command with the path of the currently edited file filled in
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>


" -----------------------------------------------------------------------------
" search
"   - gdefault applies substitutions globally on lines by default
"   - incsearch/showmatch/hlsearch setup search highlighting as you type
" -----------------------------------------------------------------------------
set gdefault
set incsearch
set showmatch
set hlsearch
" clear current search
nnoremap <leader><space> :noh<cr>

" Hitting '#' in visual mode does a search on the current selection. Will not
" work with multi-line selection.
vnoremap # <esc>:let save_reg=@"<cr>gvy:let @/=@"<cr>:let @"=save_reg<cr>?<cr>


" -----------------------------------------------------------------------------
" pasting
" -----------------------------------------------------------------------------
let paste_mode = 0 " 0 = normal, 1 = paste
set pastetoggle=<F12>
nmap <C-P> :set paste!<bar>set paste?<CR>
" The new and improved toggle paste; gives pastetoggle a target
nmap <F12> :call Paste_on_off()<CR>
" Ian had this in here, I assume it toggles pasting vai middlemouse clicks.
inoremap <MiddleMouse> <C-O>:set paste<cr><MiddleMouse><C-O>:set nopaste<CR>


" -----------------------------------------------------------------------------
" Mappings: window/buffer manipulation
" -----------------------------------------------------------------------------

" Toggle wrapping
nmap <C-H> :set wrap!<bar>set wrap?<CR>

" Toggle line numbers
nmap <C-N> :set number!<bar>set number?<CR>

" Cycle through the buffers
map  <F7>  :bp<CR>
map  <F8>  :bn<CR>

" Move and maximize horizontal buffers.
map  <C-J> <C-W>j<C-W>_
map  <C-K> <C-W>k<C-W>_

" Buffer resizing mappings (shift + arrow key)
nnoremap <S-Up> <c-w>+
nnoremap <S-Down> <c-w>-
nnoremap <S-Left> <c-w><
nnoremap <S-Right> <c-w>>


" -----------------------------------------------------------------------------
" Mappings: text manipulation/navigation
" -----------------------------------------------------------------------------

" comment/uncomment: mappings to nerdcommenter
nmap - :call NERDComment(0, 'alignLeft')<CR>
vmap - :call NERDComment(1, 'alignLeft')<CR>

nmap _ :call NERDComment(0, 'uncomment')<CR>
vmap _ :call NERDComment(0, 'uncomment')<CR>

" use tab keys to match bracket pairs
nmap <tab> %
vmap <tab> %

" Y to yank from the cursor to the end of the line.
map Y y$

" insert blank lines without going into insert mode
nmap go o<esc>
nmap gO O<esc>

" select the lines which were just pasted
noremap vv `[V`]

" Align on the respective symbols
vmap <C-L>  :Align "="<CR>

" Enable paste in visual mode.
vmap p d"0P


" -----------------------------------------------------------------------------
" Mappings: misc
" -----------------------------------------------------------------------------


" Turn off F1 help; always hit this shit when I'm going for the escape key.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" make <c-g> more verbose
" proposed by Rajesh Kallingal <RajeshKallingal@email.com>
nnoremap <c-g> 2<c-g>

" Because I fuck up all the time.
cmap Wq wq
cmap WQ wq

" Inserts the path of the currently edited file into a command
" " Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>


" -----------------------------------------------------------------------------
" Abbreviations and highlights
" -----------------------------------------------------------------------------

iab Ydatekey <C-R>=strftime("%Y%m%d")<CR>
  " Example: 20100101
iab Ydate <C-R>=strftime("%Y-%m-%d")<CR>
  " Example: 2010-01-01
iab Ytime <C-R>=strftime("%H:%M")<CR>
  " Example: 14:28
iab Ydt   <C-R>=strftime("%m/%d/%y %T")<CR>
  " Example: 971027 12:00:00
iab Ystamp <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
  " Example: Tue Dec 16 12:07:00 CET 1997
  "
iab teh the
iab tehy they
iab durring during
iab untill until
iab allways always

match todo /@@@/

" -----------------------------------------------------------------------------
" Functions
" -----------------------------------------------------------------------------
func! Paste_on_off()
    if g:paste_mode == 0
        set paste
        let g:paste_mode = 1
    else
        set nopaste
        let g:paste_mode = 0
    endif
    return
endfunc

" augment status line
function! ETry(function, ...)
    if exists('*'.a:function)
        return call(a:function, a:000)
    else
        return ''
    endif
endfunction

" -----------------------------------------------------------------------------
" Color Settings
" -----------------------------------------------------------------------------
set background=dark

highlight Comment       ctermfg=DarkCyan
"highlight Constant      ctermfg=DarkMagenta
"highlight Character     ctermfg=DarkRed
"highlight Special       ctermfg=DarkBlue
"highlight Function      ctermfg=DarkBlue
"highlight Identifier    ctermfg=DarkGrey
"highlight Statement     ctermfg=DarkBlue
"highlight PreProc       ctermfg=DarkBlue
"highlight Type          ctermfg=DarkBlue
"highlight Number        ctermfg=DarkBlue
highlight LineNr        ctermfg=DarkRed
"highlight Delimiter     ctermfg=DarkBlue
"highlight Error         ctermfg=Black
"highlight Todo          ctermfg=DarkBlue
"highlight WarningMsg    term=NONE           ctermfg=Black   ctermbg=NONE
"highlight ErrorMsg      term=NONE           ctermfg=DarkRed ctermbg=NONE

""Try doing some color
"  "Try using 88 colors
if has("terminfo")
    set t_Co=16
    set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
    set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
else
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
endif

" -----------------------------------------------------------------------------
" Macros
" -----------------------------------------------------------------------------
com! -range Align <line1>,<line2>call AlignOnRE(<q-args>)
fun! AlignOnRE(re) range
    let last = 0
    let i = a:firstline
    while i <= a:lastline
        exec "let col" . i . "= match(getline(i)," . a:re . ")"
        exec 'if col' . i . '> last | let last = col' . i . '| endif'
        let i = i + 1
    endwhile
    let i = a:firstline
    while i <= a:lastline
        exec ' let col = col' . i
        if col > 0
            exec 'let N = last - col' . i
            let s = ""
            let j = 1
            while j <= N
                let s = s . " "
                let j = j + 1
            endwhile
            let dots = strpart(getline(i), 0, col)
            let dots = substitute(dots, '.', '.', 'g')
            let str = substitute(getline(i), '^' . dots, '&' . s, '')
            call setline(i, str)
        endif
        let i = i + 1
    endwhile
endfun

" the following lines will enable
" item comments.  I'm not sure how though...
set fo+=crq2b
set com& " reset to default
set com^=sr:*\ -,mb:*\ \ ,el:*/ com^=sr://\ -,mb://\ \ ,el:///


" -----------------------------------------------------------------------------
"   (vim)diff options...
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


"
"       Menus in console vim
"
"  press F3 to bring up menus in console-vim

if ! has("gui_running")
	set wildmenu wildcharm=<C-Z>
	nmap <F3> :runtime menu.vim<CR>:emenu <C-Z>
endif


"      Font menu

amenu F&ont.&5x7			:set guifont=5x7<CR><C-L>
amenu F&ont.&6x10			:set guifont=6x10<CR><C-L>
amenu F&ont.6x13			:set guifont=6x13<CR><C-L>
amenu F&ont.&7x13			:set guifont=7x13<CR><C-L>
amenu F&ont.&8x13			:set guifont=8x13<CR><C-L>
amenu F&ont.&9x15			:set guifont=9x15<CR><C-L>
amenu F&ont.&10x20			:set guifont=10x20<CR><C-L>
amenu F&ont.&12x24			:set guifont=12x24<CR><C-L>
amenu F&ont.&heabfix		:set guifont=-*-haebfix-medium-r-normal-*-15-*-*-*-*-*-*-*<CR><C-L>
amenu F&ont.&lucida			:set guifont=-*-lucidatypewriter-medium-r-*-*-14-*-*-*-*-*-*-*<CR><C-L>



"
"      Misc menu
"

amenu Misc.Remove\ &trailing\ white-space<Tab>F10	:%s/\s\+$//<CR>``
amenu Misc.&Save\ Viminfo							:set viminfo='7,n./viminfo<CR>:wv<CR>:set viminfo=<CR>
amenu Misc.Toggle\ case\ for\ searching<Tab>F4		:set ignorecase!<CR>:set ignorecase?<CR>
amenu Misc.Toggle\ highlight\ search\ results		:set hlsearch!<CR>:set hlsearch?<CR>
amenu Misc.Spell\ Check\ Menu						:runtime my/spellcheck.vim<CR>
amenu Misc.All\ Chars\ Menu							:runtime my/char_menu.vim<CR>


" -----------------------------------------------------------------------------
" the "wtf are these" section
" -----------------------------------------------------------------------------

set	cindent
"set	cinkeys=0{,0},:,!,o,O,e
"set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,+s,(0,u0,)20,*30,g0
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,+s,(s,us,)20,*30,g0

set	complete=.,w,b,u,t,i



" -----------------------------------------------------------------------------
" Load local configuration options
" -----------------------------------------------------------------------------
if filereadable("$HOME/.vimrc_local")
    source $HOME/.vimrc_local
endif

if filereadable("$HOME/.gvimrc_local")
    source $HOME/.gvimrc_local
endif
