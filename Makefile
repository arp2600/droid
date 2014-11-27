all: index.html
	cat src/*.coffee > main.coffee.swp
	mv main.coffee.swp main.coffee
	coffee -c -o js/ main.coffee

index.html: index.haml
	haml index.haml > index.html

