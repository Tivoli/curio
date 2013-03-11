# Get version number from package.json, need this for tagging.
version = $(shell node -e "console.log(JSON.parse(require('fs').readFileSync('package.json')).version)")
reporter = dot

test:
	@NODE_ENV=test PORT=3001 mocha \
		--reporter $(reporter) \
		test/landing/*.coffee

tag:
	git push
	git tag v$(version)
	git push --tags origin master

.PHONY: test tag
