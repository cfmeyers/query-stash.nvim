local M = {}

local function set_status_line(connection_name)
    local db_symbol = "❄"
    vim.o.statusline = db_symbol .. " " .. connection_name .. " " .. db_symbol
end

M.set_status_line = set_status_line
return M
