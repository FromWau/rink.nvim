# rink.nvim

Evaluate expressions using [`rink`](https://github.com/YourRinkRepo) from Neovim.  
Supports **plugin-local installation**, **async execution**, and visual selection evaluation.

---

## Installation

### Using `lazy.nvim`

```lua
return {
    {
        "FromWau/rink.nvim",
        opts = {},
        keys = {
            { "<leader>h", function() require("rink").rink() end, desc = "Rink", mode = "v" },
        },
    },
}
```

### Usage

Select text in visual mode and press <leader>h to evaluate it.
If rink is not installed, it will be installed locally for the plugin.
Result is for now printed in the command line

