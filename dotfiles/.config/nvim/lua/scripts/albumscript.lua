local M = {}

function M.process_metadata()
  -- Store current register states
  local saved_unnamed = vim.fn.getreginfo('"')
  local saved_clipboard = vim.fn.getreginfo('+')

  -- Read buffer lines
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local has_album_gain = vim.fn.search('^REPLAYGAIN_ALBUM_GAIN = ', 'nw') > 0
  local has_albumartists = vim.fn.search('^ALBUMARTISTS = ', 'nw') > 0

  -- Identify all ARTIST lines
  local artist_lines = {}
  for _, line in ipairs(lines) do
    if line:match("^ARTIST = ") then
      table.insert(artist_lines, line)
    end
  end

  local all_artists_same = #artist_lines > 0
  for i = 2, #artist_lines do
    if artist_lines[i] ~= artist_lines[1] then
      all_artists_same = false
      break
    end
  end

  -- 1. General Deletions (Black hole)
  vim.cmd([[silent! %g/^\(REPLAYGAIN_TRACK_PEAK\|REPLAYGAIN_ALBUM_PEAK\|ORIGINAL_DATE\|ORIGINAL_YYYY_MM\|DATE_ADDED\) = /d _]])

  -- 2. Conditional Artist Deletion
  if all_artists_same then
    vim.cmd([[silent! %g/^ARTIST = /d _]])
  end

  -- 3. Conditional Gain Removal
  if has_album_gain then
    vim.cmd([[silent! %g/^REPLAYGAIN_TRACK_GAIN = /d _]])
  end
  vim.cmd([[silent! %g/^REPLAYGAIN_ALBUM_GAIN = /d _]])

  -- 4. Tag Duplication/Renaming
  if not has_albumartists then
    vim.cmd([[silent! %s/^\(CUSTOM_ALBUMARTIST\) = \(.*\)/ALBUMARTISTS = \2\r\1 = \2/ge]])
  end

  -- 5. Swap Album/Artist Order
  vim.cmd([[silent! %s/^\(ALBUM = .*\)\n\(ALBUMARTISTS\? = .*\)/\2\r\1/ge]])

  -- 6. Formatting (Numbers & Quotes)
  vim.cmd([[silent! %s/TRACKNUMBER = "0*\(\d\+\)"/TRACKNUMBER = \1/ge]])
  vim.cmd([[silent! %s/DISCNUMBER = "0*\(\d\+\)"/DISCNUMBER = \1/ge]])
  vim.cmd([[silent! %g/^UNIX_ADDED_\(FOOBAR\|APPLEMUSIC\|YOUTUBE\)/s/"//ge]])

  -- 7. Whitespace Management
  vim.cmd([[silent! %s/^\[album\]$/[album]\r/ge]])
  vim.cmd([[silent! %s/\n\{3,}/\r\r/ge]])

  -- 8. Save
  vim.cmd("silent! write")

  -- Restore Registers
  vim.fn.setreg('"', saved_unnamed)
  vim.fn.setreg('+', saved_clipboard)
end

return M
