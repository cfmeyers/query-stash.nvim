local M = {}

local sqlite = require("sqlite.db")
local SQLITE_DB_URI = "~/.config/query-stash/query-stash.db"

QueryResult = {}

function QueryResult:new(t)
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

local db = sqlite {uri = SQLITE_DB_URI}
local function get_results_from_query(query)
    db:open()
    local results = db:eval(query)
    db:close()

    local query_results = {}
    for _, r in pairs(results) do
        table.insert(query_results, QueryResult:new(r))
    end
    return query_results
end

M.get_results_from_query = get_results_from_query
return M
