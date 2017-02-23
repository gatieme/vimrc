"  Gvim中文菜单乱码解决方案
"  http://blog.csdn.net/laruence/article/details/2603031
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
if has("win32")
 set fileencoding=chinese
else
 set fileencoding=utf-8
endif

"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"解决consle输出乱码
language messages zh_CN.utf-8


" 2017-02-04修改"
" https://www.oschina.net/code/snippet_574132_13351"
"------------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
"------------------------------------------------------------------------------
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:iswindows = 0
endif

"------------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
"------------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

"------------------------------------------------------------------------------
"  < 编译、连接、运行配置 >
"------------------------------------------------------------------------------
" F9 一键保存、编译、连接存并运行
map <F9> :call Run()<CR>
imap <F9> <ESC>:call Run()<CR>

" Ctrl + F9 一键保存并编译
map <c-F9> :call Compile()<CR>
imap <c-F9> <ESC>:call Compile()<CR>

" Ctrl + F10 一键保存并连接
map <c-F10> :call Link()<CR>
imap <c-F10> <ESC>:call Link()<CR>

let s:LastShellReturn_C = 0
let s:LastShellReturn_L = 0
let s:ShowWarning = 1
let s:Obj_Extension = '.o'
let s:Exe_Extension = '.exe'
let s:Sou_Error = 0

let s:windows_CFlags = 'gcc\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

let s:windows_CPPFlags = 'g++\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CPPFlags = 'g++\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

func! Compile()
    exe ":w!"
    exe ":ccl"
    exe ":update"
    if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
        let s:Sou_Error = 0
        let s:LastShellReturn_C = 0
        let Sou = expand("%:p")
        let Obj = expand("%:p:r").s:Obj_Extension
        let Obj_Name = expand("%:p:t:r").s:Obj_Extension
        let v:statusmsg = ''
        if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
            redraw!
            if expand("%:e") == "c"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CFlags
                else
                    exe ":setlocal makeprg=".s:linux_CFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CPPFlags
                else
                    exe ":setlocal makeprg=".s:linux_CPPFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_C = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_C != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " compilation failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " compilation successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " compilation successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Obj_Name"is up to date"
        endif
    else
        let s:Sou_Error = 1
        echohl WarningMsg | echo " please choose the correct source file"
    endif
    exe ":setlocal makeprg=make"
endfunc

func! Link()
    call Compile()
    if s:Sou_Error || s:LastShellReturn_C != 0
        return
    endif
    let s:LastShellReturn_L = 0
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
        let Exe_Name = expand("%:p:t:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
        let Exe_Name = expand("%:p:t:r")
    endif
    let v:statusmsg = ''
    if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
        redraw!
        if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
            if expand("%:e") == "c"
                setlocal makeprg=gcc\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                setlocal makeprg=g++\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_L = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_L != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " linking failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " linking successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " linking successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Exe_Name"is up to date"
        endif
    endif
    setlocal makeprg=make
endfunc

func! Run()
    let s:ShowWarning = 0
    call Link()
    let s:ShowWarning = 1
    if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
        return
    endif
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
    endif
    if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
        redraw!
        echohl WarningMsg | echo " running..."
        if g:iswindows
            exe ":!%<.exe"
        else
            if g:isGUI
                exe ":!gnome-terminal -e ./%<"
            else
                exe ":!./%<"
            endif
        endif
        redraw!
        echohl WarningMsg | echo " running finish"
    endif
endfunc




"==========================================
" Author:  wklken
" Version: 9.0
" Email: wklken@yeah.net
" BlogPost: http://www.wklken.me
" ReadMe: README.md
" Donation: http://www.wklken.me/pages/donation.html
" Last_modify: 2015-05-02
" Sections:
"       -> Initial Plugin 加载插件
"       -> General Settings 基础设置
"       -> Display Settings 展示/排版等界面格式设置
"       -> FileEncode Settings 文件编码设置
"       -> Others 其它配置
"       -> HotKey Settings  自定义快捷键
"       -> FileType Settings  针对文件类型的设置
"       -> Theme Settings  主题设置
"
"       -> 插件配置和具体设置在vimrc.bundles中
"==========================================

"==========================================
" Initial Plugin 加载插件
"==========================================

" 修改leader键
let mapleader = ','
let g:mapleader = ','

" 开启语法高亮
syntax on


" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

"==========================================
" General Settings 基础设置
"==========================================

"以下配置有详细说明，一些特性不喜欢可以直接注解掉

"set guifont=Monaco:h20          " 字体 && 字号

" history存储容量
set history=2000

"检测文件类型
filetype on
"针对不同的文件类型采用不同的缩进格式
filetype indent on
"允许插件
filetype plugin on
"启动自动补全
filetype plugin indent on

set autoread          " 文件修改之后自动载入。
set shortmess=atI       " 启动的时候不显示那个援助索马里儿童的提示

" 备份,到另一个位置. 防止误删, 目前是取消备份
"set backup
"set backupext=.bak
"set backupdir=/tmp/vimbk/

" 取消备份。 视情况自己改
set nobackup
" 关闭交换文件
set noswapfile


"create undo file
if has('persistent_undo')
  set undolevels=1000         " How many undos
  set undoreload=10000        " number of lines to save for undo
  set undofile                " So is persistent undo ...
  set undodir=/tmp/vimundo/
endif

set wildignore=*.swp,*.bak,*.pyc,*.class,.svn
" 突出显示当前行等
set cursorcolumn
set cursorline          " 突出显示当前行

" 让第80列高亮
set cc=81

"设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制
"好处：误删什么的，如果以前屏幕打开，可以找回
set t_ti= t_te=


"- 则点击光标不会换,用于复制
"set mouse-=a             " 鼠标暂不启用, 键盘党....
set mouse=a                 " Automatically enable mouse usage
" set mousehide               " Hide the mouse cursor while typing
" 设置按下鼠标右键之后像vim一样弹出菜单
set mousemodel=popup

" 修复ctrl+m 多光标操作选择的bug，但是改变了ctrl+v进行字符选中时将包含光标下的字符
"set selection=exclusive
set selection=inclusive
set selectmode=mouse,key

" No annoying sound on errors
" 去掉输入错误的提示声音
set title                " change the terminal's title
set novisualbell         " don't beep
set noerrorbells         " don't beep
set t_vb=
set tm=500

" Remember info about open buffers on close"
set viminfo^=%

" For regular expressions turn magic on
set magic

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"==========================================
" Display Settings 展示/排版等界面格式设置
"==========================================
"
"显示当前的行号列号：
set ruler
""在状态栏显示正在输入的命令
set showcmd
" 左下角显示当前vim模式
set showmode

" 在上下移动光标时，光标的上方或下方至少会保留显示的行数
set scrolloff=7

" set winwidth=79

" 命令行（在状态行下）的高度，默认为1，这里是2
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
" Always show the status line - use 2 lines for the status bar
set laststatus=2
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
"set laststatus=2
"set ruler


"显示行号：
set number
" 取消换行。
set nowrap

" 括号配对情况,跳转并高亮一下匹配的括号
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

"设置文内智能搜索提示
" 高亮search命中的文本。
set hlsearch
" 打开增量搜索模式,随着键入即时搜索
set incsearch
" 搜索时忽略大小写
set ignorecase
" 有一个或以上大写字母时仍大小写敏感
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise

" 代码折叠
set foldenable
" 折叠方法
" manual    手工折叠
" indent    使用缩进表示折叠
" expr      使用表达式定义折叠
" syntax    使用语法定义折叠
" diff      对没有更改的文本进行折叠
" marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}
set foldmethod=indent
set foldlevel=99
" 代码折叠自定义快捷键
let g:FoldMethod = 0
map <leader>zz :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun

" 缩进配置

set smartindent   " Smart indent
set autoindent    " 打开自动缩进
" never add copyindent, case error   " copy the previous indentation on autoindenting

" tab相关变更
set tabstop=4     " 设置Tab键的宽度        [等同的空格个数]
set shiftwidth=4  " 每一次缩进对应的空格数
set softtabstop=4 " 按退格键时可以一次删掉 4 个空格
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop 按退格键时可以一次删掉 4 个空格
set expandtab     " 将Tab自动转化成空格    [需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set shiftround    " 缩进时，取整 use multiple of shiftwidth when indenting with '<' and '>'

" A buffer becomes hidden when it is abandoned
set hidden
set wildmode=list:longest
set ttyfast

" 00x增减数字时使用十进制
set nrformats=


" 相对行号      行号变成相对，可以用 nj  nk   进行跳转 5j   5k 上下跳5行
set relativenumber number
au FocusLost * :set norelativenumber number
au FocusGained * :set relativenumber
" 插入模式下用绝对行号, 普通模式下用相对
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber number
  else
    set relativenumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>


"==========================================
" FileEncode Settings 文件编码,格式
"==========================================
" 设置新文件的编码为 UTF-8
set encoding=utf-8
" 自动判断编码时，依次尝试以下编码：
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set helplang=cn
"set langmenu=zh_CN.UTF-8
"set enc=2byte-gb18030
" 下面这句只影响普通模式 (非图形界面) 下的 Vim。
set termencoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" 如遇Unicode值大于255的文本，不必等到空格再折行。
set formatoptions+=m
" 合并两行中文时，不在中间加空格：
set formatoptions+=B


"==========================================
" others 其它设置
"==========================================
autocmd! bufwritepost _vimrc source % " vimrc文件修改之后自动加载。 windows。
autocmd! bufwritepost .vimrc source % " vimrc文件修改之后自动加载。 linux。

" 自动补全配置
"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu

" 增强模式中的命令行自动完成操作
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.class

"离开插入模式后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"回车即选中当前项
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"

"上下左右键的行为 会显示其他信息
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

" if this not work ,make sure .viminfo is writable for you
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"==========================================
" HotKey Settings  自定义快捷键设置
"==========================================

" 主要按键重定义

" 关闭方向键, 强迫自己用 hjkl
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

"Treat long lines as break lines (useful when moving around in them)
"se swap之后，同物理行上线直接跳
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" F1 - F12 设置
" F1  废弃这个键,防止调出系统帮助
" F2  行号开关，用于鼠标复制代码用
" F3  显示可打印字符开关
" F4  换行开关
" F5  粘贴模式paste_mode开关,用于有格式的代码粘贴
" F6  语法开关，关闭语法可以加快大文件的展示
" F7  开启NERDTree插件
" F8  C, C++调试
" F9  编译运行
" F10 Gnome桌面的菜单键
" F11 Ubuntu终端的全屏键
" F12

" I can type :help on my own, thanks.  Protect your fat fingers from the evils of <F1>
noremap <F1> <Esc>"

""为方便复制，用<F2>开启/关闭行号显示:
function! HideNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
nnoremap <F2> :call HideNumber()<CR>
nnoremap <F3> :set list! list?<CR>
nnoremap <F4> :set wrap! wrap?<CR>
              "set paste
set pastetoggle=<F5>            "    when in insert mode, press <F5> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented

" disbale paste mode when leaving insert mode
au InsertLeave * set nopaste

nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>


"Smart way to move between windows 分屏窗口移动
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Go to home and end using capitalized directions
noremap H ^
noremap L $


"Map ; to : and save a million keystrokes
" ex mode commands made easy 用于快速进入命令行
nnoremap ; :


" 命令行模式增强，ctrl - a到行首， -e 到行尾
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" 搜索相关

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
" 进入搜索Use sane regexes"
nnoremap / /\v
vnoremap / /\v

"Keep search pattern at the center of the screen."
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" switch # *
nnoremap # *
nnoremap * #

" for # indent, python文件中输入新行时#号注释不切回行首
autocmd BufNewFile,BufRead *.py inoremap # X<c-h>#


" 去掉搜索高亮
noremap <silent><leader>/ :nohls<CR>

" --------tab/buffer相关

"Use arrow key to change buffer"
" TODO: 如何跳转到确定的buffer?
" :b1 :b2   :bf :bl
nnoremap [b :bprevious<cr>
nnoremap ]b :bnext<cr>
noremap <left> :bp<CR>
noremap <right> :bn<CR>


" tab 操作
" TODO: ctrl + n 变成切换tab的方法
" http://vim.wikia.com/wiki/Alternative_tab_navigation
" http://stackoverflow.com/questions/2005214/switching-to-a-particular-tab-in-vim
"map <C-2> 2gt
map <leader>th :tabfirst<cr>
map <leader>tl :tablast<cr>

map <leader>tj :tabnext<cr>
map <leader>tk :tabprev<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprev<cr>

map <leader>te :tabedit<cr>
map <leader>td :tabclose<cr>
map <leader>tm :tabm<cr>


" 新建tab  Ctrl+t
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>
" TODO: 配置成功这里, 切换更方便, 两个键
" nnoremap <C-S-tab> :tabprevious<CR>
" nnoremap <C-tab>   :tabnext<CR>
" inoremap <C-S-tab> <Esc>:tabprevious<CR>i
" inoremap <C-tab>   <Esc>:tabnext<CR>i
" nnoremap <C-Left> :tabprevious<CR>
" nnoremap <C-Right> :tabnext<CR>

" normal模式下切换到确切的tab
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" Toggles between the active and last active tab "
" The first tab is always 1 "
let g:last_active_tab = 1
" nnoremap <leader>gt :execute 'tabnext ' . g:last_active_tab<cr>
" nnoremap <silent> <c-o> :execute 'tabnext ' . g:last_active_tab<cr>
" vnoremap <silent> <c-o> :execute 'tabnext ' . g:last_active_tab<cr>
nnoremap <silent> <leader>tt :execute 'tabnext ' . g:last_active_tab<cr>
vnoremap <silent> <leader>tt :execute 'tabnext ' . g:last_active_tab<cr>
autocmd TabLeave * let g:last_active_tab = tabpagenr()


" ------- 选中及操作改键

"Reselect visual block after indent/outdent.调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv

" y$ -> Y Make Y behave like other capitals
map Y y$

" auto jump to end of select
" vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]

" select all
map <Leader>sa ggVG"

" select block
nnoremap <leader>v V`}

" w!! to sudo & write a file
cmap w!! w !sudo tee >/dev/null %

" kj 替换 Esc
inoremap kj <Esc>

" 滚动Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>


"Jump to start and end of line using the home row keys
" 增强tab操作, 导致这个会有问题, 考虑换键
"nmap t o<ESC>k
"nmap T O<ESC>j

" Quickly close the current window
nnoremap <leader>q :q<CR>
" Quickly save the current file
nnoremap <leader>w :w<CR>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Automatically set paste mode in Vim when pasting in insert mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"==========================================
" FileType Settings  文件类型设置
"==========================================

" Python 文件的一般设置，比如不要 tab 等
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
autocmd BufRead,BufNew *.md,*.mkd,*.markdown  set filetype=markdown.mkd


" 保存python文件时删除多余空格
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()


" 定义函数AutoSetFileHead，自动插入文件头
autocmd BufNewFile *.sh,*.py,*.c,*.cpp exec ":call AutoSetFileHead()"
function! AutoSetFileHead()

    "如果文件类型为python
    if &filetype == 'python'

        call setline(1, "\#!/usr/bin/env python")

        call append(1, "\# encoding: utf-8")

    "如果文件类型为.sh文件
    elseif &filetype == 'sh'
        call setline(1,"\#########################################################################")

        call append(line("."), "\# File Name: ".expand("%"))

        call append(line(".")+1, "\# Author: GatieMe")

        call append(line(".")+2, "\# mail: gatieme@163.com")

        call append(line(".")+3, "\# Created Time: ".strftime("%c"))

        call append(line(".")+4, "\#########################################################################")

        call append(line(".")+5, "\#!/bin/bash")

        call append(line(".")+6, "")

    elseif &filetype == 'c'

        call setline(1, "/*************************************************************************")

        call append(line("."), "    > File Name: ".expand("%"))

        call append(line(".")+1, "    > Author: GatieMe")

        call append(line(".")+2, "    > Mail: gatieme@163.com")

        call append(line(".")+3, "    > Created Time: ".strftime("%c"))

        call append(line(".")+4, " ************************************************************************/")

        call append(line(".")+5, "")

        call append(line(".")+6, "#include <stdio.h>")

        call append(line(".")+7, "#include <stdlib.h>")

	    call append(line(".")+8, "")

    elseif &filetype == 'cpp'

        call setline(1, "/*************************************************************************")

        call append(line("."), "    > File Name: ".expand("%"))

        call append(line(".")+1, "    > Author: GatieMe")

        call append(line(".")+2, "    > Mail: gatieme@163.com ")

        call append(line(".")+3, "    > Created Time: ".strftime("%c"))

        call append(line(".")+4, " ************************************************************************/")

        call append(line(".")+5, "")

        call append(line(".")+6, "#include <iostream>")

        call append(line(".")+7, "using namespace std;")

        call append(line(".")+8, "")

    endif



    "新建文件后，自动定位到文件末尾
    "autocmd BufNewFile * normal G
    normal G
    normal o
    normal o

endfunc

"C,C++的调试
map <F8> :call Rungdb()<CR>

func! Rungdb()

        exec "w"
        exec "!g++ % -g -o %<"
        exec "!gdb ./%<"

endfunc


"C，C++, shell, python, javascript, ruby...等按F9运行

map <F9> :call CompileRunGcc()<CR>

func! CompileRunGcc()

    exec "w"

    if &filetype == 'c'
		" 如果没有安装color_compile
		" 安装方法参见
		" http://blog.csdn.net/gatieme/article/details/44956967
		if exists("/usr/local/bin/color_compile")

			exec "!gcc % -o %< -lm -lpthread -Wall -std=gnu9x"

			exec "! ./%<"

		else

			exec "!color_compile gcc % -o %< -lm -lpthread -Wall -std=gnu9x"

			exec "! ./%<"

		endif

	elseif &filetype == 'cpp'

		if exists("/usr/local/bin/color_compile")

			exec "! g++ % -o %< -lm -Wall"

			exec "! ./%<"

		else

			exec "!color_compile g++ % -o %< -lm -Wall"

			exec "! ./%<"

        endif

	elseif &filetype == 'py'

        exec "!python ./%"
        "exec "!/usr/bin/env python %"

    elseif &filetype == 'sh'

        :!sh ./%

    elseif &filetype == 'java'

        exec "!javac %"

        exec "!java %<"

    endif

endfunc




" set some keyword to highlight
if has("autocmd")

    " Highlight TODO, FIXME, NOTE, etc.

    if v:version > 701

        autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')

        autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')

    endif

endif

"==========================================
" Theme Settings  主题设置
"==========================================

" Set extra options when running in GUI mode
"set guifont=Courier\ New\ Bold\ 16
if has("gui_running")
    "set guifont=Monaco:h14
    if has("gui_gtk2")
        set guifont=Courier\ New\ Bold\ 16,Monospace\ 12
    elseif has("gui_macvim")
        "set guifont=DejaVu\ Sans\ Mono\ 11
        set guifont=Monaco\ 12,Monospace\ 12
    elseif has("gui_win32")
        set guifont=Courier\ New:b:h16
        "set guifont=Monaco\ 12,Monospace\ 12
        "set guifont=DejaVu_Sans_Mono:h11
    endif
    set guioptions-=T
    set guioptions+=e
    set guioptions-=r
    set guioptions-=L
    set guitablabel=%M\ %t
    set showtabline=1
    set linespace=2
    set noimd
    set t_Co=256
endif


"
"  安装了tmux终端功能后，vim显示不正常
"  使用如下配置修复


" 使用tmux后vim颜色不正常的修复
"if exists('$TMUX')
"    set term=screen-256color
"endif

"if exists('$ITERM_PROFILE')
"    if exists('$TMUX')
"       let &amp;t_SI = "<Esc>[3 q"
"        let &amp;t_EI = "<Esc>[0 q"
"    else
"        let &amp;t_SI = "<Esc>]50;CursorShape=1x7"
"        let &amp;t_EI = "<Esc>]50;CursorShape=0x7"
"    endif
"endif

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" theme主题
set background=dark
set t_Co=256
" colorscheme solarized
" colorscheme Tomorrow-Night
" colorscheme Tomorrow-Night-Bright
" colorscheme desert
"https://github.com/sickill/vim-monokai
colorscheme monokai
"color theme: brogrammer
"for sublime
"https://github.com/kenwheeler/brogrammer-theme
"for vim
"https://github.com/marciomazza/vim-brogrammer-theme


" 设置标记一列的背景颜色和数字一行颜色一致
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" for error highlight，防止错误整行标红导致看不清
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline




" 判断当前系统类型是Windows还是Linux
" return OS type, eg: windows, or linux, mac, et.st..
function! MySys( )

    if has("win16") || has("win32") || has("win64") || has("win95")

        return "windows"

    elseif has("unix")

        return "linux"

endif

endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CTags的设定

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let Tlist_Sort_Type = "name"    " 按照名称排序

let Tlist_Use_Right_Window = 0  " 在左侧显示窗口

let Tlist_Compart_Format = 1    " 压缩方式

let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer

let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags

let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树

autocmd FileType java set tags+=D:\tools\java\tags

"autocmd FileType h,cpp,cc,c set tags+=D:\tools\cpp\tags

"let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的

"设置tags

set tags=tags

"set autochdir



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"其他东东

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" minibufexpl插件的一般设置

let g:miniBufExplMapWindowNavVim = 1

let g:miniBufExplMapWindowNavArrows = 1

let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1


"-----------------------------------------------------------------
" plugin - bufexplorer.vim Buffers切换
" \be 全屏方式查看全部打开的文件列表
" \bv 左右方式查看 \bs 上下方式查看
"-----------------------------------------------------------------


"-----------------------------------------------------------------
" plugin - taglist.vim 查看函数列表，需要ctags程序
" F12 打开隐藏taglist窗口
"-----------------------------------------------------------------
if MySys() == "windows" " 设定windows系统中ctags程序的位置

    let Tlist_Ctags_Cmd = '"'.$VIMRUNTIME.'/ctags.exe"'

elseif MySys() == "linux" " 设定windows系统中ctags程序的位置

    let Tlist_Ctags_Cmd = '/usr/bin/ctags'

endif

"nnoremap <silent><F12> :TlistToggle<CR>


"默认不打开Taglist
"let Tlist_Auto_Open=0

"let Tlist_Show_One_File = 1 " 不同时显示多个文件的tag，只显示当前文件的
"let Tlist_Exit_OnlyWindow = 1 " 如果taglist窗口是最后一个窗口，则退出vim
"let Tlist_Use_Right_Window = 1 " 在右侧窗口中显示taglist窗口
"let Tlist_File_Fold_Auto_Close=1 " 自动折叠当前非编辑文件的方法列表

"let Tlist_Auto_Update = 1

"let Tlist_Hightlight_Tag_On_BufEnter = 1
"let Tlist_Enable_Fold_Column = 0
"let Tlist_Process_File_Always = 1
"let Tlist_Display_Prototype = 0
"let Tlist_Compact_Format = 1


"-----------------------------------------------------------------
" plugin - mark.vim 给各种tags标记不同的颜色，便于观看调式的插件。
" \m mark or unmark the word under (or before) the cursor
" \r manually input a regular expression. 用于搜索.
" \n clear this mark (i.e. the mark under the cursor), or clear all highlighted marks .
" \* 当前MarkWord的下一个 \# 当前MarkWord的上一个
" \/ 所有MarkWords的下一个 \? 所有MarkWords的上一个
"-----------------------------------------------------------------


"-----------------------------------------------------------------
" plugin - NERD_tree.vim 以树状方式浏览系统中的文件和目录
" :ERDtree 打开NERD_tree :NERDtreeClose 关闭NERD_tree
" o 打开关闭文件或者目录 t 在标签页中打开
" T 在后台标签页中打开 ! 执行此文件
" p 到上层目录 P 到根目录
" K 到第一个节点 J 到最后一个节点
" u 打开上层目录 m 显示文件系统菜单（添加、删除、移动操作）
" r 递归刷新当前目录 R 递归刷新当前根目录
"-----------------------------------------------------------------
" F7 NERDTree 切换
map <F7> :NERDTreeToggle<CR>
imap <F7> <ESC>:NERDTreeToggle<CR>

" 打开vim时，默认开启NERDTree，并将光标定位在右侧文件编辑终端中
"autocmd VimEnter * NERDTree
"wincmd w
"autocmd VimEnter * wincmd w

let NERDTreeWinPos ="left"   "将NERDTree的窗口设置在gvim窗口的左边

let NERDTreeShowBookmarks=1  "当打开NERDTree窗口时，自动显示Bookmarks

let NERDChristmasTree=1

let NERDTreeAutoCenter=1

let NERDTreeMouseMode=2

let NERDTreeShowFiles=1

let NERDTreeShowHidden=1

let NERDTreeShowLineNumbers=1

let NERDTreeWinSize=31



"-----------------------------------------------------------------
" plugin - NERD_commenter.vim 注释代码用的，
" [count],cc 光标以下count行逐行添加注释(7,cc)
" [count],cu 光标以下count行逐行取消注释(7,cu)
" [count],cm 光标以下count行尝试添加块注释(7,cm)
" ,cA 在行尾插入 /* */,并且进入插入模式。 这个命令方便写注释。
" 注：count参数可选，无则默认为选中行或当前行
"-----------------------------------------------------------------
let NERDSpaceDelims=1 " 让注释符与语句之间留一个空格
let NERDCompactSexyComs=1 " 多行注释时样子更好看



"-----------------------------------------------------------------
"-- omnicppcomplete setting --
"" 按下F4自动补全代码，注意该映射语句后不能有其他字符，包括tab；否则按下F3会自动补全一些乱码
"-----------------------------------------------------------------
imap <F4> <C-X><C-O>
" 按下F2根据头文件内关键字补全
imap <F2> <C-X><C-I>
set completeopt=menu,menuone " 关掉智能补全时的预览窗口
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype in popup window
let OmniCpp_GlobalScopeSearch=1 " enable the global scope search
let OmniCpp_DisplayMode=1 " Class scope completion mode: always show all`:
" members
"let OmniCpp_DefaultNamespaces=["std"]
let OmniCpp_ShowScopeInAbbr=1 " show scope in abbreviation and remove the
" last column
let OmniCpp_ShowAccess=1"""]"""""')""""""""

"-----------------------------------------------------------------
" plugin - DoxygenToolkit.vim 由注释生成文档，并且能够快速生成函数标准注释
"-----------------------------------------------------------------
let g:DoxygenToolkit_authorName="Asins - asinsimple AT gmail DOT com"
let g:DoxygenToolkit_briefTag_funcName="yes"
map <leader>da :DoxAuthor<CR>
map <leader>df :Dox<CR>
map <leader>db :DoxBlock<CR>
map <leader>dc a /* */<LEFT><LEFT><LEFT>


"-----------------------------------------------------------------
" plugin – ZenCoding.vim 很酷的插件，HTML代码生成
" 插件最新版：http://github.com/mattn/zencoding-vim
" 常用命令可看：http://nootn.com/blog/Tool/23/
"-----------------------------------------------------------------


"-----------------------------------------------------------------
" plugin – checksyntax.vim JavaScript常见语法错误检查
" 默认快捷方式为 F5
"-----------------------------------------------------------------
let g:checksyntax_auto = 0 " 不自动检查


"-----------------------------------------------------------------
" plugin - NeoComplCache.vim 自动补全插件
"-----------------------------------------------------------------
let g:AutoComplPop_NotEnableAtStartup = 1
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_TagsAutoUpdate = 1
let g:NeoComplCache_EnableInfo = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_MinSyntaxLength = 3
let g:NeoComplCache_EnableSkipCompletion = 1
let g:NeoComplCache_SkipInputTime = '0.5'
let g:NeoComplCache_SnippetsDir = $VIMFILES.'/snippets'
" <TAB> completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" snippets expand key
imap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)
smap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)




"-----------------------------------------------------------------
" plugin - matchit.vim 对%命令进行扩展使得能在嵌套标签和语句之间跳转
" % 正向匹配 g% 反向匹配
" [% 定位块首 ]% 定位块尾
"-----------------------------------------------------------------


"-----------------------------------------------------------------
" plugin - vcscommand.vim 对%命令进行扩展使得能在嵌套标签和语句之间跳转
" SVN/git管理工具
"-----------------------------------------------------------------


"-----------------------------------------------------------------
" plugin – a.vim
"-----------------------------------------------------------------
