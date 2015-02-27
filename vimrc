" Thing: ajdiaz's Vim configuration file. This one is important!
" Author: Andrés J. Díaz <ajdiaz@connectical.com>,
"         Adrian Perez de Castro <aperez@igalia.com>
" License: Distributed under terms of the MIT license

if has("vim_starting")
	set nocompatible
	set runtimepath+=~/.vim/bundle/vim-pathogen
endif
filetype indent plugin on

" Plugin: CamelCaseMotion
" This plug-in has to be configured before sourcing
map <S-W> <Plug>CamelCaseMotion_w
map <S-B> <Plug>CamelCaseMotion_b
map <S-E> <Plug>CamelCaseMotion_e

let mapleader=','
let g:using_neocomplete = 1
execute pathogen#infect()

set tabstop=2				 " Set tabstops to 2 spaces
set smarttab                 " Use smart tabs... we are not as dumb!
set shiftwidth=2			 " Set indentation shift-width to 2 spaces
set autoindent				 " Enable automatic indentation
set copyindent				 " Enable automatic indentation of pasted lines
set incsearch				 " Use incremental search
set smartcase                " No case-sense by default, but on on typing mays.
set nohlsearch				 " Disable search highlighting
set ruler					 " Show line number & column
set laststatus=2			 " Always show a status line
set sidescrolloff=2			 " Keep some context when scrolling
set scrolloff=6				 " The same in vertical :)
set viminfo+=n~/.viminfo	 " Name of the viminfo file
set whichwrap+=[,],<,>		 " Allow arrow keys to wrap lines
set nowrap					 " Don't wrap long lines
set showmode				 " Print the current mode in the last line
set ttyfast             	 " Lots of console stuff that may slow down Vim
set showfulltag			     " Do not show full prototype of tags on completion
set showcmd					 " Show commands as they are typed
set formatoptions+=cqron1 	 " Some useful formatting options
set showmatch				 " Show matching parens
set textwidth=76             " Text is 76 columns wide
set backspace=2              " Backspace always useable in insert mode
set fileformats=unix,mac,dos " Allows automatic line-end detection.
set completeopt-=preview
set ignorecase
set infercase
set splitbelow
set splitright
set hidden
set diffopt+=iwhite
set nobackup
set tags=tags;/
set nofsync
set nosol
set shortmess+=a
set noshowmode
set grepprg=ag\ --noheading\ --nocolor\ --nobreak
set secure
set exrc
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
set colorcolumn=80          " Put color column in column 80


if has("mouse")
	"set mouse=a
	if has("mouse_sgr")
		set ttymouse=sgr
	endif
endif

if has("linebreak")
	set linebreak 		 	 " Break on `breakat' chars when linewrapping is on.
	set showbreak=+          " Prepend `+' to wrapped lines
endif

if has("folding")
	set foldminlines=5 		 " Don't fold stuff with less lines
	set foldmethod=syntax 	 " Use syntax-aware folding
	set nofoldenable 		 " Don't enable folding by default
endif

if has("wildmenu")
	set wildmenu           	 " Show completions on menu over cmdline
	set wildchar=<TAB>     	 " Navigate wildmenu with tabs
	set wildignore=*.o,*.cm[ioax],*.ppu,*.core,*~,core,#*#
endif

" Plugin: JSON
let g:vim_json_syntax_conceal = 0

" Plugin: XML
let g:xml_syntax_folding = 1

" Plugin: NeoComplete
function! s:completion_check_bs()
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~ '\s'
endfunction

if g:using_neocomplete
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_smart_case = 1
	let g:neocomplete#auto_completion_start_length = 3
	inoremap <expr><C-g> neocomplete#undo_completion()
	inoremap <expr><C-l> neocomplete#complete_common_string()
	inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><C-y> neocomplete#close_popup()
	inoremap <expr><C-e> neocomplete#cancel_popup()
	inoremap <expr><Space> pumvisible() ? neocomplete#close_popup()."\<Space>" : "\<Space>"

	"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
	inoremap <expr><TAB> pumvisible() ? "\<C-n>" :
				\ <SID>completion_check_bs() ? "\<TAB>" :
				\ neocomplete#start_manual_complete()
	inoremap <silent><CR> <C-R>=<SID>neocomplete_do_cr()<CR>
	function! s:neocomplete_do_cr()
		"return neocomplete#close_popup()."\<CR>"
		return pumvisible() ? neocomplete#close_popup() : "\<CR>"
	endfunction
else
	" Simple autocompletion with <TAB>, uses Omni Completion if available.
	inoremap <expr><TAB> pumvisible() ? "\<C-n>" :
				\ <SID>completion_check_bs() ? "\<TAB>" :
				\ &omnifunc == "" ? "\<C-p>" : "\<C-x><C-o><C-p>"
endif

" Plugin: clang_complete
let g:clang_complete_macros = 1

" Plugin: Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '»»'
let g:syntastic_style_warning_symbol = '»'
"let g:syntastic_always_populate_loc_list = 1

"let g:syntastic_python_pylint_args = '--indent-string="    "'

let g:syntastic_c_compiler = 'clang'
let g:syntastic_c_compiler_options = ' -std=gnu99'
let g:syntastic_c_check_header=1
let g:syntastic_c_auto_refresh_includes=1

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++1y -stdlib=libc++ '
let g:syntastic_cpp_check_header=1
let g:syntastic_cpp_auto_refresh_includes=1

let g:syntastic_objc_compiler = 'clang'
let g:syntastic_objc_compiler_options = ' -fobjc '
let g:syntastic_objc_check_header=1
let g:syntastic_objc_auto_refresh_includes=1

let g:syntastic_objcpp_compiler = 'clang++'
let g:syntastic_objcpp_compiler_options = ' -std=c++11y -stdlib=libc++ -fobjc '
let g:syntastic_objcpp_check_header=1
let g:syntastic_objcpp_auto_refresh_includes=1

" Unite: General settings
let g:unite_update_time = 200
let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 1000
call unite#custom#profile('default', 'context', { 'prompt': '% ' })
call unite#filters#matcher_default#use(['matcher_fuzzy'])

autocmd FileType unite call s:unite_enter_buffer()
function s:unite_enter_buffer()
	nmap <buffer> <ESC>   <Plug>(unite_insert_enter)
	imap <buffer> <ESC>   <Plug>(unite_exit)
	nmap <buffer> <tab>   <Plug>(unite_loop_cursor_down)
	nmap <buffer> <s-tab> <Plug>(unite_loop_cursor_up)
	imap <buffer> <c-a>   <Plug>(unite_choose_action)
	imap <buffer> <tab>   <Plug>(unite_insert_leave)<Plug>(unite_loop_cursor_down)
	imap <buffer> <C-w>   <Plug>(unite_delete_backward_word)
	imap <buffer> <C-u>   <Plug>(unite_delete_backward_path)
	nmap <buffer> <C-r>   <Plug>(unite_redraw)
	imap <buffer> <C-r>   <Plug>(unite_redraw)
endfunction

" Unite: CtrlP-alike behavior and variations
nnoremap <silent> <leader>f :<C-u>Unite file_rec/async file/new -buffer-name=Files<cr>
nnoremap <silent> <leader>F :<C-u>Unite file_rec/git:--cached:--others:--exclude-standard file/new -buffer-name=Files\ (Git)<cr>
nnoremap <silent> <leader>d :<C-u>Unite buffer bookmark file/async -buffer-name=Files\ (misc)<cr>
nnoremap <silent> <leader>m :<C-u>Unite neomru/file -buffer-name=MRU\ Files<cr>
nnoremap <silent> <leader>b :<C-u>Unite buffer -buffer-name=Buffers<cr>
nnoremap <silent> <leader>J :<C-u>Unite jump -buffer-name=Jump\ Locations<cr>

" Unite: Outline (TagBar-alike)
nnoremap <silent> <leader>o :<C-u>Unite outline -buffer-name=Outline<cr>
nnoremap <silent> <leader>O :<C-u>Unite outline -no-split -buffer-name=Outline<cr>

" Unite: QuickFix
let g:unite_quickfix_is_multiline = 1
nnoremap <silent> <leader>q :<C-u>Unite location_list quickfix -buffer-name=Location<cr>

" Unite: Ag/Ack/Grep
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --noheading'
	let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
	let g:unite_source_grep_command = 'ack'
	let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
	let g:unite_source_grep_recursive_opt = ''
endif
nnoremap <silent> <leader>g :<C-u>Unite grep:. -buffer-name=Find<cr>

" Unite: Open last-used Unite buffer
nnoremap <silent> <leader>L :<C-u>UniteResume<cr>

" Plugin: Airline
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols = {
			\ 'linenr'     : '◢',
			\ 'branch'     : '≣',
			\ 'paste'      : '⟂',
			\ 'readonly'   : '⚠',
			\ 'whitespace' : '␥',
			\ }
let g:airline_mode_map = {
			\ '__' : '-',
			\ 'n'  : 'N',
			\ 'i'  : 'I',
			\ 'R'  : 'R',
			\ 'c'  : 'C',
			\ 'v'  : 'V',
			\ 'V'  : 'V',
			\ '' : 'V',
			\ 's'  : 'S',
			\ 'S'  : 'S',
			\ '' : 'S',
			\ }
let g:airline_theme = 'bubblegum'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_min_count = 2

" Plugin: GitGutter
let g:gitgutter_sign_column_always = 1
nmap gh <Plug>GitGutterNextHunk
nmap gH <Plug>GitGutterPrevHunk
nmap gs <Plug>GitGutterStageHunk
nmap gR <Plug>GitGutterRevertHunk
nmap gd <Plug>GitGutterPreviewHunk

" Plugin: incsearch
let g:incsearch#consistent_n_direction = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" End of configuration for (most) plug-ins

if has("folding")
	map , zj
	"map m zk
	map - za
	map _ zA
	"map ; zi
	"map <CR> za
	"map <C-v> zA
endif

" Tune defaults for some particular file types.
autocmd FileType javascript setlocal expandtab
autocmd FileType *html,xml setlocal matchpairs+=<:>
autocmd FileType xhtml,xml let xml_use_xhtml=1
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
autocmd FileType lua setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType rst setlocal expandtab tabstop=2 shiftwidth=2
autocmd FileType objc setlocal expandtab cinoptions+=(0
autocmd FileType cpp setlocal expandtab cinoptions+=(0
autocmd FileType c setlocal expandtab cinoptions+=(0
autocmd FileType d setlocal expandtab cinoptions+=(0

" Jump to the last edited position in the file being loaded (if available)
" in the ~/.viminfo file, I really love this =)
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\		execute "normal g'\"" |
			\ endif

" Set PO mode for POT gettext templates, too.
autocmd BufEnter *.pot
			\ setf po | setlocal fenc=utf8

" Set Python mode for Twisted Application Configuration (.tac) fiels.
autocmd BufReadPost,BufNewFile *.tac setf python

" Add the `a' format option (autoreflow) to plain text files.
autocmd BufReadPost,BufNewFile *.txt,*README*,*TODO*,*HACKING*,*[Rr]eadme*,*[Tt]odo*
			\ setlocal expandtab

" System headers usually are designed to be viewed with 8-space tabs
autocmd BufReadPost /usr/include/* setlocal ts=8 sw=8

" Tup build system
autocmd BufNewFile,BufRead Tupfile,*.tup setf tup

" Use Enter key to navigate help links.
autocmd FileType help nmap <buffer> <Return> <C-]>

" When under xterm and compatible terminals, use titles if available and
" change cursor color depending on active mode.
if &term =~ "xterm" || &term =~ "screen" || &term =~ "tmux"
	if has("title")
		set title
	endif
endif

" Some fixups for Screen, which has those messed up in most versions
if &term =~ "screen"
	map  <silent> [1;5D <C-Left>
	map  <silent> [1;5C <C-Right>
	lmap <silent> [1;5D <C-Left>
	lmap <silent> [1;5C <C-Right>
	imap <silent> [1;5D <C-Left>
	imap <silent> [1;5C <C-Right>
endif

if has("syntax") || has("gui_running")
	syntax on
	if has("gui_running")
		colorscheme twilight
		set guifont=PragmataPro\ 12
		set guifontwide=VL\ Gothic
		set cursorline
	else
		colorscheme elflord

		if &term =~ "xterm-256color" || &term =~ "screen-256color" || $COLORTERM =~ "gnome-terminal"
			set t_Co=256
			set t_AB=[48;5;%dm
			set t_AF=[38;5;%dm
			set cursorline
		endif
		if &term =~ "st-256color"
			set t_Co=256
			set cursorline
		endif

		highlight CursorLine   NONE
		highlight CursorLine   ctermbg=235
		highlight CursorLineNr ctermbg=235 ctermfg=246
		highlight LineNr       ctermbg=234 ctermfg=238
		highlight SignColumn   ctermbg=234
		highlight ColorColumn  ctermbg=234
	endif

	" Match whitespace at end of lines (which is usually a mistake),
	" but only while not in insert mode, to avoid matches popping in
	" and out while typing.
	highlight WhitespaceEOL ctermbg=red guibg=red
	augroup WhitespaceEOL
		autocmd!
		autocmd InsertEnter * syn clear WhitespaceEOL | syn match WhitespaceEOL excludenl /\s\+\%#\@!$/
		autocmd InsertLeave * syn clear WhitespaceEOL | syn match WhitespaceEOL excludenl /\s\+$/
	augroup END
endif

" Let Vim be picky about syntax, so we are reported of glitches visually.
let c_gnu                = 1
let use_fvwm_2           = 1
let c_space_errors       = 1
let java_space_errors    = 1
let ora_space_errors     = 1
let plsql_space_errors   = 1
let python_space_errors  = 1
let python_highlight_all = 1
let g:sql_type_default   = 'mysql'

" Set up things for UTF-8 text editing by default, if multibyte
" support was compiled in. Let Linux consoles be Latin-1.
if has("multi_byte")
	set encoding=utf-8
	if $TERM == "linux" || $TERM_PROGRAM == "GLterm"
		set termencoding=latin1
	endif
endif

" Autocorrect some usually-mispelled commands
command! -nargs=0 -bang Q q<bang>
command! -bang W write<bang>
command! -nargs=0 -bang Wq wq<bang>

" Saves current position, executes the given expression using :execute
" and sets the cursor in the saved position, so the user thinks cursor
" was not moved at all during an operation.
function ExecuteInPlace(expr)
	let l:linePos = line(".")
	let l:colPos = col(".")
	execute a:expr
	call cursor(l:linePos, l:colPos)
endfunction

" Some commands used to thrash trailing garbage in lines.
command -nargs=0 KillEolLF      call ExecuteInPlace("%s/\\r$//")
command -nargs=0 KillEolSpaces  call ExecuteInPlace("%s/[ \\t]\\+$//")
command -nargs=0 KillEolGarbage call ExecuteInPlace("%s/[ \\t\\r]\\+$//")
command -nargs=0 EolMac2Unix    call ExecuteInPlace("%s/\\r/\\n/g")
command -nargs=0 EolUnix2Mac    call ExecuteInPlace("%s/$/\\r/g")
command -nargs=0 EolUnix2DOS    call ExecuteInPlace("%s/$/\\r\\n/g")

" Configure explorer
let g:netrw_liststyle=3
map <leader>e :Lexplore<cr>


" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move to the previous/mext buffer
nnoremap P :bprevious<CR>
nnoremap N :bnext<CR>

" Exit swiftly
map __ ZZ

" A bit of commoddity to jump through source files using tags
map <C-J> :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <C-T> <C-]>
map <C-P> :pop<CR>

" Start searching with spacebar.
map <Space> /

" F2 -> Save file
map  <F2>   :w!<CR>
imap <F2>   <ESC>:w!<CR>a

" F5 -> Compile/build
" F6 -> Show build errors
" F7 -> Previous error
" F8 -> Next error
map  <F5>   :wall!<CR>:make<CR>
map  <F6>   :cl!<CR>
map  <F7>   :cp!<CR>
map  <F8>   :cn!<CR>

" clang-format, see http://clang.llvm.org/docs/ClangFormat.html
map <C-K> :pyf /usr/share/clang/clang-format.py<CR>
imap <C-K> <ESC>:pyf /usr/share/clang/clang-format.py<CR>i

runtime! macros/matchit.vim

" vim:ts=4:sw=4:fenc=utf-8
