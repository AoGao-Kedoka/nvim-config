local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local categories = {"color_schemes", "appearance", "utilities", "lsp_debugging"}
local plugins = {}
for _, category in ipairs(categories) do
    local plugin_file = require("plugins." .. category)
    for _, plugin in ipairs(plugin_file) do
        table.insert(plugins, plugin)
    end
end

require("lazy").setup(plugins)
