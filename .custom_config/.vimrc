" vim:foldmethod=marker

" GENERAL:
"{{{ LOAD PLUGINS - vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'junegunn/fzf.vim'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'lervag/wiki.vim'
Plug 'itchyny/lightline.vim'
Plug 'roxma/vim-tmux-clipboard'
Plug 'sunaku/tmux-navigate'
Plug 'chrisbra/Recover.vim'
Plug 'tpope/vim-fugitive'

call plug#end()
"}}}
"{{{ OPTIONS
set ts=4 sts=4 sw=4 et
set autoindent smartindent
set breakindent breakindentopt=min:20,shift:1,sbr showbreak=\|->\ 
set ignorecase smartcase
set number
set relativenumber
set cursorline
set clipboard=unnamed
set hidden
"set termguicolors
"}}}
"{{{ BASIC KEYMAPPINGS
let mapleader = "\<Space>"

noremap : q:i
noremap / q/i
noremap ? q?i
noremap q: :
noremap q/ /
noremap q? ?

" Scroll horizontally using Ctrl + h/l
map <C-l> 20zl " Scroll 20 characters to the right
map <C-h> 20zh " Scroll 20 characters to the left

" Remove whitespaces from line ends
nmap <leader>w :%s/\s\+$//<CR>:noh<CR>

" Replace selected text with content of clipboard without yanking
vnoremap <silent> <leader>p "_dP

" Counts occurances of phrase
map <leader>cc q:%s///gn<CR>
"}}}
"{{{ Colorscheme - backup: murphy
colorscheme murphy
"}}}

" PLUGINS:
"{{{ Colorscheme: ONEDARK
colorscheme onedark
"}}}
"{{{ File Explorer: RANGER.VIM - <leader>e Ranger
map <leader>e q:Ranger<CR>

" Opening ranger instead of netrw when you open a directory
"let g:NERDTreeHijackNetrw = 0 " add this line if you use NERDTree
let g:ranger_replace_netrw = 1 " open ranger when vim open a directory

" Setting a custom ranger command
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
"}}}
"{{{ Fuzzy finder: FZF.VIM
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>ff :Files<CR>
"}}}
"{{{ Wiki: WIKIA.VIM
let g:wiki_root = '~/Wiki/'
let g:wiki_filetypes = ['md']
let g:wiki_link_extension = '.md'
"}}}
"{{{  Status line: lightline.vim
set laststatus=2
let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ }
"}}}
"{{{ Visual marks: VIM-MARK (+ custom filtering solution)
let g:mwDefaultHighlightingPalette = 'extended'
"}}}

" OTHER:
"{{{ Clipboard support using tmux - TODO Requires testing
"   let g:clipboard = {
"       \   'name': 'myTmuxClipboard',
"       \       'copy': {
"       \               '+': ['tmux', 'load-buffer', '-'],
"       \               '*': ['tmux', 'load-buffer', '-'],
"       \               },
"       \       'paste': {
"       \               '+': ['tmux', 'save-buffer', '-'],
"       \               '*': ['tmux', 'save-buffer', '-'],
"       \                }
"       \             }
"}}}
"{{{ Setting which may be needed to 256 colors to be displayed correctly with tmux
if &term == "screen"
    set t_Co=256
endif
"}}}
"{{{ This should theoretically change cursor depending on mode, but it doesn't work
if exists('$TMUX')
    let &t_SI .= "\ePtmux;\e\e[=1c\e\\"
    let &t_EI .= "\ePtmux;\e\e[=2c\e\\"
else
    let &t_SI .= "\e[=1c"
    let &t_EI .= "\e[=2c"
endif
"}}}
"{{{ Disable line wrapping for .log files
autocmd FileType log :set nowrap
"}}}
"{{{ Fixes for Quickfix list - <l> SortUniqQFList, (qf)dd RemoveQFItem, (qf)p preview,

    "{{{ <l>s SortUniqQFList
     " sort quicklist and leave only unique elements
    function! s:CompareQuickfixEntries(i1, i2)
        if bufname(a:i1.bufnr) == bufname(a:i2.bufnr)
            return a:i1.lnum == a:i2.lnum ? 0 : (a:i1.lnum < a:i2.lnum ? -1 : 1)
        else
            return bufname(a:i1.bufnr) < bufname(a:i2.bufnr) ? -1 : 1
        endif
    endfunction

    function! SortUniqQFList()
        let sortedList = sort(getqflist(), 's:CompareQuickfixEntries')
        let uniqedList = []
        let last = ''
        for item in sortedList
            let this = bufname(item.bufnr) . "\t" . item.lnum
            if this !=# last
                call add(uniqedList, item)
        "         call remove(uniqedList, -1)
                let last = this
            endif
        endfor
        call setqflist(uniqedList, 'r')
    endfunction
    " for some reason below command doesnt wotk
    " autocmd!
    " QuickfixCmdPost * call s:SortUniqQFList()
    " Workaround:
    autocmd FileType qf map <buffer> <leader>s :call SortUniqQFList()<CR>
    "}}}
    "{{{ (qf)dd RemoveQFItem
    " When using `dd` in the quickfix list, remove the item from the quickfix list.
    function!  RemoveQFItem()
        let curqfidx = line('.') - 1
        let qfall = getqflist()
        call remove(qfall, curqfidx)
        call setqflist(qfall, 'r')
        execute curqfidx + 1 . "cfirst"
        :copen
    endfunction
    :command!  RemoveQFItem :call RemoveQFItem()
    " Use map <buffer> to only map dd in the quickfix window.  Requires +localmap
    autocmd FileType qf map <buffer> dd q:RemoveQFItem<CR>
    "}}}
    "{{{ (qf)p preview, <CR> gotoAndClose
    " Preview - don't leave quickfix window when selecting element
    autocmd FileType qf nnoremap <buffer> p <CR><C-w>p 
    " gotoAndClose - closes qf window after jumping to selected element
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
    "}}}
    "{{{ (qf)<l>cq ClearQuicfixList, <l>co openQFList
    command! ClearQuickfixList cexpr []
    autocmd FileType qf nnoremap <buffer> <leader>cq <CR>:ClearQuickfixList<CR>
    " openQFList
    nnoremap <leader>co <CR>:copen<CR>
    "}}}
    "{{{ <l>cs searchToQFList
        " searchToQFList - Populate QF list with last searched phrase
        nnoremap <leader>cs :vim // %<CR>:copen<CR>
    "}}}

"}}}
"{{{ Custom filtering solution (Requires VIM-MARK) TODO - remove clipboard dependancy
nmap <silent> <leader>mf q:MarkYankDefinitions *<CR>q:!xclip -o <bar> awk 'BEGIN {FS = "Mark\! "} {output=output "\\\\|" substr($2, 2, length($2)-2)} END {print "/" substr(output, 3, length(output)) "/"} ' <bar> xclip<CR>q:sleep 1<CR>q:vimgrep <C-r>* %<CR>q:copen<CR>q:setlocal conceallevel=2<CR>q:syntax match qfLocation /^[^\|]*\|[^\|]*\| / transparent conceal<CR>q:set concealcursor=nvic<CR>
nmap <silent> <leader>ml q:MarkYankDefinitions *<CR>q:!xclip -o <bar> awk 'BEGIN {FS = "Mark\! " ; output="Rg "} {output=output " -e \047" substr($2, 2, length($2)-2) "\047"} END {print output} ' <bar> sed 's/<bar>/\\\\<bar>/g; s/\[/\\[/g; s/{/\\{/g' <bar> xclip<CR>q:sleep 1<CR>q:<C-r>* %<CR>q:copen<CR>q:setlocal conceallevel=2<CR>q:syntax match qfLocation /^[^\|]*\|[^\|]*\| / transparent conceal<CR>q:set concealcursor=nvic<CR>q:set filetype=log.qf<CR>
"awk 'BEGIN {FS = "Mark\! "} {output=output "\\\\|" substr($2, 2, length($2)-2)} END {print "/" substr(output, 3, length(output)) "/"} ' <bar> xclip<CR>q:sleep 1<CR>q:vimgrep <C-r>* %<CR>q:copen<CR>q:setlocal conceallevel=2<CR>q:syntax match qfLocation /^[^\|]*\|[^\|]*\| / transparent conceal<CR>q:set concealcursor=nvic<CR>
"To use vim-mark with Rg "\<" and "\>" needs to be removed from vim-mark Mark function code
" xclip -o | awk 'BEGIN {FS = "Mark! "} {output=output "\\|" substr($2, 2, length($2)-2)} END {print "/" substr(output, 3, length(output)) "/"} ' | xclip
"}}}
