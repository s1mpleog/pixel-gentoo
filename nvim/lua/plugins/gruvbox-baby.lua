return {
  "luisiacc/gruvbox-baby",
  lazy = false,
  priority = 1000,
  config = function()
    -- Disable italics globally by setting styles to NONE or non-italic values
    vim.g.gruvbox_baby_comment_style = "NONE" -- Comments (default: italic)
    vim.g.gruvbox_baby_keyword_style = "NONE" -- Keywords like return, if, etc. (default: italic)
    vim.g.gruvbox_baby_string_style = "NONE" -- Strings (default: nocombine, but can have italic in some contexts)
    vim.g.gruvbox_baby_function_style = "NONE" -- Functions (default: bold, set to NONE if needed)
    vim.g.gruvbox_baby_variable_style = "NONE" -- Variables (default: NONE already)

    -- Your existing customizations
    vim.g.gruvbox_baby_telescope_theme = 1
    vim.g.gruvbox_baby_transparent_mode = 1
    vim.g.gruvbox_baby_background_color = "dark"

    -- Load the colorscheme (uncomment this if not loaded elsewhere)
    -- vim.cmd.colorscheme "gruvbox-baby"
  end,
}
