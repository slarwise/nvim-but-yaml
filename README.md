# nvim but yaml

Configure neovim using yaml.

## Installation

Clone this repo to somewhere under `:help packpath` or install using a package
manager. Then install [yq](https://github.com/mikefarah/yq).

## Usage

First, create a yaml configuration file, which will look something like this
(for a more detailed example, see `./examples/nvim.yaml`.
Something like this:

```yaml
# nvim.yaml
options:
  shiftwidth: 4
```

Then, add the following to your `init.lua`:

```lua
-- init.lua
require("nvim_but_yaml").run("./nvim.yaml")
```

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
