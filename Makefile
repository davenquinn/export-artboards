all: bin/export-artboards

bin/export-artboards: src/index.coffee
	echo "#!/usr/bin/osascript -l JavaScript" > $@
	echo 'window = this;' >> $@
	node_modules/.bin/browserify -t coffeeify $^ >> $@
	chmod +x $@

.PHONY: test
test: bin/export-artboards
	$^ --format png \
		/Users/Daven/Projects/Tools/export-artboards/test-data/shapes.ai /Users/Daven/Projects/Tools/export-artboards/test-export
