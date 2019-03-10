"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
    "Windows size
    set columns=120
    set lines=57
    " Height of the command bar
    set cmdheight=3
    function! s:SetFullWindows()
        set columns=317
        set lines=57
    endfunction
    com! FULLWINDOWS call s:SetFullWindows()
    function! s:SetSmallWindows()
        set columns=90
        set lines=40
    endfunction
    com! SMALLWINDOWS call s:SetSmallWindows()
    function! s:SetNormalWindows()
        set columns=120
        set lines=57
    endfunction
    com! NORMALWINDOWS call s:SetNormalWindows()
endif
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set shell
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shellcmdflag=-fc

set diffopt+=iwhite
set diffexpr=""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set warp
"set nowarp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Taglist settings
let Tlist_WinWidth = 40
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1                
let Tlist_Use_left_Window=1              
let Tlist_File_Fold_Auto_Close=1         
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set guifont=gothic\ 10
set guifont=Monospace\ 16
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"disable bell
set noerrorbells
set noeb vb t_vb=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Encoding
set termencoding=utf-8
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,gbk,cp936,latin-1

" Sets how many lines of history VIM has to remember
set history=900

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" flodmethod
set foldmethod=syntax        

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set title
"let &titleold=getcwd()
"show line number
set nu
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler
set rulerformat=%15(%c%V\ %p%%%)

" turn off ring
set vb t_vb=

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" () etc auto match

":inoremap ( ()<ESC>i

":inoremap ) <c-r>=ClosePair(')')<CR>

":inoremap { {}<ESC>i

":inoremap } <c-r>=ClosePair('}')<CR>

":inoremap [ []<ESC>i

":inoremap ] <c-r>=ClosePair(']')<CR>

":inoremap " ""<ESC>i

":inoremap ' ''<ESC>i

":inoremap ` ``<ESC>i
"function ClosePair(char)
"    if getline('.')[col('.') - 1] == a:char
"       return "\<Right>"
"    else
"       return a:char
"    endif
"endf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => matchit
let loaded_matchit = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
syntax on  

if has("gui_running")
"  colorscheme sandydune
  colorscheme desert
else
  colorscheme sean
endif
set background=dark
" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
"    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix
set ff=unix

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python 2.7 syntax highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let python_version_2 = 1
"let python_highlight_builtins = 1
"let python_highlight_exceptions = 1
"let python_highlight_indent_errors = 1
let python_highlight_all = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


" --------------------
" ShowMarks
" --------------------
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let g:showmarks_enable = 1
" For marks a-z
highlight ShowMarksHLl gui=bold guibg=LightBlue guifg=Blue ctermfg=white ctermbg=blue
" For marks A-Z
highlight ShowMarksHLu gui=bold guibg=LightRed guifg=DarkRed ctermfg=white ctermbg=blue
" For all other marks
highlight ShowMarksHLo gui=bold guibg=LightYellow guifg=DarkYellow ctermfg=white ctermbg=blue
" For multiple marks on the same line.
highlight ShowMarksHLm gui=bold guibg=LightGreen guifg=DarkGreen ctermfg=red ctermbg=blue

" --------------------
" Map Alt
" --------------------
"  Disable window alt
set winaltkeys=no
" --------------------
" Hightlight
" --------------------
"  remove the search hightlight
"map \h <Esc>:noh<Esc>
"Alt+h
map <M-h> <Esc>:noh<Esc>
" --------------------
" Replace words without tap
" --------------------
noremap ty lb"bye
noremap tp lb"bPlcw<ESC>hb
" --------------------
" Copy&Phase Line in buffer z
" --------------------
"noremap ty "zyy
"noremap tp "zp
" --------------------
" Diff
" --------------------
"  diff between opened two windows
map <M-d> <Esc><C-h><Esc>:diffthis<Esc><C-l>:diffthis<Esc><C-h>
" diff between the currently edited file and its unmodified version in the filesystem
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

"diff with the svn base function
function! DIFF_WITH_SVN_(rev)
  let filetype=&ft
"  let rev=${1}
  diffthis
  vnew | exe "%!svn cat -r"a:rev " "  . expand("#:cpp:h")
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSVN    call DIFF_WITH_SVN_("'BASE'")
"diff with the old svn
com! DiffOLDSVN call DIFF_WITH_SVN_("'PREV'")
"diff with the newest svn
com! DiffNEWSVN call DIFF_WITH_SVN_("'HEAD'")

" Switch off diff-mode of all currently open windows.
command! DiffOff call DiffOff()
function! DiffOff()
  windo set nodiff
  windo set noscrollbind
  " Reset, then restore the 'foldmethod' and 'foldcolumn' settings by
  " re-setting the filetype. This triggers the filetype-based folding to be
  " reactivated, and ( contrary to a simple :e!) works even on modified
  " buffers.
  windo set foldmethod=manual
  windo set foldcolumn=0
  windo let &filetype = &filetype
endfunction
" <F11> moves to "previous" change location,
" <F12> moves to "next" change location,
map <F36> [c
map <F37> ]c

" SHIFT<F12> does a "diff put" change location,
map <S-F37> dp
" SHIFT<F11> does a "diff get" change location,
map <S-F36> do
"--------------------------------------------------------------------------------
function! SetDiffEnviron()
  set diff
  set scrollbind
  set scrollopt=ver,jump,hor
  set nowrap
  set fdm=diff
endfunction
:command! SetDiffEnviron call SetDiffEnviron()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map up down to c-e c-y
map <down> <C-e>
map <up>   <C-y>
" map ctrl up down to up down
inoremap <c-down> <down>
inoremap <c-up> <up>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""set list
""set listchars=tab:>-,trail:-
" SeeTab: toggles between showing tabs and using standard listchars
fu! SeeTab()
    if !exists("g:SeeTabEnabled")
      let g:SeeTabEnabled = 1
      let g:SeeTab_list = &list
      let g:SeeTab_listchars = &listchars
      let regA = @a
      redir @a
      silent hi SpecialKey
      redir END
      let g:SeeTabSpecialKey = @a
      let @a = regA
      "silent! hi SpecialKey guifg=gold ctermfg=black ctermbg=magenta
      silent hi SpecialKey guifg=gold4 ctermfg=black ctermbg=magenta
      set list
      ""set listchars=tab:\|\
      set listchars=tab:\|-\,trail:-  
    else
      let &list = g:SeeTab_list
      let &listchars = &listchars
      silent! exe "hi ".substitute(g:SeeTabSpecialKey,'xxx','','e')
      unlet g:SeeTabEnabled g:SeeTab_list g:SeeTab_listchars
    endif
endfunc
com! -nargs=0 SeeTab :call SeeTab()
""call SeeTab()
"Use syntax highlighting when expand tabs are on. Note the use of &sw to get the current shiftwidth for the expanded tabs. 

""fu! SeeTab()
""  if !exists("g:SeeTabEnabled")
""    let g:SeeTabEnabled = 0
""  end
""  if g:SeeTabEnabled==0
""    syn match leadspace /^\s\+/ contains=syntab
""    exe "syn match syntab /\\s\\{" . &sw . "}/hs=s,he=s+1 contained"
""    hi syntab guibg=Grey
""    let g:SeeTabEnabled=1
""  else
""    syn clear leadspace
""    syn clear syntab
""    let g:SeeTabEnabled=0
""  end
""endfunc
""com! -nargs=0 SeeTab :call SeeTab()


" That awful mixed mode with the half-tabs-are-spaces:
map \M <Esc>:set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>

" Mini tabs, small "m":
map \m <Esc>:set expandtab softtabstop=2 tabstop=2 shiftwidth=2<CR>

" Think "little tabs" and "big tabs":
map \t <Esc>:set expandtab softtabstop=4 tabstop=4 shiftwidth=4<CR>
map \T <Esc>:set expandtab softtabstop=8 tabstop=8 shiftwidth=8<CR>

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
" Makes the spaces feel like real tabs
set softtabstop=4
" Use the shift-tab to insert the real tabs
inoremap <S-Tab> <C-V><Tab>
" Use spaces instead of tabs in GUI mode
if has("gui_running")
"  set expandtab
endif
" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

set autoindent               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Comment and Uncomment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""function! Comment()
""  let ext = tolower(expand('%:e'))
""  if ext == 'tcl' || ext == 'rb' || ext == 'sh' || ext == 'csh'
""    silent s/^/\#/
""  elseif ext == 'c' || ext == 'cpp' || ext == 'h'
""    silent s:^:\/\/:g
""  elseif ext == 'vimrc'
""    silent s:^:\":g
""  endif
""endfunction
""
""function! Uncomment()
""  let ext = tolower(expand('%:e'))
""  if ext == 'tcl' || ext == 'rb' || ext == 'sh' || ext == 'csh'
""    silent s/^\#//
""  elseif ext == 'c' || ext == 'cpp' || ext == 'h'
""    silent s:^\/\/::g
""  elseif ext == 'vimrc'
""    silent s:^\"::g
""  endif
""endfunction
""
""map <C-a> :call Comment()<CR>
""map <C-b> :call Uncomment()<CR>

function! Comment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'tcsh' || ft == 'perl'|| ft == 'csh' || ft == 'tcl' || ft == 'conf' || ft == 'python'
		silent s/^/\#/
	elseif ft == 'javascript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'verilog'
		silent s:^:\/\/:g
	elseif ft == 'tex'
		silent s:^:%:g
	elseif ft == 'vim'
		silent s:^:\":g
	endif
endfunction

function! Uncomment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'tcsh' || ft == 'perl'|| ft == 'csh' || ft == 'tcl' || ft == 'conf' || ft == 'python'
		silent s/^\#//
	elseif ft == 'javascript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'verilog'
		silent s:^\/\/::g
	elseif ft == 'tex'
		silent s:^%::g
	elseif ft == 'vim'
		silent s:^\"::g
	endif
endfunction

map <C-a> :call Comment()<CR>
"map <C-b> :call Uncomment()<CR>
""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
if has("gui_running")
  map j gj
  map k gk
endif

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=ASCII=\%03.3b\|HEX=\%04.4B\ \ Line:\ %l\ \/\ %L\ in\ [%f]\ %{HasPaste()}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction


"  use verilog highlight
map <M-v> <Esc>:let do_syntax_sel_menu = 1\|runtime! synmenu.vim<Esc>:cal SetSyn("verilog")<Esc>
"  use cshell highlight
map <M-c> <Esc>:let do_syntax_sel_menu = 1\|runtime! synmenu.vim<Esc>:cal SetSyn("csh")<Esc>
" csh script template file
autocmd BufNewFile       *.csh   exec ":call SetTitle()" 
function SetTitle()
        call setline(1, "#!/bin/csh -f") 
"        call append(line("."),  "#") 
"        call append(line(".")+1, "# **HISTORY**") 
"        call append(line(".")+2, "# @V0.00 Generated By CSH Template AT ".strftime("%Y-%m-%d %X")) 
"        call append(line(".")+3, "# @V0.01 Last Modified AT ".strftime("%Y-%m-%d %X")) 
"        call append(line(".")+4, "#") 
"        call append(line(".")+5, "") 
endfunction
autocmd BufNewFile       *.py   exec ":call Pythonstart()" 
function Pythonstart()
        call setline(1,  "\#\!/installtop/lx24-amd64/vendor/cadence/Cynthesizer_5.0.7/tools.5.0b2.Linux.SC23.gcc446/bin/python2.7") 
        call setline(2,  "\# encoding: UTF-8") 
endfunction
"autocmd BufNewFile  * normal G
"autocmd BufWrite,BufWritePre,FileWritePre  *.csh    ks|call LastModified()|'s  
"function LastModified()
"        if line("$") > 5
"                let l = 5
"        else 
"                let l = line("$")
"        endif
"        exe "1,".l."g/Last Modified AT.*/s/Last Modified AT.*/Last Modified AT".
"                                \strftime(" %Y-%m-%d %X" ) . "/ge"
"endfunction

function! StWipeout()
	" list of *all* buffer numbers
	let l:buffers = range(1, bufnr('$'))

	" what tab page are we in?
	try
		" if there are any buffers left, delete them
		if len(l:buffers)
			execute 'bwipeout!' join(l:buffers)
		endif
	endtry
endfunction
autocmd VimLeavePre * call StWipeout()

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
