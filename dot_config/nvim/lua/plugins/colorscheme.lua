-- Catppuccin Latte/Mocha following 'background', which Neovim detects from
-- the terminal (Ghostty follows the macOS appearance).
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
