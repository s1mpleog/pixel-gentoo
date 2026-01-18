-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  --{ import = "astrocommunity.colorscheme.gruvbox-baby" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.colorscheme.nord-nvim" },
  --{ import = "astrocommunity.colorscheme.everforest" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.nim" },
  { import = "astrocommunity.pack.zig" },
  { import = "astrocommunity.pack.eslint" },
  --{ import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },
  --{ import = "astrocommunity.completion.coq_nvim" },
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },
  --{ import = "astrocommunity.lsp.nvim-lint" },
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  --{ import = "astrocommunity.lsp.garbage-day-nvim" },
  { import = "astrocommunity.diagnostics.tiny-inline-diagnostic-nvim" },
  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  -- { import = "astrocommunity.note-taking.neorg" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  --{ import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.comment.mini-comment" },
  { import = "astrocommunity.indent.indent-blankline-nvim" },
  -- import/override with your plugins folder
}
