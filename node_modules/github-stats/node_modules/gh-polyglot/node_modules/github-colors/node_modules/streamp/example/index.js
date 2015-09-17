// Dependencies
var Streamp = require("../lib");

// Constants
const PATH = __dirname + "/long/path/to/foo.txt";

// Create writable stream
var bar = new Streamp.writable(PATH);
bar.write(new Date().toString() + "\n");
bar.end();

// Create readable stream
var foo = new Streamp.readable(PATH);
foo.pipe(process.stdout);
