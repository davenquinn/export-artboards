# Export artboards from Adobe Illustrator documents

`export-artboards` is a Mac OS "Javascript for Automation" script
packaged as a command-line application. It exports all of the artboards
in an Adobe Illustrator file to a specified directory, in formats defined
by a configuration file, using the "Export for Screens" API. It is designed
to support the repeatable export of figures in predefined file formats, as
aspects of the core document are changed.

This script supports a figure-annotation workflow for academic
publishing, based on laying out
all figures for a paper as multiple artboards in a single
Adobe Illustrator file (with referenced images and PDF compatibility off
to ensure small file sizes for ease of version control). Exporting the
artboards using this script can then update all images simultaneously.

## Usage

```
export-artboards [OPTS] docFile exportFolder

OPTS:
--format/-f       Export format [png*,png8,png24,pdf,svg]
                  * default (alias for `png8`)
--create-folders  Whether to create subfolders
                  [boolean default false]
--preset          PDF export preset
                  default "[Smallest File Size]" (same
                  as Illustrator default)
ARGS:
docFile           Illustrator document
exportFolder      Folder in which to export (will be
                  created if it doesn't exist)
```

## Contributing

Node JS is required to build; run `npm install` to get required modules
for bundling executable, and then run `make` to build. `make test` both
builds and attempts to export a test document containing two artboards to PNG.
The script currently works only on Mac OS but an alternative
implementation for Windows could be created using COM scripting,
potentially using the same API.


