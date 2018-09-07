# export-artboards

`export-artboards` is a Mac OS "Javascript for Automation" script
packaged as a command-line application. It exports all of the artboards
in an Adobe Illustrator file to a specified directory, in formats defined
by a configuration file, using the "Export for Screens" API. It is designed
to support the repeatable export of figures in predefined file formats, as
aspects of the core document are changed.

This script supports my preferred figure-annotation workflow, which involves
all figures for a paper laid out as multiple artboards in a single
Adobe Illustrator file, with referenced images and PDF compatibility off
to ensure small file sizes for ease of use with version control. Exporting the
artboards using this script can then update all images simultaneously.
