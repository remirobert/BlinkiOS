// Dependencies
var Fs = require("fs")
  , Ul = require("ul")
  , Mkdirp = require("mkdirp")
  , Path = require("path")
  ;

// Constants
const PATH_SEP = Path.sep;

// Constructor
var Streamp = module.exports = {};

/*!
 * prepareOptions
 * Prepare the options.
 *
 * @name prepareOptions
 * @function
 * @param {Object} options The options that were provided.
 */
function prepareOptions(options) {
    if (typeof options === "string") {
        options = { path: options };
    }

    Ul.merge(options, {
        flags: "a"
    });

    this.options = options;
}

/*!
 * createStream
 * Creates the stream.
 *
 * @name createStream
 * @function
 * @param {String} func The `Fs` method.
 * @return {Stream} The created stream.
 */
function createStream(func) {
    var dir = this.options.path.split(PATH_SEP).slice(0, -1).join(PATH_SEP);
    Mkdirp.sync(dir);
    return Fs[func](this.options.path, Ul.deepMerge(
        {}
      , this.options.options
      , { flags: this.options.flags }
    ));
}

/**
 * readable
 * Creates a readable stream in the specified path (which will be created if doesn't exist).
 *
 * @name readable
 * @function
 * @param {String|Object} options The path to the file or an object containing the following fields:
 *
 *  - `path` (String): The file path.
 *  - `flags` (String): The stream flags (default: `"a"`).
 *  - `options` (Object): Additional options which are passed when the stream is created.
 *
 * @return {Stream} The readable stream that was created.
 */
Streamp.readable = function (options) {
    var self = this;
    prepareOptions.call(self, options);
    return createStream.call(self, "createReadStream");
};

/**
 * writable
 * Creates a writable stream in the specified path (which will be created if doesn't exist).
 *
 * @name writable
 * @function
 * @param {String|Object} options The path to the file or an object containing the following fields:
 *
 *  - `path` (String): The file path.
 *  - `flags` (String): The stream flags (default: `"a"`).
 *  - `options` (Object): Additional options which are passed when the stream is created.
 *
 * @return {Stream} The writable stream that was created.
 */
Streamp.writable = function (options) {
    var self = this;
    prepareOptions.call(self, options);
    return createStream.call(self, "createWriteStream");
};
