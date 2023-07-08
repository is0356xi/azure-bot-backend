api_input_path = openapi.yaml
api_output_path = schemas.py

.DEFAULT_GOAL := default

.PHONY: gen

default:
	echo "Please use 'make help' to see available commands"

gen:
	datamodel-codegen --input ${api_input_path} --input-file-type openapi --output ${api_output_path}

dev:
	python main.py