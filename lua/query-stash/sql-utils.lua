
-- luafile dev/init.lua
-- lua vim.api.nvim_set_keymap("n", ",,", ":lua require('query-stash').test_harness()<cr>", {})

local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local plenary = require('plenary')

local M = {}

--- This function checks if the current line is the first line of a SQL query.
-- A line is considered the first line of a query if it starts with "with" or "select",
-- and it is either the first line in the file or the previous line is empty.
-- @param i The index of the current line in the lines table.
-- @param lines A table where each element is a line from the file.
-- @return True if the current line is the first line of a query, false otherwise.
local function is_first_line_of_query(i, lines)
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
      if is_first_line_of_query(i, lines) then
          return i
      end
  end

  for i = 1, start_line do
      if is_first_line_of_query(i, lines) then
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
      if is_first_line_of_query(i, lines) then
          return i
      end
  end
  for i = #lines, start_line, -1 do
      if is_first_line_of_query(i, lines) then
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

--- This function returns a list of all queries in the current buffer and their 
-- starting line numbers. A "query" is a paragraph of text that starts with a line 
-- that satisfies `is_first_line_of_query` and ends with a blank line.
-- It uses the `is_first_line_of_query` function to identify the start of each query.
-- @return A table where each element is a table with two elements: the starting 
-- line number and the query.
local function get_all_queries_in_current_buffer()
    local queries = {}
    local current_query_lines = {}
    local start_line = nil
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    for i, line in ipairs(lines) do

        if is_first_line_of_query(i, lines) then
            -- if #current_query_lines > 0 then
            --     table.insert(queries, {
            --         start_line = start_line, 
            --         query = table.concat(current_query_lines, "\n")
            --     })
            --     current_query_lines = {}
            -- end
            start_line = i
            table.insert(current_query_lines, line)

        elseif #current_query_lines > 0 then
            if line == "" then
                table.insert(queries, {
                    start_line = start_line, 
                    query = table.concat(current_query_lines, "\n")
                })
                current_query_lines = {}
            else
                table.insert(current_query_lines, line)
            end

        end

    end

    if #current_query_lines > 0 then
        table.insert(queries, {
            start_line = start_line, 
            query = table.concat(current_query_lines, "\n")
        })
    end

    return queries
end


-- local function transform_query_for_telescope_select_display(query)
--     return string.gsub(query, "\n", " ")
-- end

local function transform_query_for_telescope_select_display(query)
    query = string.gsub(query, "\n", " ")
    query = string.gsub(query, " +", " ")
    return query
end

local function show_queries_with_telescope()
  local queries = get_all_queries_in_current_buffer()

  pickers.new({}, {
    prompt_title = 'Queries',

    finder = finders.new_table({

      results = queries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = transform_query_for_telescope_select_display(entry.query),
          ordinal = entry.query,
        }
      end

    }),

    sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(
        function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_cursor(win, {selection.value.start_line, 0})
            vim.api.nvim_command('normal! zz')
        end
      )
      return true
    end,

    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry, status)
        -- Save the current cursor position
        -- pcall(vim.cmd, 'normal! m"')

        -- Set the lines of the buffer
        vim.api.nvim_buf_set_lines(
          self.state.bufnr, -- The buffer handle
          0, -- The first line that will be replaced
          -1, -- The last line that will be replaced
          false, -- Whether to keep the cursor position
          vim.split(entry.value.query, "\n") -- The new lines
        )

        -- Set the filetype to SQL for syntax highlighting
        vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'sql')
      end
    }),

  sorting_strategy = "ascending",  -- display results top->bottom
  layout_config = {
    prompt_position = 'top',
  },

  }):find()
end



M.get_line_number_for_next_query = get_line_number_for_next_query
M.jump_to_next_query = jump_to_next_query
M.jump_to_previous_query = jump_to_previous_query
M.get_all_queries_in_current_buffer = get_all_queries_in_current_buffer
M.show_queries_with_telescope = show_queries_with_telescope
return M
