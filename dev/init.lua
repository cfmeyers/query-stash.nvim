--[[ Development:
- be sure to load the project with vi --cmd "set rtp+=."
- open dev/init.lua first and manually run
    :luafile dev/init.lua
in the command line.  After that, you can refresh the project
in normal mode by hitting ,t
--]] --
for k in pairs(package.loaded) do
    if k:match("^query") then
        package.loaded[k] = nil
    end
end

package.loaded["dev"] = nil

vim.api.nvim_set_keymap("n", ",t", ":luafile dev/init.lua<cr>", {})
vim.api.nvim_set_keymap(
    "v", ",t",
    ":lua require('query-stash').send_visual_selection_to_query_stash()<cr>", {}
)
-- require("query-stash").test_harness()

-- vim.api.nvim_set_keymap("n", ",,", ":lua require('query-stash').test_harness()<cr>.", {})

--[[ test sql

SELECT
    *
FROM dbt_collin.raw_customers
LIMIT 8
/*
| id | first_name | last_name |
| -- | ---------- | --------- |
| 1  | Michael    | P.        |
| -- | ---------- | --------- |
*/

SELECT
    *
FROM account
LIMIT 8


/* ¿2023-08-16 16:25:54?
| ----------- | ----------- |
| flow_1111   | 2015-01-01  |
| *********** | 2015-01-01  |
| *********   | 2015-01-31  |
| ----------- | ----------- |
*/

--]]
