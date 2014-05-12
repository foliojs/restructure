test:
	@./node_modules/.bin/mocha
		
coverage: test
	@./node_modules/.bin/mocha --require coverage.js --reporter html-cov > coverage.html
	
coveralls: test
	@./node_modules/.bin/mocha --require coverage.js --reporter mocha-lcov-reporter | ./node_modules/coveralls/bin/coveralls.js
	
js: index.coffee src/*.coffee
	./node_modules/.bin/coffee -c src/ index.coffee
	
clean:
	rm -rf index.js src/*.js

.PHONY: test coverage