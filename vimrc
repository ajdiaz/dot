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

set path+=**                 " Recursive path search
set tabstop=2                " Set tabstops to 2 spaces
set expandtab                " Use spaces instead of tabs by default
set smarttab                 " Use smart tabs... we are not as dumb!
set shiftwidth=2             " Set indentation shift-width to 2 spaces
set autoindent               " Enable automatic indentation
set copyindent               " Enable automatic indentation of pasted lines
set incsearch                " Use incremental search
set smartcase                " No case-sense by default, but on on typing mays.
set nohlsearch               " Disable search highlighting
set ruler                    " Show line number & column
set laststatus=2             " Always show a status line
set sidescrolloff=2          " Keep some context when scrolling
set scrolloff=6              " The same in vertical :)
set viminfo+=n~/.viminfo     " Name of the viminfo file
set whichwrap+=[,],<,>       " Allow arrow keys to wrap lines
set nowrap                   " Don't wrap long lines
set showmode                 " Print the current mode in the last line
set ttyfast                  " Lots of console stuff that may slow down Vim
set showfulltag              " Do not show full prototype of tags on completion
set showcmd                  " Show commands as they are typed
set formatoptions+=cqron1    " Some useful formatting options
set showmatch                " Show matching parens
set textwidth=76             " Text is 76 columns wide
set backspace=2              " Backspace always useable in insert mode
set fileformats=unix,mac,dos " Allows automatic line-end detection.
set conceallevel=0           " Show some hidden elements, like quotes in json
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
set pastetoggle=<F2>        " Key to enter in paste mode
set synmaxcol=300           " Disable syntax in large files
set updatetime=500          " Decrease the default time to update status

command Suw w !sudo tee %

if &diff
    nmap 1 :diffg LO<C-M>
    nmap 2 :diffg BA<C-M>
    nmap 3 :diffg RE<C-M>
    nmap ZZ :wqa<C-M>
endif

if has("mouse")
  set mouse=a
  if has("mouse_sgr")
    set ttymouse=sgr
  endif
endif

if has("linebreak")
  set linebreak           " Break on `breakat' chars when linewrapping is on.
  set showbreak=+         " Prepend `+' to wrapped lines
endif

if has("folding")
  set foldminlines=2      " Don't fold stuff with less lines
  set foldmethod=syntax   " Use syntax-aware folding
  set foldtext=FoldText() " Use custom fold text
  set fillchars=fold:\    " No fill folding

  augroup vimrc
    autocmd ColorScheme * highlight Folded ctermbg=none ctermfg=242
  augroup end

  function! FoldText()
      let line = getline(v:foldstart)
      return "▶ ".line
  endfunction

  " Commodity here, I'll never understand why zO and zC apply only to the
  " current cursor having za and zi
  nmap <leader>zO zR
  nmap <leader>zC zM

endif

if has("wildmenu")
  set wildmenu            " Show completions on menu over cmdline
  set wildchar=<TAB>      " Navigate wildmenu with tabs
  set wildmode=list       " Show list when more than one match
  set wildignore=*.o,*.cm[ioax],*.ppu,*.core,*~,core,#*#,*pyc,__pycache__
endif

if has("terminal")
  au BufWinEnter * if &buftype == 'terminal' | setlocal bufhidden=hide | endif
endif

" Plugin: templates
let g:email = "ajdiaz@ajdiaz.me"
let g:user = "Andres J. Diaz"

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

" Plugin: gundo
nnoremap <leader>gu :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_preview_bottom = 1

" Plugin: clang_complete
let g:clang_complete_macros = 1

" Plugin: tabular
noremap <silent> <leader>t: :Tabularize /:<CR>
noremap <silent> <leader>t= :Tabularize /=<CR>
noremap <silent> <leader>t, :Tabularize /,<CR>
noremap <silent> <leader>t{ :Tabularize /{<CR>
noremap <silent> <leader>t" :Tabularize /"<CR>
noremap <silent> <leader>t' :Tabularize /'<CR>
noremap <silent> <leader>t[ :Tabularize /[<CR>
noremap <silent> <leader>t/ :Tabularize ///<CR>
noremap <silent> <leader>t\| :Tabularize /\|<CR>

" Plugin: Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '🚨'
let g:syntastic_style_warning_symbol = '🚨'
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

" Plugin: vim-go
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 1
let g:syntastic_go_checkers = ['gofmt', 'go']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:go_list_type = "quickfix"
let g:go_highlight_build_constraints = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
let g:go_term_enabled = 1
let g:go_autodetect_gopath = 0
let g:go_metalinter_deadline = '20s'
let g:go_metalinter_enabled = [
            \ 'golint', 'vetshadow', 'errcheck', 'ineffassign',
            \ 'vet', 'goimports', 'defercheck', 'aligncheck',
            \ 'dupl', 'gofmt', 'varcheck', 'gocyclo', 'testify',
            \ 'structcheck', 'deadcode' ]

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd FileType go nmap <Leader>i <Plug>(go-info)
autocmd FileType go nmap <Leader>r :<C-U>GoRun<CR>
autocmd FileType go nmap <leader>co :GoCoverageToggle<CR>
autocmd FileType go nmap <leader>m :call <SID>GoBuildAgnostic()<CR>

function s:GoBuildAgnostic()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#cmd#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

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
set signcolumn=yes
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
autocmd FileType text,markdown NeoCompleteLock

" Jump to the last edited position in the file being loaded (if available)
" in the ~/.viminfo file, I really love this =)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \    execute "normal g'\"" |
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

" Ensure NeoMutt files are threated as mail
au BufNewFile,BufRead {neo,}mutt{ng,}-*-\w\+,{neo,}mutt[[:alnum:]_-]\\\{6\} setf mail

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

" Strip whitespaces
function! StripWhitespace ()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Show line numbers
map <leader>nu :set nu!<cr>

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
let g:netrw_banner=0
"let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
map <leader>e :Explore<cr>

" Find and bufer bindings
map <leader>f :find<space>
map <leader>q :bw!<cr>

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move to the previous/mext buffer
nnoremap P :bprevious<CR>
nnoremap N :bnext<CR>

" Exit swiftly
map __ ZZ

" build map
nmap <leader>b :make<CR>

" remove xml/sgml tags
map <leader>rtag yitvatp<CR>

" tabs configuration
execute "set <M-t>=\et"

" buffer commodites
nmap <M-Left> :bp<CR>
nmap <M-Right> :bn<CR>

runtime! macros/matchit.vim

" vim:ts=4:sw=4:fenc=utf-8
