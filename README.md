# nvim but yaml

Configure neovim using yaml.

## Installation

Clone this repo to somewhere under `:help packpath` or install using a package
manager. Then install [yq](https://github.com/mikefarah/yq).

## Usage

First, create a yaml configuration file, which will look something like this.
For a more detailed example, see [./examples/nvim.yaml](./examples/nvim.yaml).

```yaml
# nvim.yaml
options:
  shiftwidth: 4
mappings:
  normal:
    <C-J>: <Cmd>cnext<CR>
    <C-K>: <Cmd>cprevious<CR>
autocmds:
  TextYankPost:
    command: silent! lua vim.highlight.on_yank()
language_server:
  mappings:
    normal:
      gd: <Cmd>lua vim.lsp.buf.definition()<CR>
  handlers:
    textDocument/hover:
      border: rounded
diagnostics:
  signs: false
filetype_mappings:
  extension:
    tf: terraform
filetypes:
  go:
    options:
      expandtab: false
      tabstop: 4
    language_server:
      name: gopls
      cmd:
        - gopls
      root_dir:
        patterns:
          - go.mod
          - .git
      settings:
        single_file_support: true
```

Then, add the following to your `init.lua`:

```lua
-- init.lua
require("nvim_but_yaml").apply("<absolute-path-to-nvim.yaml>")
```

Now your configuration in `nvim.yaml` will be applied on startup.

## Supported configuration

- [x] Global options
- [x] Colorscheme
- [x] Mappings
- [x] Global variables
- [x] Autocommands (Skip augroups for now)
- [x] Commands
- [x] Language server settings
  - [x] Mappings
- [x] Filetype
  - [x] Options
  - [ ] Mappings
  - [x] Language server
  - [ ] Syntax
  - [ ] Indent
- [ ] Plugins. I think we should skip this

## Schema

Use [schema.yaml](./schema.yaml) to validate your configuration.

### Validate using CLI

This example uses [yajsv](https://github.com/neilpa/yajsv) to validate the
configuration file `nvim.yaml`.

```sh
curl https://raw.githubusercontent.com/slarwise/nvim-but-yaml/main/schema.yaml > schema.yaml
yajsv -s schema.yaml nvim.yaml
```

### Validate in editor

If you use the
[yaml-language-server](https://github.com/redhat-developer/yaml-language-server#using-inlined-schema),
it is possible to provide the schema in your configuration file, like this:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/slarwise/nvim-but-yaml/main/schema.yaml

options:
  background: dark
```
