# krbon.nvim

krbon.nvim, inspired by [oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim/tree/main) using the [IBM Carbon](https://carbondesignsystem.com/guidelines/color/overview/#themes) and using [onedark.nvim](https://github.com/navarasu/onedark.nvim) as a template

- Support for popular plugins, such as Lsp, Treesitter, and Semantic Highlighting

### Plugin support

The colorscheme explicitly adds highlights for the following plugins:

- Vim Diagnostics
- Vim LSP
- Nvim-Treesitter
- Telescope
- Nvim-Notify
- Nvim-Cmp
- NvimTree
- Neogit
- Gitsigns
- Dashboard
- Which Key
- Item Kind
- Lualine

And many others should "just work!" If you have a plugin that needs explicit highlights, feel free to open an issue or PR and I would be happy to add them.

## Install

The colorscheme has only been tested in the latest stable version of Neovim (> `v0.10.0`)

### Lazy.nvim
```lua
return {
  "deadkper/krbon.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    ending_tildes = false,
    transparent = {
      background = false,
      float = false,
      statusline = false,
    },
    plugins = {
      cmp_itemkind_reverse = false,
    },
    colors = {},
    highlights = {},
    diagnostics = {
      darker = true,
    },
  }
},
```
### Usage

```lua
vim.cmd.colorscheme("krbon")
```

## License

The project is licensed under the MIT license
