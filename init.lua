-- Opts
vim.opt.hlsearch = false
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "onsails/lspkind.nvim" },
	{ "numToStr/Comment.nvim" },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				show_end_of_buffer = true,
				integrations = {
					cmp = true,
					treesitter = true,
					native_lsp = {
						enabled = true,
					},
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp = require("cmp")

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "emoji" },
				},
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						col_offset = -3,
						side_padding = 0,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind =
							require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
				experimental = { ghost_text = { hl_group = "CmpGhostText" } },
				completion = {
					keyword_length = 4,
					completeopt = "menu,menuone,noselect",
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif vim.snippet and vim.snippet.active({ direction = 1 }) then
							vim.schedule(function()
								vim.snippet.jump(1)
							end)
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-k>"] = cmp.mapping.select_prev_item(),
					["<S-j>"] = cmp.mapping.select_next_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Esc>"] = cmp.mapping.abort(),
					["<C-e>"] = cmp.mapping.abort(),
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = false,
				modules = {},
				ensure_installed = {
					"html",
					"css",
					"lua",
					"astro",
					"go",
					"javascript",
					"typescript",
					"tsx",
					"svelte",
					"gleam",
					"markdown",
				},
				ignore_install = {},
				auto_install = true,
				indent = {
					enable = true,
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				diagnostics = {
					virtual_text = true,
				},
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = { "lua_ls", "gopls", "ts_ls", "svelte", "zls" },
			auto_install = true,
			automatic_enable = true,
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback",
			},
			formatters = {
				eslint_d = {
					command = "eslint_d",
					args = { "--fix" },
				},
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		keys = {
			{
				"<leader>ft",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explore Neotree (project)",
			},
		},
		opts = {
			close_if_last_window = true,
			window = {
				position = "right",
				width = 40,
			},
			filesystem = {
				filtered_items = {
					always_show_by_pattern = {
						".env*",
					},
				},
				follow_current_file = {
					enabled = true,
				},
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = { enabled = true },
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				indicator = {
					separator_style = "slope",
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					component_separators = "|",
					section_separators = { left = "", right = "" },
				},
				sections = {

					lualine_x = { "encoding", "filetype" },
					lualine_y = { "lsp_status" },
				},
			})
		end,
	},
})

vim.diagnostic.config({
	virtual_text = true,
})

-- Keymaps
local map = vim.keymap

map.set("n", "<C-s>", ":w<CR>")
map.set("n", "<C-q>", ":bd<CR>")
map.set("n", "<C-h>", ":bprevious<CR>")
map.set("n", "<C-l>", ":bnext<CR>")

map.set("n", "<Left>", "<Nop>")
map.set("n", "<Right>", "<Nop>")
map.set("n", "<Up>", "<Nop>")
map.set("n", "<Down>", "<Nop>")

map.set("v", "<", "<gv")
map.set("v", ">", ">gv")

map.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
map.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live grep" })
map.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "List open buffers" })

map.set("n", "<leader>v", function()
	vim.cmd("vsplit | enew")
end, { desc = "Vertical split and open new buffer" })

-- Autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_set_hl(0, "CmpGhostText", {
	italic = true,
	link = "Comment",
	blend = 40,
})

local catp_text = "#cdd6f4"
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = catp_text, blend = 80 })
vim.api.nvim_set_hl(0, "LineNr", { fg = catp_text, blend = 40 })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = catp_text, blend = 80 })

vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#313244" })
