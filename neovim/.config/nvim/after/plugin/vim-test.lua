vim.keymap.set('n', '<leader>tt', vim.cmd.TestNearest, { silent = true })
vim.keymap.set('n', '<leader>tT', vim.cmd.TestFile, { silent = true })
vim.keymap.set('n', '<leader>ta', vim.cmd.TestSuite, { silent = true })
vim.keymap.set('n', '<leader>tl', vim.cmd.TestLast, { silent = true })
vim.keymap.set('n', '<leader>tg', vim.cmd.TestVisit, { silent = true })

vim.g['test#strategy'] = 'neovim'
vim.g['test#python#runner'] = 'pytest'
