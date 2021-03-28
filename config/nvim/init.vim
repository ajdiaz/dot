" block: preload setting {{{
set nocompatible

let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_logipat = 1
let g:loaded_vimballPlugin = 1

augroup vimrc
	autocmd!
augroup END
" }}}
" block: load/unload plugins {{{
packloadall!
function! HavePlugin(name)
  return &runtimepath =~ ('pack/plugins/start/' . a:name)
endfunction
" }}}
" block: create missing dirs {{{
if !isdirectory(expand('~/.cache/nvim/undo'))
  call system('mkdir -p ' . shellescape(expand('~/.cache/nvim/undo')))
endif
" }}}
" block: general settings {{{
let mapleader=','

set path+=**
set tabstop=2 shiftwidth=2 expandtab
set copyindent clipboard=unnamedplus
set incsearch smartcase ignorecase noinfercase nohlsearch
set showmode ruler showcmd showmatch number shortmess+=c updatetime=500
set scrolloff=6 sidescrolloff=2
set nowrap whichwrap+=[,],<,>
set formatoptions+=cqron1 fileformats=unix,mac,dos
set textwidth=140 colorcolumn=80 synmaxcol=300 conceallevel=0
"set completeopt=menu,longest "
set secure nofsync nobackup
set diffopt+=iwhite tags=tags;/
set undofile undodir=~/.cache/nvim/undo undolevels=1000 undoreload=10000
set timeout timeoutlen=1000
set ttimeout ttimeoutlen=10
set splitbelow splitright
set encoding=utf-8

if executable('ack')
  set grepprg=ack\ --noheading\ --nocolor\ --nobreak
endif

if has('linebreak')
  set linebreak showbreak=+
endif

if has('folding')
  function! FoldText()
    return "▶ " . getline(v:foldstart)
  endfunction
  set foldtext=FoldText() foldnestmax=1 fillchars=fold:\ 
endif

if has('wildmenu')
  set wildmode=list wildchar=<tab>
  set wildignore+=*.o,*.a,a.out,*.idx,*.bin,*.cm[ioax],*.core,core,*~,#*#
endif

if has('gui_running') || has('nvim')
  set guicursor=n-v-c-sm-i-ci-ve-r-cr-o:block
endif

if has('title')
  set title
endif
" }}}
" block: terminal/tmux helpers {{{
for mapmode in ['n', 'vnore', 'i', 'c', 'l', 't']
  execute mapmode.'map <silent> [1;5A <C-Up>'
  execute mapmode.'map <silent> [1;5B <C-Down>'
  execute mapmode.'map <silent> [1;5C <C-Right>'
  execute mapmode.'map <silent> [1;5D <C-Left>'
  execute mapmode.'map <silent> [1;3A <M-Up>'
  execute mapmode.'map <silent> [1;3B <M-Down>'
  execute mapmode.'map <silent> [1;3C <M-Right>'
  execute mapmode.'map <silent> [1;3D <M-Left>'
endfor
unlet mapmode

if &term =~# '^screen' || &term =~# '^tmux' || &term ==# 'linux'
  set t_ts=k
  set t_fs=\
  set t_Co=16
endif

" use esc to exit in term window
tnoremap <Esc> <C-\><C-n><C-w><Up>
if has('nvim')
  au TermOpen * startinsert
endif
" }}}
" block: explorer/netrw {{{
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
let g:netrw_altv = 1
let g:netrw_alto = 1
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
let g:nertw_preview = 1

nmap <leader>t :Vexplore<cr>
autocmd FileType netrw map f %

" }}}
" block: colorscheme and color tunes {{{
syntax on

if HavePlugin('vim-elrond')
  colors elrond
  highlight EndOfBuffer ctermfg=236
  highlight SpecialKey ctermfg=196
else
  colors elflord
endif

" because strings in magenta are eye damaged
hi Constant term=underline ctermfg=LightBlue guifg=LightBlue

if has('folding')
  highlight Folded ctermbg=none ctermfg=242
endif

" }}}
" block: autocmds for filetypes {{{
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \    execute "normal g'\"" |
  \ endif

autocmd FileType help nmap <buffer> <Return> <C-]>
autocmd BufNewFile,BufRead Containerfile set ft=dockerfile

au BufNewFile,BufRead {neo,}mutt{ng,}-*-\w\+,{neo,}mutt[[:alnum:]_-]\\\{6\}
  \ setf mail
au BufNewFile,BufRead,BufReadPost
  \ {neo,}mutt{ng,}-*-\w\+,{neo,}mutt[[:alnum:]_-]\\\{6\}
  \ execute "normal! gg6ji\n"

function! HelmSyntax()
  set filetype=yaml
  unlet b:current_syntax
  syn include @yamlGoTextTmpl syntax/gotexttmpl.vim
  let b:current_syntax = "yaml"
  syn region goTextTmpl start=/{{/ end=/}}/ contains=@gotplLiteral,gotplControl,gotplFunctions,gotplVariable,goTplIdentifier containedin=ALLBUT,goTextTmpl keepend
  hi def link goTextTmpl PreProc
endfunction

augroup helm_syntax
  autocmd!
  autocmd BufRead,BufNewFile templates/*.yaml,templates/*.tpl call HelmSyntax()
augroup END

" }}}
" block: configure plugins {{{
" plugin vim-buftabline {{{
if HavePlugin('vim-buftabline')
  let g:buftabline_show = 1
endif
" }}}}
" plugin fzf {{{
if HavePlugin('fzf')
  let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'Type'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Character'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }
endif
map <leader>ff :FZF<cr>

" }}}
" plugin fzf.vim {{{
if HavePlugin('fzf.vim')
  map <leader>fc :Commits<cr>
endif

" }}}
" plugin: vim-fugitive {{{
autocmd vimrc FileType dirvish call FugitiveDetect(@%)
if HavePlugin('vim-fugitive')
  nmap <leader>gs :G<cr>
  nmap <leader>gb :GBlame<cr>
  nmap <leader>gl :0Glog<cr>
  nmap <leader>g1 :diffget //2<cr>
  nmap <leader>g0 :diffget //3<cr>
endif
" }}}
" plugin: ale  {{{
if HavePlugin('ale')
  let g:ale_linters = {
        \ 'rust': ['analyzer', 'cargo'],
        \ 'python': ['pyls'],
        \ 'go': ['gopls'],
        \ 'c': ['clangd', 'clang', 'gcc'],
        \ }

  let g:ale_fixers = {
        \ 'rust': ['rustfmt', 'remove_trailing_lines', 'trim_whitespace'],
        \ 'go': ['gofmt', 'remove_trailing_lines', 'trim_whitespace'],
        \ 'c': ['remove_trailing_lines', 'trim_whitespace'],
        \ }

  set completeopt=menu,menuone,noselect,noinsert
  let g:ale_fix_on_save = 1
  let g:ale_hover_to_floating_preview = 1

  " emoji looks better with noto sans
  let g:ale_sign_error = '⛔'
  let g:ale_sign_warning = '⚠️'

  highlight ALEErrorSign ctermbg=234
  highlight ALEWarningSign ctermbg=234

  nmap <silent> <C-k>      <Plug>(ale_previous_wrap)
	nmap <silent> <C-j>      <Plug>(ale_next_wrap)
	nmap <silent> <Leader>d  <Plug>(ale_detail)
	nmap <silent> <Leader>h  <Plug>(ale_hover)
	nmap <silent> <Leader>D  <Plug>(ale_go_to_definition)
	nmap <silent> <Leader>r  <Plug>(ale_find_references)
	nmap <silent> <Leader>x  <Plug>(ale_fix)

" }}}
" plugin: vim-lining {{{
	if HavePlugin('vim-lining')
		function s:linting_done()
			let buffer = bufnr('')
			return get(g:, 'ale_enabled')
						\ && getbufvar(buffer, 'ale_linted', 0)
						\ && !ale#engine#IsCheckingBuffer(buffer)
		endfunction

		let s:ale_lining_warnings_item = {}
		function s:ale_lining_warnings_item.format(item, active)
			if a:active && s:linting_done()
				let counts = ale#statusline#Count(bufnr(''))
				let warnings = counts.total - counts.error - counts.style_error
				if warnings > 0
					return warnings
				endif
			endif
			return ''
		endfunction
		call lining#right(s:ale_lining_warnings_item, 'Warn')

		let s:ale_lining_errors_item = {}
		function s:ale_lining_errors_item.format(item, active)
			if a:active && s:linting_done()
				let counts = ale#statusline#Count(bufnr(''))
				let errors = counts.error + counts.style_error
				if errors > 0
					return errors
				endif
			endif
			return ''
		endfunction
		call lining#right(s:ale_lining_errors_item, 'Error')

		let s:ale_status_item = {}
		function s:ale_status_item.format(item, active)
			return (a:active && ale#engine#IsCheckingBuffer(bufnr(''))) ? 'linting' : ''
		endfunction
		call lining#right(s:ale_status_item)

		autocmd vimrc User ALEJobStarted call lining#refresh()
		autocmd vimrc User ALELintPost   call lining#refresh()
		autocmd vimrc User ALEFixPost    call lining#refresh()
	endif
endif
" }}}
" plugin vim-commentary {{{
vmap <leader>cc gc
nmap <leader>cc gcc
" }}}
" }}}
" block: key mappings {{{
command! -nargs=0 -bang Q q<bang>
command! -nargs=0 -bang W w<bang>
command! -nargs=0 -bang Wq wq<bang>
command! -nargs=0 B b#

" commodities
map <C-t> <C-]>
map <C-p> :pop<cr>
map <Space> /
map __ ZZ
nmap <leader>B :buffers<cr>buffer<space>
nmap <leader>b :buffers<cr>
nmap <leader>q :bd<cr>
nmap <C-j> <C-b>
nmap <C-k> <C-f>
nmap <C-l> <end>
nmap <C-h> <home>
inoremap <C-c> <Esc>
nnoremap <C-Left>  b
nnoremap <C-Right> w
nnoremap <C-q> :wq!<cr>

" buffer movements
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>
map <leader>bd :bd<cr>
nnoremap <S-Left> :bprevious<CR>
nnoremap <S-Right> :bnext<CR>

nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" window movements
nnoremap <silent> <M-Left>  <C-w><C-h>
nnoremap <silent> <M-Down>  <C-w><C-j>
nnoremap <silent> <M-Up>    <C-w><C-k>
nnoremap <silent> <M-Right> <C-w><C-l>

" manually re-format a paragraph of text
nnoremap <silent> Q gwip
vnoremap <silent> Q :norm qwip<cr>

" make . work with visually selected lines
vnoremap . :norm .<cr>

" highlight word below the cursor.
nnoremap <silent> <leader>+ :execute 'highlight DoubleClick ctermbg=green ctermfg=black<bar>match DoubleClick /\V\<'.escape(expand('<cword>'), '\').'\>/'<cr>
nnoremap <silent> <leader>- :match none<cr>

" alternate mapping for increasing/decreasing numbers.
nnoremap <S-Up>   <C-x>
nnoremap <S-Down> <C-a>

" tab-completion helper
function! s:check_backspace() abort
	let l:column = col('.') - 1
	return !l:column || getline('.')[l:column - 1] =~# '\s'
endfunction

function! s:trigger_completion() abort
	if &omnifunc !=# ''
		let b:complete_p = 0
		return "\<C-x>\<C-o>"
	elseif &completefunc !=# ''
		let b:complete_p = 1
		return "\<C-x>\<C-u>"
	else
		let b:complete_p = 1
		return "\<C-x>\<C-p>"
	endif
endfunction

inoremap <silent><expr> <Tab>
			\ pumvisible() ? (get(b:, 'complete_p', 1) ? "\<C-p>" : "\<C-n>") :
			\ <sid>check_backspace() ? "\<Tab>" :
			\ "\<C-p>"
inoremap <silent><expr> <C-Space>
			\ <sid>trigger_completion()
inoremap <silent><expr> <CR>
			\ pumvisible() ? "\<C-y>" : "\<CR>"

inoremap <silent><expr> <S-Tab>
			\ pumvisible() ? "\<C-n>" : "\<C-h>"

" }}}
" block: misc stuff and modeline {{{
if filereadable(expand('~/.config/nvim/user.vim'))
  source ~/.config/nvim/user.vim
endif
runtime! macros/matchit.vim
" buffer access with 1gb, 2gb, etc.
let c = 1
while c <= 99
  execute "nnoremap " . c . "gb :" . c . "b\<CR>"
  let c += 1
endwhile
" vim:fdm=marker:foldenable:
" }}}
