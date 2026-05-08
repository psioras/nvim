return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
          },
        },
        fidget = true,
        trouble = true,
      },
    })

    -- Always start with mocha
    vim.g.catppuccin_flavour = "mocha"
    vim.cmd.colorscheme("catppuccin-mocha")

    -- <leader>tt to toggle between mocha and frappe
    vim.keymap.set("n", "<leader>tt", function()
      if vim.g.catppuccin_flavour == "mocha" then
        vim.g.catppuccin_flavour = "frappe"
      else
        vim.g.catppuccin_flavour = "mocha"
      end
      vim.cmd.colorscheme("catppuccin-" .. vim.g.catppuccin_flavour)
      vim.notify("Theme: catppuccin-" .. vim.g.catppuccin_flavour, vim.log.levels.INFO)
    end, { desc = "Toggle Catppuccin Frappé/Mocha" })
  end,
}
