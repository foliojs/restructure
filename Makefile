test:
	@./node_modules/.bin/mocha
		
coverage:
	@./node_modules/.bin/mocha
	@./node_modules/.bin/mocha --require coverage.js --reporter html-cov > coverage.html

.PHONY: test coverage