.PHONY: validate
validate:
	yajsv -s schema.yaml examples/nvim.yaml

.PHONY: test
test:
	nvim -u examples/init.lua --cmd "set runtimepath^=."
