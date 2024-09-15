local M = {}

local function set_status_line(connection_name)
    if connection_name then
        local db_symbol = "📊"  -- Default database symbol
        local env_symbol = "⚪"  -- Default environment symbol
        local lower_connection = connection_name:lower()

        -- Database symbols
        local db_symbols = {
            { pattern = "snowflake", symbol = "❄" },
            { pattern = "clickhouse", symbol = "🏠" },
            { pattern = "mysql", symbol = "🐬" },
            { pattern = "duckdb", symbol = "🦆" },
            { pattern = "sqlite", symbol = "🗄️" },
            { pattern = "postgres", symbol = "🐘" },
        }

        -- Environment symbols
        local env_symbols = {
            { pattern = "prod", symbol = "🦄" },  -- Unicorn
            { pattern = "dev", symbol = "🐣" },   -- Hatching chick
        }

        -- Set database symbol
        for _, db in ipairs(db_symbols) do
            if lower_connection:match(db.pattern) then
                db_symbol = db.symbol
                break
            end
        end

        -- Set environment symbol
        for _, env in ipairs(env_symbols) do
            if lower_connection:match(env.pattern) then
                env_symbol = env.symbol
                break
            end
        end

        vim.o.statusline = "    " .. env_symbol .. db_symbol .. " " .. connection_name ..
                           " " .. db_symbol .. env_symbol
    end
end

M.set_status_line = set_status_line
return M
