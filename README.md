# nvim but yaml

Configure neovim using yaml.

## Installation

Clone this repo to somewhere under `:help packpath` or install using a package
manager.

## Usage

First, create a yaml configuration file, which will look something like this
(for a more detailed example, see `./examples/nvim.yaml`.
Something like this:

```yaml
# nvim.yaml
options:
  shiftwidth: 4
```

Second, convert this document to json (uses
[yq](https://github.com/mikefarah/yq)):

```sh
cat nvim.yaml | yq > nvim.json
```

Third, add the following to your `init.lua`:

```lua
-- init.lua
require("nvim_but_yaml").run("./nvim.json")
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
  - [ ] Language server
  - [ ] Syntax
  - [ ] Indent
- [ ] Plugins. I think we should skip this

## Schema

TODO, kind of a chore but might be worth it.
