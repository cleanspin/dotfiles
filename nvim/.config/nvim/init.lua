-- Neovim Configuration with markview.nvim
-- Plugin Manager: vim-plug

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for yank/paste
vim.opt.swapfile = false -- Disable swap files

-- vim-plug configuration
vim.cmd([[
call plug#begin('~/.local/share/nvim/plugged')

" Colorschemes
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'folke/tokyonight.nvim'
Plug 'rose-pine/neovim', { 'as': 'rose-pine' }
Plug 'ellisonleao/gruvbox.nvim'
Plug 'shaunsingh/nord.nvim'
Plug 'Mofiqul/dracula.nvim'

" markview.nvim - Markdown, YAML, and LaTeX previewer
Plug 'OXY2DEV/markview.nvim'

" Dependencies for markview.nvim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-web-devicons'

" Telescope - Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Lualine - Statusline
Plug 'nvim-lualine/lualine.nvim'

" Alpha - Dashboard/start screen
Plug 'goolord/alpha-nvim'

" Which-key - Keybinding popup helper
Plug 'folke/which-key.nvim'

" QoL plugins
Plug 'windwp/nvim-autopairs'
Plug 'numToStr/Comment.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" Neo-tree - File explorer
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" API Testing / HTTP Client
Plug 'mistweaverco/kulala.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Vim practice game
Plug 'ThePrimeagen/vim-be-good'

" Surround - Add/change/delete surrounding pairs
Plug 'tpope/vim-surround'

" KNAP - Live preview for markdown/LaTeX with Zathura
Plug 'frabjous/knap'

" Overseer - Task runner (dev servers, builds, etc.)
Plug 'stevearc/overseer.nvim'

" Kitty scrollback - vim navigation over terminal output
Plug 'mikesmithgh/kitty-scrollback.nvim'

" JSON schemas for jsonls
Plug 'b0o/SchemaStore.nvim'

call plug#end()
]])

-- Colorscheme configuration
-- Setup catppuccin with macchiato as default
local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
if catppuccin_ok then
  catppuccin.setup({
    flavour = "macchiato",
    transparent_background = true,
    term_colors = true,
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
    },
    integrations = {
      treesitter = true,
      native_lsp = { enabled = true },
      markdown = true,
    },
  })
end

-- Setup tokyonight with transparency
local tokyonight_ok, tokyonight = pcall(require, "tokyonight")
if tokyonight_ok then
  tokyonight.setup({
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  })
end

-- Setup dracula with transparency
local dracula_ok, dracula = pcall(require, "dracula")
if dracula_ok then
  dracula.setup({
    transparent_bg = true,
  })
end

-- Setup rose-pine with transparency
local rosepine_ok, rosepine = pcall(require, "rose-pine")
if rosepine_ok then
  rosepine.setup({
    styles = {
      transparency = true,
    },
  })
end

-- Setup gruvbox with transparency
local gruvbox_ok, gruvbox = pcall(require, "gruvbox")
if gruvbox_ok then
  gruvbox.setup({
    transparent_mode = true,
  })
end

-- Setup nord with transparency (uses global variable)
vim.g.nord_disable_background = true

-- Load current theme from file (managed by theme-switch.sh)
local theme_file = vim.fn.expand("~/.config/nvim/lua/current-theme.lua")
if vim.fn.filereadable(theme_file) == 1 then
  dofile(theme_file)
else
  -- Fallback to catppuccin
  vim.cmd.colorscheme("catppuccin")
end

-- markview.nvim configuration (with protected call)
local markview_ok, markview = pcall(require, "markview")
if not markview_ok then
  vim.notify("Markview not found. Run :PlugInstall", vim.log.levels.WARN)
  return
end

markview.setup({
  -- Default modes
  modes = { "n", "i", "no", "c" },
  hybrid_modes = { "i" },

  -- Callbacks for autocommands
  callbacks = {
    on_enable = function (_, win)
      vim.wo[win].conceallevel = 2;
      vim.wo[win].concealcursor = "nc";
    end
  },

  -- Enable YAML support
  yaml = {
    enable = true,
  },

  -- Enable LaTeX support
  latex = {
    enable = true,
    -- LaTeX-specific configurations
    operators = {
      enable = true,
    },
    symbols = {
      enable = true,
    },
  },

  -- Markdown configuration (keeping it minimal for now)
  markdown = {
    enable = true,
  },
})

-- Keybindings for markview.nvim
-- Leader key setup (using space as leader)
vim.g.mapleader = " "

-- Copy register a to system clipboard (for multi-line yanking across terminals)
vim.keymap.set("n", "<Leader>ac", ':let @+ = @a<CR>', { desc = "Copy register a to clipboard", silent = true })

-- Keybinding explanations:
-- <Leader>mt - Toggle markview on/off
-- <Leader>mm - Toggle between hybrid and normal mode
-- <Leader>ms - Split view toggle
-- <Leader>mc - Cycle through preview modes (normal -> hybrid -> off -> normal)

vim.keymap.set("n", "<Leader>mt", ":Markview toggle<CR>", {
  desc = "Toggle Markview preview on/off",
  silent = true
})

vim.keymap.set("n", "<Leader>mm", ":Markview hybridToggle<CR>", {
  desc = "Toggle Markview hybrid mode (edit while previewing)",
  silent = true
})

vim.keymap.set("n", "<Leader>ms", ":Markview splitToggle<CR>", {
  desc = "Toggle Markview split view",
  silent = true
})

-- Custom function to cycle between preview modes
local markview_state = "normal"
function CycleMarkviewMode()
  if markview_state == "normal" then
    vim.cmd("Markview hybridToggle")
    markview_state = "hybrid"
    print("Markview: Hybrid mode (edit + preview)")
  elseif markview_state == "hybrid" then
    vim.cmd("Markview disable")
    markview_state = "off"
    print("Markview: Disabled")
  else
    vim.cmd("Markview enable")
    markview_state = "normal"
    print("Markview: Normal preview mode")
  end
end

vim.keymap.set("n", "<Leader>mc", ":lua CycleMarkviewMode()<CR>", {
  desc = "Cycle Markview modes (normal -> hybrid -> off -> normal)",
  silent = true
})

-- Markview starts disabled - toggle with <Leader>mt
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.md", "*.markdown", "*.yaml", "*.yml", "*.tex"},
  callback = function()
    vim.cmd("Markview disable")
  end,
})

-- Telescope configuration
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_ignore_patterns = { "node_modules", ".git/", "%.lock", "__pycache__", "%.pyc" },
      path_display = { "truncate" },
      winblend = 0,
      border = true,
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-c>"] = actions.close,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
        },
        n = {
          ["q"] = actions.close,
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
        previewer = true,
      },
      live_grep = {
        additional_args = function()
          return { "--hidden" }
        end,
      },
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
        },
      },
    },
  })

  -- Load fzf extension for better performance
  pcall(telescope.load_extension, "fzf")
end

-- Telescope highlight groups for a cleaner look
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colors = {
      bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg,
      fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg,
      border = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg,
      accent = vim.api.nvim_get_hl(0, { name = "Function" }).fg,
    }

    -- Make telescope look more integrated
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.border, bg = colors.bg })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.border, bg = colors.bg })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.border, bg = colors.bg })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = colors.bg, bg = colors.accent, bold = true })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = colors.bg, bg = colors.accent, bold = true })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = colors.bg, bg = colors.accent, bold = true })
  end,
})

-- Telescope keybindings
local builtin_ok, builtin = pcall(require, "telescope.builtin")
if builtin_ok then
  vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Find buffers" })
  vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })
  vim.keymap.set("n", "<Leader>fr", builtin.oldfiles, { desc = "Recent files" })
  vim.keymap.set("n", "<Leader>fc", builtin.commands, { desc = "Commands" })
  vim.keymap.set("n", "<Leader>fs", builtin.grep_string, { desc = "Grep string under cursor" })
  vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files (Ctrl+P)" })
  vim.keymap.set("n", "<Leader>fd", function()
    builtin.find_files({
      cwd = vim.env.HOME,
      find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
      prompt_title = "Find Directory",
      attach_mappings = function(_, map)
        map("i", "<CR>", function(prompt_bufnr)
          local entry = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(prompt_bufnr)
          vim.cmd("cd " .. entry.path)
          vim.notify("Changed directory to: " .. entry.path)
        end)
        return true
      end,
    })
  end, { desc = "Find and cd to directory" })
end

-- Alpha dashboard configuration
local alpha_ok, alpha = pcall(require, "alpha")
if alpha_ok then
  local dashboard = require("alpha.themes.dashboard")

  -- Custom ASCII header
  dashboard.section.header.val = {
    "",
    "",
    "██╗  ██╗██╗       ██████╗ ██████╗  ██████╗ █████╗ ██╗███╗   ██╗███████╗",
    "██║  ██║██║      ██╔════╝██╔═══██╗██╔════╝██╔══██╗██║████╗  ██║██╔════╝",
    "███████║██║      ██║     ██║   ██║██║     ███████║██║██╔██╗ ██║█████╗  ",
    "██╔══██║██║      ██║     ██║   ██║██║     ██╔══██║██║██║╚██╗██║██╔══╝  ",
    "██║  ██║██║      ╚██████╗╚██████╔╝╚██████╗██║  ██║██║██║ ╚████║███████╗",
    "╚═╝  ╚═╝╚═╝       ╚═════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝",
    "",
    "",
  }

  -- Menu buttons
  dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("g", "󰈬  Find word", ":Telescope live_grep<CR>"),
    dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
    dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
  }

  -- Footer
  dashboard.section.footer.val = {
    "",
    "",
  }

  -- Colors
  dashboard.section.header.opts.hl = "AlphaHeader"
  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.section.footer.opts.hl = "AlphaFooter"

  -- Layout spacing
  dashboard.config.layout = {
    { type = "padding", val = 4 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 2 },
    dashboard.section.footer,
  }

  alpha.setup(dashboard.config)

  -- Set highlight colors after colorscheme loads
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#f38ba8", bold = true })
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#89b4fa" })
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6c7086", italic = true })
    end,
  })

  -- Trigger once on load
  vim.cmd("doautocmd ColorScheme")
end

-- Treesitter configuration
local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if treesitter_ok then
  treesitter.setup({
    ensure_installed = {
      "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript",
      "html", "css", "json", "yaml", "toml", "markdown", "markdown_inline",
      "regex", "c", "cpp", "rust", "go",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  })
end

-- Web-devicons configuration
local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
if devicons_ok then
  devicons.setup({
    default = true,
    strict = true,
  })
end

-- Which-key configuration
local whichkey_ok, whichkey = pcall(require, "which-key")
if whichkey_ok then
  whichkey.setup({
    delay = 300, -- Show popup after 300ms
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+ ",
    },
    win = {
      border = "rounded",
      padding = { 2, 2, 2, 2 },
    },
  })

  -- Keep popup visible longer
  vim.opt.timeoutlen = 3000 -- Wait 3 seconds before timing out key sequences

  -- Register key groups for better labels
  whichkey.add({
    { "<leader>f", group = "Find (Telescope)" },
    { "<leader>m", group = "Markview" },
  })
end

-- Lualine configuration
local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
  -- Custom filename component with modified indicator color
  local custom_filename = {
    "filename",
    path = 1, -- Relative path
    symbols = {
      modified = " ●",
      readonly = " ",
      unnamed = "[No Name]",
      newfile = "[New]",
    },
    color = function()
      -- Return different color if buffer is modified
      if vim.bo.modified then
        return { fg = "#f38ba8", gui = "bold" } -- Red-ish for modified
      end
      return {}
    end,
  }

  lualine.setup({
    options = {
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true, -- Single statusline for all windows
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
    },
    sections = {
      lualine_a = {
        { "mode", icon = "" },
      },
      lualine_b = {
        { "branch", icon = "" },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          colored = true,
        },
      },
      lualine_c = {
        "%=", -- Left padding to push content to center
        { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
        custom_filename,
        {
          "searchcount",
          maxcount = 999,
          timeout = 500,
        },
        "%=", -- Right padding to keep content centered
      },
      lualine_x = {},
      lualine_y = {
        { "progress", icon = "" },
      },
      lualine_z = {
        { "location", icon = "" },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  })
end

-- Autopairs configuration
local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if autopairs_ok then
  autopairs.setup({
    check_ts = true, -- Use treesitter for smarter pairing
    disable_filetype = { "TelescopePrompt" },
  })
end

-- Comment.nvim configuration
local comment_ok, comment = pcall(require, "Comment")
if comment_ok then
  comment.setup({
    -- gcc to comment line, gc + motion for block
    -- gbc for block comment style
  })
end

-- Gitsigns configuration
local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if gitsigns_ok then
  gitsigns.setup({
    signs = {
      add          = { text = "│" },
      change       = { text = "│" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },
    current_line_blame = false, -- Set to true if you want git blame on current line
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- Navigation between hunks
      map("n", "]c", gs.next_hunk, { desc = "Next git hunk" })
      map("n", "[c", gs.prev_hunk, { desc = "Previous git hunk" })
      -- Actions
      map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
    end,
  })
end

-- Colorizer configuration
local colorizer_ok, colorizer = pcall(require, "colorizer")
if colorizer_ok then
  colorizer.setup({
    "*", -- Enable for all filetypes
  }, {
    RGB = true,
    RRGGBB = true,
    names = false, -- Disable named colors like "red"
    RRGGBBAA = true,
    css = true,
    css_fn = true,
  })
end

-- Neo-tree configuration
local neotree_ok, neotree = pcall(require, "neo-tree")
if neotree_ok then
  neotree.setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = false, -- Slow on large repos
    enable_diagnostics = false,
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.opt_local.guicursor = "a:Cursor/lCursor"
          vim.cmd("highlight! Cursor blend=100")
        end,
      },
      {
        event = "neo_tree_buffer_leave",
        handler = function()
          vim.cmd("highlight! Cursor blend=0")
          vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
        end,
      },
    },
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
      },
    },
    window = {
      position = "left",
      width = 30,
      highlight_cursor = false, -- Hide cursor, just use line highlight
      mappings = {
        ["<space>"] = "none",
        ["<cr>"] = "open",
        ["o"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { "node_modules", ".git" },
      },
      follow_current_file = { enabled = false },
      use_libuv_file_watcher = false, -- Slow
    },
  })

  vim.keymap.set("n", "<Leader>e", ":Neotree toggle<CR>", { desc = "Toggle file explorer", silent = true })
  vim.keymap.set("n", "<Leader>o", ":Neotree focus<CR>", { desc = "Focus file explorer", silent = true })

  -- Make selection more visible in neo-tree
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
      local visual_bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg
      -- Use Visual highlight as base for better contrast
      if visual_bg then
        vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = visual_bg, bold = true })
      else
        -- Fallback: use a visible highlight
        vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#45475a", bold = true })
      end
    end,
  })
  vim.cmd("doautocmd ColorScheme")
end

-- Mason configuration (LSP installer)
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup({
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
end

-- Mason-lspconfig
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
  mason_lspconfig.setup({
    ensure_installed = {
      "ts_ls",           -- TypeScript/JavaScript (React, Next.js, Vite)
      "pyright",            -- Python
      "bashls",             -- Bash
      "marksman",           -- Markdown
      "sqlls",              -- SQL
      "cssls",              -- CSS
      "html",               -- HTML
      "jsonls",             -- JSON
      "lua_ls",             -- Lua (for nvim config)
      "tailwindcss",        -- Tailwind CSS
      "rust_analyzer",       -- Rust
    },
    automatic_installation = true,
  })
end

-- LSP Configuration (Neovim 0.11+ native API)

-- Capabilities for autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- LSP keybindings on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf

    -- Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Find references" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })

    -- Actions
    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
    vim.keymap.set("n", "<Leader>lf", function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "Format file" })

    -- Diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
    vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show diagnostic" })
  end,
})

-- Configure language servers using vim.lsp.config (Neovim 0.11+)
local servers = {
  ts_ls = {},
  pyright = {},
  bashls = {},
  marksman = {},
  sqlls = {},
  cssls = {},
  html = {},
  jsonls = {},
  tailwindcss = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
        cargo = { allFeatures = true },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
}

for server, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- Diagnostic appearance
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  float = { border = "rounded" },
})

-- nvim-cmp (Autocompletion)
local cmp_ok, cmp = pcall(require, "cmp")
local luasnip_ok, luasnip = pcall(require, "luasnip")
if cmp_ok and luasnip_ok then
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    }),
    formatting = {
      format = function(entry, vim_item)
        local icons = {
          Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
          Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
          Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
          Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
          File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
          Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
          TypeParameter = "",
        }
        vim_item.kind = string.format("%s %s", icons[vim_item.kind] or "", vim_item.kind)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          buffer = "[Buf]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },
  })
end

-- Markdown Preview (browser-sync live server)
-- Uses ~/.local/bin/md-preview script

local md_preview = vim.fn.expand("~/.local/bin/md-preview")
local preview_active = false
local current_template = "themed"
local templates = { "themed", "github", "tufte" }

-- Helper to run md-preview commands
local function preview_cmd(args, callback)
  vim.fn.jobstart(md_preview .. " " .. args, {
    on_exit = callback,
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        print(table.concat(data, " "))
      end
    end,
  })
end

-- Auto-rebuild on save and scroll sync when preview is active
local preview_augroup = vim.api.nvim_create_augroup("MarkdownPreview", { clear = true })

local function setup_auto_rebuild()
  vim.api.nvim_clear_autocmds({ group = preview_augroup })
  if preview_active then
    -- Rebuild on save
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = preview_augroup,
      pattern = "*.md",
      callback = function()
        vim.fn.jobstart(md_preview .. " rebuild", { detach = true })
      end,
    })
    -- Scroll sync on cursor move
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = preview_augroup,
      pattern = "*.md",
      callback = function()
        local line = vim.fn.line(".")
        local total = vim.fn.line("$")
        local pos = (line - 1) / math.max(total - 1, 1)
        vim.fn.jobstart(md_preview .. " scroll " .. string.format("%.4f", pos), { detach = true })
      end,
    })
  end
end

-- <Leader>pp: Toggle preview on/off
vim.keymap.set("n", "<Leader>pp", function()
  if preview_active then
    preview_cmd("stop")
    preview_active = false
    setup_auto_rebuild()
    print("Preview stopped")
  else
    local file = vim.fn.expand("%:p")
    if not file:match("%.md$") then
      print("Not a markdown file")
      return
    end
    preview_active = true  -- Set flag before async call
    setup_auto_rebuild()   -- Setup autocmds immediately
    preview_cmd("start " .. vim.fn.shellescape(file) .. " " .. current_template)
  end
end, { desc = "Toggle preview" })

-- <Leader>pt: Cycle templates
vim.keymap.set("n", "<Leader>pt", function()
  if not preview_active then
    print("Preview not active")
    return
  end

  -- Cycle to next template
  local idx = 1
  for i, t in ipairs(templates) do
    if t == current_template then idx = i break end
  end
  idx = (idx % #templates) + 1
  current_template = templates[idx]

  preview_cmd("template " .. current_template)
end, { desc = "Cycle template" })

-- <Leader>pP: Print HTML to current directory
vim.keymap.set("n", "<Leader>pP", function()
  if not preview_active then
    print("Preview not active")
    return
  end
  preview_cmd("print")
end, { desc = "Print HTML to directory" })

-- Register with which-key if available
if whichkey_ok then
  whichkey.add({
    { "<leader>p", group = "Preview" },
  })
end

-- Kulala - HTTP client (API testing)
local kulala_ok, kulala = pcall(require, "kulala")
if kulala_ok then
  kulala.setup({
    global_keymaps = false,
    ui = {
      default_view = "headers_body",
    },
  })

  -- Keybindings under <Leader>R (REST)
  vim.keymap.set("n", "<Leader>Rs", kulala.run, { desc = "Send request" })
  vim.keymap.set("n", "<Leader>Ra", kulala.run_all, { desc = "Send all requests" })
  vim.keymap.set("n", "<Leader>Rb", kulala.scratchpad, { desc = "Open scratchpad" })
  vim.keymap.set("n", "<Leader>Rt", kulala.toggle_view, { desc = "Toggle headers/body" })
  vim.keymap.set("n", "<Leader>Ri", kulala.inspect, { desc = "Inspect request" })
  vim.keymap.set("n", "<Leader>Rc", kulala.copy, { desc = "Copy as cURL" })
  vim.keymap.set("n", "<Leader>Re", kulala.set_selected_env, { desc = "Select environment" })
  vim.keymap.set("n", "<Leader>Rr", kulala.replay, { desc = "Replay last request" })
  vim.keymap.set("n", "<Leader>Rf", kulala.search, { desc = "Find request" })
  vim.keymap.set("n", "[r", kulala.jump_prev, { desc = "Previous request" })
  vim.keymap.set("n", "]r", kulala.jump_next, { desc = "Next request" })

  -- Register with which-key
  if whichkey_ok then
    whichkey.add({
      { "<leader>R", group = "REST (Kulala)" },
    })
  end
end

-- Overseer - Task runner for dev servers, builds, etc.
local overseer_ok, overseer = pcall(require, "overseer")
if overseer_ok then
  overseer.setup({
    templates = { "user" },
    task_list = {
      direction = "bottom",
      min_height = 12,
      max_height = 20,
      default_detail = 1,
      bindings = {
        ["q"] = "Close",
        ["<CR>"] = "RunAction",
        ["o"] = "Open",
        ["<C-v>"] = "OpenVsplit",
        ["<C-s>"] = "OpenSplit",
      },
    },
    -- Show output in a terminal buffer
    strategy = "terminal",
    -- Auto-scroll task output
    form = {
      border = "rounded",
    },
    confirm = {
      border = "rounded",
    },
    task_win = {
      border = "rounded",
    },
  })

  -- Keybindings under <Leader>r (run)
  vim.keymap.set("n", "<Leader>rr", "<cmd>OverseerRun<CR>", { desc = "Run task" })
  vim.keymap.set("n", "<Leader>rt", "<cmd>OverseerToggle<CR>", { desc = "Toggle task list" })
  vim.keymap.set("n", "<Leader>ra", "<cmd>OverseerQuickAction<CR>", { desc = "Task quick action" })

  -- Register with which-key
  if whichkey_ok then
    whichkey.add({
      { "<leader>r", group = "Run (Overseer)" },
    })
  end
end

-- Kitty scrollback - vim navigation over terminal output
local ksb_ok, ksb = pcall(require, "kitty-scrollback")
if ksb_ok then
  ksb.setup()
end
