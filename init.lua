vim.opt.number = true
vim.opt.termguicolors = true

--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

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
require('cmp-config')
