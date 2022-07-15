helpText = """
export-artboards [OPTS] docFile exportFolder

OPTS:
--format/-f       Export format [png*,png8,png24,pdf,svg]
                  * default (alias for `png8`)
--create-folders  Whether to create subfolders
                  [boolean default false]
--preset          PDF export preset
                  default "[Smallest File Size]" (same
                  as Illustrator default)
--dpi/-d          Resolution for image [default 300]
ARGS:
docFile           Illustrator document
exportFolder      Folder in which to export (will be
                  created if it doesn't exist)
"""
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
  flags: ['help']
  integer: ['resolution', 'scale']
  string: ['format', 'preset']
  default: {
    'create-folders': false
    'format': 'png8'
    'preset': '[Smallest File Size]'
    'dpi': 300
    'scale': 100
  }
  alias: {f: 'format', h: 'help', d: 'dpi'}
}

if args.help
  console.log helpText
  $.exit(0)

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

# https://ai-scripting.docsforadobe.dev/jsobjref/PDFSaveOptions.html

# Some info about running extendscripts: https://stackoverflow.com/questions/52489315/run-illustrator-extendscript-through-automator-applescript-or-bash

if format == 'pdf'
  console.log "PDF preset: #{args.preset}"
  # We now run PDF export in extendScript so we can easily modify presets
  app.doJavascript(
    """#target illustrator
    exportPNGs();
    function exportPNGs() {
      app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;  
      var basePath = '#{exportFolder}';
      var doc = app.activeDocument;
      var opts = new PDFSaveOptions();
      opts.pDFPreset = '#{args.preset}';
  
      for ( var i = 0; i < doc.artboards.length; i++ ) {
        var artboard = app.activeDocument.artboards[i];
			  var artboardName = artboard.name;
        var destFile = new File( basePath + "/" + artboardName + '.pdf' );
        opts.artboardRange = (i+1).toString();
        doc.saveAs( destFile, opts, i, artboardName);
      };
      app.userInteractionLevel = UserInteractionLevel.DISPLAYALERTS;
    };""")
else
  opts = {}
  if format == 'png8'
    opts = {
      horizontalScaling: args.scale,
      verticalScaling: args.scale
    }

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
