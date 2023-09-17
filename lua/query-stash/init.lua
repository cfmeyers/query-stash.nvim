local M = {}
local CURRENT_BUFFER = 0 -- current buffer
local DB = require("query-stash.db")
local STATUS_LINE = require("query-stash.status-line")
local SQL_UTILS = require("query-stash.sql-utils")

local function setup(parameters)
    PATH_TO_EXECUTABLE = parameters["path_to_executable"]
    CONNECTION_NAMES = parameters["connection_names"]
    STATUS_LINE.set_status_line(CONNECTION_NAMES[1])
end

local function get_visual_index_range()
    local start_index = vim.api.nvim_buf_get_mark(CURRENT_BUFFER, "<")[1] - 1
    local end_index = vim.api.nvim_buf_get_mark(CURRENT_BUFFER, ">")[1]
    return {start_index, end_index}
end

local function get_current_visual_selection_as_string()
    local result = get_visual_index_range()
    local start_index, end_index = unpack(get_visual_index_range())
    local lines = vim.api.nvim_buf_get_lines(
                      CURRENT_BUFFER, start_index, end_index, false
                  )
    return table.concat(lines, "\n")
end

local function wrap_results_in_multiline_comments(results)
    table.insert(results, 1, "/* ¿" .. os.date("%Y-%m-%d %H:%M:%S") .. "?")
    table.insert(results, 1, "")
    table.insert(results, "*/")
    table.insert(results, "")
    return results
end

local function call_query_stash(query, connection_name)
    if connection_name ~= nil then
        connection_name_arg = " --connection-name=" .. connection_name
    else
        connection_name_arg = ""
    end

    local command = PATH_TO_EXECUTABLE .. " query \"" .. query .. "\"" ..
                        connection_name_arg
    local results = vim.fn.systemlist(command)
    return wrap_results_in_multiline_comments(results)
end

local function lines(initial_str)
    local result = {}
    for line in initial_str:gmatch "[^\n]+" do
        table.insert(result, line)
    end
    return result
end

local function write_query_results_to_buffer(results, line_index_start)
    vim.api.nvim_buf_set_lines(
        CURRENT_BUFFER, line_index_start, line_index_start, false, results
    )
end

local function send_visual_selection_to_query_stash(connection_name)
    local start_index, end_index = unpack(get_visual_index_range())
    local query = get_current_visual_selection_as_string()
    local results = call_query_stash(query, connection_name)
    write_query_results_to_buffer(results, end_index)
end

-- local function test_harness()
    -- local query = "select * from dbt_collin.raw_customers limit 1"
    -- local sqlite_query = "SELECT * FROM queries LIMIT 10;"
    -- results = DB.get_results_from_query(sqlite_query)
    -- for k, v in pairs(results) do
    --     write_query_results_to_buffer(lines(v.query_text), 99)
    -- end
-- end

local function test_harness()
    -- result = SQL_UTILS.get_line_number_for_next_query()
    -- require("notify")(tostring(result))
    -- SQL_UTILS.jump_to_next_query()
    -- put(SQL_UTILS.get_all_queries_in_current_buffer())
    -- SQL_UTILS.show_queries_with_telescope()
    -- SQL_UTILS.jump_to_previous_cell()
    SQL_UTILS.jump_to_last_cell()
end

M.test_harness = test_harness
M.send_visual_selection_to_query_stash = send_visual_selection_to_query_stash
M.setup = setup
M.jump_to_next_query = SQL_UTILS.jump_to_next_query
M.jump_to_previous_query = SQL_UTILS.jump_to_previous_query
M.show_queries_with_telescope = SQL_UTILS.show_queries_with_telescope
M.jump_to_next_cell = SQL_UTILS.jump_to_next_cell
M.jump_to_previous_cell = SQL_UTILS.jump_to_previous_cell
M.jump_to_last_cell = SQL_UTILS.jump_to_last_cell
M.jump_to_first_cell = SQL_UTILS.jump_to_first_cell
return M
