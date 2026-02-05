.PHONY: build test
build:
	docker build -t jarvas-wrapper:local .
test:
	echo "no tests configured"
release:
	echo "use release workflow"
