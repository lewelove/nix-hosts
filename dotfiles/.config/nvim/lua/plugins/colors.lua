return {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    require("nvim-highlight-colors").setup({
      render = "virtual",
      virtual_symbol = "██",
      enable_named_colors = true,
      enable_tailwind = false,
      exclude_filetypes = {
        "lazy",
        "oil",
      },
    })
  end,
}
