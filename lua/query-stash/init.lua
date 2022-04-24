local M = {}
local CURRENT_BUFFER = 0 -- current buffer
local DB = require("query-stash.db")

local function setup(parameters)
    PATH_TO_EXECUTABLE = parameters["path_to_executable"]
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
    table.insert(results, 1, "/*")
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

local function test_harness()
    local query = "select * from dbt_collin.raw_customers limit 1"
    local sqlite_query = "SELECT * FROM queries LIMIT 10;"
    results = DB.get_results_from_query(sqlite_query)
    for k, v in pairs(results) do
        write_query_results_to_buffer(lines(v.query_text), 99)
    end
end

M.test_harness = test_harness
M.send_visual_selection_to_query_stash = send_visual_selection_to_query_stash
M.setup = setup
return M
