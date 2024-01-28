-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        -- or                            , tag = '0.1.5',
        requires = { { 'nvim-lua/plenary.nvim' } },
        config = function()
            -- If multiple file selections are detected, open each file. If hitting
            -- <CR> on a single selection fall back to the default behaviour.
            -- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1679797700

            local select_one_or_multi = function(prompt_bufnr)
                local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                    require('telescope.actions').close(prompt_bufnr)
                    for _, j in pairs(multi) do
                        if j.path ~= nil then
                            vim.cmd(string.format("%s %s", "edit", j.path))
                        end
                    end
                else
                    require('telescope.actions').select_default(prompt_bufnr)
                end
            end

            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            -- Open files on <Enter>. See above.
                            ["<CR>"] = select_one_or_multi,
                        }
                    },

                    -- Until this is fixed: https://github.com/nvim-telescope/telescope.nvim/issues/2667
                    sorting_strategy = 'ascending'
                }
            })
        end
    }

    use { "catppuccin/nvim", as = "catppuccin" }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use 'JoosepAlviste/nvim-ts-context-commentstring'

    use('mbbill/undotree')
    use('tpope/vim-fugitive')


    -- Tmux config
    use { 'christoomey/vim-tmux-navigator',
        lazy = false
    }

    -- Personal Finance
    use 'ledger/vim-ledger'

    -- Rust
    use 'neovim/nvim-lspconfig'
    use 'simrat39/rust-tools.nvim'

    -- Debugging
    use 'nvim-lua/plenary.nvim'
    use 'mfussenegger/nvim-dap'

    -- Testing
    use 'vim-test/vim-test'

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }

    use {
        'prettier/vim-prettier',
        run = 'pnpm install',
        ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'graphql', 'markdown', 'vue', 'html' }
    }

    use 'airblade/vim-gitgutter'

    -- Vim Be Good Game https://github.com/ThePrimeagen/vim-be-good
    use 'ThePrimeagen/vim-be-good'

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({ {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            } })
        end
    }
end)
