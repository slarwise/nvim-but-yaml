.PHONY: validate
validate:
	yajsv -s schema.json nvim.yaml
