{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript-language-server
    gcc
    xclip
    (
      let
        init = ''
          -- init
          -- utils
          local fn = vim.fn
          local cmd = vim.cmd
          local com = vim.api.nvim_command
          local g = vim.g
          local vim = vim

          local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

          local function opt(scope, key, value)
            scopes[scope][key] = value
            if scope ~= 'o' then scopes['o'][key] = value end
          end

          local function map(mode, lhs, rhs, opts)
            local options = {noremap = true}
            if opts then options = vim.tbl_extend('force', options, opts) end
            vim.api.nvim_set_keymap(mode, lhs, rhs, options)
          end

          -- packages
          local user_install_path = fn.stdpath('data') ..
                                        '/site/pack/user/opt/faerryn/user.nvim/default/default'
          if fn.empty(fn.glob(user_install_path)) > 0 then
            os.execute(
                [[git clone --depth 1 https://github.com/faerryn/user.nvim.git ']] ..
                    user_install_path .. [[']])
          end
          com('packadd faerryn/user.nvim/default/default')

          local user = require 'user'
          user.setup()
          local use = user.use

          use 'faerryn/user.nvim'

          -- navigation
          use {
            'tpope/vim-vinegar',
            init = function()
              g.netrw_altfile = 1
              g.netrw_preview = 1
              g.netrw_altv = 1
              g.netrw_alto = 0
              g.netrw_use_errorwindow = 0
              g.netrw_localcopydircmd = 'cp -r'
            end,
            config = function()
              cmd 'autocmd FileType netrw nmap <buffer><silent> <right> <cr>'
              cmd 'autocmd FileType netrw nmap <buffer><silent> <left> -'
              cmd 'autocmd FileType netrw nmap <buffer> <c-x> mfmx'
            end
          }

          use 'vijaymarupudi/nvim-fzf'
          use {
            'ibhagwan/fzf-lua',
            after = 'vijaymarupudi/nvim-fzf',
            config = function()
              require'fzf-lua'.setup {
                winopts = {
                  win_height       = 0.5,
                  win_width        = 0.75,
                  win_row          = 1.00,
                  win_col          = 0.50,
                  window_on_create = function()
                    vim.cmd("set winhl=Normal:Normal")
                  end,
                },
                previewers = {
                  bat = {
                    cmd            = "bat",
                    args           = "--italic-text=always --style=numbers,changes --color always",
                    theme          = 'Nord',
                    config         = ""
                  }
                },
                files = {
                  prompt           = 'Files❯ ',
                  cmd              = 'fd --type f --hidden --follow --exclude .git --exclude plugged',
                },
                grep = {
                  prompt           = 'Rg❯ ',
                  input_prompt     = 'Grep For❯ ',
                  cmd              = "rg --vimgrep"
                },
              }
              cmd([[nnoremap <c-p> <cmd>lua require('fzf-lua').files()<CR>]])
              cmd([[nnoremap <bs> <cmd>lua require('fzf-lua').buffers()<CR>]])
              cmd([[command! -nargs=* His lua require('fzf-lua').oldfiles()<CR>]])
              cmd([[command! -nargs=* Branches lua require('fzf-lua').git_branches()<CR>]])
              cmd([[command! -nargs=* Commits lua require('fzf-lua').git_commits()<CR>]])
              cmd([[command! -nargs=* Bcommits lua require('fzf-lua').git_bcommits()<CR>]])
              cmd([[command! -nargs=* CA lua require('fzf-lua').lsp_code_actions()<CR>]])
              cmd([[command! -nargs=* QF lua require('fzf-lua').quickfix()<CR>]])
              cmd([[nnoremap <leader>g <cmd>lua require('fzf-lua').grep()<CR>]])
              cmd([[command! -nargs=* Rg lua require('fzf-lua').live_grep()<CR>]])
              cmd([[command! -nargs=* Rgv lua require('fzf-lua').grep_visual()<CR>]])
            end
          }

          -- completion
          use {
            'nvim-lua/completion-nvim',
            config = function()
              vim.g.completion_enable_in_comment    = 1
              vim.g.completion_auto_change_source   = 1
              vim.g.completion_trigger_keyword_length = 2
              map('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {expr = true})
              map('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {expr = true})
              cmd('autocmd BufEnter * lua require"completion".on_attach()')
              vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
            end
          }

          -- lint
          use {
            'dense-analysis/ale',
            config = function()
              g.ale_disable_lsp = 1
              g.ale_sign_error = '• '
              g.ale_sign_warning = '• '
              g.ale_set_highlights = 0
              g.ale_lint_on_text_changed = 'normal'
              g.ale_lint_on_insert_leave = 1
              g.ale_lint_delay = 0
              g.ale_echo_msg_format = '%s'
              map('n', '[a', '<Plug>(ale_previous_wrap)', {noremap = false})
              map('n', ']a', '<Plug>(ale_next_wrap)', {noremap = false})
              g.ale_fixers = {
                css = 'prettier',
                javascript = 'eslint',
                typescript = 'tslint',
                json = 'prettier',
                scss = 'prettier',
                yml = 'prettier',
                html = 'eslint',
                rust = 'rustfmt'
              }
            end
          }
          use 'nathunsmitty/nvim-ale-diagnostic'

          -- lsp
          use {
            'neovim/nvim-lspconfig',
            config = function()
              local lspconfig = require('lspconfig')
              local on_attach = function()
                require('nvim-ale-diagnostic')
                vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
                                                                          vim.lsp
                                                                              .diagnostic
                                                                              .on_publish_diagnostics,
                                                                          {
                      underline = false,
                      virtual_text = false,
                      signs = true,
                      update_in_insert = false
                    })
                map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
                map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
                map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
                map('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
                map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
                map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
                fn.sign_define('LspDiagnosticsSignError', {text = '•'})
                fn.sign_define('LspDiagnosticsSignWarning', {text = '•'})
                fn.sign_define('LspDiagnosticsSignInformation', {text = '•'})
                fn.sign_define('LspDiagnosticsSignHint', {text = '•'})
              end
              lspconfig.tsserver.setup {on_attach = on_attach}
            end
          }

          -- syntax
          use {
            'nvim-treesitter/nvim-treesitter',
            config = function()
              local ts_config = require('nvim-treesitter.configs')
              ts_config.setup {
                ensure_installed = {
                  'javascript', 'typescript', 'jsdoc', 'json', 'html', 'css', 'bash',
                  'lua', 'nix'
                },
                highlight = {enable = true, use_languagetree = true}
              }
            end
          }
          use 'maxmellon/vim-jsx-pretty'
          use 'yuezk/vim-js'
          use 'LnL7/vim-nix'

          -- formatter
          use {
            'mhartington/formatter.nvim',
            after = 'basilgood/barow',
            config = function()
              require('formatter').setup({
                logging = false,
                filetype = {
                  javascript = {
                    -- prettier
                    function()
                      return {
                        exe = 'prettier',
                        args = {
                          '--stdin-filepath', vim.api.nvim_buf_get_name(0),
                          '--single-quote', '--trailing-comma', 'none', '--arrow-parens',
                          'avoid'
                        },
                        stdin = true
                      }
                    end
                  },
                  nix = {
                    -- nixpkgs-fmt
                    function() return {exe = 'nixpkgs-fmt', stdin = true} end
                  },
                  lua = {
                    -- luafmt
                    function()
                      return {
                        exe = 'lua-format',
                        args = {
                          '--indent-width', 2, '--tab-width', 2,
                          '--double-quote-to-single-quote'
                        },
                        stdin = true
                      }
                    end
                  }
                }
              })
            end
          }

          -- terminal
          use {
            "numtostr/FTerm.nvim",
            config = function()
              require("FTerm").setup({border = 'single'})
              cmd([[nnoremap <C-\> <CMD>lua require("FTerm").toggle()<CR>]])
              cmd([[tnoremap <C-\> <C-\><C-n><CMD>lua require("FTerm").toggle()<CR>]])
            end
          }

          -- git
          use {
            'tpope/vim-fugitive',
            config = function()
              cmd 'nnoremap <leader><leader> :G'
              cmd 'autocmd FileType fugitive nnoremap <buffer> qp :G push<cr>'
              cmd 'autocmd FileType fugitive nnoremap <buffer> qf :G push -f<cr>'
            end
          }
          use {
            'airblade/vim-gitgutter',
            config = function()
              g.gitgutter_sign_priority = 8
              g.gitgutter_override_sign_column_highlight = 0
              map('n', 'ghs', '<Plug>(GitGutterStageHunk)', {noremap = false})
              map('n', 'ghu', '<Plug>(GitGutterUndoHunk)', {noremap = false})
              map('n', 'ghp', '<Plug>(GitGutterPreviewHunk)', {noremap = false})
            end
          }
          use 'gotchane/vim-git-commit-prefix'
          use 'hotwatermorning/auto-git-diff'
          use 'whiteinge/diffconflicts'
          use 'junegunn/gv.vim'

          -- misc
          use 'editorconfig/editorconfig-vim'
          use {
            'basilgood/vim-system-copy',
            config = function()
              cmd 'let g:system_copy#copy_command="xclip -sel clipboard"'
              cmd 'let g:system_copy#paste_command="xclip -sel clipboard -o"'
            end
          }
          use {
            'kevinhwang91/nvim-bqf',
            config = function()
              require 'bqf'.setup({
                preview = {
                  auto_preview = false,
                },
              })
            end
          }
          use 'wellle/targets.vim'
          use 'michaeljsmith/vim-indent-object'
          use 'tpope/vim-surround'
          use 'tpope/vim-repeat'
          use {
            'terrortylor/nvim-comment',
            config = function() require('nvim_comment').setup({comment_empty = false}) end
          }
          use 'pgdouyon/vim-evanesco'
          use 'sgur/cmdline-completion'
          use {
            'antoinemadec/FixCursorHold.nvim',
            init = function() g.cursorhold_updatetime = 100 end
          }
          use {
            'mbbill/undotree',
            config = function()
              g.undotree_WindowLayout = 4
              g.undotree_SetFocusWhenToggle = 1
              g.undotree_ShortIndicators = 1
            end
          }
          use {
            'romgrk/winteract.vim',
            config = function() map('n', 'gw', '<cmd>InteractiveWindow<CR>') end
          }
          use {
            'mileszs/ack.vim',
            config = function()
              g.ackprg = 'rg --vimgrep'
              g.ackhighlight = 1
              map('c', 'Ack', 'Ack!')
            end
          }
          use {
            'norcalli/nvim-colorizer.lua',
            init = function() cmd 'set termguicolors' end,
            config = function() require'colorizer'.setup() end
          }

          -- theme and statusline
          use 'norcalli/nvim.lua'
          use {
            'norcalli/nvim-base16.lua',
            config = function()
              nvim = require 'nvim'
              local base16 = require 'base16'
              base16(base16.themes[nvim.env.BASE16_THEME or "ia-dark"], true)
            end
          }
          use {'basilgood/barow'}

          user.startup()

          -- options
          vim.opt.path:append(".,**")
          vim.opt.swapfile = false
          vim.opt.undofile = true
          vim.opt.writebackup = false
          vim.opt.autowrite = true
          vim.opt.autowriteall = true
          vim.opt.number = true
          vim.opt.termguicolors = true
          vim.opt.lazyredraw = true
          vim.opt.gdefault = true
          vim.opt.tabstop = 2
          vim.opt.softtabstop = 2
          vim.opt.shiftwidth = 2
          vim.opt.shiftround = true
          vim.opt.expandtab = true
          vim.opt.smartindent = true
          vim.opt.wrap = false
          vim.opt.linebreak = true
          vim.opt.breakindent = true
          vim.opt.breakindentopt = 'shift:2'
          vim.opt.number = true
          vim.opt.mouse = 'a'
          vim.opt.incsearch = true
          vim.opt.hlsearch = true
          vim.opt.completeopt = 'noinsert,menuone,noselect'
          vim.opt.shortmess:append('aoOTIcF')
          vim.opt.showmode = false
          vim.opt.sidescroll = 1
          vim.opt.sidescrolloff = 5
          vim.opt.splitbelow = true
          vim.opt.splitright = true
          vim.opt.inccommand = 'nosplit'
          vim.opt.confirm = true
          vim.opt.pumheight = 10
          vim.opt.updatetime = 50
          vim.opt.ttimeoutlen = 0
          vim.opt.timeoutlen = 2000
          vim.opt.wildcharm = 9
          vim.opt.wildmode = 'longest:full,full'
          vim.opt.wildignorecase = true
          vim.opt.wildignore = '*/.git,*/node_modules,'
          vim.opt.diffopt = 'internal,filler,closeoff,context:3,algorithm:patience,indent-heuristic'
          vim.opt.list = true
          vim.opt.listchars = 'tab:┊ ,trail:•,nbsp:␣,extends:↦,precedes:↤'
          -- opt('o', 'statusline', table.concat({
          --   ' %t ', '%m', '%=', '%{&filetype} ', '%2c:%l/%L '
          -- }))

          -- mappings
          -- wrap
          cmd 'noremap j gj'
          cmd 'noremap k gk'
          cmd 'noremap <Down> gj'
          cmd 'noremap <Up> gk'
          -- redline
          cmd 'cnoremap <C-a> <Home>'
          cmd 'cnoremap <C-e> <End>'
          cmd 'inoremap <C-a> <Home>'
          cmd 'inoremap <C-e> <End>'
          -- paragraph
          cmd 'nnoremap } }zz'
          cmd 'nnoremap { {zz'
          -- c-g improved
          cmd([[nnoremap <silent> <C-g> :echon '['.expand("%:p:~").']'.' [L:'.line('$').']'<Bar>echon ' ['system("git rev-parse --abbrev-ref HEAD 2>/dev/null \| tr -d '\n'")']'<CR>]])
          -- reload syntax and nohl
          cmd([[nnoremap <silent><expr> <C-l> empty(get(b:, 'current_syntax')) ? "\<C-l>" : "\<C-l>:syntax sync fromstart\<cr>:nohlsearch<cr>"]])
          -- objects
          map('x', 'I', [[mode()=~#'[vV]'?'<C-v>^o^I':'I']], {expr = true})
          map('x', 'A', [[mode()=~#'[vV]'?'<C-v>0o$A':'A']], {expr = true})
          map('v', 'il', [[<Esc>^vg_]], {silent = true})
          map('o', 'il', [[:<C-U>normal! ^vg_<cr>]])
          map('v', 'ie', 'gg0oG$')
          -- paste from change
          map('v', 'P', '"0p')
          -- search and replace
          cmd 'nmap sn *cgn'
          -- execute macro
          map('n', 'Q', '@q')
          map('v', 'Q', [[:norm Q<cr>]])
          -- copy/move from cmdline
          map('c', '<c-x>t', [[<CR>:t'''<CR>]])
          map('c', '<c-x>m', [[<CR>:m'''<CR>]])
          map('c', '<c-x>d', [[<CR>:d<CR>``]])

          -- autocommands
          cmd 'autocmd TextYankPost * lua vim.highlight.on_yank {higroup = "Search", timeout = 300}'
          cmd([[autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$")]] ..
          [[&& &ft !~# 'commit' | exe "normal! g`\"" | endif]])
          cmd 'autocmd FileType qf wincmd J'
          cmd 'autocmd BufWinEnter * if &ft == "help" | wincmd J | end'
          cmd 'autocmd InsertLeave * if &l:diff | diffupdate | endif'
          cmd 'autocmd BufWritePre * if !isdirectory(expand("%:h", v:true)) | call mkdir(expand("%:h", v:true), "p") | endif'
          cmd 'autocmd! VimResume, CursorHold * checktime'
          cmd 'autocmd! VimResume, CursorHold * if exists("g:loaded_gitgutter") | call gitgutter#all(1) | endif'
          cmd 'autocmd BufNewFile,BufRead config setlocal filetype=config'
          cmd 'autocmd BufWinEnter *.json setlocal conceallevel=0 concealcursor='
          cmd 'autocmd BufReadPre *.json setlocal conceallevel=0 concealcursor='
          cmd 'autocmd BufReadPre *.json setlocal formatoptions='
          cmd 'autocmd FileType git setlocal nofoldenable'
          cmd 'autocmd FileType gitcommit setlocal spell | setlocal textwidth=72 | setlocal colorcolumn=+1'
          cmd 'autocmd TermOpen * setlocal nonumber norelativenumber'
          cmd 'autocmd TermOpen * if &buftype ==# "terminal" | startinsert | endif'
          cmd 'autocmd BufLeave term://* stopinsert'
          cmd [[autocmd TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif]]
          cmd 'autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif'

          -- sessions
          if fn.empty(fn.glob('~/.cache/sessions')) > 0 then
          os.execute 'mkdir -p ~/.cache/sessions'
          end
          cmd 'autocmd! VimLeavePre * execute "mksession! ~/.cache/sessions/" . split(getcwd(), "/")[-1] . ".vim"'
          com(
          [[command! -nargs=0 SS :execute 'source ~/.cache/sessions/' .  split(getcwd(), '/')[-1] . '.vim']])

          --- commands
          com([[command! -nargs=0 BO silent! execute "%bd|e#|bd#"]])
          com([[command BD bp | bd #]])
          com([[command! -nargs=0 WS %s/\s\+$// | normal! ``]])
          com([[command! -nargs=0 WT %s/[^\t]\zs\t\+/ / | normal! ``]])
          com([[command! -bar HL echo synIDattr(synID(line('.'),col('.'),0),'name')]] ..
          [[synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')]])
          com([[command! WW w !sudo tee % > /dev/null]])

          -- clean packages
          cmd 'autocmd VimLeavePre * lua require"user".clean()'

          vim.o.exrc = true
          vim.o.secure = true
        '';
      in
      symlinkJoin {
        name = "nvim-with-config";
        buildInputs = [ makeWrapper ];
        paths = [ neovim-unwrapped ];
        postBuild = ''
          wrapProgram "$out/bin/nvim" \
          --add-flags "-u ${writeText "init.lua" init}"
        '';
      }
    )
  ];
}
