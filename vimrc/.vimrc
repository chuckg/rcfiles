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

  autocmd FileType procmail  call PoundComment()
  autocmd FileType muttrc    call PoundComment()
  autocmd FileType python    call PoundComment()
  autocmd FileType perl      call PoundComment()
  autocmd FileType cgi       call PoundComment()
  autocmd FileType csh       call PoundComment()
  autocmd FileType sh        call PoundComment()
  autocmd FileType ruby      call PoundComment()
  autocmd FileType ruby      call SmallAssShiftWidt()
  autocmd FileType html      call HtmlPrepare()
  autocmd FileType php       call HtmlPrepare()
  autocmd FileType php       call PHPPrepare()
  autocmd FileType make      call MakePrepare()
  autocmd BufRead,BufNewFile *.t set ft=perl
endif

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
set noerrorbells
set magic

set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set smarttab

set smartcase
set infercase
set textwidth=80
set laststatus=2  "always put a status line at the bottem of the window.
set visualbell
set ruler
set showmatch  "matching brackets.
set showcmd
set showfulltag
set scrolloff=2				" cursors stays 2 lines below/above top/bottom
"set updatecount=50 updatetime=3600000		" saves power on notebooks

set updatetime=400  "this makes Tlist update which function you are in much faster.
nmap \tl :Tlist<CR>

" open a quick fix window whenever there is something to put in it.
:cwindow
" put cscope results in a quick fix window.
"set csqf=s-,c-,d-,i-,t-,e-

match todo /@@@/

" EMACS LIKE MAPPINGS FOR THE INSERT MODE
"
"  scroll up
"inoremap 		
"  scroll down
"inoremap 		
"  END OF LINE
"inoremap 		<End>
"  START OF LINE
"inoremap 		<Home>

set  tags=./tags,../tags,../../tags,../../../tags

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

"nmap :W :w
"nmap :Q :q
"nmap :Wq :wq

set pastetoggle=<F12>
set number
set stl=%t%y%r%m%=line\ %l\ of\ %L,\ col\ %c,\ %p%%
set comments=b:#,:%,://,fb:-,n:>,n:),s1:/*,mb:*,ex:*/

" ----------------------------------------------------
" Plugin specific settings.

" folder specific vim settings filename (local_vimrc)
let g:local_vimrc = '_vimrc_local.vim' 

" ----------------------------------------------------
" Define functions
function! PoundComment()
   map - mx:s/^/# /<CR>/<C-p><C-p><CR>'x
   map _ mx:s/^\s*# \=//<CR>/<C-p><C-p><CR>'x
   set comments=:#
endfunction

function! SmallAssShiftWidt()
  set shiftwidth=2
  set tabstop=2
endfunction

function! HtmlPrepare()
   source $VIM/vimcurrent/syntax/html.vim
   source $VIM/vimcurrent/indent/html.vim
   set matchpairs+=<:>
   set comments=:<li>
endfunction

function! PHPPrepare()
   source $VIM/vimcurrent/syntax/php.vim
   source $VIM/vimcurrent/indent/php.vim
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

"NOTE TO SELF: read :help repeat
"NOTE TO SELF: read :help user-defined

" fold function bodies in c
nmap <F4> ]]V][zf

" Y to yank from the cursor to the end of the line.
map Y y$

" cycle thru buffers ...
"nnoremap <c-n> :bn<cr>
"nnoremap <c-p> :bp<cr>

" Things for vimsh
" <F5> is used for vimsh
nmap \sh :source ~/.vim/vimsh/vimsh.vim<CR>
let g:vimsh_pty_prompt_override = 0
let g:vimsh_sh                  = '/bin/bash'
let $VIMSH                      = 1

" Things for vimspell (see :help vimspell)
let loaded_vimspell = 1
nmap \s/ <Plug>SpellProposeAlternatives 
let spell_auto_type = "tex,mail,text,txt,html,sgml,otl,cvs"
let spell_auto_jump = 1
let spell_no_readonly = 1

map  <F5>  :TlistToggle<CR>
map  <F7>  :bp<CR>
map  <F8>  :bn<CR>
map  <F9>  :set noscrollbind<bar>set foldcolumn=0<bar>set nodiff<bar>set foldmethod=manual<CR>
map  <F10> :set hls!<bar>set hls?<CR>
imap <F11> /*++<CR><ESC>0Do<ESC>iRoutine Description:<CR><CR>    <CR><CR>Arguments:<CR><CR>    <CR><CR>Return Value:<CR><CR>    <CR><CR>--*/<CR><ESC>0D11kA
nmap <S-F11> /\t<CR>gR <ESC>
" Ian's old method of enabling/disabling paste. 
" nmap <F12> :set mouse=a<bar>set nopaste<bar>set mouse?<CR>
" nmap <S-F12> :set mouse=<bar>set paste<bar>set mouse?<CR>
" The new and improved toggle paste.
nmap <F12> :call Paste_on_off()<CR>

inoremap <MiddleMouse> <C-O>:set paste<cr><MiddleMouse><C-O>:set nopaste<CR>

" sessions - Control-Q to save a session, Control-S to reload it.
" set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
" map <C-Q> :mks! ~/.vim/.session <CR>
" map <C-S> :source ~/.vim/.session <CR>

" make <c-g> more verbose
" proposed by Rajesh Kallingal <RajeshKallingal@email.com>
nnoremap <c-g> 2<c-g>

" So, hitting '*' while in visual mode does a search on everything that
" matches the currently selected area. Of course, this does not work
" with multi-line selections.
vnoremap * <esc>:let save_reg=@"<cr>gvy:let @/=@"<cr>:let @"=save_reg<cr>/<cr>
vnoremap # <esc>:let save_reg=@"<cr>gvy:let @/=@"<cr>:let @"=save_reg<cr>?<cr>


" These commands deal with changing and minimizing windows up and down.
set winminheight=0
map  <C-J> <C-W>j<C-W>_
map  <C-K> <C-W>k<C-W>_

vmap <C-L>  :Align "="<CR>
vmap <C-\>  :FixMacro<CR>
vmap <BS>   :RemoveMacroSlashes<CR>
vmap <C-;>  :Align ":"<CR>
nmap <C-H> :set wrap!<bar>set wrap?<CR>
nmap <C-P> :set paste!<bar>set paste?<CR>
nmap <C-N> :set number!<bar>set number?<CR>

"make tag goto open in a different window when clicking on it with the mouse
map <C-LeftMouse> <LeftMouse><C-Space>g
map g<LeftMouse> <LeftMouse><C-Space>g

vmap p            d"0P

cmap Wq wq
cmap WQ wq

iab Ydate <C-R>=strftime("%m/%d/%y")<CR>
  " Example: 8/16/00
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

 " remember folds
"au BufWinLeave *.c mkview
"au BufWinEnter *.c silent loadview
"au BufWinLeave *.h mkview
"au BufWinEnter *.h silent loadview


" Enable file type detection

"nmap :W :w
"nmap :Q :q
"nmap :Wq :wq

" Terminal Color Settings
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

" This is a function which will allign any '\''s at the end of lines with in
" the given range at the &textwidth.  This functions intended use was to
" allign back-slashes in a macro (in C).
command! -range FixMacro <line1>,<line2>call AlignFinalBSlash()
function! AlignFinalBSlash() range
    let i = a:firstline
    while i <= a:lastline

        "Remove trailing white-space
        exec i . 's/\s\+$//e'
        "Remove trailing '\'
        exec i . 's/\\$//e'
        "Remove trailing white-space
        exec i . 's/\s\+$//e'

        let line_len = strlen(getline(i))
        if line_len < &textwidth
            let N = &textwidth - line_len
            let s = ""
            let j = 1
            while j < N
                let s = s . " "
                let j = j + 1
            endwhile
            call setline(i, getline(i) . s . '\')
        else
            call setline(i, getline(i) . ' \')
        endif

        let i = i + 1
    endwhile
endfunction

" This is a function which will remove any '\''s at the end of lines with in
" the given range.
command! -range RemoveMacroSlashes <line1>,<line2>call RemoveFinalBSlash()
function! RemoveFinalBSlash() range
    let i = a:firstline
    while i <= a:lastline
        "Remove trailing white-space
        exec i . 's/\s\+$//e'
        "Remove trailing '\'
        exec i . 's/\\$//e'
        "Remove trailing white-space
        exec i . 's/\s\+$//e'
        let i = i + 1
    endwhile
endfunction

" This is quick hack of a command that will diff the current file from
" perforce by opening the perforce version in a vertically split window and
" set both to be diffed.
" command! PFD call P4diff()
"function! P4diff()
"    let f  = expand("%")
"    let ft = expand("%:t")
"    exec 'diffthis'
"    exec 'vs +e\ ' . ft
"    exec 'r !p4 print ' . f
"    exec 'diffthis'
"endfunction

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
set foldmethod=manual

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

set background=dark



" the following lines will enable
" item comments.  I'm not sure how though...
set fo+=crq2b
set com& " reset to default
set com^=sr:*\ -,mb:*\ \ ,el:*/ com^=sr://\ -,mb://\ \ ,el:///


"
"   (vim)diff options...
"
set diffopt=iwhite,filler

set diffexpr=MyDiff()
function MyDiff()
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

" GNU coding style due to Tomas Ogren <stric@ing.umu.se>
" set cinoptions={.5s,:.5s,+.5s,t0,g0,^-2,e-2,n-2,p2s,(0,=.5s
" formatoptions=croql cindent sw=4 ts=8


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
if isdirectory(expand("/usr/include/CC/"))
    set path+=/usr/include/CC
endif

" set path+=..,../../

" set     tags=tags,zwei,drei,vier
set wildignore=*.o,*.r,*.so,*.tar,*.tgz
"set wildmode=longest:list,full
set wildmode=list:longest,list:full
"set wildmode=longest:full,full
" set wildmenu

let paste_mode = 0 " 0 = normal, 1 = paste
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
