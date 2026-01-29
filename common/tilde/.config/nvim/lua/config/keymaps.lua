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
vim.keymap.set({ 'n', 'v' }, '1', 'g$', { silent = true })
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
-- DIFF NAVIGATION & MERGING
-- =============================================================

-- Jump between hunks
vim.keymap.set("n", "]", "]c", { desc = "Next Change" })
vim.keymap.set("n", "[", "[c", { desc = "Prev Change" })

-- Smart Diff Merge (Leader m)
-- If in DIFF_REVIEW -> Push to original (diffput)
-- If in Original    -> Pull from review (diffget)
vim.keymap.set({ "n", "v" }, "<leader>m", function()
  if vim.fn.bufname("%") == "DIFF_REVIEW" then
    vim.cmd("diffput")
  else
    vim.cmd("diffget")
  end
end, { desc = "Smart Diff Put/Get" })

-- =============================================================
-- DIFF MERGE TOOL (Internal V-Split)
-- =============================================================

vim.keymap.set("n", "<leader>d", function()
  local ft = vim.bo.filetype
  local clipboard = vim.fn.getreg('+')
  if clipboard == "" then
    vim.notify("Clipboard is empty!", vim.log.levels.WARN)
    return
  end

  -- vim.cmd([[
  --   hi DiffAdd guibg=#2d3322 guifg=#a6e22e
  --   hi DiffDelete guibg=#331b1b guifg=#661111
  --   hi DiffChange guibg=#1f2430
  --   hi DiffText guibg=#394b70 guifg=#7aa2f7 gui=bold
  -- ]])

  vim.cmd("diffthis")

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(clipboard, "\n"))
  
  vim.bo[buf].filetype = ft
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_buf_set_name(buf, "DIFF_REVIEW")

  vim.cmd("vsplit")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  
  vim.cmd("diffthis")

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      vim.cmd("diffoff!")
    end,
  })
  
end, { desc = "Diff Merge Tool (Internal)" })

-- =============================================================

-- Reload Configuration
vim.keymap.set("n", "<leader>rl", function()
  for name,_ in pairs(package.loaded) do
    if name:match("^config") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  if vim.fn.expand("%:e") == "lua" then
      pcall(dofile, vim.fn.expand("%"))
  end
  vim.notify("Configuration Reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Config" })
