// Dependencies
var Abs = require("../lib");

console.log(Abs("/foo"));
// => "/foo"

console.log(Abs("foo"));
// => "/path/to/where/you/are/foo"

console.log(Abs("~/foo"));
// => "/home/username/foo"

