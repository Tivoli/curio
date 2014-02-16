default: test
NODE_ENV = test
REPORTER = dot
MOCHA_OPTS =
CFLAGS = -c -g -D $(NODE_ENV)

# Find all coffee files except in node_modules
OBJECTS = $(shell find . ! -path "*/node_modules/*" -type f -name "*.coffee")

# Find all test files
SPECS = $(shell find ./test/specs -type f -name "*.coffee")
ACCEPTANCE = $(shell find ./test/acceptance -type f -name "*.coffee")

# Get version number from package.json, need this for tagging.
version = $(shell node -e "console.log(JSON.parse(require('fs').readFileSync('package.json')).version)")

test:
	@NODE_ENV=$(NODE_ENV) PORT=3001 ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		$(MOCHA_OPTS) \
		--compilers coffee:coffee-script/register \
		--require test/support/setup \
		--timeout 10s \
		--bail \
		test/spec_helper.coffee \
		$(SPECS) \
		$(ACCEPTANCE)

test-lint:
	@./node_modules/.bin/coffeelint $(OBJECTS) --rules ./test/lint/

test-cov:
	@NODE_COV=1 $(MAKE) test MOCHA_OPTS='--require blanket' REPORTER=html-cov > coverage.html

test-all: test-lint test

tag:
	git push
	git tag v$(version)
	git push --tags origin master

clean:
	rm -f coverage.html
	rm -rf builtAssets

.PHONY: test test-lint test-cov test-all tag clean
