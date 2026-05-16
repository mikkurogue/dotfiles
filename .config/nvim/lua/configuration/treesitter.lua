return {
  "romus204/tree-sitter-manager.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("tree-sitter-manager").setup({
      ensure_installed = {
        "bash", "c", "css", "csv", "diff", "dockerfile",
        "git_config", "gitignore", "glimmer", "glsl",
        "go", "gomod", "gosum", "html", "javascript", "jsdoc",
        "json", "lua", "make", "markdown", "nix", "query",
        "rust", "sql", "toml", "tsx", "typescript",
        "vim", "vimdoc", "xml", "yaml", "zig",
      },
      auto_install = true,
      highlight = true,
    })
  end,
}
