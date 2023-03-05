.PHONY: validate
validate:
	yajsv -s schema.json nvim.yaml

.PHONY: run
run:
	lua yaml-conf.lua
