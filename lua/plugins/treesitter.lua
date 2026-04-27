return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- We call the main module directly now
      require('nvim-treesitter').setup({
  ensure_installed = { "lua", "vim", "vimdoc" },
  highlight = { enable = true },
})
    end,
  },
}
