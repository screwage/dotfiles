return {
  'chomosuke/typst-preview.nvim',
  lazy = false, -- or ft = 'typst'
  version = '1.*',
  opts = {
    port = 19999,
  }, -- lazy.nvim will implicitly calls `setup {}`
}
