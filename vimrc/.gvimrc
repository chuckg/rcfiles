" Turn off the annoying ass blinking cursor.
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

" Add some menu's for quick font changing.
amenu Fonts.Monaco\ 11pt         :set gfn=Monaco:h11<cr>
amenu Fonts.Monaco\ 12pt         :set gfn=Monaco:h12<cr>
amenu Fonts.Monaco\ 14pt         :set gfn=Monaco:h14<cr>
amenu Fonts.Menlo\ Regular\ 11pt :set gfn=Menlo\ Regular:h11<cr>
amenu Fonts.Menlo\ Regular\ 12pt :set gfn=Menlo\ Regular:h12<cr>
amenu Fonts.Menlo\ Regular\ 14pt :set gfn=Menlo\ Regular:h14<cr>

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
