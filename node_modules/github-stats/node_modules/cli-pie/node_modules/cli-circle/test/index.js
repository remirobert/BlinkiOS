// Dependencies
var Assert = require("assert")
  , CliCircle = require("../lib")
  , Fs = require("fs")
  ;

// Constants
const CIRCLE = Fs.readFileSync(__dirname + "/circle", "utf-8");

// Tests
it("should create and stringify the circle", function (cb) {
    Assert(CliCircle(100).toString(), CIRCLE);
    cb();
});
