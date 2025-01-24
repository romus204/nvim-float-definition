# nvim-float-definition

A Neovim plugin that opens the definition of a symbol in a floating window. It integrates with Neovim's built-in LSP (Language Server Protocol) to provide a seamless way to view definitions without leaving your current buffer.

---

## Features

- Opens the definition of a symbol in a floating window.
- Customizable window size, border style, and keybindings.
- Supports closing the floating window with a custom key.
- Allows opening the file in a new buffer directly from the floating window.

---

## Installation

Using [Lazy.nvim](https://github.com/folke/lazy.nvim), add the following to your Neovim configuration:

```lua
{
    "romus204/nvim-float-definition",
    config = function()
        require("nvim-float-definition").setup({
            -- Add your custom configuration here (optional)
        })
    end,
}

```
---

## Default config 

```lua
require("nvim-float-definition").setup({
    width = 140,               -- Default width of the floating window
    height = 40,               -- Default height of the floating window
    border = "rounded",        -- Border style for the floating window (e.g., "single", "double", "rounded")
    close_key = "q",           -- Key to close the floating window
    open_key = "o",            -- Key to open the file in a new buffer
    max_width_percent = 0.8,   -- Maximum width of the window as a percentage of the screen width
    max_height_percent = 0.8,  -- Maximum height of the window as a percentage of the screen height
})
```
---

## Keybindings
By default, the plugin does not bind any keys. You can create a keybinding to trigger the open_definition_in_float function. For example:
```lua
vim.api.nvim_set_keymap("n", "<leader>df", "<cmd>lua require('nvim-float-definition').open_definition_in_float()<CR>", {
    noremap = true,
    silent = true,
})
```
---

## Usage

1. Place your cursor on the symbol you want to inspect.

2. Use the keybinding (e.g., <leader>df) to open the definition in a floating window.

3. Inside the floating window:

    -Press the close_key (default: q) to close the window.

    -Press the open_key (default: o) to open the file in a new buffer.


