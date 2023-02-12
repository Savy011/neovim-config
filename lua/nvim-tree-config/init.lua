require("nvim-tree").setup({
	sort_by = "case_sensitive",
	disable_netrw = true,
	view = {
		float = {
			enable = true,
			open_win_config = {
				width = 150,
			}
			
		},
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})
