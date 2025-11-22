map = vim.keymap

map.set("n", "<C-s>", ":w<CR>")

map.set("n", "<Left>", "<Nop>")
map.set("n", "<Right>", "<Nop>")
map.set("n", "<Up>", "<Nop>")
map.set("n", "<Down>", "<Nop>")

map.set("v", "<", "<gv")
map.set("v", ">", ">gv")
