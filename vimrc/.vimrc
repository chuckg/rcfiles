version 6.1 

filetype on
syntax on
colors elflord

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

  autocmd FileType procmail  call PoundComment()
  autocmd FileType muttrc    call PoundComment()
  autocmd FileType python    call PoundComment()
  autocmd FileType perl      call PoundComment()
  autocmd FileType cgi       call PoundComment()
  autocmd FileType csh       call PoundComment()
  autocmd FileType sh        call PoundComment()
  autocmd FileType ruby
    \ call PoundComment() |
    \ call SmallAssShiftWidth()
  autocmd FileType html      call HtmlPrepare()
  autocmd FileType php       
    \ call HtmlPrepare() |
    \ call PHPPrepare()
  autocmd FileType make      call MakePrepare()
  autocmd FileType sql       call DashComment()
  
  autocmd BufRead,BufNewFile *.t set ft=perl
  autocmd BufRead,BufNewFile *.thor set ft=ruby
endif


" ----------------------------------------------------
" Load plugins

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
" add it via plugins to ensure we have it in every environment
set runtimepath+=$HOME/.vim/plugins/matchit

" scratch
set runtimepath+=$HOME/.vim/plugins/scratch

" textobj-rubyblock
" http://vimcasts.org/blog/2010/12/a-text-object-for-ruby-blocks/
"   var - visual all ruby block
"   vir - visual inner ruby block
"   ar  - all ruby block
"   ir  - inner ruby block
" textobj-user is required by rubyblock
set runtimepath+=$HOME/.vim/plugins/textobj-user
set runtimepath+=$HOME/.vim/plugins/textobj-rubyblock



" ----------------------------------------------------
" Basics
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
set laststatus=2  "always put a status line at the bottem of the window.
set visualbell
set ruler
set showmatch  "matching brackets.
set showcmd
set showfulltag
set scrolloff=2				" cursors stays 2 lines below/above top/bottom

set foldmethod=manual

set updatetime=400  "this makes Tlist update which function you are in much faster.

" open a quick fix window whenever there is something to put in it.
:cwindow
" put cscope results in a quick fix window.
"set csqf=s-,c-,d-,i-,t-,e-

match todo /@@@/

set wrap
set linebreak

set history=50
set formatoptions=cqrt
set hlsearch
set incsearch
set nolist
set listchars=tab:»·,trail:·
"set listchars=tab:>-,trail:+
set whichwrap=<,>,h,l,[,]

set number
set stl=%t%y%r%m%=line\ %l\ of\ %L,\ col\ %c,\ %p%%
set comments=b:#,:%,://,fb:-,n:>,n:),s1:/*,mb:*,ex:*/


" ----------------------------------------------------
" leader (of men) 
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

" scratch
nnoremap <leader>s :Sscratch<CR>
nnoremap <leader>S :Scratch<CR>

" strip all trailing whitespace 
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>


" ----------------------------------------------------
" search
"   - gdefault applies substitutions globally on lines by default
"   - incsearch/showmatch/hlsearch setup search highlighting as you type 
set gdefault
set incsearch   
set showmatch
set hlsearch
" clear current search
nnoremap <leader><space> :noh<cr>

" use tab keys to match bracket pairs
nmap <tab> %
vmap <tab> %

" ----------------------------------------------------
" pasting
let paste_mode = 0 " 0 = normal, 1 = paste
set pastetoggle=<F12>
nmap <C-P> :set paste!<bar>set paste?<CR>
" The new and improved toggle paste; gives pastetoggle a target 
nmap <F12> :call Paste_on_off()<CR>
" Ian had this in here, I assume it toggles pasting vai middlemouse clicks.
inoremap <MiddleMouse> <C-O>:set paste<cr><MiddleMouse><C-O>:set nopaste<CR>


" ----------------------------------------------------
" window management
set winminheight=0      " allows windows not visible to have 0 height
map  <C-J> <C-W>j<C-W>_ 
map  <C-K> <C-W>k<C-W>_


" ----------------------------------------------------
" mappings (orphaned)

" Y to yank from the cursor to the end of the line.
map Y y$

" Cycle through the buffers
map  <F7>  :bp<CR>
map  <F8>  :bn<CR>

" Turn off F1 help; always hit this shit when I'm going for the escape key.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" TODO: Add automatic folding for different languages.
" fold function bodies in c
" nmap <F4> ]]V][zf

" sessions - Control-Q to save a session, Control-S to reload it.
" set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
" map <C-Q> :mks! ~/.vim/.session <CR>
" map <C-S> :source ~/.vim/.session <CR>

" make <c-g> more verbose
" proposed by Rajesh Kallingal <RajeshKallingal@email.com>
nnoremap <c-g> 2<c-g>

nmap <C-H> :set wrap!<bar>set wrap?<CR>
nmap <C-N> :set number!<bar>set number?<CR>

"make tag goto open in a different window when clicking on it with the mouse
map <C-LeftMouse> <LeftMouse><C-Space>g
map g<LeftMouse> <LeftMouse><C-Space>g

" Hitting '#' in visual mode does a search on the current selection. Will not
" work with multi-line selection.
vnoremap # <esc>:let save_reg=@"<cr>gvy:let @/=@"<cr>:let @"=save_reg<cr>?<cr>

" Unclear, this was in Ian's original config, but I like the way my paste works
" currently so I'm not going to fuck with it.
vmap p            d"0P

" Align on the respective symbols
vmap <C-L>  :Align "="<CR>

" Because I fuck up all the time.
cmap Wq wq 
cmap WQ wq


" ----------------------------------------------------
" Abbreviations
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


" ----------------------------------------------------
" Functions
function! PoundComment()
   map - mx:s/^/# /<CR>/<C-p><C-p><CR>'x
   map _ mx:s/^\s*# \=//<CR>/<C-p><C-p><CR>'x
   set comments=:#
endfunction

function! DashComment()
   map - mx:s/^/-- /<CR>/<C-p><C-p><CR>'x
   map _ mx:s/^\s*-- \=//<CR>/<C-p><C-p><CR>'x
   set comments=:--
endfunction

function! SmallAssShiftWidth()
  set shiftwidth=2
  set tabstop=2
endfunction

function! HtmlPrepare()
"   source $VIM/vimcurrent/syntax/html.vim
"   source $VIM/vimcurrent/indent/html.vim
   set matchpairs+=<:>
   set comments=:<li>
endfunction

function! PHPPrepare()
"   source $VIM/vimcurrent/syntax/php.vim
"   source $VIM/vimcurrent/indent/php.vim
   map - mx:s/^/# /<CR>/<C-p><C-p><CR>'x
   map _ mx:s/^\s*# \=//<CR>/<C-p><C-p><CR>'x
endfunction

function! MakePrepare()
   call PoundComment()
   set  noexpandtab
   set  shiftwidth=8
   set  tabstop=8
   set  softtabstop=8
endfunction

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

 " remember folds
"au BufWinLeave *.c mkview
"au BufWinEnter *.c silent loadview
"au BufWinLeave *.h mkview
"au BufWinEnter *.h silent loadview


" ----------------------------------------------------
" Color Settings
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

" ----------------------------------------------------
" Macros
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
" Add this to your .vimrc file and it'll automatically fold perl functions
" (and possibly other languages that define a subroutine with "sub ...")
" Once you open a perl file, you'll see all functions are folded. You can then
" move to a function and (space) or "zo" to open it, "zc" to close it, "zR" to
" open all folds (normal file) and "zM" to re-fold all folds.  It makes
" skimming over a file a breeze. See ":help folding" for more info on folding
" in general.
"
"function GetPerlFold()
"   if getline(v:lnum) =~ '^\s*sub'
"      return ">1"
"   elseif getline(v:lnum + 2) =~ '^\s*sub' && getline(v:lnum + 1) =~ '^\s*$'
"      return "<1"
"   else
"      return "="
"   endif
"endfunction
"setlocal foldexpr=GetPerlFold()
"setlocal foldmethod=expr 

" This was some scroll wheel stuff...
"
":map <M-Esc>[62~ <MouseDown>
":map! <M-Esc>[62~ <MouseDown>
":map <M-Esc>[63~ <MouseUp>
":map! <M-Esc>[63~ <MouseUp>
":map <M-Esc>[64~ <S-MouseDown>
":map! <M-Esc>[64~ <S-MouseDown>
":map <M-Esc>[65~ <S-MouseUp>
":map! <M-Esc>[65~ <S-MouseUp>



" the following lines will enable
" item comments.  I'm not sure how though...
set fo+=crq2b
set com& " reset to default
set com^=sr:*\ -,mb:*\ \ ,el:*/ com^=sr://\ -,mb://\ \ ,el:///


" ----------------------------------------------------
"   (vim)diff options...
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


"
"
" EXPERIMENTAL:
"
"

set	cindent
"set	cinkeys=0{,0},:,!,o,O,e
"set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,+s,(0,u0,)20,*30,g0
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,+s,(s,us,)20,*30,g0

set	switchbuf=useopen
set	smartcase
set	infercase
if version < 600
    set	shortmess=astI
endif
set	incsearch
set	complete=.,w,b,u,t,i

" [-- PATH SETUP --]
" if v:version >= 600
"     set path=.,~/include/**,~/src/**2,~/.vim/**2,~/lib/**2,/usr/include/**,/usr/X11R6/include/,/usr/local/include,/usr/lib/gcc-lib/i386-linux/2.95.2/include
"     set path=.,~/include/**,/usr/include/**,/usr/X11R6/include/,/usr/local/include,/usr/lib/gcc-lib/i386-linux/2.95.2/include
" endif

set path=.,~/include,/usr/local/include,/usr/include,/usr/include/g++-3,/usr/X11R6/include/,/usr/lib/gcc-lib/i386-linux/2.95.2/include

" if isdirectory(expand("~/pub/mpich/include/"))
"     set path+=~/pub/mpich/include,~/pub/mpich/build/LINUX/ch_p4/include/,~/pub/mpich/build/LINUX/ch_p4/include/c++/
" else
"     set path+=/usr/lib/mpich/include,/usr/lib/mpich/build/LINUX/ch_p4/include/,/usr/lib/mpich/build/LINUX/ch_p4/include/c++
" endif
" set path+=..,../../

" set     tags=tags,zwei,drei,vier
set wildignore=*.o,*.r,*.so,*.tar,*.tgz
"set wildmode=longest:list,full
set wildmode=list:longest,list:full
"set wildmode=longest:full,full
" set wildmenu

" Environment specific settings.
if strlen(findfile("vimrc_env", $HOME . "/.vim"))
    source $HOME/.vim/vimrc_env
endif
