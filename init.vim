let mapleader = ","

syntax on
set tabstop=4
set softtabstop=0
set shiftwidth=4
set noexpandtab
set hidden
set number
set relativenumber
set incsearch
set splitright
set splitbelow
set mouse=a
set scrolloff=10

set wildmenu
set wildmode=longest:list,full
set wildignore=*.swp,*.bak,*.pyc,*.class,*~,*.o,*.a

set completeopt=menu,menuone,noselect

color desert

let g:ale_floating_preview = 1

" Use ctags to open the function definition in a preview window
function! TogglePreviewWindow()
	if !exists('w:showPreviewWindow') 
		let w:showPreviewWindow = 0
	endif
	
	let w:showPreviewWindow = !w:showPreviewWindow
	if w:showPreviewWindow
		let l:currentWord = expand('<cword>')
		execute ':ptag ' . l:currentWord
	else
		execute ':pc'
	endif
endfunction

let g:netrw_browse_split=0
let g:netrw_banner=0
let g:netrw_list_hide= '.*\.swp$'

" Highlight the current word the curson is on
let g:quickHighlightOn=0
let g:lastHighlightWord=''
function! QuickHighlightToggle()
	let result = expand("<cword>")
	if g:quickHighlightOn && (result == g:lastHighlightWord)
		let g:quickHighlightOn=0
		execute ':Hclear 4'
	else
		let g:quickHighlightOn=1
		let g:lastHighlightWord=result
		execute ':Highlight 4 '.result
	endif
endfunction

map <leader>h :call QuickHighlightToggle()<CR>

" quickly open terminal along with bash profile
noremap <leader>t :terminal ++curwin<CR> source ~/.bash_profile<CR>clear<CR>
noremap <leader>d :bd<CR>

" Highlight the currently searched word
let g:searchHightlightOn=0
function! SearchHightlightToggle()
	if g:searchHightlightOn
		let g:searchHightlightOn=0
		set nohlsearch
	else
		let g:searchHightlightOn=1
		set hlsearch
	endif
endfunction

noremap <C-h>	:call SearchHightlightToggle()<CR>
inoremap <C-h>	<Esc>:call SearchHightlightToggle()<CR>i

" tab managment shortcuts
noremap <C-t>   :tab split<CR>
noremap <C-j>	:tabprevious<CR>
noremap <C-k>	:tabnext<CR>
inoremap <C-t>  <Esc>:tab split<CR>i
inoremap <C-j>	<Esc>:tabp<CR>
inoremap <C-k>	<Esc>:tabn<CR>

noremap <C-b>		:TagbarToggle<CR>
noremap <C-b>		:TagbarToggle<CR>
inoremap <C-b>	<Esc>:TagbarToggle<CR>i

" Window size management, max current windows/equalize all windows
noremap <C-w>M	<C-w>\|<C-w>_
noremap <C-w>m	<C-w>=

" Clipboard
"inoremap <C-c><C-v> <C-o>"+gP
vmap <C-c><C-x> "+x
vmap <C-c><C-c> "+y
map <C-c><C-v> "+gP
"imap <C-v> <C-o>"+gP
"vmap <C-c> "+y

" delete word cursor is on and paste without copying deleted word into register
nnoremap <leader>r "_dePb 

" Import plugins
if has('nvim')
	:lua require('plugins')
else
	set runtimepath^=~/.vim/bundle/ctrlp.vim
	set runtimepath^=~/.vim/bundle/vim-fugitive
	set runtimepath^=~/.vim/bundle/vim-grepper
endif

" CtrlP shortcuts
function! CtrlPFiles()
	CtrlP :call pwd
endfunction

if has('nvim')
		nnoremap <leader>g :Telescope live_grep_args<CR>
        nnoremap <leader>G :Telescope current_buffer_fuzzy_find<CR>
        nnoremap <leader>f :Telescope find_files<CR>
        nnoremap <leader>b :Telescope buffers<CR>
        nnoremap <leader>e :Dirbuf<CR>
        nnoremap <leader>j :HopWord<CR>
		map <silent> <leader>w :lua require('nvim-window').pick()<CR>
else
        nnoremap <leader>f :call CtrlPFiles()<CR>
        command -nargs=1 Ffd CtrlP "<args>"
        noremap <Leader>b :CtrlPBuffer<CR>
        noremap <Leader>m :CtrlPTag<CR>
        nnoremap <leader>e :Ex<CR>
		nnoremap <leader>w :let @w=@"<CR>
		noremap <leader>g :Grepper -tool grep -highlight -query --exclude=tags <CR>
end

" shortcut to opening file minus the extension, good for opening the other cpp/hpp (if they reside in the same directory)
noremap <Leader>o :e %<.

noremap <Leader>p :call TogglePreviewWindow()<CR>

" quickly copy last copied into registers
nnoremap <leader>a :let @a=@"<CR>
nnoremap <leader>q :let @q=@"<CR>

" switch to window by number using <leader><window number>
let mapleader = ","
function! DefineWindowSelect()
	let l:iWindow = 1
	while l:iWindow <= 9
		execute 'noremap <Leader>' . iWindow . ' :' . iWindow . 'wincmd w<CR>'
		let l:iWindow = iWindow + 1
	endwhile
endfunction
call DefineWindowSelect()

" running out of keys! changing leader
let mapleader = "\\"

" select tab using <leader><tab number>
function! DefineTabSelect()
	let l:iTab = 1
	while l:iTab <= 9
		execute 'noremap <Leader>' . iTab . ' ' . iTab . 'gt<CR>'
		let l:iTab = iTab + 1
	endwhile
endfunction
call DefineTabSelect()

" next/previous tag (ctags)
noremap <leader>] :tn<CR>
noremap <leader>[ :tp<CR>

tnoremap <C-j> <C-W>:tabp<CR>
tnoremap <C-k> <C-W>:tabn<CR>
