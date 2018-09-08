min = require 'minimist'
ObjC.import("stdlib")
# Note: `debugger` statements can be added to debug
# this script with the Safari Web Inspector (Safari must be running)

# Create arguments array, ignoring script name
args = $.NSProcessInfo.processInfo.arguments
argv = []
for i in [4...args.count]
  val = ObjC.unwrap(args.objectAtIndex(i))
  argv.push val

# Actually runs the command

ill = Application 'Adobe Illustrator'

# If application doesn't exist then exit
$.exit(0) unless ill.activate()
$.exit(0) unless ill.launch()

filename = argv[0]

ill.open("/Users/Daven/Projects/Tools/export-artboards/test-data/shapes.ai")
doc = ill.currentDocument

# Run JSX
ill.doJavascript(
  "app.preferences.setIntegerPreference('plugin/SmartExportUI/CreateFoldersPreference', 1)"
)

doc.exportforscreens {
  toFolder: "~/Documents"
  as:"se_pdf"
}

doc.close()


# This took a while to find
$.exit(0)
