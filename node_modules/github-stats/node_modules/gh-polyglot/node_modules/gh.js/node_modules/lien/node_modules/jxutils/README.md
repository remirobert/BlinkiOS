# Utils
Util functions for Mono modules.

# Methods

## `findValue(parent, dotNot)`
Finds a value in parent (object) using the dot notation passed in dotNot.

### Params:
* **Object** *parent* The object containing the searched value
* **String** *dotNot* Path to the value

### Return:
* **Anything** Found value or undefined

## `findFunction(parent, dotNot)`
Finds a function in parent (object) using the dot notation passed in dotNot.

### Params:
* **Object** *parent* The object containing the searched function
* **String** *dotNot* Path to the function value

### Return:
* **Function** Function that was found in the parent object

## `flattenObject(obj)`
Converts an object to a flat one

### Params:
* **Object** *obj* The object that should be converted

### Return:
* **Object** Flatten object

## `unflattenObject(flat)`
Converts a flat object to an unflatten one

### Params:
* **Object** *flat* The flat object that should be converted

### Return:
* **Object** Unflatten object

## `cloneObject(item, deepClone)`
Clones an object

### Params:
* **Object** *item* Object that should be cloned
* **Boolean** *deepClone* If true, the subfields of the @item function will be cloned

### Return:
* **Object** The cloned object

## `slug(input)`
Converts a string to slug

### Params:
* **String** *input* The input string that should be converted to slug

### Return:
* **String** The slug that was generated

# Changelog
## `v0.1.8`
 - Fixed the broken flattenObject method.

## `v0.1.7`
 - Moved `bug-killer` in `devDependencies`.
 - Upgraded to `bug-killer@1.0.0`.
 - Fixed the test script.

## `v0.1.6`
 - Fixed `Date` objects handling.
 - Syntax fixes.

## `v0.1.5`
 - Added `slug` method.

## `v0.1.4`
 - `deepClone` in `cloneObject` method

## `v0.1.3`
 - Added `cloneObject` method.

## `v0.1.2`
 - Fixed typo in API function name

## `v0.1.1`
 - Fixed typo
 - Published the module on NPM

## `v0.1.0`
 - Initial release
