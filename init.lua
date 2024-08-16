-- Based on https://github.com/nvim-lua/kickstart.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = false
local font_name = 'LigaConsolas Nerd Font'
local font_size = 'h14'

_G.neovim_gui_font = font_name .. ':' .. font_size
vim.opt.guifont = _G.neovim_gui_font

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- line wrap
vim.wo.wrap = false

-- Tab spacing
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Make line numbers default
vim.opt.number = true
-- vim.opt.relativenumber = true

-- Enable mouse mode,
vim.opt.mouse = 'a'

-- Remove context mouse message
pcall(vim.cmd.aunmenu, 'PopUp.How-to\\ disable\\ mouse')
pcall(vim.cmd.aunmenu, 'PopUp.-1-')

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
-- vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '[Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Shitft-Y to yank line
vim.keymap.set('n', 'Y', 'yy', { noremap = true, silent = true, desc = "Yank Line" })

-- Ctrl-s to save
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "File Save" })

-- Unbind F1 to since I always accidentally hit it and launch help
vim.keymap.set('', '<F1>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<F1>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('v', '<F1>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('c', '<F1>', '<Nop>', { noremap = true, silent = true })

-- Highlight flash when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Function to copy the full path of the current file
local function copy_current_file_path()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    print("No file is currently open.")
    return
  end
  vim.fn.setreg('+', file_path)
  print("Copied file path: " .. file_path)
end

vim.api.nvim_create_user_command('CopyCurrentFilePath', copy_current_file_path, { range = false })

-- Function to open the current file in the OS file manager
local function open_in_file_manager()
  local file_path = vim.fn.expand("%:p:h")
  if file_path == "" then
    print("No file is currently open.")
    return
  end
  local open_cmd
  if vim.fn.has("mac") == 1 then
    open_cmd = "open " .. file_path
  elseif vim.fn.has("unix") == 1 then
    open_cmd = "xdg-open " .. file_path
  elseif vim.fn.has("win32") == 1 then
    open_cmd = "explorer " .. file_path
  else
    print("Unsupported OS")
    return
  end
  vim.fn.system(open_cmd)
end

-- Function to open a terminal at the current file's directory path
local function open_terminal_at_file_path()
  local file_path = vim.fn.expand("%:p:h")
  if file_path == "" then
    print("No file is currently open.")
    return
  end
  local terminal_cmd
  if vim.fn.has("mac") == 1 then
    terminal_cmd = "open -a Terminal " .. file_path
  elseif vim.fn.has("unix") == 1 then
    terminal_cmd = "gnome-terminal --working-directory=" .. file_path .. " &"
  elseif vim.fn.has("win32") == 1 then
    terminal_cmd = "start cmd /K cd " .. file_path
  else
    print("Unsupported OS")
    return
  end
  vim.fn.system(terminal_cmd)
end

vim.keymap.set('n', '<leader>dc', copy_current_file_path, { noremap = true, silent = true, desc = "[C]opy Path" })
vim.cmd.amenu('PopUp.Path :CopyCurrentFilePath<CR>')
vim.keymap.set('n', '<leader>do', open_in_file_manager, { noremap = true, silent = true, desc = "[O]pen Path" })
vim.keymap.set('n', '<leader>dt', open_terminal_at_file_path, { noremap = true, silent = true, desc = "[T]erminal Path" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
      -- Detect tabstop and shiftwidth automatically
      'tpope/vim-sleuth',
    },
    {
      -- "gc" to comment visual regions/lines
      'numToStr/Comment.nvim',
      opts = {},
    },
    {
      -- Better bdelete
      'ojroques/nvim-bufdel',
      cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
      keys = {
        { '<leader>bd', "<cmd>BufDel<cr>", desc = "[D]elete" }
      },
    },
    {
      -- Disable features for big files
      "LunarVim/bigfile.nvim"
    },
    {
      -- Adds git signs to gutter
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },
    {
      'folke/which-key.nvim',
      event = 'VimEnter',
      config = function()
        require('which-key').setup {
          icons = {
            mappings = vim.g.have_nerd_font,
          },
        }
        require('which-key').add {
          { '<leader>b', group = '[B]uffer' },
          { '<leader>c', group = '[C]ode' },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        }
      end,
    },
    {
      -- Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
        {
          'nvim-lua/plenary.nvim',
        },
        {
          -- Compile native fuzzy search if cmake is installed
          'nvim-telescope/telescope-fzf-native.nvim',
          build =
          'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
          cond = function()
            return vim.fn.executable 'cmake' == 1
          end,
        },
        {
          'nvim-telescope/telescope-ui-select.nvim',
        },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
        require('telescope').setup {
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
          },
        }

        -- Enable telescope extensions, if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'

        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find Buffer' })

        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] Fuzzy Search File' })

        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[F]iles' })
        vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Search Files' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[.] Recent Files' })

        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[/] Grep Open Files' })

        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[N]eovim files' })

      end,
    },
    {
      -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-T>.
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            map('<A-g>', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

            -- Find references for the word under your cursor.
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

            -- Fuzzy find all the symbols in your current workspace
            --  Similar to document symbols, except searches over your whole project.
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- Rename the variable under your cursor
            --  Most Language Servers support renaming across files, etc.
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            -- Opens a popup that displays documentation about the word under your cursor
            --  See `:help K` for why this keymap
            map('K', vim.lsp.buf.hover, 'Hover Documentation')

            -- WARN: This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
              })
            end
          end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        local servers = {
          clangd = {},
          gopls = {},
          pyright = {},
          rust_analyzer = {},
          tsserver = {},

          lua_ls = {
            -- cmd = {...},
            -- filetypes { ...},
            -- capabilities = {},
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                workspace = {
                  checkThirdParty = false,
                  -- Tells lua_ls where to find all the Lua files that you have loaded
                  -- for your neovim configuration.
                  library = {
                    '${3rd}/luv/library',
                    unpack(vim.api.nvim_get_runtime_file('', true)),
                  },
                  -- If lua_ls is really slow on your computer, you can try this instead:
                  -- library = { vim.env.VIMRUNTIME },
                },
                completion = {
                  callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },
        }

        -- Ensure the servers and tools above are installed
        require('mason').setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua',
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- This handles overriding only values explicitly passed
              -- by the server configuration above. Useful when disabling
              -- certain features of an LSP (for example, turning off formatting for tsserver)
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },
    {
      -- Lightweight code formatter
      'stevearc/conform.nvim',
      config = function()
        -- Format command to format current buffer
        vim.api.nvim_create_user_command('Format', function(args)
          local range = nil
          if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
              start = { args.line1, 0 },
              ['end'] = { args.line2, end_line:len() },
            }
          end
          require('conform').format { async = true, lsp_fallback = true, range = range }
        end, { range = true })

        vim.keymap.set('n', '<leader>df', '<cmd>Format<cr>', { desc = '[F]ormat' })
        vim.cmd.amenu('PopUp.Format :Format<CR>')
      end,
      opts = {
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black' },
          json = { { 'prettierd', 'prettier' } },
          markdown = { { 'prettierd', 'prettier' } },
          javascript = { { 'prettierd', 'prettier' } },
          typescript = { { 'prettierd', 'prettier' } },
          go = { 'gofmt' },
          rust = { 'rustfmt' },
        },
      },
    },
    {
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
          'L3MON4D3/LuaSnip',
          build = (function()
            -- Build Step is needed for regex support in snippets
            -- This step is not supported in many windows environments
            -- Remove the below condition to re-enable on windows
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
        },
        'saadparwaiz1/cmp_luasnip',

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',

        -- If you want to add a bunch of pre-configured snippets,
        --    you can use this plugin to help you. It even has snippets
        --    for various frameworks/libraries/etc. but you will have to
        --    set up the ones that are useful for you.
        -- 'rafamadriz/friendly-snippets',
      },
      config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },

          -- For an understanding of why these mappings were
          -- chosen, you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          mapping = cmp.mapping.preset.insert {
            -- Select the [n]ext item
            ['<C-n>'] = cmp.mapping.select_next_item(),
            -- Select the [p]revious item
            ['<C-p>'] = cmp.mapping.select_prev_item(),

            -- Accept ([y]es) the completion.
            --  This will auto-import if your LSP supports it.
            --  This will expand snippets if the LSP sent a snippet.
            ['<C-y>'] = cmp.mapping.confirm { select = true },

            -- Manually trigger a completion from nvim-cmp.
            --  Generally you don't need this, because nvim-cmp will display
            --  completions whenever it has completion options available.
            ['<C-Space>'] = cmp.mapping.complete {},

            -- Think of <c-l> as moving to the right of your snippet expansion.
            --  So if you have a snippet that's like:
            --  function $name($args)
            --    $body
            --  end
            --
            -- <c-l> will move you to the right of each of the expansion locations.
            -- <c-h> is similar, except moving you backwards.
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
          },
        }
      end,
    },
    {
      -- tokyonight theme
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        -- OSX Terminal.app only supports 256 colors
        if vim.env.TERM_PROGRAM == 'Apple_Terminal' then
          -- ginit.vim will correctly override these with
          -- tokyonight when nvim-qt is launched from Terminal.app
          vim.opt.termguicolors = false
          vim.cmd.colorscheme('habamax')
        else
          vim.opt.termguicolors = true
          vim.cmd.colorscheme('tokyonight')
        end
      end,
      opts = {},
    },
    {
      -- Buffer Tabs
      'akinsho/bufferline.nvim',
      version = '*',
      dependencies = {
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
        require('bufferline').setup {
          options = {
            show_buffer_icons = vim.g.have_nerd_font,
            close_command = "BufDel! %d",
            max_name_length = 18,
            max_prefix_length = 15,
            truncate_names = true,
            tab_size = 18,
            separator_style = "thin",
            always_show_bufferline = false,
            offsets = {
              {
                filetype = "NvimTree",
                text = "Explorer",
                highlight = "PanelHeading",
                padding = 1,
              },
              {
                filetype = "DiffviewFiles",
                text = "Diff View",
                highlight = "PanelHeading",
                padding = 1,
              },
              {
                filetype = "lazy",
                text = "Lazy",
                highlight = "PanelHeading",
                padding = 1,
              },
            },
          },
        }
        vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<cr>', { desc = '[P]ick' })
      end,
    },
    {
      -- Fancy statusline
      'nvim-lualine/lualine.nvim',
      dependencies = {
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
        require('lualine').setup {
          options = {
            theme = 'tokyonight',
            icons_enabled = vim.g.have_nerd_font,
          },
        }
      end,
    },
    {
      -- CSV highlighting
      'cameron-wags/rainbow_csv.nvim',
      config = true,
      ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon',
      },
      cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim',
      },
    },
    {
      -- Treesitter-based highlighting and indenting
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup {
          ensure_installed = {
            'lua',
            'python',
            'llvm',
            'c',
            'cpp',
            'go',
            'rust',
            'javascript',
            'typescript',
            'sql',
            'vim',
            'vimdoc',
            'markdown_inline',
            'markdown',
            'html',
            'css',
            'json',
            'yaml',
            'toml',
            'ron',
            'bash',
          },
          ignore_install = {
            'csv',
            'org',
          },
          auto_install = true,
          sync_install = false,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
        }
      end,
    },
    {
      -- Nvim-qt GUI
      'equalsraf/neovim-gui-shim',
      config = function()
        vim.api.nvim_command('GuiFont! ' .. _G.neovim_gui_font)
        vim.api.nvim_command('GuiTabline 0')
        vim.api.nvim_command('GuiPopupmenu 0')
        vim.api.nvim_command('GuiScrollBar 1')
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      keys = {
        { '<leader>wt', "<cmd>NvimTreeToggle<cr>", desc = '[T]ree View' }
      },
      config = function()
        require("nvim-tree").setup {}
      end,
    },
    {
      -- Terminal
      'akinsho/toggleterm.nvim',
      version = "*",
      opts = {
        direction = "float",
        open_mapping = [[<c-\>]],
      }
    },
    {
      -- Highlight other uses of the word under the cursor
      "RRethy/vim-illuminate",
    },
    {
      -- Surround text in quotes, etc
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end
    },
  },
  {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  })

-- vim: ts=2 sts=2 sw=2 et
