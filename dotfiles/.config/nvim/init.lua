require("config.options")

require("config.keymaps")

require("config.lazy")

require("config.autocmds")

local album_script = require("scripts.albumscript")

vim.api.nvim_create_user_command('AlbumScript', function()
  album_script.process_metadata()
  vim.notify("AlbumScript: Processed and saved.", vim.log.levels.INFO)
end, { desc = "Run album metadata cleanup" })

local vapor_script = require("scripts.vapormemory")

vim.api.nvim_create_user_command('VaporMemory', function()
  local success = vapor_script.process_vapor_metadata()
  if success then
    vim.notify("VaporMemory: Processed and saved.", vim.log.levels.INFO)
  else
    vim.notify("VaporMemory: Skipped (Not Vaporwave).", vim.log.levels.WARN)
  end
end, { desc = "Run specialized Vapor Memory cleanup" })
