all:
	# Merge all the source files
	cat src/*.coffee > main.coffee.swp
	mv main.coffee.swp main.coffee
	# Compile the program into javascript
	coffee -c -o js/ main.coffee
	# Compile index.haml to html
	haml index.haml > index.html
