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
	{ "onsails/lspkind.nvim", lazy = true },
	{ "numToStr/Comment.nvim", keys = { "gc", "gb", config = true } },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
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

			local colors = require("catppuccin.palettes").get_palette()

			-- Override specific highlight groups to be opaque
			vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = colors.base })
			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = colors.base })
			vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.base })
			vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.base })
			vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.base })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.surface0 })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.base })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.base })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
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
		"jinzhongjia/LspUI.nvim",
		branch = "main",
		opts = {
			inlay_hint = {
				enable = false,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
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
		event = { "BufReadPre", "BufNewFile" },
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
		event = { "BufReadPre", "BufNewFile" },
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
		cmd = "Telescope",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				typescript = { "biome" },
				javascript = { "biome" },
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
		cmd = "Neotree",
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
				width = 35,
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
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			scope = { enabled = true },
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "VeryLazy",
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
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local logo = [[ _       __                     _
| |     / /__  ___  ___        (_)___ ___
| | /| / / _ \/ _ \/ _ \______/ / __ `__ \
| |/ |/ /  __/  __/  __/_____/ / / / / / /
|__/|__/\___/\___/\___/     /_/_/ /_/ /_/]]

			dashboard.section.header.val = vim.split(logo, "\n")
			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
				dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
				dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
				dashboard.button("q", " " .. " Quit", ":qa<CR>"),
			}

			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AplhaButtons"
				button.opts.hl_shortcut = "AplhaShortcut"
			end

			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "AlphaFooter"
			dashboard.opts.layout[1].val = 8

			return dashboard
		end,
		config = function(_, dashboard)
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
})

vim.diagnostic.config({
	virtual_text = true,
})

vim.lsp.enable("gleam")
vim.lsp.enable("eslint")
vim.lsp.enable("biome")

local customizations = {
	{ rule = "style/*", severity = "off", fixable = true },
	{ rule = "format/*", severity = "off", fixable = true },
	{ rule = "*-indent", severity = "off", fixable = true },
	{ rule = "*-spacing", severity = "off", fixable = true },
	{ rule = "*-spaces", severity = "off", fixable = true },
	{ rule = "*-order", severity = "off", fixable = true },
	{ rule = "*-dangle", severity = "off", fixable = true },
	{ rule = "*-newline", severity = "off", fixable = true },
	{ rule = "*quotes", severity = "off", fixable = true },
	{ rule = "*semi", severity = "off", fixable = true },
}

local web_filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
	"vue",
	"html",
	"markdown",
	"json",
	"jsonc",
	"yaml",
	"toml",
	"xml",
	"gql",
	"graphql",
	"astro",
	"svelte",
	"css",
	"less",
	"scss",
	"pcss",
	"postcss",
}

vim.lsp.config("eslint", {
	filetypes = web_filetypes,
	settings = {
		format = { enable = true },
		workingDirectory = { mode = "auto" },
		codeActionOnSave = { enable = true, mode = "problems" },
		rulesCustomizations = customizations,
	},
	on_attach = function(client, buffer)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = buffer,
			callback = function(event)
				local namespace = vim.lsp.diagnostic.get_namespace(client.id, true)
				local diagnostics = vim.diagnostic.get(event.buf, { namespace = namespace })
				local eslint = function(formatter)
					return formatter.name == "eslint"
				end
				if #diagnostics > 0 then
					vim.lsp.buf.format({ async = false, filter = eslint })
				end
			end,
		})
	end,
})

vim.lsp.config("tailwindcss", {
	flags = {
		debounce_text_changes = 1000,
	},
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
map.set("v", "J", ":m '>+1<CR>gv=gv")
map.set("v", "K", ":m '<-2<CR>gv=gv")

map.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
map.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live grep" })
map.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "List open buffers" })

map.set("n", "<leader>v", function()
	vim.cmd("vsplit | enew")
end, { desc = "Vertical split and open new buffer" })

map.set("n", "??", ":lua vim.diagnostic.goto_next()<CR>")

map.set("n", "K", "<cmd>LspUI hover<CR>")
map.set("n", "gr", "<cmd>LspUI reference<CR>")
map.set("n", "gd", "<cmd>LspUI definition<CR>")
map.set("n", "gs", "<cmd>LspUI diagnostic<CR>")
map.set("n", "gt", "<cmd>LspUI type_definition<CR>")
map.set("n", "gi", "<cmd>LspUI implementation<CR>")
map.set("n", "<leader>rn", "<cmd>LspUI rename<CR>")
map.set("n", "<leader>ca", "<cmd>LspUI code_action<CR>")
map.set("n", "<leader>ci", "<cmd>LspUI call_hierarchy incoming_calls<CR>")
map.set("n", "<leader>co", "<cmd>LspUI call_hierarchy outgoing_calls<CR>")

-- Autocmds

local function set_language_config()
	local filetype = vim.bo.filetype

	if vim.tbl_contains(web_filetypes, filetype) then
		vim.opt.expandtab = true
		vim.opt.smartindent = true
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
	end
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*" },
	callback = function()
		set_language_config()
	end,
})

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
