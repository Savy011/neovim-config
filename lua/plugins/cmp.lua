return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-emoji", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp"
	},
	config = function()
		local cmp = require("cmp")

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and
			vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			sources = {
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "emoji" }
			},
			view = {
				entries = { name = "custom", selection_order = "near_cursor" }
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
					local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					kind.kind = " " .. (strings[1] or "") .. " "
					kind.menu = "    (" .. (strings[2] or "") .. ")"

					return kind
				end,
			},
			experimental = { ghost_text = { hl_group = "CmpGhostText" } },
			completion = {
				keyword_length = 4,
				completeopt = "menu,menuone,noselect"
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
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<Esc>'] = cmp.mapping.abort()
			}
		})
	end
}
