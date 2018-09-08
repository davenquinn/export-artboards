# Unlike yargs, minimist does not appear to refer to modules like "fs"
min = require 'minimist'
esc = require 'shell-escape'

fail = (msg)->
  console.error msg
  $.exit(1)

ObjC.import("stdlib")
# Note: `debugger` statements can be added to debug
# this script with the Safari Web Inspector (Safari must be running)

# Create arguments array, ignoring script name
args = $.NSProcessInfo.processInfo.arguments
argv = []
for i in [4...args.count]
  val = ObjC.unwrap(args.objectAtIndex(i))
  argv.push val

args = min argv, {
  boolean: ['create-folders']
  string: ['format']
  default: {
    'create-folders': false
    'format': 'png8'
  }
}

if args._.length < 2
  fail "Not enough arguments"
else if args._.length > 2
  fail "Too many arguments"

formats = ['png', 'png8', 'png24', 'pdf', 'svg']
{format} = args
format += '8' if format == 'png'
if formats.indexOf(format) == -1
  fail "Improper format #{format} specified"

# Get absolute paths
docFile = Path(args._[0]).toString()
exportFolder = Path(args._[1]).toString()

# Actually runs the command

app = Application 'Adobe Illustrator'
app.includeStandardAdditions = true

# If application doesn't exist then exit
$.exit(0) unless app.activate()
$.exit(0) unless app.launch()

app.open(docFile)
doc = app.currentDocument

# Run JSX
pref = 'plugin/SmartExportUI/CreateFoldersPreference'
i = args['create-folders'] | 0
app.doJavascript(
  "app.preferences.setIntegerPreference('#{pref}', #{i});"
)

fileManager = $.NSFileManager.defaultManager
if !fileManager.fileExistsAtPath(exportFolder)
  fileManager.createDirectoryAtPathWithIntermediateDirectoriesAttributesError(exportFolder, false, $(), $())

doc.exportforscreens {
  toFolder: exportFolder
  as:"se_#{format}"
}

doc.close()

# This took a while to find
$.exit(0)
