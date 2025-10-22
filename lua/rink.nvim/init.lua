local M = {}

-- The 'rink' function
M.rink = function()
    print("rink")
end

-- Optional: create a Neovim command for lazy loading
vim.api.nvim_create_user_command("Rink", function()
    M.rink()
end, {})

return M
