# rink.nvim

Evaluate expressions using [`rink`](https://github.com/tiffany352/rink-rs) for Neovim.  


https://github.com/user-attachments/assets/79c4841a-1c64-47b2-8f07-f641f8a7d2df

---

## Installation

<details>
    <summary>lazy.nvim</summary>
    
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
</details>

## Usage
- Select text in visual mode and press <leader>h to evaluate it.
- If rink is not installed, it will be installed locally for the plugin.
- Result is for now printed in the command line
