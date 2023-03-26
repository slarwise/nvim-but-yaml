.PHONY: validate
validate: convert
	yajsv -s schema.json examples/nvim.yaml

.PHONY: convert
convert:
	cat examples/nvim.yaml | yq > examples/nvim.json
	cat schema.yaml | yq > schema.json

.PHONY: test
test: convert
	nvim -u examples/init.lua --cmd "set runtimepath^=."
