" Watson's vimrc
set encoding=utf-8
scriptencoding utf-8

"---------------------------
" 一般設定
"---------------------------

" 想定される改行コード
set fileformats=unix,dos,mac

" 行番号を表示
set number

" 行端で折り返し
set wrap

" 上下8行の視界を確保
set scrolloff=8

" 行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]

" タブを表示するときの幅
set tabstop=2

" タブを挿入するときの幅
set shiftwidth=2

" タブをスペースに展開
set expandtab

" 前の行と同じインデント
set autoindent

" クリップボードにコピー
set clipboard+=unnamed

" マウスの入力を受け付ける
set mouse=a

" ヒープ音の無効化
set visualbell t_vb=
set noerrorbells

" ファイル形式の検出の有効化
filetype plugin indent on

" カラー設定
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid
syntax on

" ステータスラインの表示
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 

"---------------------------
" 検索設定
"---------------------------

" 検索ワードをハイライト（<ESC> 2回押しで解除）
set hlsearch
nnoremap <ESC><ESC> :nohlsearch<CR>

" 大文字と小文字が混在するときのみ区別
set ignorecase
set smartcase

" ループ検索
set wrapscan

"---------------------------
" コマンドライン設定
"---------------------------

" TABキーによるファイル名補完を有効化
set wildmenu wildmode=list:longest,full

" 履歴を10000件保存する
set history=10000

"---------------------------
" 括弧類補完
"---------------------------

inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap <> <><LEFT>
inoremap {<Enter> {}<Left><CR><ESC><S-o><Tab>
inoremap [<Enter> []<Left><CR><ESC><S-o><Tab>
inoremap (<Enter> ()<Left><CR><ESC><S-o><Tab>

"---------------------------
" キーマッピング設定
"---------------------------

" 折り返しテキスト対策
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" 行末に ;
nnoremap <Space>; A;<Esc>

" .vimrc 関連（いずれ現在編集ファイルが .vimrc なら :source するように拡張）
nnoremap <Space>. :edit $MYVIMRC<CR>

" 使わない危険コマンドを潰す
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

"---------------------------
" テンプレート
"---------------------------

autocmd BufNewFile *.cpp 0r ~/.vim/template/cpp.txt

"---------------------------
" Neobundle関連
"---------------------------

filetype plugin indent off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
  call neobundle#end()
endif 

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vinarise'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'

NeoBundle 'szw/vim-tags'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'kana/vim-submode'
NeoBundle 'wlangstroth/vim-racket'
NeoBundle 'haya14busa/incsearch.vim'
"NeoBundleLazy 'supermomonga/neocomplete-rsense.vim', { 'autoload' : {
"  \ 'insert' : 1,
"  \ 'filetypes': 'ruby',
"  \ }}
NeoBundleCheck
call neobundle#end()

filetype plugin indent on

"---------------------------
" neocomplete設定
"---------------------------

" デフォルトで有効化
let g:neocomplete#enable_at_startup = 1

"---------------------------
" incsearch設定
"---------------------------

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

"---------------------------
" RSense設定（フリーズ頻発）
"---------------------------

" .や::を入力したときにオムニ補完が有効になるようにする
"if !exists('g:neocomplete#force_omni_input_patterns')
"  let g:neocomplete#force_omni_input_patterns = {}
"endif
"let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"
"let g:neocomplete#sources#rsense#home_directory = '/usr/local/bin/rsense'
"let g:rsenseHome = '/usr/local/Cellar/rsense/0.3/libexec'

"---------------------------
" QuickRun設定
"---------------------------

" オプション
let g:quickrun_config = {
	\   "_" : {
	\       "outputter/buffer/split" : ":botright 8sp",
	\       "outputter/buffer/close_on_empty" : 1,
	\		"hook/time/enable": 1,
	\   },
	\}

" 終了設定
nnoremap <Space>o :only<CR>

"---------------------------
" -bオプションでvinarise
"---------------------------

augroup BinaryXXD
	autocmd!
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | Vinarise
	autocmd BufWritePre * if &binary | Vinarise | endif
	autocmd BufWritePost * if &binary | Vinarise 
augroup END

"---------------------------
" その他 追加プラグイン設定
"---------------------------

" 静的解析（保存時に実行）
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }

"---------------------------
" タブ分割設定
"---------------------------

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"---------------------------
" vim script 用設定
"---------------------------

let g:vim_indent_cont = 2
