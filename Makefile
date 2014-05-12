test:
	@./node_modules/.bin/mocha
		
coverage: test
	@./node_modules/.bin/mocha --require coverage.js --reporter html-cov > coverage.html
	
coveralls: test
	@./node_modules/.bin/mocha --require coverage.js --reporter mocha-lcov-reporter | ./node_modules/coveralls/bin/coveralls.js

.PHONY: test coverage