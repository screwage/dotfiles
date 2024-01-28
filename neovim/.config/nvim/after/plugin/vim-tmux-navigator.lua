vim.g['tmux_navigator_no_mappings'] = 1

vim.keymap.set("n", "<M-h>", ":<C-U>TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<M-j>", ":<C-U>TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<M-k>", ":<C-U>TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<M-l>", ":<C-U>TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("n", "<M-\\>", ":<C-U>TmuxNavigatePrevious<CR>", { silent = true })
