vim.opt.guicursor = ''

-- Make line numbers default
vim.opt.number = true

-- Add relative line numbers to help with jumping
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Set highlight on search.
-- Clear using <CR> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enable 24-bit RGB
vim.opt.termguicolors = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

-- Decrease update time
vim.opt.updatetime = 50

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'
vim.opt.clipboard = 'unnamed'

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Use custom tmux navigator key mappings
vim.g['tmux_navigator_no_mappings'] = 1
