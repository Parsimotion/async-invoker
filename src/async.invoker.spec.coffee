should = require "should"
_ = require "lodash"

AsyncInvoker = require "./async.invoker"


describe "Async Invoker", ->

  _createFunctionAndRun = (code, params...) ->
    new AsyncInvoker(code, logErrors: false).run(params...)

  it "if create a function parameterless and return a value should resolve a promise", ->
    code = " function () { return 1; } "

    _createFunctionAndRun(code)
    .then (result) -> result.should.be.eql 1

  it "if create a function with parameters and return a value should resolve a promise", ->
    code = " function (a, b) { return a + b; } "
    
    _createFunctionAndRun(code, 1, 2)
    .then (result) -> result.should.be.eql 3

  it "if call the callback then should resolve a promise", ->
    code = " function (callback) { callback(1 + 2); } "

    _createFunctionAndRun code
    .then (result) -> result.should.be.eql 3

  it "if throw an error should reject a promise", ->
    code = "
      function () {
        var array = undefined;
        array.length;
      }
    "
    _createFunctionAndRun code
    .done(
      -> throw new Error "should be not call",
      -> # it is ok
    )

  it "use other library in function work well", ->
    code = "
      function () {
        return _.sum([1,2,3,4]);
      }
    "
    new AsyncInvoker(code, undefined, { _ }).run()
    .then (result) -> result.should.be.eql 10;

  it "should fail if create with invalid code", ->
    createFail = -> new AsyncInvoker "f{}"
    should.throws createFail
