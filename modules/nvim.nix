{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript-language-server
    nixpkgs-fmt
    yamllint
    vim-vint
    gcc
    xclip
    fd
    ripgrep
    (
      let
        init = ''
          -- packer
          local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'

          if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
            vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
          end

          vim.cmd [[packadd packer.nvim]]

          local use = require('packer').use
          require('packer').startup(function()
            use { 'wbthomason/packer.nvim', opt = true }

            -- navigation
            use {
              'tpope/vim-vinegar',
              event = 'VimEnter',
              config = function()
                vim.g.netrw_altfile = 1
                vim.g.netrw_preview = 1
                vim.g.netrw_altv = 1
                vim.g.netrw_alto = 0
                vim.g.netrw_use_errorwindow = 0
                vim.g.netrw_localcopydircmd = 'cp -r'
                vim.cmd 'autocmd FileType netrw nmap <buffer><silent> <right> <cr>'
                vim.cmd 'autocmd FileType netrw nmap <buffer><silent> <left> -'
                vim.cmd 'autocmd FileType netrw nmap <buffer> <c-x> mfmx'
              end
            }
            use { 'vijaymarupudi/nvim-fzf', event = 'VimEnter' }
            use {
              'ibhagwan/fzf-lua',
              after = 'nvim-fzf',
              config = function()
                require'fzf-lua'.setup {
                  winopts = {
                    win_height       = 0.5,
                    win_width        = 0.75,
                    win_row          = 0.92,
                    win_col          = 0.50,
                  },
                  files = {
                    prompt           = 'Files❯ ',
                    cmd              = 'fd --type f --hidden --follow --exclude .git --exclude plugged',
                  }
                }
                vim.cmd([[nnoremap <c-p> <cmd>lua require('fzf-lua').files()<CR>]])
                vim.cmd([[nnoremap <bs> <cmd>lua require('fzf-lua').buffers()<CR>]])
                vim.cmd([[command! -nargs=* His lua require('fzf-lua').oldfiles()<CR>]])
                vim.cmd([[command! -nargs=* Branches lua require('fzf-lua').git_branches()<CR>]])
                vim.cmd([[command! -nargs=* Commits lua require('fzf-lua').git_commits()<CR>]])
                vim.cmd([[command! -nargs=* Bcommits lua require('fzf-lua').git_bcommits()<CR>]])
                vim.cmd([[command! -nargs=* CA lua require('fzf-lua').lsp_code_actions()<CR>]])
                vim.cmd([[command! -nargs=* QF lua require('fzf-lua').quickfix()<CR>]])
                vim.cmd([[nnoremap <leader>g <cmd>lua require('fzf-lua').grep_cword()<CR>]])
                vim.cmd([[command! -nargs=* Rg lua require('fzf-lua').live_grep()<CR>]])
              end
            }
            use {
              'mileszs/ack.vim',
              setup = function()
                vim.g.ackprg = "rg --vimgrep"
                vim.g.ackhighlight = 1
                vim.cmd[[cnoreabbrev Ack Ack!]]
              end
            }

            -- completion
            use {
              'nvim-lua/completion-nvim',
              event = 'BufReadPre',
              config = function()
                vim.g.completion_enable_in_comment    = 1
                vim.g.completion_auto_change_source   = 1
                vim.g.completion_trigger_keyword_length = 2
                vim.cmd([[inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"]])
                vim.cmd([[inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
                vim.cmd('autocmd BufEnter * lua require"completion".on_attach()')
                vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
              end
            }

            -- lint
            use {
              'dense-analysis/ale',
              event = 'VimEnter',
              config = function()
                vim.g.ale_disable_lsp = 1
                vim.g.ale_sign_error = '• '
                vim.g.ale_sign_warning = '• '
                vim.g.ale_set_highlights = 0
                vim.g.ale_lint_on_text_changed = 'normal'
                vim.g.ale_lint_on_insert_leave = 1
                vim.g.ale_lint_delay = 0
                vim.g.ale_echo_msg_format = '%s'
                vim.cmd [[nmap [a <Plug>(ale_next_wrap)]]
                vim.cmd [[nmap ]a <Plug>(ale_previous_wrap)]]
                vim.g.ale_fixers = {
                  css = 'prettier',
                  javascript = 'eslint',
                  typescript = 'eslint',
                  json = 'prettier',
                  scss = 'prettier',
                  yml = 'prettier',
                  html = 'eslint',
                  rust = 'rustfmt'
                }
              end
            }
            use { 'nathunsmitty/nvim-ale-diagnostic', after = 'ale' }

            -- lsp
            use {
              'neovim/nvim-lspconfig',
              event = 'VimEnter',
              config = function()
                local lspconfig = require('lspconfig')
                local on_attach = function()
                  require('nvim-ale-diagnostic')
                  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
                    vim.lsp.diagnostic.on_publish_diagnostics, {
                      underline = false,
                      virtual_text = false,
                      signs = true,
                      update_in_insert = false
                    }
                  )
                  vim.cmd[[nnoremap gd :lua vim.lsp.buf.definition()<cr>]]
                  vim.cmd[[nnoremap gr :lua vim.lsp.buf.references()<cr>]]
                  vim.cmd[[nnoremap gs :lua vim.lsp.buf.signature_help()<cr>]]
                  vim.cmd[[nnoremap K :lua vim.lsp.buf.hover()<cr>]]
                  vim.cmd[[nnoremap ga :lua vim.lsp.buf.code_action()<cr>]]
                  vim.cmd[[nnoremap [d :lua vim.lsp.diagnostic.goto_prev()<cr>]]
                  vim.cmd[[nnoremap ]d :lua vim.lsp.diagnostic.goto_next()<cr>]]
                  vim.fn.sign_define('LspDiagnosticsSignError', {text = '•'})
                  vim.fn.sign_define('LspDiagnosticsSignWarning', {text = '•'})
                  vim.fn.sign_define('LspDiagnosticsSignInformation', {text = '•'})
                  vim.fn.sign_define('LspDiagnosticsSignHint', {text = '•'})
                end
                lspconfig.tsserver.setup {on_attach = on_attach}
              end
            }

            -- syntax
            use {
              'nvim-treesitter/nvim-treesitter',
              branch = '0.5-compat',
              config = function()
              require'nvim-treesitter.configs'.setup {
                  ensure_installed = {
                    'javascript', 'typescript', 'jsdoc', 'json', 'html', 'css', 'bash',
                    'lua', 'nix'
                  },
                  highlight = {enable = true},
                  indent = {enable = true}
                }
              end
            }
            use 'maxmellon/vim-jsx-pretty'
            use 'yuezk/vim-js'
            use { 'LnL7/vim-nix', ft = 'nix' }

            -- formatter
            use {
              'lukas-reineke/format.nvim',
              event = 'BufReadPre',
              config = function()
                require "format".setup {
                  ["*"] = {
                    {cmd = {"sed -i 's/[ \t]*$//'"}} -- remove trailing whitespace
                  },
                  javascript = {
                    {cmd = {"prettier --single-quote --trailing-comma none --arrow-parens avoid --print-width 160 --parser typescript --no-bracket-spacing true --write", "./node_modules/.bin/eslint --fix"}}
                  },
                  nix = {
                    {cmd = {"nixpkgs-fmt"}}
                  }
                }
              end
            }

            -- git
            use {
              'tpope/vim-fugitive',
              event = 'VimEnter'
            }
            use {
              'airblade/vim-gitgutter',
              event = 'VimEnter',
              config = function()
                vim.g.gitgutter_sign_priority = 8
                vim.g.gitgutter_override_sign_column_highlight = 0
                vim.cmd([[nmap ghs <Plug>(GitGutterStageHunk)]])
                vim.cmd([[nmap ghu <Plug>(GitGutterUndoHunk)]])
                vim.cmd([[nmap ghp <Plug>(GitGutterPreviewHunk)]])
              end
            }
            use { 'tpope/vim-rhubarb', event = 'BufReadPre' }
            use { 'gotchane/vim-git-commit-prefix', ft = 'gitcommit' }
            use { 'hotwatermorning/auto-git-diff', ft = 'gitcommit' }
            use { 'whiteinge/diffconflicts', event = 'BufReadPre' }
            use { 'junegunn/gv.vim', event = 'BufReadPre' }

            -- misc
            use { 'gpanders/editorconfig.nvim', event = 'BufReadPre' }
            use {
              'basilgood/vim-system-copy',
              event = 'BufReadPre',
              setup = 'vim.g.system_copy_use_default_mappings = 0',
              config = function()
                vim.cmd 'let g:system_copy#copy_command="xclip -sel clipboard"'
                vim.cmd 'let g:system_copy#paste_command="xclip -sel clipboard -o"'
                vim.cmd 'nmap <space>y <Plug>SystemCopy'
                vim.cmd 'xmap <space>y <Plug>SystemCopy'
                vim.cmd 'nmap <space>Y <Plug>SystemCopyLine'
                vim.cmd 'nmap <space>p <Plug>SystemPaste'
                vim.cmd 'xmap <space>p <Plug>SystemPaste'
                vim.cmd 'nmap <space>P <Plug>SystemPasteLine'
              end
            }
            use {
              'kevinhwang91/nvim-bqf',
              ft = 'qf',
              config = function()
                require 'bqf'.setup({
                  preview = {
                    auto_preview = false,
                  },
                })
              end
            }
            use {
              'ten3roberts/qf.nvim',
              ft = 'qf',
                config = function()
                  require'qf'.setup{}
              end
            }
            use { 'wellle/targets.vim', event = 'BufReadPre' }
            use { 'michaeljsmith/vim-indent-object', event = 'BufReadPre' }
            use { 'tpope/vim-surround', event = 'BufReadPre' }
            use { 'tpope/vim-repeat', event = 'BufReadPre' }
            --use { 'markonm/traces.vim', event = 'BufReadPre' }
            use { 'winston0410/cmd-parser.nvim', event = 'BufReadPre' }
            use {
              'winston0410/range-highlight.nvim',
              after = 'cmd-parser.nvim',
              config = function()
                require"range-highlight".setup{}
              end
            }
            use {
              'haya14busa/vim-edgemotion', event = 'BufReadPre',
              config =
                vim.cmd
                [[
                  map <C-j> <Plug>(edgemotion-j)
                  map <C-k> <Plug>(edgemotion-k)
                ]]
            }
            use {
              'terrortylor/nvim-comment',
              event = 'BufReadPre',
              config = function()
                require('nvim_comment').setup({
                  comment_empty = false,
                  hook = function()
                    require('ts_context_commentstring.internal').update_commentstring()
                  end
                })
              end
            }
            use {
              'JoosepAlviste/nvim-ts-context-commentstring',
              after = 'nvim-comment',
              config = function()
                require'nvim-treesitter.configs'.setup {
                  context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                    config = {
                      nix = '# %s'
                    }
                  }
                }
              end
            }
            use { 'pgdouyon/vim-evanesco', event = 'BufReadPre' }
            use { 'sgur/cmdline-completion', event = 'CmdlineEnter' }
            use { 'antoinemadec/FixCursorHold.nvim' }
            use {
              'mbbill/undotree',
              event = 'BufReadPre',
              config = function()
                vim.g.undotree_WindowLayout = 4
                vim.g.undotree_SetFocusWhenToggle = 1
                vim.g.undotree_ShortIndicators = 1
              end
            }

            -- theme and statusline
            use {
              'hoob3rt/lualine.nvim',
              event = 'VimEnter',
              config = function()
                require('lualine').setup {
                  options = {
                    theme = 'iceberg_dark',
                    section_separators = ''',
                    component_separators = '''
                  },
                  sections = {
                    lualine_a = {'mode'},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                  },
                  inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                  }
                }
              end
            }
            use {
              'seblj/nvim-tabline',
              event = 'BufWinEnter',
              config = function()
                require('tabline').setup{
                  no_name = '[No Name]',
                  modified_icon = '',
                  close_icon = '',
                  separator = "▌",
                  padding = 3,
                  color_all_icons = false,
                  always_show_tabs = false,
                  right_separator = false,
                }
              end
            }
            use {
              'eddyekofo94/gruvbox-flat.nvim',
              event = 'VimEnter',
              config = function()
                vim.g.gruvbox_flat_style = 'hard'
                vim.cmd([[
                  colorscheme gruvbox-flat
                ]])
                -- vim.cmd 'hi! Normal guifg=#B3B1AD guibg=#0A0E14'
                -- vim.cmd 'hi Normal guifg=#abb2bf guibg=#1f2227'
                vim.cmd 'hi! Todo gui=reverse'
                vim.cmd 'hi! TabLineSel guibg=#3e445e'
                vim.cmd 'hi! TabLinePaddingActive guibg=#3e445e'
                vim.cmd 'hi! TabLineCloseActive guibg=#3e445e'
                vim.cmd 'hi! Sneak guibg=NONE guifg=#fca123 gui=bold'
              end
            }
          end)

          -- options
          vim.o.path = vim.o.path .. '**'
          vim.o.swapfile = false
          vim.o.undofile = true
          vim.o.writebackup = false
          vim.o.autowrite = true
          vim.o.autowriteall = true
          vim.wo.number = true
          vim.wo.relativenumber = true
          vim.o.inccommand = 'nosplit'
          vim.o.termguicolors = true
          vim.o.lazyredraw = true
          vim.o.gdefault = true
          vim.o.tabstop = 2
          vim.o.softtabstop = 2
          vim.o.shiftwidth = 2
          vim.o.shiftround = true
          vim.o.expandtab = true
          vim.o.smartindent = true
          vim.o.wrap = false
          vim.o.linebreak = true
          vim.o.breakindent = true
          vim.o.breakindentopt = 'shift:2'
          vim.o.number = true
          vim.o.mouse = 'a'
          vim.o.grepprg = 'rg --vimgrep'
          vim.o.incsearch = true
          vim.o.hlsearch = true
          vim.o.completeopt = 'menuone,noselect'
          vim.o.shortmess = 'aoOTIcF'
          vim.o.showmode = false
          vim.o.sidescroll = 1
          vim.o.sidescrolloff = 5
          vim.o.splitbelow = true
          vim.o.splitright = true
          vim.o.confirm = true
          vim.o.pumheight = 10
          vim.o.updatetime = 50
          vim.o.ttimeoutlen = 0
          vim.o.timeoutlen = 2000
          vim.o.wildcharm = 9
          vim.opt.wildmode = 'longest:full,full'
          vim.o.wildignorecase = true
          vim.o.wildignore = '*/.git,*/node_modules,'
          vim.o.diffopt = 'internal,filler,closeoff,context:3,algorithm:patience,indent-heuristic'
          vim.o.list = true
          vim.o.listchars = 'tab:⇥ ,trail:•,nbsp:␣,extends:↦,precedes:↤'

          -- mappings
          -- wrap
          vim.cmd 'noremap j gj'
          vim.cmd 'noremap k gk'
          vim.cmd 'noremap <Down> gj'
          vim.cmd 'noremap <Up> gk'
          -- redline
          vim.cmd 'cnoremap <C-a> <Home>'
          vim.cmd 'cnoremap <C-e> <End>'
          vim.cmd 'inoremap <C-a> <Home>'
          vim.cmd 'inoremap <C-e> <End>'
          -- paragraph
          vim.cmd 'nnoremap } }zz'
          vim.cmd 'nnoremap { {zz'
          -- c-g improved
          vim.cmd([[nnoremap <silent> <C-g> :echon '['.expand("%:p:~").']'<Bar>echon ' ['system("git rev-parse --abbrev-ref HEAD 2>/dev/null \| tr -d '\n'")']'<CR>]])
          -- reload syntax and nohl
          vim.cmd([[nnoremap <silent><expr> <C-l> empty(get(b:, 'current_syntax')) ? "<C-l>:nohlsearch<cr>" : "<C-l>:syntax sync fromstart<cr>:nohlsearch<cr>"]])
          -- objects
          vim.cmd([[xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')]])
          vim.cmd([[xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')]])
          vim.cmd([[xnoremap <silent> il <Esc>^vg_]])
          vim.cmd([[onoremap <silent> il :<C-U>normal! ^vg_<cr>]])
          vim.cmd([[xnoremap <silent> ie gg0oG$]])
          vim.cmd([[onoremap <silent> ie :<C-U>execute "normal! m`"<Bar>keepjumps normal! ggVG<cr>]])
          -- paste from change
          vim.cmd 'vnoremap ]p "0p'
          -- search and replace
          vim.cmd 'nmap cg* *cgn'
          -- execute macro
          vim.cmd 'nnoremap Q <Nop>'
          vim.cmd 'nnoremap Q @q'
          -- ranges
          vim.cmd([[cnoremap <c-x>t <CR>:t'''<CR>]])
          vim.cmd([[cnoremap <c-x>m <CR>:m'''<CR>]])
          vim.cmd([[cnoremap <c-x>d <CR>:d<CR>``]])
          -- numbers
          vim.cmd[[nnoremap <silent> <expr> <c-n> &relativenumber ? ':windo set norelativenumber<cr>' : ':windo set relativenumber<cr>']]

          -- autocommands
          vim.cmd 'autocmd TextYankPost * lua vim.highlight.on_yank {higroup = "Search", timeout = 300}'
          vim.cmd([[autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$")]] ..
          [[&& &ft !~# 'commit' | exe "normal! g`\"" | endif]])
          vim.cmd 'autocmd FileType qf wincmd J'
          vim.cmd 'autocmd BufWinEnter * if &ft == "help" | wincmd J | end'
          vim.cmd 'autocmd InsertLeave * if &l:diff | diffupdate | endif'
          vim.cmd 'autocmd BufWritePre * if !isdirectory(expand("%:h", v:true)) | call mkdir(expand("%:h", v:true), "p") | endif'
          vim.cmd 'autocmd! VimResume, CursorHold * checktime'
          vim.cmd 'autocmd! VimResume, CursorHold * if exists("g:loaded_gitgutter") | call gitgutter#all(1) | endif'
          vim.cmd 'autocmd BufNewFile,BufRead config setlocal filetype=config'
          vim.cmd 'autocmd BufWinEnter *.json setlocal conceallevel=0 concealcursor='
          vim.cmd 'autocmd BufReadPre *.json setlocal conceallevel=0 concealcursor='
          vim.cmd 'autocmd BufReadPre *.json setlocal formatoptions='
          vim.cmd 'autocmd FileType git setlocal nofoldenable'
          vim.cmd 'autocmd FileType gitcommit setlocal spell | setlocal textwidth=72 | setlocal colorcolumn=+1'
          vim.cmd 'autocmd TermOpen * setlocal nonumber norelativenumber'
          vim.cmd 'autocmd TermOpen * if &buftype ==# "terminal" | startinsert | endif'
          vim.cmd 'autocmd BufLeave term://* stopinsert'
          vim.cmd [[autocmd TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif]]
          vim.cmd 'autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif'

          -- sessions
          if vim.fn.empty(vim.fn.glob('~/.cache/sessions')) > 0 then
          os.execute 'mkdir -p ~/.cache/sessions'
          end
          vim.cmd 'autocmd! VimLeavePre * execute "mksession! ~/.cache/sessions/" . split(getcwd(), "/")[-1] . ".vim"'
          vim.cmd(
          [[command! -nargs=0 SS :execute 'source ~/.cache/sessions/' .  split(getcwd(), '/')[-1] . '.vim']])

          --- commands
          vim.cmd([[command! -nargs=0 BO silent! execute "%bd|e#|bd#"]])
          vim.cmd([[command BD bp | bd #]])
          vim.cmd([[command! -nargs=0 WS %s/\s\+$// | normal! ``]])
          vim.cmd([[command! -nargs=0 WT %s/[^\t]\zs\t\+/ / | normal! ``]])
          vim.cmd([[command! -bar HL echo synIDattr(synID(line('.'),col('.'),0),'name')]] ..
          [[synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')]])
          vim.cmd([[command! WW w !sudo tee % > /dev/null]])
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
