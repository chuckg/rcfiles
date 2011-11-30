" Turn off the blasted blinking cursor.
set guicursor=a:blinkon0

" Set the font, 12pt Monaco.
set gfn=Monaco:h12

" Use gui tabs
set guioptions+=e

" Start without the toolbar
set guioptions-=T

" Kill the scrollbars
set guioptions-=r
set guioptions-=L

" Go full screen like you mean it
if has('win32')
  au GUIEnter * simalt ~x
elseif has('mac')
  set fuoptions=maxvert,maxhorz
endif

" Load local configuration options
if filereadable(expand("~/.gvimrc_local"))
    source ~/.gvimrc_local
endif
