--Use systwm clipboard (for Linux X11 Window System)
vim.opt.clipboard = 'unnamedplus'

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

--Config for Prettier
local prettier = require("prettier")

prettier.setup({
  bin = 'prettierd', -- or `'prettierd'` (v0.22+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})
