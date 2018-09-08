# Unlike yargs, minimist does not appear to refer to modules like "fs"
min = require 'minimist'
esc = require 'shell-escape'

fail = (msg)->
  console.log msg
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
  string: ['format', 'preset']
  default: {
    'create-folders': false
    'format': 'png8'
    'preset': '[Smallest File Size]'
  }
  alias: {f: 'format'}
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
running = app.running()
if not running
  fail("Could not launch Adobe Illustrator") unless app.launch()

app.open(docFile)
doc = app.currentDocument

# Run JSX to flip export option
pref = 'plugin/SmartExportUI/CreateFoldersPreference'
i = args['create-folders'] | 0
app.doJavascript(
  "app.preferences.setIntegerPreference('#{pref}', #{i});"
)

fileManager = $.NSFileManager.defaultManager
if !fileManager.fileExistsAtPath(exportFolder)
  fileManager.createDirectoryAtPathWithIntermediateDirectoriesAttributesError(exportFolder, false, $(), $())

opts = {}
if format == 'pdf'
  opts.PDFPreset = args['pdf-preset']

try
  doc.exportforscreens {
    toFolder: exportFolder
    as:"se_#{format}"
    withOptions: opts
  }
catch
  fail "Could not export for screens"

doc.close()

if not running
  app.quit()

# This took a while to find
$.exit(0)
