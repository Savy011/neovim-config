vim.opt.number = true
vim.opt.termguicolors = true

require('impatient')

require('plugins')
require('color')
require('text')
require('keymap')

require('lualine-config')
require('bufferline-config')
require('treesitter-config')
require('nvim-tree-config')
require('alpha-config')
require('telescope-config')
require('blankline-config')
require('lsp-config')
require('lsp-config.null-ls')
require('cmp-config')
