// Dependencies
var Path = require("path")
  , Ul = require("ul")
  ;

/**
 * Abs
 * Computes the absolute path of an input.
 *
 * @name Abs
 * @function
 * @param {String} input The input path.
 * @return {String} The absolute path.
 */
function Abs(input) {
    if (input.charAt(0) === "/") { return input; }
    if (input.charAt(0) === "~" && input.charAt(1) === "/") {
        input = Ul.HOME_DIR + input.substr(1);
    }
    return Path.resolve(input);
}

module.exports = Abs;
