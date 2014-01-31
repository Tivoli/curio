default: test
NODE_ENV = test
REPORTER = dot
MOCHA_OPTS =
CFLAGS = -c -g -D $(NODE_ENV)

# Find all coffee files except in node_modules
OBJECTS = $(shell find . ! -path "*/node_modules/*" -type f -name "*.coffee")

# Get version number from package.json, need this for tagging.
version = $(shell node -e "console.log(JSON.parse(require('fs').readFileSync('package.json')).version)")

test:
	@NODE_ENV=$(NODE_ENV) PORT=3001 ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		$(MOCHA_OPTS) \
		--compilers coffee:coffee-script/register \
		--require test/support/setup \
		--timeout 20s \
		--bail \
		test/spec_helper.coffee \
		test/specs/**/*.coffee \
		test/acceptance/**/*.coffee

test-lint:
	@./node_modules/coffeelint/bin/coffeelint $(OBJECTS) --rules ./test/lint/

test-cov:
	@NODE_COV=1 $(MAKE) test MOCHA_OPTS='--require blanket' REPORTER=html-cov > coverage.html

test-all: test-lint test

tag:
	git push
	git tag v$(version)
	git push --tags origin master

.PHONY: test test-lint test-cov test-all tag
