runtime! archlinux.vim

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"    -> Auto-header
"    -> Shortcuts
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Enable mouse usage (all modes)
set mouse=a

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

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

" Line Number
set nu

" Placement NERDTree
let g:NERDTreeWinPos = "left"

" No scratch
set completeopt-=preview


" Show special chars in blue
"set list
"set listchars=tab:>-,trail:-,eol:$

" Try to keep the cursor on the same column when we change line.
set nostartofline

" Set max width
"set textwidth=80

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

set bg=dark

" Enable 256 color (if supported)
set t_Co=256

"colorscheme distinguished
set background=dark
" set cc=80

" Set extra options when running in GUI mode
if has("gui_running")
	set guioptions-=T
	set guioptions+=e
	set t_Co=256
	set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"call pathogen#infect()
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

syntax enable
filetype plugin indent on

"function! HighlightDefinedNames()
    " Clear any existing defined names
"    syn clear DefinedName
    " Run through the whole file
"    for l in getline('1','$')
    	" Look for #define
"    	if l =~ '^\s*#\s*define\s\+'
    		" Find the name part of the #define
"    		let name = substitute(l, '^\s*#\s*define\s\+\(\k\+\).*$', '\1', '')
    		" Highlight it as DefinedName
"    		exe 'syn keyword DefinedName ' . name
"    	endif
"    endfor
"endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
"set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 80 characters
" set lbr
" set tw=80

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


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
map j gj
map k gk

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
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>

nmap <F3> :call ApplyTemplate()<CR>I
imap <F3> <ESC>:call ApplyTemplate()<CR>i

set pastetoggle=<F2>

nmap <F4> :q<CR>
nmap <F5> :w<CR>
nmap <F6> :q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>
nmap <F7> :wq<CR>
nmap <F8> :wq<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>
imap <F5> <Esc>:q!
imap <F6> <Esc>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>
imap <F4> <Esc>:w<CR>
imap <F7> <Esc>:wq<CR>
imap <F8> <Esc>:wq<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>:q!<CR>

nmap <silent> <S-tab> <C-w><C-w>
inoremap <silent> <S-tab> <Esc><C-w><C-w>

nmap <C-a> :!<space>
imap <C-a> <Esc>:!<space>

nmap <C-F5> :tabprev<CR>
imap <C-F5> <Esc>:tabprev<CR>
nmap <C-F6> :tabnext<CR>
imap <C-F6> <Esc>:tabnext<CR>
nmap <C-F9> :tabclose<CR>
imap <C-F9> <Esc>:tabclose<CR>
nmap <C-F7> :tabm<space>
imap <C-F7> <Esc>:tabm<space>
nmap <C-F8> :tabedit<space>
imap <C-F8> <Esc>:tabedit<space>

imap <C-l> <Esc><leader>c<space>
nmap <C-l> <Esc><leader>c<space>
nmap <C-m> :call NERDComment(1, 'sexy')<CR>

function ApplyTemplate()
	let name = expand('%:t')
	let line = getline(2, 2)
	if (len(line) == 1 && line[0] == " * " . name)
		return
	endif
	exec ":Template *" . name
endfunction

"function s:filetype ()

	"let s:file = expand("<afile>:t")
	"let l:ft = &ft
	"let s:comment = ""
	"let s:endcomment = ""
	"let s:medcomment = ""
	"if l:ft ==# 'sh'
		"let s:comment = "#"
		"let s:medcomment = "#"
		"let s:type = "!/usr/bin/env bash"

	"elseif l:ft ==# 'python'
		"let s:comment = "#"
		"let s:medcomment = "#"
		"let s:type = "-*- coding:utf-8 -*-"

	"elseif l:ft ==# 'perl'
		"let s:comment = "#"
		"let s:medcomment = "#"
		"let s:type = "!/usr/bin/env perl"

	"elseif l:ft ==# 'c'
		"let s:comment = "/*"
		"let s:medcomment = "*"
		"let s:endcomment = "*/"
		"let s:type = " C/C++ File"

	"elseif l:ft==# 'rst'
		"let s:comment = ".."
		"let s:medcomment = ".."
		"let s:type = " reStructuredText "

	"elseif l:ft==# 'php'
		"let s:comment = "<?php/*"
		"let s:medcomment = "     *"
		"let s:endcomment = "*/?>"
		"let s:type = " Php File"

	"elseif l:ft ==# 'javascript'File
		"let s:comment = "/*"
		"let s:endcomment = "*/"
		"let s:type = " Javascript File"

	"endif
	"unlet s:file

"endfunction

"function s:insert ()
	"call s:filetype ()

	"let s:head = s:comment .		"*************************************"
	"let s:author = s:medcomment .	" AUTHOR:	" . system ("id -un | tr -d '\n'")
	"let s:file = s:medcomment .		" FILE:		" . expand("<afile>")
	"let s:role = s:medcomment .		" ROLE:		TODO : "
	"let s:created = s:medcomment .	" CREATED:	" . strftime ("%Y-%m-%d %H:%M:%S")"
	"let s:modified = s:medcomment .	" MODIFIED:	" . strftime ("%Y-%m-%d %H:%M:%S")
	"let s:buttom = s:medcomment . 	"*************************************" . s:endcomment
	"call append (0, s:head)
	"call append (1, s:medcomment . s:type)
	"call append (2, s:author)
	"call append (3, s:file)
	"call append (4, s:role)
	"call append (5, s:created)
	"call append (6, s:modified)
	"call append (7, s:buttom)
	"unlet s:head
	"unlet s:comment
	"unlet s:medcomment
	"unlet s:endcomment
	"unlet s:type
	"unlet s:author
	"unlet s:file
	"unlet s:role
	"unlet s:created
	"unlet s:modified
	"unlet s:buttom

"endfunction

"function s:update ()

	"call s:filetype ()
	"let s:modified = s:medcomment . " MODIFIED: " . strftime ("%Y-%m-%d %H:%M:%S")
	"call setline (6, s:modified)
	"unlet s:modified

	"unlet s:comment

"endfunction

"autocmd BufNewFile * call s:insert ()
"autocmd BufWritePost * call s:update ()
"autocmd BufReadPost * call HighlightDefinedNames()
"autocmd CursorMovedI * call HighlightDefinedNames()

