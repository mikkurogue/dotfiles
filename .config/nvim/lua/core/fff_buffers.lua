local v = vim

-- A "currently open buffers" source for fff.nvim
--
-- fff's index is repo-wide and has no buffers mode, so this patches the
-- picker's file search: while the buffers picker is open, every ranked
-- result is filtered down to loaded, listed buffers. Touches fff internals
-- (`fff.file_picker`), so it may need a tweak after fff updates.

-- true while the buffers-only picker is open
local buffers_only = false
-- filtered buffer ranking of the last buffers-only search (used for counts)
local buffers_page = nil

local M = {}

--- Open the fff picker scoped to the currently open (listed) buffers.
function M.find_buffers()
  buffers_only = true
  require("fff").find_files({ title = "Buffers" })
end

--- Install the search filter. Call once after `require("fff").setup()`.
function M.setup()
  local file_picker = require("fff.file_picker")
  local canonicalize = require("fff.utils").canonicalize_fff_path

  local search_files_paginated = file_picker.search_files_paginated
  local get_search_metadata = file_picker.get_search_metadata

  -- Absolute paths of all loaded, listed buffers, as a lookup set
  local function open_buffer_paths()
    local paths = {}
    for _, bufnr in ipairs(v.api.nvim_list_bufs()) do
      if v.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
        local name = v.api.nvim_buf_get_name(bufnr)
        if name ~= "" then paths[v.fs.normalize(vim.fn.fnamemodify(name, ":p"))] = true end
      end
    end
    return paths
  end

  file_picker.search_files_paginated = function(query, current_file, max_threads, min_combo, page_index, page_size)
    if not buffers_only then
      return search_files_paginated(query, current_file, max_threads, min_combo, page_index, page_size)
    end

    -- Buffers are few but not guaranteed to cluster at the top of the
    -- repo-wide frecency ranking, so fetch a wider slice than one page and
    -- keep only buffers from it.
    local ps = page_size or 100
    local results =
      search_files_paginated(query, current_file, max_threads, min_combo, 0, math.max(ps * 20, 1000)) or {}

    local open = open_buffer_paths()
    buffers_page = {}
    for _, item in ipairs(results) do
      local abs = canonicalize(item.relative_path)
      if abs and open[v.fs.normalize(abs)] then buffers_page[#buffers_page + 1] = item end
    end

    -- Slice the filtered ranking into pages so fff's pagination still works.
    local start = (page_index or 0) * ps + 1
    local page = {}
    for i = start, math.min(start + ps - 1, #buffers_page) do
      page[#page + 1] = buffers_page[i]
    end
    return page
  end

  -- fff reads match counts from here; report the filtered counts so the
  -- matched/total display next to the prompt stays correct.
  file_picker.get_search_metadata = function()
    if not buffers_only then return get_search_metadata() end
    local total = buffers_page and #buffers_page or 0
    return { total_matched = total, total_files = total }
  end

  -- The buffers picker is find_files with a filter flag; make sure the flag
  -- never outlives the picker session.
  v.api.nvim_create_autocmd("User", {
    pattern = "FFFClose",
    callback = function()
      buffers_only = false
      buffers_page = nil
    end,
  })
end

return M
