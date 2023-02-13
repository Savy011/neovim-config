local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
	[[ _    _                _    _       ]],
	[[| |  | |              | |  | |      ]],
	[[| |  | | ___  ___  ___| | _| |_   _ ]],
	[[| |/\| |/ _ \/ _ \/ _ \ |/ / | | | |]],
	[[\  /\  /  __/  __/  __/   <| | |_| |]],
	[[ \/  \/ \___|\___|\___|_|\_\_|\__, |]],
	[[                               __/ |]],
	[[                              |___/ ]],
}

--dashboard.section.header.val = {	
--		[[  (`\ .-') /`  ('-.     ('-.     ('-.  .-. .-')                      ]],
--		[[   `.( OO ),'_(  OO)  _(  OO)  _(  OO) \  ( OO )                     ]],
--		[[,--./  .--. (,------.(,------.(,------.,--. ,--.,--.      ,--.   ,--.]],
--		[[|      |  |  |  .---' |  .---' |  .---'|  .'   /|  |.-')   \  `.'  / ]],
--		[[|  |   |  |, |  |     |  |     |  |    |      /,|  | OO ).-')     /  ]],
--		[[|  |.'.|  |_||  '--. (|  '--. (|  '--. |     ' _)  |`-' (OO  \   /   ]],
--		[[|         |  |  .--'  |  .--'  |  .--' |  .   \(|  '---.'|   /  /\_  ]],
--		[[|   ,'.   |  |  `---. |  `---. |  `---.|  |\   \|      | `-./  /.__) ]],
--		[['--'   '--'  `------' `------' `------'`--' '--'`------'   `--'      ]]
--
--}

dashboard.section.buttons.val = {
    dashboard.button("n", "📝   New File", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "🕒   Recent Files", ":lua require('telescope.builtin').oldfiles{}<CR>"),
    dashboard.button("e", "📁   File Browser", ":NvimTreeOpen<CR>"),
    dashboard.button("c", "✨   Change Theme", ":Telescope colorscheme<CR>"),
    dashboard.button("p", "✅   PackerSync", ":PackerSync<CR>"),
    dashboard.button("q", "🛑   Quit NVIM", ":qa<CR>"),
}

dashboard.section.footer.val = {
	'',
	'Can We Do? We Can Do! WEEEKLY!!',
	'',
}
