Promise = require "bluebird"
eval_ = require "eval"
_ = require "lodash"
module.exports =

class AsyncInvoker
  
  constructor: (code, @options = {}, globals = {}) ->
    _.defaults @options,
      logErrors: true

    code = "module.exports = #{code}"
    @_invoke = @_doSomething (=> eval_ code, globals)
    @_assertIsFunction @_invoke

  invoke: (args...) =>
    invoke = (functionArgs) =>
      @_doSomething (=> @_invoke.apply null, functionArgs)
    tryLog = (e) => console.log e if @options.logErrors

    new Promise (resolve, reject) =>
      try
        output = invoke args.concat(resolve)
        if not _.isUndefined output
          resolve output
      catch e then tryLog e ; reject e

  _doSomething: (doSomething) => doSomething()

  _assertIsFunction: (func) =>
    if not _.isFunction func
      throw new Error("The function is not a function");
