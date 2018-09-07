{argv} = require 'yargs'
  .usage '$0 [OPTIONS] file'
  .option 'format', {
    describe: "File type"
    type: 'string'
    default: 'png'
    }
  .help 'h'
  .alias 'h','help'

if argv._.length != 1
  console.error "Illustrator file not specified"
  process.exit(1)

iTunes = Application 'iTunes'

name = iTunes.currentTrack.name()

console.log argv
