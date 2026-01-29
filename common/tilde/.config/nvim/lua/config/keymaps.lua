local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Leader Keys
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR> ')

-- No clipboard override
map("n", "x", '"_x')
map({"n", "v"}, "d", '"_d')
map("n", "dd", '"_dd')
map("v", "p", '"_dP')

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better navigation
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { silent = true })
vim.keymap.set({ 'n', 'v' }, '0', 'g0', { silent = true })
vim.keymap.set({ 'n', 'v' }, '$', 'g$', { silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", "gj", { silent = true })
vim.keymap.set({ "n", "v" }, "<Up>", "gk", { silent = true })
vim.keymap.set("i", "<Down>", "<C-o>gj", { silent = true })
vim.keymap.set("i", "<Up>", "<C-o>gk", { silent = true })

-- New buffer in same directory
vim.keymap.set("n", "<leader>a", function() _G.NewBufferSameDir() end, { desc = "New buffer in current dir", silent = true })

-- Autorename by first line
vim.keymap.set("n", "<leader>n", function() _G.RenameByContent() end, { silent = true })

-- Replace whole file with clipboard paste
vim.keymap.set('n', '<leader>v', 'ggVG"_dP | :w<CR>', { desc = 'Paste clipboard to whole buffer' })

-- Copy entire buffer
vim.keymap.set('n', '<leader>y', 'ggVG"+y', { desc = 'Yank whole buffer to clipboard' })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
vim.keymap.set("n", "<leader>e", function()
  require("oil").open()
  vim.schedule(function()
    if vim.bo.filetype == "oil" then
      vim.cmd.edit()
    end
  end)
end, { desc = "Open oil and force refresh" })

vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })

-- Quick config editing
vim.keymap.set("n", "<leader>rc", ":e $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>rl", ":so $MYVIMRC<CR>", { desc = "Reload config" })

vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode", silent = true })

-- Copy Full File-Path
vim.keymap.set("n", "<leader>cfp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

-- =============================================================
-- AI MERGE TOOL (UNIFIED GITHUB LOGIC)
-- =============================================================

vim.keymap.set("n", "<leader>d", function()
  local current_file = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")
  local tmp_file = "/tmp/ai_diff." .. ext
  
  -- 1. Grab Clipboard
  local clipboard = vim.fn.getreg('+')
  if clipboard == "" then
    vim.notify("Clipboard is empty!", vim.log.levels.WARN)
    return
  end
  
  -- 2. Write to Temp
  local f = io.open(tmp_file, "w")
  f:write(clipboard)
  f:close()
  
  -- 3. Construct the "GitHub Review" commands
  local review_setup = table.concat({
    "set diffopt+=iwhite",
    "hi DiffAdd guibg=#2d3322 guifg=#a6e22e", 
    "hi DiffDelete guibg=#331111 guifg=#331111", 
    "hi DiffChange guibg=#332d22",               
    "hi DiffText guibg=#443311 guifg=#fd971f bold", 
  }, " | ")

  -- 4. Spawn Window
  local nvim_cmd = string.format("nvim -d %s %s -c '%s'", current_file, tmp_file, review_setup)
  local terminal_cmd = string.format('hyprctl dispatch exec "foot %s"', nvim_cmd)
  
  vim.fn.jobstart(terminal_cmd)
  vim.notify("Launching AI Reviewer...", vim.log.levels.INFO)
end, { desc = "AI Merge Tool" })

-- =============================================================

-- Reload Configuration
vim.keymap.set("n", "<leader>rl", function()
  -- 1. Clear Lua Cache for your config modules
  for name,_ in pairs(package.loaded) do
    if name:match("^config") then
      package.loaded[name] = nil
    end
  end

  -- 2. Reload init.lua
  dofile(vim.env.MYVIMRC)
  
  -- 3. Re-source specific file if you are currently editing one
  if vim.fn.expand("%:e") == "lua" then
      pcall(dofile, vim.fn.expand("%"))
  end

  vim.notify("Configuration Reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Config" })
