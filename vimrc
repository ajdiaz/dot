".vimrc
" ---------------------------------------------------------------------
" Copyright (c) 2006 Andrés J. Díaz <ajdiaz@connectical.com>
" Copyright (c) 2008 Adrian Perez <aperez@connectical.com>
"
" Permission is hereby granted, free of charge, to any person
" obtaining a copy of this software and associated documentation
" files (the "Software"), to deal in the Software without restriction,
" including without limitation the rights to use, copy, modify, merge,
" publish, distribute, sublicense, and/or sell copies of the Software,
" and to permit persons to whom the Software is furnished to do so,
" subject to the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
" CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
" SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" ---------------------------------------------------------------------

" Set options {{{1
" ----------------

set nocompatible                " Use advanced features not found in Vi
set tabstop=4                   " Set tabstops to 4 spaces
set shiftwidth=4                " Set indentation shift-width to 2 spaces
set autoindent                  " Enable automatic indentation
set copyindent                  " Enable automatic indentation of pasted lines
set incsearch                   " Use incremental search
set nohlsearch                  " Disable search highlighting
set ruler                       " Show line number & column
set laststatus=2                " Always show a status line
set sidescrolloff=2             " Keep some context when scrolling
set scrolloff=6                 " The same in vertical :)
set viminfo+=n~/.viminfo        " Name of the viminfo file
set whichwrap+=[,],<,>          " Allow arrow keys to wrap lines
set nowrap                      " Don't wrap long lines
set showmode                    " Print the current mode in the last line
set nottyfast                   " Lots of console stuff that may slow down Vim
set showfulltag                 " Show full prototype of tags on completion
set showcmd                     " Show commands as they are typed
set formatoptions+=cqron1       " Some useful formatting options
set showmatch                   " Show matching parens
set textwidth=76                " Text is 76 columns wide
set backspace=2                 " Backspace always useable in insert mode
set fileformats=unix,mac,dos    " Allows automatic line-end detection.
set grepprg=grep\ -nH\ $*       " Make grep always print the file name.
"set keywordprg='pinfo'          " Use pinfo instead of man

let g:username = "Andrés J. Díaz"
let g:author   = "Andrés J. Díaz"
let g:email    = "ajdiaz@connectical.com"
let g:template_dir = "~/.vim/templates"

if has("spell")
    set spellfile+=~/.vim/spell/cs.utf-8.add " Computer Science words.
endif


if has("linebreak")
    set linebreak             " Break on `breakat' chars when linewrapping is on.
    set showbreak=+           " Prepend `+' to wrapped lines
endif

if has("folding")
    set foldminlines=5        " Don't fold stuff with less lines
    set foldmethod=indent     " Use syntax-aware folding
    set nofoldenable          " Don't enable automatic folding!
endif

if has("wildmenu")
    set wildmenu             " Show completions on menu over cmdline
    set wildchar=<TAB>       " Navigate wildmenu with tabs

    " Ignore backups and misc files for wilcompletion
    set wildignore=*.o,*.cm[ioax],*.ppu,*.core,*~,core,#*#
endif

" Configure file-explorer }}}1{{{1
" --------------------------------

let g:explVertical     = 1        " Split windows in vertical.
let g:explSplitRight   = 1        " Put new opened windows at right.
let g:explWinSize      = 80       " New windows are 80 columns wide.
let g:explDetailedHelp = 0        " We don't need detailed help.
let g:explSortBy       = 'name'   " Sort files by their names.
let g:explDirsFirst    = 0        " Mix files and directories.

" Hide some kinds of files in file-explorer windows.
let g:explHideFiles  = '^\.,\.gz,\.exe,\.o,\.cm[oxia],\.zip,\.bz2'


" Some folding/unfolding misc mappings  }}}1{{{1
" ----------------------------------------------
if has("folding")
    map - za
    map _ zA
endif

" Syntax highlighting (bwahahaha!)   }}}1{{{1
if has("syntax") || has("gui_running")
    syntax on
    colorscheme elflord
endif

" Filetyping and autocommands  }}}1{{{1
" -------------------------------------

filetype indent plugin on

if has("autocmd")

    " Tune defaults for some particular file types.
    " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    autocmd FileType *html,xml setlocal matchpairs+=<:>
    autocmd FileType xhtml,xml let xml_use_xhtml=1
    autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 |
                \ match String /\"/

    " Java 'tuning'. {{{
    " ~~~~~~~~~~~~~~~~~~
    autocmd FileType java setlocal errorformat=
                \%-G%.%#build.xml:%.%#,
                \%-G%.%#warning:\ %.%#,
                \%-G%\\C%.%#EXPECTED%.%#,
                \%f:%l:\ %#%m,
                \C:%f:%l:\ %m,
                \%DEntering:\ %f\ %\\=,
                \%ECaused\ by:%[%^:]%#:%\\=\ %\\=%m,
                \%ERoot\ cause:%[%^:]%#:%\\=\ %\\=%m,
                \%Ecom.%[%^:]%#:%\\=\ %\\=%m,
                \%Eorg.%[%^:]%#:%\\=\ %\\=%m,
                \%Ejava.%[%^:]%#:%\\=\ %\\=%m,
                \%Ejunit.%[%^:]%#:%\\=\ %\\=%m,
                \%-Z%\\C\ at\ com.mypkg.%.%#.test%[A-Z]%.%#(%f:%l)\ %\\=,
                \%-Z%\\C\ at\ com.mypkg.%.%#.setUp(%f:%l)\ %\\=,
                \%-Z%\\C\ at\ com.mypkg.%.%#.tearDown(%f:%l)\ %\\=,
                \%-Z%^\ %#%$,
                \%-C%.%#,
                \%-G%.%#

    " Define abbreviations for Java(tm) mode.
    " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    autocmd FileType java
                \ iab Jmain public static void main(String [] args)|
                \ iab const- private static final|
                \ iab const+ public static final|
                \ iab cls- private class|
                \ iab cls+ public class|
                \ iab bool boolean|
                \ iab unsigned int

    " TeX error mode. }}}{{{
    " ~~~~~~~~~~~~~~~~~~~~~~
    " (Note: this is *cumbersome*.)
    autocmd FileType tex setlocal makeprg=
                \\pdflatex\ \\\\nonstopmode\ \\\\input\\{%} |
                \ setlocal errorformat=
                \%E!\ LaTeX\ %trror:\ %m,
                \%E!\ %m,
                \%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
                \%+W%.%#\ at\ lines\ %l--%*\\d,
                \%WLaTeX\ %.%#Warning:\ %m,
                \%Cl.%l\ %m,
                \%+C\ \ %m.,
                \%+C%.%#-%.%#,
                \%+C%.%#[]%.%#,
                \%+C[]%.%#,
                \%+C%.%#%[{}\\]%.%#,
                \%+C<%.%#>%.%#,
                \%C\ \ %m,
                \%-GSee\ the\ LaTeX%m,
                \%-GType\ \ H\ <return>%m,
                \%-G\ ...%.%#,
                \%-G%.%#\ (C)\ %.%#,
                \%-G(see\ the\ transcript%.%#),
                \%-G\\s%#,
                \%+O(%f)%r,
                \%+P(%f%r,
                \%+P\ %\\=(%f%r,
                \%+P%*[^()](%f%r,
                \%+P[%\\d%[^()]%#(%f%r,
                \%+Q)%r,
                \%+Q%*[^()])%r,
                \%+Q[%\\d%*[^()])%r

    "}}}

    " Jump to the last edited position in the file being loaded (if available)
    " in the ~/.viminfo file, I really love this =)
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \        execute "normal g'\"" |
                \ endif

    " Set ChangeLog mode for GNU Arch revision logs
    autocmd BufReadPost *++log.*
                \ setf changelog |
                \ setlocal formatoptions+=a

    " Set PO mode for POT gettext templates, too.
    autocmd BufEnter *.pot
                \ setf po | setlocal fenc=utf8

    " Add the `a' format option (autoreflow) to plain text files.
    autocmd BufReadPost,BufNewFile *.txt,*README*,*TODO*,*HACKING*,*[Rr]eadme*,*[Tt]odo*
                \ setlocal expandtab |
                \ setlocal spell spelllang=en_us

    " System headers usually are designed to be viewed with 8-space tabs
    autocmd BufReadPost /usr/include/sys/*.h    setlocal ts=8 sw=8
    autocmd BufReadPost /usr/include/mach*/*.h     setlocal ts=8 sw=8

endif

" Change colors of completion popup for Vim 7.
highlight Pmenu      ctermbg=grey ctermfg=black
highlight PmenuSel   cterm=bold,reverse ctermbg=black ctermfg=yellow
highlight PmenuSbar  ctermbg=blue
highlight PmenuThumb ctermfg=lightblue

" Change colors of matchpairs in Vim 7
highlight MatchParen ctermfg=yellow ctermbg=black cterm=bold

" Change colors for visual mode
highlight Visual ctermfg=lightblue ctermbg=white

let c_space_errors       = 1
let java_space_errors    = 1
let ora_space_errors     = 1
let plsql_space_errors   = 1
let python_space_errors  = 1
let python_highlight_all = 1

" Some more highlighting stuff.
highlight WhitespaceEOL ctermbg=red
match WhitespaceEOL /\s\+$/

" Multibyte support   }}}1{{{1
" Set up things for UTF-8 text editing by default, if multibyte
" support was compiled in.
if has("multi_byte")
    set encoding=utf-8
    if $TERM == "linux" || $TERM_PROGRAM == "GLterm"
        set termencoding=latin1
    endif
endif


" Functions and Commands   }}}1{{{1
" Autocorrect some usually-mispelled commands
command! -nargs=0 -bang Q q<bang>
command! -bang W write<bang>
command! -nargs=0 -bang Wq wq<bang>

" Saves current position, executes the given expression using :execute
" and sets the cursor in the saved position, so the user thinks cursor
" was not moved at all during an operation.
"function ExecuteInPlace(expr)
"    let l:linePos = line(".")
"    let l:colPos = col(".")
"    execute a:expr
"    call cursor(l:linePos, l:colPos)
"endfunction
"
" Checks wether a given path is readable and sources it as a Vim script.
" Very useful to load scripts only when available.
function <SID>SourceIfAvailable(path)
    if filereadable(expand(a:path))
        execute "source " . expand(a:path)
    endif
endfunction

" Command that loads the doxygen syntax file.
command! -nargs=0 Doxygen
    \ call <SID>SourceIfAvailable($VIMRUNTIME . "/../vimfiles/syntax/doxygen.vim")

" Some commands used to thrash trailing garbage in lines.
"command -nargs=0 KillEolLF      call ExecuteInPlace("%s/\\r$//")
"command -nargs=0 KillEolSpaces  call ExecuteInPlace("%s/[ \\t]\\+$//")
"command -nargs=0 KillEolGarbage call ExecuteInPlace("%s/[ \\t\\r]\\+$//")
"command -nargs=0 EolMac2Unix    call ExecuteInPlace("%s/\\r/\\n/g")
"command -nargs=0 EolUnix2Mac    call ExecuteInPlace("%s/$/\\r/g")
"command -nargs=0 EolUnix2DOS    call ExecuteInPlace("%s/$/\\r\\n/g")
"command -nargs=0 CreateTag      call CreateTag()

map __ ZZ

" A bit of commoddity to jump through source files using tags!
map <C-T> <C-]>
map <C-P> :pop<CR>


" }}}1 Autocomplete with <TAB> (AJ) {{{1
" --------------------------------------
"
function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

inoremap <Tab> <C-R>=InsertTabWrapper()<CR>

" }}}1 Python documentation {{{1
" ------------------------------
"
command -nargs=1 PyHelp :call ShowPyDoc("<args>")
function ShowPyDoc(module)
    :execute ":new"
    :execute ":read ! pydoc " . a:module
    :execute ":0"
    setlocal readonly buftype=nowrite filetype=man
endfunction

" }}}1 Key Mappings {{{1

" Developing mapings
map <C-m>  :wall!<CR>:make<CR>
map <C-e>  :cl!<cr>
map <C-e>n :cn!<cr>
map <C-e>p :cp!<cr>

" Multiple flie manage mappings
map <C-Up>  :prev!<CR>
map <C-Down> :next!<CR>

" Some usefull kay bindings
map <C-Left> <Home>
map <C-Right> <End>
imap <C-BS> <Del>
imap <C-Left> <Home>
imap <C-Right> <End>

"if has("loaded_less")
"    map q ZZ
"endif

" }}}1


let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat 
" vim:ft=vim foldmethod=marker tw=78
" vim:ts=4:sw=4:foldmethod=marker:foldenable:foldminlines=1:fenc=utf-8
" ---------------------------------------------------------------------
