local builtin = require('telescope.builtin')

vim.g.mapleader = " "

--Close Currently Open Buffer
vim.keymap.set("n", "<leader>q", ":bd<CR>")

--Mappings for BufferLine
vim.keymap.set("n", "<leader>c", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<leader>v", ":BufferLineCycleNext<CR>")

--Mappings for Nvim-Tree
vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>")

--Mappings for Zen-Mode.nvim
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>")

--Mapping for Markdown Preview
vim.keymap.set("n", "<leaderM>", ":MarkdownPreview<CR>")

--Mapping for Telescope
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', ":Telescope oldfiles<CR>")
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fz', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--Enable ScreenSaver
vim.keymap.set('n', '<leader>S', ":ScreenSaver largeclock<CR>")

--Mapping for Formatters
vim.keymap.set('n', '<leader>P', ":Prettier<CR>")

--Which-Key
require('which-key').setup{}
