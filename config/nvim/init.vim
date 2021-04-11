" block: preload setting {{{
set nocompatible

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
set showmode ruler showcmd showmatch shortmess+=c updatetime=500
set scrolloff=6 sidescrolloff=2 number relativenumber
set nowrap whichwrap+=[,],<,>
set formatoptions+=cqron1 fileformats=unix,mac,dos
set textwidth=140 colorcolumn=80 synmaxcol=300 conceallevel=0
set secure nofsync nobackup
set diffopt+=iwhite tags=tags;/
set undofile undodir=~/.cache/nvim/undo undolevels=1000 undoreload=10000
set timeout timeoutlen=1000
set ttimeout ttimeoutlen=10
set splitbelow splitright
set encoding=utf-8
set completeopt=menuone,noselect,noinsert
set completeopt-=preview
set hidden

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
" block: buffer helpers {{{
function! s:quitiflast()
  bdelete
  let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  echo bufcnt
  if bufcnt == 1 && expand('%') == ''
    quit
  endif
endfunction
command! Bd :call s:quitiflast()
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
let g:netrw_winsize = 25
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

augroup AutoDeleteNetrwHiddenBuffers
  au!
  au FileType netrw setlocal bufhidden=wipe
augroup end

nmap <leader>t :Lexplore<cr>
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

function! MarkdownSyntax()
  syn match    customHeader1     "^# .*$"
  syn match    customHeader2     "^## .*$"
  syn match    customHeader3     "^### .*$"
  syn match    customHeader4     "^#### .*$"
  syn match    customHeader5     "^##### .*$"

  highlight customHeader1 ctermbg=105 ctermfg=white
  highlight customHeader2 ctermfg=105
  highlight customHeader3 ctermfg=71
  highlight customHeader4 ctermfg=172
  highlight customHeader5 ctermfg=246

  highlight mkdCode ctermfg=245
  highlight mkdCodeDelimiter ctermfg=245

  set conceallevel=2
endfunction

augroup markdown_syntax
  autocmd!
  autocmd FileType markdown call MarkdownSyntax()
augroup END

" }}}
" block: configure plugins {{{
" plugin vim-buftabline {{{
if HavePlugin('vim-buftabline')
  let g:buftabline_show = 1
  let g:buftabline_indicators = 1
endif
" }}}
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
" plugin vim-fugitive {{{
autocmd vimrc FileType dirvish call FugitiveDetect(@%)
if HavePlugin('vim-fugitive')
  nmap <leader>gs :G<cr>
  nmap <leader>gb :GBlame<cr>
  nmap <leader>gl :0Glog<cr>
  nmap <leader>g1 :diffget //2<cr>
  nmap <leader>g0 :diffget //3<cr>
endif
" }}}
" plugin vim-commentary {{{
vmap <leader>cc gc
nmap <leader>cc gcc
" }}}
" plugin vim-lsp {{{
if HavePlugin('vim-lsp')
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
  endfunction

  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    autocmd BufWritePre <buffer> LspDocumentFormatSync
  augroup END

  if HavePlugin('vim-lining')
    let s:lsp_lining_warnings_item = {}
    function s:lsp_lining_warnings_item.format(item, active)
      if a:active
        let warnings = lsp#get_buffer_diagnostics_counts()['warning']
        if warnings > 0
          return warnings
        endif
      endif
      return ''
    endfunction
    call lining#right(s:lsp_lining_warnings_item, 'Warn')

    let s:lsp_lining_errors_item = {}
    function s:lsp_lining_errors_item.format(item, active)
      if a:active
        let errors = lsp#get_buffer_diagnostics_counts()['error']
        if errors > 0
          return errors
        endif
      endif
      return ''
    endfunction
    call lining#right(s:lsp_lining_errors_item, 'Error')
  endif

  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_diagnostics_signs_insert_mode_enabled = 1
  let g:lsp_diagnostics_virtual_text_enabled = 0
  let g:lsp_ultisnips_integration = 1

	let g:lsp_diagnostics_signs_error = {'text': '⛔'}
	let g:lsp_diagnostics_signs_warning = {'text': '⚠️ '}
	let g:lsp_diagnostics_signs_hint = {'text': '💡'}
	let g:lsp_diagnostics_signs_information = {'text': 'ℹ️ '}
	let g:lsp_document_code_action_signs_hint = {'text': '🔧'}

  highlight LspErrorText ctermbg=none
  highlight LspWarningText ctermbg=none
  highlight LspHintText ctermbg=none
  highlight LspInformationText ctermbg=none
  highlight LspCodeActionText ctermbg=none

  nmap <leader>d <plug>(lsp-definition)
  nmap <leader>D <plug>(lsp-declaration)
  nmap <leader>h <plug>(lsp-hover)
  nmap <leader>r <plug>(lsp-rename)
  nmap <leader>R <plug>(lsp-references)
  nmap <leader>n <plug>(lsp-next-diagnostic)

  if executable('clangd')
    augroup vim_lsp_cpp
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd']},
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
            \ })
    augroup end
  endif

  if executable('pyls')
    augroup vim_lsp_python
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->['pyls']},
            \ 'allowlist': ['python'],
            \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}},
            \ }}
            \})
    augroup end
  endif

  if executable('yaml-language-server')
    augroup vim_lsp_yaml
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'yamlls',
            \ 'cmd': ['yaml-language-server', '--stdio'],
            \ 'allowlist': ['yaml'],
            \ 'workspace_config': {'yaml': {'schemas': {
            \     'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json': ['/**k8s**', '/**kubernetes**'],
            \     'https://json.schemastore.org/helmfile.json': ['/**Chart.y*ml', '/**charts/**.y*ml'],
            \     'https://json.schemastore.org/github-action.json': ['/.github/actions/*.y*ml'],
            \     'https://json.schemastore.org/gitlab-ci.json': ['/.gitlab-ci.y*ml'],
            \  }},
            \ }})
    augroup end
  endif

  if executable('gopls')
    augroup vim_lsp_gopls
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'gopls',
            \ 'cmd': {server_info->['gopls']},
            \ 'allowlist': ['go'],
            \ })
    augroup end
  endif

  if executable('bash-language-server')
    augroup vim_lsp_bash
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'bash-language-server',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
            \ 'config': {
            \   'refresh_pattern': '\\([a-zA-Z0-9_-]\\+\\|\\k\\+\\)$'
            \ },
            \ 'allowlist': ['sh'],
            \ })
    augroup end
  endif
endif
" }}}
" plugin ultisnips {{{
if HavePlugin('ultisnips')
  let g:UltiSnipsExpandTrigger="<s-tab>"
endif
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
nmap q :Bd<cr>
nmap <C-j> <C-f>
nmap <C-k> <C-b>
nmap <C-l> <end>
nmap <C-h> <home>
inoremap <C-c> <Esc>
nnoremap <C-Left>  b
nnoremap <C-Right> w
nnoremap <C-q> :wq!<cr>

" buffer movements
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>
map <leader>bd :Bd<cr>
nnoremap <M-Left> :bprevious<CR>
nnoremap <M-Right> :bnext<CR>

nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" window movements
nnoremap <silent> <S-Left>  <C-w><C-h>
nnoremap <silent> <S-Down>  <C-w><C-j>
nnoremap <silent> <S-Up>    <C-w><C-k>
nnoremap <silent> <S-Right> <C-w><C-l>

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
  if s:check_backspace()
    return "\<Tab>"
  elseif &omnifunc !=# ''
		return "\<C-x>\<C-o>"
	elseif &completefunc !=# ''
		return "\<C-x>\<C-u>"
	else
		return "\<C-x>\<C-p>"
	endif
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" : <sid>trigger_completion()
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
