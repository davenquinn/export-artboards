min = require 'minimist'
ObjC.import("stdlib")

args = $.NSProcessInfo.processInfo.arguments

argv = []
for i in [0...args.count]
  val = ObjC.unwrap(args.objectAtIndex(i))
  console.log i, val
  argv.push val

console.log argv
# Actually runs the command

iTunes = Application 'iTunes'

name = iTunes.currentTrack.name()

$.exit(0)
console.log name
