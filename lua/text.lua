--Use systwm clipboard (for Linux X11 Window System)
vim.opt.clipboard = 'unnamedplus'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.scrolloff = 8

--Config forAuto-Pairs
require('nvim-autopairs').setup({
disable_filetype = { "vim" },
map_cr = true
})

--Config for ZenMode
require("zen-mode").setup{
	backdrop = 0.75,
	width = 70,
	options = {
		--signcolumn = "no", -- disable signcolumn
		number = "no", -- disable number column
	},
	plugins = {
		options = {
			twilight = { enabled = true},
		}
	}
}

--Config for Twilight
require("twilight").setup{
	treesitter = true,
}

--Config for Markdown-Preview
vim.g.nvim_markdown_preview_theme = 'github'

--Config for Null-LS
local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

null_ls.setup({
sources = {
null_ls.builtins.diagnostics.eslint_d.with({
diagnostics_format = '[eslint] #{m}\n(#{c})'
}),
null_ls.builtins.diagnostics.fish
}
})

