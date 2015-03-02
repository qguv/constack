#!/usr/bin/env sh

all: constack.js index.html

constack.js: constack.coffee
	coffee -c constack.coffee

index.html: index.haml
	haml index.haml index.html

clean:
	rm -f constack.js index.html
