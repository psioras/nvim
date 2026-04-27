return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Suppress the vim.lsp.get_log_path deprecation notice on startup
      vim.deprecate = (function(original)
        return function(name, alternative, version, plugin, backtrace)
          if name == "vim.lsp.get_log_path" then return end
          original(name, alternative, version, plugin, backtrace)
        end
      end)(vim.deprecate)

      local fzf = require("fzf-lua")

      fzf.setup({
        -- Use the same Catppuccin Mocha colors as your shell fzf config
        fzf_colors = {
          ["fg"]      = { "fg", "CursorLine" },
          ["bg"]      = { "bg", "Normal" },
          ["hl"]      = { "fg", "Comment" },
          ["fg+"]     = { "fg", "Normal" },
          ["bg+"]     = { "bg", "CursorLine" },
          ["hl+"]     = { "fg", "Statement" },
          ["info"]    = { "fg", "PreProc" },
          ["prompt"]  = { "fg", "Conditional" },
          ["pointer"] = { "fg", "Exception" },
          ["marker"]  = { "fg", "Keyword" },
          ["spinner"] = { "fg", "Label" },
          ["header"]  = { "fg", "Comment" },
          ["border"]  = { "fg", "FloatBorder" },
        },

        -- Window appearance
        winopts = {
          height  = 0.85,
          width   = 0.90,
          row     = 0.35,
          col     = 0.50,
          border  = "rounded",
          preview = {
            border       = "border",
            wrap         = "nowrap",
            hidden       = "nohidden",
            vertical     = "down:45%",
            horizontal   = "right:55%",
            layout       = "flex", -- auto-switches based on terminal size
            flip_columns = 120,
            title        = true,
            scrollbar    = "float",
          },
        },

        -- Keymaps inside the fzf window
        keymap = {
          builtin = {
            ["?"]     = "toggle-help",
            ["<C-/>"] = "toggle-preview",
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-u>"] = "preview-half-page-up",
            ["<C-d>"] = "preview-half-page-down",
          },
          fzf = {
            ["ctrl-/"] = "toggle-preview",
            ["ctrl-a"] = "select-all+accept",
            ["ctrl-u"] = "preview-half-page-up",
            ["ctrl-d"] = "preview-half-page-down",
          },
        },

        -- bat for file previews (same as your shell config)
        previewers = {
          bat = {
            cmd   = "bat",
            args  = "--color=always --style=numbers,changes",
            theme = "Catppuccin Mocha", -- remove if you haven't installed this bat theme
          },
        },

        files = {
          cmd         = "fd --hidden --follow --strip-cwd-prefix --exclude .git",
          git_icons   = true,
          file_icons  = true,
          color_icons = true,
          fzf_opts    = { ["--scheme"] = "path" },
          actions     = {
            -- Alt-Up inside the picker → re-open from parent directory
            ["alt-up"] = function(_, opts)
              local parent = vim.fn.fnamemodify(opts.cwd or vim.fn.getcwd(), ":h")
              require("fzf-lua").files({ cwd = parent })
            end,
            -- Alt-Down / Enter on a dir → cd into it and re-open
            ["alt-down"] = function(selected, opts)
              local path = require("fzf-lua").path.entry_to_file(selected[1]).path
              local fullpath = (opts.cwd or vim.fn.getcwd()) .. "/" .. path
              if vim.fn.isdirectory(fullpath) == 1 then
                require("fzf-lua").files({ cwd = fullpath })
              end
            end,
          },
        },
        -- live_grep via ripgrep
        grep = {
          rg_opts     = "--hidden --column --line-number --no-heading "
              .. "--color=always --smart-case --glob='!.git'",
          git_icons   = true,
          file_icons  = true,
          color_icons = true,
        },

        git = {
          files = {
            cmd         = "git ls-files --exclude-standard",
            git_icons   = true,
            file_icons  = true,
            color_icons = true,
          },
        },

        -- Replace vim.ui.select (was telescope-ui-select)
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              height = math.floor(math.min(vim.o.lines * 0.80, #items + 4) + 0.5) / vim.o.lines,
              width  = 0.55,
              row    = 0.40,
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = { width = 0.65, preview = { layout = "vertical" } },
          } or {})
        end,
      })

      -- Register as the vim.ui.select handler (replaces telescope-ui-select).
      -- Guard prevents the "already registered" warning on re-source / hot-reload.
      if vim.ui.select ~= require("fzf-lua.providers.ui_select").ui_select then
        fzf.register_ui_select()
      end

      -- ── Keymaps (same as your telescope config) ──────────────────────
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
      end

      -- <leader><leader> → find files  (was builtin.find_files)
      map("<leader><leader>", fzf.files, "Find Files")

      -- <leader>ff → live grep  (was builtin.live_grep)
      map("<leader>ff", fzf.live_grep, "Live Grep")

      -- <leader>gf → git files  (was builtin.git_files)
      map("<leader>gf", fzf.git_files, "Git Files")

      -- ── Bonus keymaps (uncomment what you want) ───────────────────────
      -- map("<leader>fb", fzf.buffers,    "Find Buffers")
      -- map("<leader>fh", fzf.help_tags,  "Help Tags")
      -- map("<leader>fr", fzf.oldfiles,   "Recent Files")
      -- map("<leader>fc", fzf.commands,   "Commands")
      -- map("<leader>fd", fzf.diagnostics_document, "Document Diagnostics")
      -- map("<leader>fs", fzf.lsp_document_symbols, "LSP Symbols")
      -- map("gr",         fzf.lsp_references,       "LSP References")
      -- map("gd",         fzf.lsp_definitions,      "LSP Definitions")
    end,
  },
}
