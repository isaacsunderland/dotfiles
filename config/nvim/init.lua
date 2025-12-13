-- Neovim Configuration
-- Cross-platform, version-compatible setup with proper swap/backup/undo handling

-- Ensure directories exist
local function ensure_dir(path)
    local expanded = vim.fn.expand(path)
    if vim.fn.isdirectory(expanded) == 0 then
        vim.fn.mkdir(expanded, 'p')
    end
end

-- Create necessary directories
-- Note: Neovim 0.11+ uses ~/.local/state by default, but we explicitly set both for compatibility
ensure_dir('~/.local/state/nvim/swap')
ensure_dir('~/.local/state/nvim/backup')
ensure_dir('~/.local/state/nvim/undo')
ensure_dir('~/.local/share/nvim/swap')  -- Fallback for older versions
ensure_dir('~/.local/share/nvim/backup')
ensure_dir('~/.local/share/nvim/undo')

-- ============================================================================
-- Basic Settings
-- ============================================================================

vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = false      -- Use absolute line numbers
vim.opt.cursorline = true           -- Highlight current line
vim.opt.signcolumn = 'yes'          -- Always show sign column

-- Indentation
vim.opt.expandtab = true            -- Use spaces instead of tabs
vim.opt.tabstop = 4                 -- Tab width
vim.opt.shiftwidth = 4              -- Indent width
vim.opt.softtabstop = 4             -- Soft tab width
vim.opt.autoindent = true           -- Auto indent new lines
vim.opt.smartindent = true          -- Smart indentation

-- Search
vim.opt.ignorecase = true           -- Case insensitive search
vim.opt.smartcase = true            -- Smart case sensitivity
vim.opt.hlsearch = true             -- Highlight search results
vim.opt.incsearch = true            -- Incremental search

-- Display
vim.opt.wrap = true                 -- Wrap long lines
vim.opt.breakindent = true          -- Maintain indent on wrapped lines
vim.opt.linebreak = true            -- Break at word boundaries
vim.opt.list = true                 -- Show whitespace
vim.opt.listchars = {
    tab = '» ',
    trail = '·',
    nbsp = '↳',
    eol = '¬',
}

-- Files and Backup
vim.opt.undofile = true             -- Enable persistent undo
vim.opt.backup = true               -- Keep backup files
vim.opt.writebackup = true          -- Backup before overwriting
vim.opt.swapfile = true             -- Use swap files (for recovery)

-- Set directories for swap, backup, and undo
-- Using // at the end tells Vim to use full path in swap filenames (prevents collisions)
-- Neovim 0.11+ uses ~/.local/state by default, but we provide fallbacks for compatibility
vim.opt.directory = {
    vim.fn.expand('~/.local/state/nvim/swap') .. '//',
    vim.fn.expand('~/.local/share/nvim/swap') .. '//',
    '.',  -- Fallback to current directory if swap dir unavailable
}
vim.opt.backupdir = {
    vim.fn.expand('~/.local/state/nvim/backup') .. '//',
    vim.fn.expand('~/.local/share/nvim/backup') .. '//',
    '.',  -- Fallback to current directory
}
vim.opt.undodir = {
    vim.fn.expand('~/.local/state/nvim/undo') .. '//',
    vim.fn.expand('~/.local/share/nvim/undo') .. '//',
}

-- ============================================================================
-- Editor Behavior
-- ============================================================================

vim.opt.mouse = 'a'                 -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'   -- Use system clipboard
vim.opt.encoding = 'utf-8'          -- UTF-8 encoding
vim.opt.termguicolors = true        -- True color support

-- Split behavior
vim.opt.splitright = true           -- New vertical splits on the right
vim.opt.splitbelow = true           -- New horizontal splits below

-- Command mode
vim.opt.wildmenu = true             -- Enhanced command mode completion
vim.opt.wildmode = 'list:longest'   -- List all matches

-- ============================================================================
-- Performance
-- ============================================================================

vim.opt.updatetime = 300            -- Faster update time
vim.opt.timeoutlen = 500            -- Timeout for mapped sequences
vim.opt.ttimeoutlen = 10            -- Timeout for terminal key codes

-- ============================================================================
-- Keybindings
-- ============================================================================

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })

-- Window resizing
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- Clear search highlighting
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR><Esc>', { noremap = true, silent = true })

-- Better indenting in visual mode
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- ============================================================================
-- Colorscheme
-- ============================================================================

-- Try to set a nice colorscheme (fallback to default if not available)
local colorscheme_status, _ = pcall(vim.cmd, 'colorscheme default')
if not colorscheme_status then
    vim.cmd('colorscheme default')
end

-- ============================================================================
-- File Type Settings
-- ============================================================================

-- File type specific settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'yaml', 'yml' },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'json', 'jsonc' },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Auto save on focus lost
vim.api.nvim_create_autocmd('FocusLost', {
    callback = function()
        vim.cmd('silent! wa')
    end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        local save_cursor = vim.fn.getpos('.')
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos('.', save_cursor)
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
    end,
})

-- ============================================================================
-- Status Line
-- ============================================================================

-- Simple built-in status line
vim.opt.laststatus = 2
vim.opt.statusline = '%f %m %r %h %w %= %l:%c %p%%'

-- ============================================================================
-- Information
-- ============================================================================

-- Print configuration info
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        if vim.fn.argc() == 0 then
            vim.fn.writefile({
                '╔════════════════════════════════════════╗',
                '║         Neovim Configured              ║',
                '╚════════════════════════════════════════╝',
                '',
                'Configuration: ~/.config/nvim/init.lua',
                'Swap Dir: ~/.local/share/nvim/swap',
                'Backup Dir: ~/.local/share/nvim/backup',
                'Undo Dir: ~/.local/share/nvim/undo',
                '',
                'Leader Key: <Space>',
                'Window Nav: <C-h/j/k/l>',
                'Window Size: <C-Arrow>',
                '',
            }, '/tmp/nvim_welcome.txt')
        end
    end,
})
