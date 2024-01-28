local builtin = require('telescope.builtin')
local utils = require('telescope.utils')

vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({ cwd = utils.buffer_dir() })
end)

vim.keymap.set('n', '<C-p>', function()
    builtin.git_files({ cwd = utils.buffer_dir() })
end)
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ cwd = utils.buffer_dir(), search = vim.fn.input("Grep > ") });
end)
