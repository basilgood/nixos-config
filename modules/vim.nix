{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodePackages.stylelint
    vim-vint
    shfmt
    (
      let
        vimrc = ''
          " vint: -ProhibitSetNoCompatible
          if &compatible
            set nocompatible
          endif

          if &encoding !=? 'utf-8'
            let &termencoding = &encoding
            setglobal encoding=utf-8
          endif
          scriptencoding utf-8

          let g:loaded_rrhelper = 1
          let g:did_install_default_menus = 1
          let g:sh_noisk = 1

          augroup vimRc
            autocmd!
          augroup END

          if empty(glob('~/.vim/autoload/plugpac.vim'))
            silent !curl -fLo ~/.vim/autoload/plugpac.vim --create-dirs https://raw.githubusercontent.com/bennyyip/plugpac.vim/master/plugpac.vim
            silent !git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
            autocmd VimEnter * PackInstall
          endif

          call plugpac#begin()
            Pack 'k-takata/minpac', {'type': 'opt'}

            Pack 'tpope/vim-vinegar', {'type': 'opt'}
              packadd! vim-vinegar
              let g:netrw_altfile = 1
              let g:netrw_preview = 1
              let g:netrw_altv = 1
              let g:netrw_alto = 0
              let g:netrw_use_errorwindow = 0
              let g:netrw_localcopydircmd = 'cp -r'
              let g:netrw_list_hide = '^\.\.\=/\=$'
              function! s:innetrw() abort
                nmap <buffer><silent> <right> <cr>
                nmap <buffer><silent> <left> -
                nmap <buffer> <c-x> mfmx
              endfunction
              autocmd vimRc FileType netrw call s:innetrw()

            Pack 'junegunn/fzf'
            Pack 'junegunn/fzf.vim'
              let $FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude plugged'
              let $FZF_PREVIEW_COMMAND = 'bat --color=always --style=plain -n -- {} || cat {}'
              let g:fzf_layout = {'window': { 'width': 0.7, 'height': 0.4,'yoffset':0.85,'xoffset': 0.5 } }
              nnoremap <c-p> :Files<cr>
              nnoremap <bs> :Buffers<cr>

            Pack 'dense-analysis/ale', {'type': 'opt'}
              let g:ale_completion_enabled = 1
              packadd ale
                " let g:ale_disable_lsp = 0
                let g:ale_sign_error = '• '
                let g:ale_sign_warning = '• '
                let g:ale_set_highlights = 0
                let g:ale_lint_on_text_changed = 'normal'
                let g:ale_lint_on_insert_leave = 1
                let g:ale_lint_delay = 0
                nmap <silent> [a <Plug>(ale_previous)
                nmap <silent> ]a <Plug>(ale_next)
                let g:ale_fixers = {
                    \   'javascript': ['eslint'],
                    \   'typescript': ['eslint'],
                    \   'css': ['stylelint'],
                    \   'json': ['fixjson'],
                    \   'sh': ['shfmt'],
                    \ }

            Pack 'prabirshrestha/vim-lsp'
            Pack 'rhysd/vim-lsp-ale'
              function! s:setup_lsp() abort
                if executable('typescript-language-server')
                  call lsp#register_server({
                      \ 'name': 'tyepscript-language-server',
                      \ 'cmd': { server_info -> ['typescript-language-server', '--stdio'] },
                      \ 'allowlist': ['javascript', 'typescript']
                      \ })
                endif
              endfunction

              autocmd vimRc User lsp_setup call s:setup_lsp()
              setlocal omnifunc=lsp#complete

            Pack 'maralla/completor.vim', { 'branch': 'lsp_more' }
              let g:completor_completion_delay = 200
              inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
              inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
              inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
              let g:completor_css_omni_trigger = '([\w-]+|@[\w-]*|[\w-]+:\s*[\w-]*)$'
              let g:completor_scss_omni_trigger = '([\w-]+|@[\w-]*|[\w-]+:\s*[\w-]*)$'

            Pack 'yuezk/vim-js'
            Pack 'maxmellon/vim-jsx-pretty'
            Pack 'LnL7/vim-nix', { 'for': 'nix' }

            " git
            Pack 'tpope/vim-fugitive'
            Pack 'airblade/vim-gitgutter'
              let g:gitgutter_sign_priority = 8
              let g:gitgutter_override_sign_column_highlight = 0
              nmap ghs <Plug>(GitGutterStageHunk)
              nmap ghu <Plug>(GitGutterUndoHunk)
              nmap ghp <Plug>(GitGutterPreviewHunk)
            Pack 'tpope/vim-rhubarb', {'type': 'opt'}
            Pack 'gotchane/vim-git-commit-prefix', {'type': 'opt'}
            Pack 'whiteinge/diffconflicts', {'for': 'gitcommit'}
            Pack 'hotwatermorning/auto-git-diff', {'for': 'gitrebase'}

            "misc
            Pack 'editorconfig/editorconfig-vim'
            Pack 'wellle/targets.vim', {'type': 'opt'}
            Pack 'haya14busa/is.vim', {'type': 'opt'}
            Pack 'haya14busa/vim-asterisk', {'type': 'opt'}
              map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
              map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
              map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
              map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
            Pack 'tpope/vim-commentary', {'type': 'opt'}
            Pack 'suy/vim-context-commentstring', {'type': 'opt'}
            Pack 'tpope/vim-surround', {'type': 'opt'}
            Pack 'tpope/vim-repeat', {'type': 'opt'}
            Pack 'markonm/traces.vim', {'type': 'opt'}
            Pack 'itchyny/vim-qfedit', { 'for': 'qf' }
            Pack 'AndrewRadev/quickpeek.vim', { 'for': 'qf' }
              autocmd vimRc FileType qf nnoremap <buffer> gp :QuickpeekToggle<cr>
            Pack 'lambdalisue/edita.vim'
            Pack 'fcpg/vim-altscreen'
            Pack 'basilgood/vim-system-copy', {'type': 'opt'}
              let g:system_copy#copy_command='xclip -sel clipboard'
              let g:system_copy#paste_command='xclip -sel clipboard -o'
            Pack 'vim-scripts/cmdline-completion', {'type': 'opt'}
            Pack 'mbbill/undotree', {'type': 'opt'}
              let g:undotree_WindowLayout = 4
              let g:undotree_SetFocusWhenToggle = 1
              let g:undotree_ShortIndicators = 1
            Pack 'michaeljsmith/vim-indent-object', {'type': 'opt'}
            Pack 'markonm/hlyank.vim', { 'rev': '39e52017f53344a4fbdac00a9153a8ca32017f43' }

            Pack 'basilgood/pansy', {'type': 'opt'}
          call plugpac#end()

          filetype plugin indent on

          " options
          let &t_SI.="\e[6 q"
          let &t_SR.="\e[4 q"
          let &t_EI.="\e[2 q"

          set path+=**
          set autoread autowrite autowriteall
          set noswapfile
          set nowritebackup
          set undofile undodir=/tmp//,.
          set nostartofline
          set nojoinspaces
          set nofoldenable
          set nowrap
          set breakindent breakindentopt=shift:4,sbr
          set noshowmode
          set number
          set relativenumber
          set mouse=a ttymouse=sgr
          set splitright splitbelow
          set virtualedit=onemore
          set scrolloff=0 sidescrolloff=10 sidescroll=1
          set sessionoptions-=options
          set sessionoptions-=blank
          set sessionoptions-=help
          set lazyredraw
          set ttimeout timeoutlen=2000 ttimeoutlen=50
          set updatetime=50
          set incsearch hlsearch
          set gdefault
          set completeopt-=preview
          set completeopt+=menuone,noselect,noinsert
          " setg omnifunc=syntaxcomplete#Complete
          " setg completefunc=syntaxcomplete#Complete
          set pumheight=10
          set diffopt+=context:3,indent-heuristic,algorithm:patience
          set list
          set listchars=tab:⇥\ ,trail:•,nbsp:␣,extends:↦,precedes:↤
          autocmd vimRc InsertEnter * set listchars-=trail:•
          autocmd vimRc InsertLeave * set listchars+=trail:•
          set confirm
          set shortmess+=sIcaF
          set shortmess-=S
          set autoindent smartindent
          set expandtab
          set tabstop=2
          set softtabstop=2
          set shiftwidth=2
          set shiftround
          set history=1000
          set wildmenu
          set wildmode=list,full
          set wildignorecase
          set wildcharm=<C-Z>
          set backspace=indent,eol,start
          set laststatus=2
          set statusline=%<%.99f\ %y%h%w%m%r%=%-14.(%l,%c%V%)\ %L

          " mappings
          " wrap
          noremap j gj
          noremap k gk
          noremap <Down> gj
          noremap <Up> gk
          "redline
          cnoremap <C-a> <Home>
          cnoremap <C-e> <End>
          inoremap <C-a> <Home>
          inoremap <C-e> <End>
          " paragraph
          nnoremap } }zz
          nnoremap { {zz
          " relativenumber
          nnoremap <silent> <expr> <c-n> &relativenumber ? ':windo set norelativenumber<cr>' : ':windo set relativenumber<cr>'
          " close qf
          nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>
          " objects
          xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
          xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')
          xnoremap <silent> il <Esc>^vg_
          onoremap <silent> il :<C-U>normal! ^vg_<cr>
          xnoremap <silent> ie gg0oG$
          onoremap <silent> ie :<C-U>execute "normal! m`"<Bar>keepjumps normal! ggVG<cr>
          " Paste continuously.
          nnoremap ]p viw"0p
          vnoremap ]p "0p
          " substitute.
          nnoremap ss :%s/
          nnoremap sl :s/
          xnoremap ss :s/
          nnoremap sp vip:s/
          " nnoremap sn z*cgn
          nmap sn *cgn
          " c-g improved
          nnoremap <silent> <C-g> :echon '['.expand("%:p:~").']'.' [L:'.line('$').']'<Bar>echon ' ['system("git rev-parse --abbrev-ref HEAD 2>/dev/null \| tr -d '\n'")']'<CR>
          " reload syntax and nohl
          nnoremap <silent><expr> <C-l> empty(get(b:, 'current_syntax'))
                \ ? "\<C-l>"
                \ : "\<C-l>:syntax sync fromstart\<cr>:nohlsearch<cr>"
          " execute macro
          nnoremap Q <Nop>
          nnoremap Q @q
          " run macro on selected lines
          vnoremap Q :norm Q<cr>
          " jump to window no
          for i in range(1, 9)
            execute 'nnoremap <silent> <space>'.i.' :'.i.'wincmd w<CR>'
          endfor
          execute 'nnoremap <silent> <space>0 :wincmd p<CR>'
          " jumping
          function! Listjump(list_type, direction, wrap) abort
            try
              exe a:list_type . a:direction
            catch /E553/
              exe a:list_type . a:wrap
            catch /E42/
              return
            catch /E163/
              return
            endtry
            normal! zz
          endfunction
          nnoremap <silent> ]q :call Listjump("c", "next", "first")<CR>
          nnoremap <silent> [q :call Listjump("c", "previous", "last")<CR>
          nnoremap <silent> ]l :call Listjump("l", "next", "first")<CR>
          nnoremap <silent> [l :call Listjump("l", "previous", "last")<CR>

          " range commands
          cnoremap <c-x>t <CR>:t'''<CR>
          cnoremap <c-x>m <CR>:m'''<CR>
          cnoremap <c-x>d <CR>:d<CR>``

          " autocmds
          " keep cursor position
          autocmd vimRc BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif

          " format
          autocmd vimRc BufRead,BufNewFile *.nix command! FM silent call system('nixpkgs-fmt ' . expand('%'))
          autocmd vimRc BufRead,BufNewFile *.js,*.jsx,*.ts,*.tsx command! FM silent call system('prettier --single-quote --trailing-comma none --arrow-parens avoid --print-width 160 --parser typescript --no-bracket-spacing true --write' . expand('%'))
          autocmd vimRc BufRead,BufNewFile *.js,*.jsx command! Fix silent call system('eslint --fix ' . expand('%'))
          autocmd vimRc FileType yaml command! FM silent call system('prettier --write ' . expand('%'))
          autocmd vimRc FileType sh command! FM silent call system('shfmt -i 2 -ci -w ' . expand('%'))

          " relativenumbers
          autocmd vimRc FileType qf setlocal norelativenumber

          " help keep widow full width
          autocmd vimRc FileType qf wincmd J
          autocmd vimRc BufWinEnter * if &ft == 'help' | wincmd J | end

          " update diff / disable paste
          autocmd vimRc InsertLeave * if &diff | diffupdate | endif
          autocmd vimRc InsertLeave * if &paste | setlocal nopaste | echo 'nopaste' | endif

          " external changes
          autocmd vimRc FocusGained,CursorHold *
                \ if !bufexists("[Command Line]") |
                \ checktime |
                \ if exists('g:loaded_gitgutter') |
                \   call gitgutter#all(1) |
                \ endif

          " mkdir
          autocmd vimRc BufWritePre *
                \ if !isdirectory(expand('%:h', v:true)) |
                \   call mkdir(expand('%:h', v:true), 'p') |
                \ endif

          " filetypes
          let g:markdown_fenced_languages = ['vim', 'ruby', 'html', 'javascript', 'css', 'bash=sh', 'sh']
          autocmd vimRc BufReadPre *.md,*.markdown setlocal conceallevel=2 concealcursor=n
          autocmd vimRc FileType javascript setlocal formatoptions-=c formatoptions-=r formatoptions-=o
          autocmd vimRc BufNewFile,BufRead *.gitignore setfiletype gitignore
          autocmd vimRc BufNewFile,BufRead *config      setfiletype config
          autocmd vimRc BufNewFile,BufRead *.lock      setfiletype config
          autocmd vimRc BufNewFile,BufRead *.babelrc    setfiletype json
          autocmd vimRc BufNewFile,BufRead *.txt       setfiletype markdown
          autocmd vimRc BufReadPre *.json  setlocal conceallevel=0 concealcursor=
          autocmd vimRc BufReadPre *.json  setlocal formatoptions=
          autocmd vimRc FileType git       setlocal nofoldenable

          " commands
          command! -nargs=0 BO silent! execute "%bd|e#|bd#"
          command BD bp | bd #
          command! -nargs=0 WS %s/\s\+$// | normal! ``
          command! -nargs=0 WT %s/[^\t]\zs\t\+/ / | normal! ``
          command! WW w !sudo tee % > /dev/null
          command! -bar HL echo
                \ synIDattr(synID(line('.'),col('.'),0),'name')
                \ synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')

          " sessions
          if empty(glob('~/.cache/vim/sessions')) > 0
            call mkdir(expand('~/.cache/vim/sessions'), 'p')
          end
          autocmd! vimRc VimLeavePre * execute "mksession! ~/.cache/vim/sessions/" . split(getcwd(), "/")[-1] . ".vim"
          command! -nargs=0 SS :execute 'source ~/.cache/vim/sessions/' .  split(getcwd(), '/')[-1] . '.vim'

          function! Grep(...)
            let l:output = system("rg --vimgrep ".join(a:000, " "))
            let l:list = split(l:output, "\n")
            let l:ql = []
            for l:item in l:list
              let sit = split(l:item, ":")
              call add(l:ql,
                  \ {"filename": sit[0], "lnum": sit[1], "col": sit[2], "text": sit[3]})
            endfor
            call setqflist(l:ql, 'r')
            echo 'Grep results: '.len(l:ql)
          endfunction
          command! -nargs=* -complete=file Grep call Grep(<q-args>)
          cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

          " plugs config
          packadd! vim-rhubarb
          packadd! vim-git-commit-prefix
          packadd! diffconflicts
          packadd! auto-git-diff
          packadd! targets.vim
          packadd! is.vim
          packadd! vim-asterisk
          packadd! vim-context-commentstring
          packadd! vim-commentary
          packadd! vim-surround
          packadd! vim-repeat
          packadd! traces.vim
          packadd! vim-system-copy
          packadd! cmdline-completion
          packadd! undotree
          packadd! vim-indent-object

          syntax enable

          set termguicolors
          colorscheme pansy

          set secure
        '';
      in
      symlinkJoin {
        name = "vim-with-config";
        buildInputs = [ makeWrapper ];
        paths = [ (vim_configurable.override { python = python3; }) ];
        postBuild = ''
          wrapProgram "$out/bin/vim" \
          --add-flags "-u ${writeText "vimrc" vimrc}"
        '';
      }
    )
  ];
}
