-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "lua", "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Enable spellcheck for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SpellCheck", { clear = true }),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#EA4335" })
vim.api.nvim_set_hl(0, "SpellRare", { underline = false, undercurl = false })
vim.api.nvim_set_hl(0, "SpellLocal", { underline = false, undercurl = false })
vim.api.nvim_set_hl(0, "SpellCap", { underline = false, undercurl = false })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "javascript", "typescript", "json", "html", "css" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Autoname file based on first line
_G.RenameByContent = function()
  local ft = vim.bo.filetype
  if ft ~= "text" and ft ~= "markdown" then return end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local line
  for _, l in ipairs(lines) do
    if l:match("%S") then
      line = l
      break
    end
  end

  if not line then return end
  local timestamp = os.date("!%Y%m%d-%H%M%S")
  local text = line:gsub('[<>:"/\\|%?%*]', "_")
  text = text:gsub("%s+", " ")
  text = text:match("^%s*(.-)%s*$")

  if #text > 45 then
    text = vim.fn.strcharpart(text, 0, 45)
    text = text:match("^(.-)%s*$")
  end
  if #text == 0 then text = "untitled" end

  local filename = timestamp .. " " .. text .. ".txt"
  local buf_name = vim.api.nvim_buf_get_name(0)
  local target_dir = (buf_name == "") and vim.fn.expand("~/Notes") or vim.fn.fnamemodify(buf_name, ":p:h")

  local new_path = target_dir .. "/" .. filename
  local current_path = vim.fn.expand("%:p")

  if current_path ~= new_path then
    if vim.fn.isdirectory(target_dir) == 0 then
      vim.fn.mkdir(target_dir, 'p')
    end

    vim.cmd("saveas! " .. vim.fn.fnameescape(new_path))
    
    if current_path ~= "" and vim.fn.filereadable(current_path) == 1 then
      vim.fn.delete(current_path)
    end
    
    vim.cmd("file " .. vim.fn.fnameescape(new_path))
  end
end

-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(event)
    if event.match:match("^%w+://") then return end
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

