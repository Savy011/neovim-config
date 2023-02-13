local null_ls = require("null-ls")
local prettier = require("prettier")
local stylua = require("stylua-nvim")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.markdownlint,
		null_ls.builtins.formatting.prettier,
	}
})

--Config for Formatters

prettier.setup{
    bin = 'prettier',
    filetypes = {
        "css",
        "html",
        "javascript",
        "json",
        "scss",
        "less"
    }
}

stylua.setup{
    config_file = "stylua.toml"
}
