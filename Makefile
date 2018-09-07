all: bin/export-artboards

bin/export-artboards: src/index.coffee
	echo "#!/usr/bin/osascript -l JavaScript" > $@
	echo 'window = this;' >> $@
	node_modules/.bin/browserify -t coffeeify $^ >> $@
	echo ';ObjC.import("stdlib");$.exit(0)' >> $@
