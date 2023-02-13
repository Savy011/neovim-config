vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
	-- Packer can manage itself
    use "wbthomason/packer.nvim"
	use "lewis6991/impatient.nvim"

	--Dashboard
	use {
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	}
	--Screensaver
	use "itchyny/screensaver.vim"

	--Colourscheme
	use "folke/tokyonight.nvim"

	--Hexokinase
	use {
		"rrethy/vim-hexokinase",
		setup = function()
			vim.g.Hexokinase_highlighters = { "backgroundfull" }
		end,
	} 

	--Distraction-free Writing
	use "folke/zen-mode.nvim" 
	use "folke/twilight.nvim" 

	--or Markdown
	use "davidgranstrom/nvim-markdown-preview"

	--Status Line & Bufferline
	use "nvim-lualine/lualine.nvim"
	use { "akinsho/bufferline.nvim", tag = "v3.*" }

	--Indent-Blankline
	use "lukas-reineke/indent-blankline.nvim"

	--Auto-Pairs
	use "windwp/nvim-autopairs" 
	use "windwp/nvim-ts-autotag" 

	--Tree File Explorer
	use {
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
	} 

	--Telescope
	use {
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
            { "nvim-lua/plenary.nvim" }
        },
	} 

	--LSP
	use "neovim/nvim-lspconfig" 
	use "williamboman/mason.nvim" 
	use "williamboman/mason-lspconfig.nvim" 
	use "jose-elias-alvarez/null-ls.nvim" 

	--Formatters
	use "MunifTanjim/prettier.nvim" 
	use "ckipp01/stylua-nvim" 

	--Auto-completion & Snippets
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	} 

	use "rafamadriz/friendly-snippets" 

	--Treesitter
	use {"nvim-treesitter/nvim-treesitter", { run = "TSUpdate" }}
end)
