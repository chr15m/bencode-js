BIN=./node_modules/.bin

MOCHA=$(BIN)/mocha
COFFEE=$(BIN)/coffee --js
CJSIFY=$(BIN)/cjsify --export Bencode src/index.coffee
BROWSERIFY=$(BIN)/browserify
UGLIFY=$(BIN)/uglifyjs

SRCS = $(shell find src -name "*.coffee" -type f | sort)
LIBS = $(SRCS:src/%.coffee=lib/%.js)

all: compile test
compile: $(LIBS)

lib/%.js: src/%.coffee
	$(COFFEE) <"$<" >"$@"

browser: bencode.js bencode-min.js
bencode.js: $(LIBS)
	$(BROWSERIFY) lib/index.js --standalone Bencode > $@
bencode-min.js: bencode.js
	$(UGLIFY) $< > $@

.PHONY: test

test:
	$(MOCHA) --compilers coffee:coffee-script-redux/register --reporter spec --recursive --colors
