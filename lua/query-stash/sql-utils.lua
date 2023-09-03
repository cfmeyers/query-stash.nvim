local M = {}

local function line_starts_with_query_word(i, lines)
    local line = lines[i]:lower()
    cur_line_matches = line:match("^with") or line:match("^select")
    if cur_line_matches then
        return i == 1 or lines[i-1] == ""
    end
end

local function get_line_number_for_next_query()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local blank_line_found = false

  for i = start_line + 1, #lines do
      if line_starts_with_query_word(i, lines) then
          return i
      end
  end

  for i = 1, start_line do
      if line_starts_with_query_word(i, lines) then
          return i
      end
  end

  return nil
end

local function get_line_number_for_previous_query()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local blank_line_found = false

  for i = start_line - 1, 1, -1 do
      if line_starts_with_query_word(i, lines) then
          return i
      end
  end
  for i = #lines, start_line, -1 do
      if line_starts_with_query_word(i, lines) then
          return i
      end
  end

  return nil
end


function jump_to_next_query()
    local line_number = get_line_number_for_next_query()
    if line_number then
        vim.api.nvim_win_set_cursor(0, {line_number, 0})
    end
end

function jump_to_previous_query()
    local line_number = get_line_number_for_previous_query()
    if line_number then
        vim.api.nvim_win_set_cursor(0, {line_number, 0})
    end
end

M.get_line_number_for_next_query = get_line_number_for_next_query
M.jump_to_next_query = jump_to_next_query
M.jump_to_previous_query = jump_to_previous_query
return M
