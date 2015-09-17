// Dependencies
var Utils = require("../utils");
var Debug = require("bug-killer");
Debug.config.success = {
    color: "#00CF06",
    text: "success"
};

// Object used for tests
var testObject = {
    a: {
        b: {
            c: 1
        },
        foo: function() {
            return "Bar";
        }
    },
    "unflatten.value": 4
};

var tests = [
    "Utils.findValue(testObject, 'a.b')",
    "Utils.findFunction(testObject, 'a.foo')",
    "Utils.flattenObject(testObject)",
    "Utils.unflattenObject(testObject)",
    "Utils.cloneObject(testObject, true)",
    "Utils.cloneObject(testObject)"
];

for (var i = 0; i < tests.length; ++i) {
    var cTest = tests[i];
    var output = "\n" + cTest;
    try {
        output += JSON.stringify(eval(cTest), null, 4);
        output += "\n";
        Debug.log(output, "success");
    } catch (e) {
        output += " - Failed. " + e.toString();
        output += "\n";
        Debug.log(output, "error");
    }
}
