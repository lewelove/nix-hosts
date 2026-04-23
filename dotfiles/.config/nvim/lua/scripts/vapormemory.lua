local M = {}

function M.process_vapor_metadata()
  -- Check for Vaporwave genre with semicolon as requested
  -- If not found, the script exits immediately without changing anything
  local is_vaporwave = vim.fn.search([[^GENRE = "Vaporwave"]], 'nw') > 0
  if not is_vaporwave then return end

  -- Store current register states to protect copy-buffer
  local saved_unnamed = vim.fn.getreginfo('"')
  local saved_clipboard = vim.fn.getreginfo('+')

  -- Scan buffer for tag state
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local has_album_gain = vim.fn.search('^REPLAYGAIN_ALBUM_GAIN = ', 'nw') > 0
  local has_albumartists = vim.fn.search('^ALBUMARTISTS = ', 'nw') > 0
  local has_collection = vim.fn.search('^COLLECTION = "Vapor Memory"', 'nw') > 0

  -- Identify all ARTIST lines to verify if they are identical
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

  -- General Deletions (Black hole register)
  vim.cmd([[silent! %g/^\(REPLAYGAIN_TRACK_PEAK\|REPLAYGAIN_ALBUM_PEAK\|ORIGINAL_DATE\|ORIGINAL_YYYY_MM\|DATE_ADDED\) = /d _]])

  -- Delete ARTIST lines only if identical across the whole file
  if all_artists_same then
    vim.cmd([[silent! %g/^ARTIST = /d _]])
  end

  -- Execute track gain removal only if album gain was present
  if has_album_gain then
    vim.cmd([[silent! %g/^REPLAYGAIN_TRACK_GAIN = /d _]])
  end
  vim.cmd([[silent! %g/^REPLAYGAIN_ALBUM_GAIN = /d _]])

  -- Insert Vapor Memory collection tag above the first [[tracks]] header
  if not has_collection then
    -- Finds the first [[tracks]] and inserts the tag + empty line above it
    vim.cmd([[silent! 0/^\[\[tracks\]\]/s/^/COLLECTION = "Vapor Memory"\r\r/e]])
  end

  -- Duplicate CUSTOM_ALBUMARTIST into ALBUMARTISTS only if missing
  if not has_albumartists then
    vim.cmd([[silent! %s/^\(CUSTOM_ALBUMARTIST\) = \(.*\)/ALBUMARTISTS = \2\r\1 = \2/ge]])
  end

  -- Swap ALBUM and ALBUMARTIST order
  vim.cmd([[silent! %s/^\(ALBUM = .*\)\n\(ALBUMARTISTS\? = .*\)/\2\r\1/ge]])

  -- Format numbers: remove quotes and leading zeros
  vim.cmd([[silent! %s/TRACKNUMBER = "0*\(\d\+\)"/TRACKNUMBER = \1/ge]])
  vim.cmd([[silent! %s/DISCNUMBER = "0*\(\d\+\)"/DISCNUMBER = \1/ge]])

  -- Remove quotes from UNIX timestamps
  vim.cmd([[silent! %g/^UNIX_ADDED_\(FOOBAR\|APPLEMUSIC\|YOUTUBE\)/s/"//ge]])

  -- Ensure one blank line after [album] header
  vim.cmd([[silent! %s/^\[album\]$/[album]\r/ge]])

  -- Squeeze whitespace (remove all consecutive empty lines > 1)
  vim.cmd([[silent! %s/\n\{3,}/\r\r/ge]])

  -- Save changes
  vim.cmd("silent! write")

  -- Restore registers
  vim.fn.setreg('"', saved_unnamed)
  vim.fn.setreg('+', saved_clipboard)

  return true -- Signal successful execution
end

return M
