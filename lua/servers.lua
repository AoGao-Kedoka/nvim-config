-- --------------------
-- Python (ty)
-- --------------------
vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = {
        "ty.toml",
        "pyproject.toml",
        ".git",
    },
})

-- --------------------
-- C / C++ / CUDA
-- --------------------
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },
})

-- --------------------
-- GLSL analyzer
-- --------------------
vim.lsp.config("glsl_analyzer", {
    cmd = { "glsl_analyzer", "--lsp" },
    filetypes = { "glsl", "vert", "tesc", "tese", "geom", "frag", "comp" },
    root_markers = { ".git" },
})

-- --------------------
-- slangd
-- --------------------
vim.lsp.config("slangd", {
    cmd = { "slangd" },
    filetypes = { "slang", "slangh", "slangf", "slangv" },
    root_markers = { "slang.json", ".git" },
})

-- --------------------
-- CMake Lanuage Server
-- --------------------
vim.lsp.config("cmake-language-server", {
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
    root_markers = { "CMakeLists.txt", ".git" },
})


-- --------------------
-- Rust
-- --------------------
vim.lsp.config("rust-analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
})

-- --------------------
-- Latex
-- --------------------
vim.lsp.config("texlab", {
    cmd = { "textlab", "--stdio" },
    filetypes = { "tex", "bib" },
    root_markers = { ".git", ".texlab.json", "texlab.json" },
})

-- --------------------
-- Lua
-- --------------------
vim.lsp.config("lua-language-server", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".git", "lua-language-server-root" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- Enable the server
vim.lsp.enable("rust-analyzer")
vim.lsp.enable({"ty"})
vim.lsp.enable({"clangd"})
vim.lsp.enable({"glsl_analyzer"})
vim.lsp.enable("slangd")
-- vim.lsp.enable("cmake-language-server")
vim.lsp.enable("textlab")
vim.lsp.enable("lua-language-server")
vim.lsp.inlay_hint.enable(true, {0})
vim.keymap.set("n", '<leader>i',
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0}) 
end
)
