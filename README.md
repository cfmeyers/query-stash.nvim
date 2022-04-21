# query-stash.nvim


# TODO

- [X] write function to send visual selection to query-stash
- [X] make `setup` function
- [X] make keymap example
- [X] update "send to query-stash" functions to take optional connection-name arg
- [ ] update setup functions to take optional config-path arg
- [ ] write function to send current paragraph to query-stash
- [ ] add vim help file
- [ ] add explanation with links to query-stash in README.md


Example configuration:
```lua
require("query-stash").setup(
    {
        path_to_executable = "~/src/github.com/cfmeyers/query-stash/venv/bin/query-stash",
    }
)
```

Example mapping:
```vim
vnoremap ,f :lua require('query-stash').send_visual_selection_to_query_stash() <cr>
```
