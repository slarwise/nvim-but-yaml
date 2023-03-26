.PHONY: validate
validate: convert
	yajsv -s schema.json examples/nvim.yaml

.PHONY: convert
convert:
	cat schema.yaml | yq > schema.json

.PHONY: test
test:
	nvim -u examples/init.lua --cmd "set runtimepath^=."
