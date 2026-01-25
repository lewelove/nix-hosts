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
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  local ft = vim.bo[buf].filetype
  local bt = vim.bo[buf].buftype
  local exists = vim.fn.filereadable(buf_name) == 1

  -- Never rename special buffers (terminals, help, oil, etc.)
  if bt ~= "" then return end
  -- Only proceed if we can actually modify the buffer
  if not vim.bo[buf].modifiable or vim.bo[buf].readonly then return end

  -- Strict Guard: Only work on text/md OR buffers that don't exist yet
  if not (ft == "text" or ft == "markdown" or buf_name == "" or not exists) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local first_line
  for _, l in ipairs(lines) do
    if l:match("%S") then
      first_line = l
      break
    end
  end
  if not first_line then return end

  local clean_text = first_line:gsub('[<>:"/\\|%?%*]', "_")
  clean_text = clean_text:gsub("^%.+", "") -- Remove leading dots
  clean_text = clean_text:gsub("%s+", " ")
  clean_text = clean_text:match("^%s*(.-)%s*$")
  
  if #clean_text > 45 then
    clean_text = vim.fn.strcharpart(clean_text, 0, 45):match("^(.-)%s*$")
  end
  if #clean_text == 0 then clean_text = "untitled" end

  local timestamp = os.date("!%Y%m%d-%H%M%S")
  
  local extension = (ft == "markdown") and ".md" or ".txt"
  local filename = timestamp .. " " .. clean_text .. extension
  
  local target_dir
  if buf_name ~= "" then
    target_dir = vim.fn.fnamemodify(buf_name, ":p:h")
  else
    target_dir = vim.fn.getcwd()
    
    if target_dir == "" or target_dir == vim.fn.expand("~") then
       target_dir = vim.fn.expand("~/Notes")
    end
  end

  local new_path = target_dir .. "/" .. filename
  local current_path = vim.fn.expand("%:p")

  if current_path ~= new_path then
    if vim.fn.isdirectory(target_dir) == 0 then
      vim.fn.mkdir(target_dir, 'p')
    end

    local success = pcall(function()
      vim.cmd("saveas! " .. vim.fn.fnameescape(new_path))
    end)

    if success then
      if exists and current_path ~= "" and current_path ~= new_path then
        vim.fn.delete(current_path)
      end
      vim.cmd("file " .. vim.fn.fnameescape(new_path))
    end
  end
end

-- Create new empty buffer in the same directory as current file
_G.NewBufferSameDir = function()
  if vim.bo.buftype ~= "" then return end

  local current_buf_path = vim.api.nvim_buf_get_name(0)
  local target_dir

  if current_buf_path ~= "" then
    target_dir = vim.fn.fnamemodify(current_buf_path, ":p:h")
  else
    target_dir = vim.fn.expand("~/Notes")
  end

  vim.cmd("enew")

  if vim.fn.isdirectory(target_dir) == 1 then
    vim.cmd("lcd " .. vim.fn.fnameescape(target_dir))
  end
end

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

