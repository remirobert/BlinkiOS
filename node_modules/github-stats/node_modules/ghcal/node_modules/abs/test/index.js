// Dependencies
var Abs = require("../lib")
  , Assert = require("assert")
  , Ul = require("ul")
  ;

it("should support absolute inputs", function (cb) {
    Assert.equal(Abs("/foo"), "/foo");
    cb();
});

it("should support relative inputs", function (cb) {
    Assert.equal(Abs("foo"), process.cwd() + "/foo");
    cb();
});

it("should support home files/dirs", function (cb) {
    Assert.equal(Abs("~/foo"), Ul.home() + "/foo");
    cb();
});
