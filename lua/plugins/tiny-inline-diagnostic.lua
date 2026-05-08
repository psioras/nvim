return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      options = {
        show_source = true,
        multilines = true,
        overflow = { mode = "wrap" },
        virt_texts = { priority = 2048 },
      },
    })
    -- Disable default inline diagnostics so tiny-inline takes over
    vim.diagnostic.config({ virtual_text = false })
  end,
}
