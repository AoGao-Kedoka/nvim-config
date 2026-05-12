local opts = { noremap=true, silent=true }

-- Ctrl+T to search files
vim.api.nvim_set_keymap(
    "n",
    "<C-t>",
    ":Files<CR>",
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
    "n",
    "<leader>ff",
    ":Files<CR>",
    { noremap = true, silent = true }
)

-- Ctril+R to search in files
vim.api.nvim_set_keymap(
    "n",
    "<leader>fr",
    ":Rg<CR>",
    { noremap = true, silent = true }
)

-- Ctrl+n to toggle the file tree
vim.api.nvim_set_keymap(
  "n",
  "<C-n>",
  ":NvimTreeToggle<CR>",
  { noremap = true, silent = true }
)

-- <leader>c to toggle copilot chat
vim.api.nvim_set_keymap(
  "n",
  "<leader>c",
  ":CopilotChatToggle<CR>",
  { noremap = true, silent = true }
)

-- Navigation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)


-- Hover / signature
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

-- Actions
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
vim.keymap.set("n","<leader>ds",vim.lsp.buf.document_symbol,{ desc = "Document Symbols" })

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

-- avante
vim.keymap.set("n", "<leader>an", ":AvanteChatNew", { noremap = true, silent = true, desc = "Avante" })

-- ToggleTerm mappings
local directions = {
  [""]  = { direction = "float" },
  ["v"] = { direction = "vertical",   size = math.floor(vim.o.columns * 0.4) },
  ["h"] = { direction = "horizontal", size = math.floor(vim.o.lines * 0.3) },
}

-- Aliases for terminal #1
for suffix, opts in pairs(directions) do
  vim.keymap.set("n", "<leader>t" .. suffix, function()
    local cmd = "1ToggleTerm direction=" .. opts.direction
    if opts.size then
      cmd = cmd .. " size=" .. opts.size
    end
    vim.cmd(cmd)
  end, {
    desc = "Toggle terminal #1 (" .. opts.direction .. ")",
  })
end

-- Numbered terminals: <leader>t1 .. <leader>t9
for i = 1, 9 do
  for suffix, opts in pairs(directions) do
    vim.keymap.set("n", "<leader>t" .. i .. suffix, function()
      local cmd = i .. "ToggleTerm direction=" .. opts.direction
      if opts.size then
        cmd = cmd .. " size=" .. opts.size
      end
      vim.cmd(cmd)
    end, {
      desc = string.format(
        "Toggle terminal #%d (%s)",
        i,
        opts.direction
      ),
    })
  end
end

