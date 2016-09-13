Promise = require "bluebird"
eval_ = require "eval"
_ = require "lodash"
module.exports =

class AsyncInvoker
  
  constructor: (code, @options = {}, globals = {}) ->
    _.defaults @options,
      logErrors: true

    code = "module.exports = #{code}"
    @_run = @_tryTo (=> eval_ code, globals), "has compile errors"
    @_assertIsFunction @_run

  run: (args...) =>
    tryRun = (functionArgs) =>
      @_tryTo (=> @_run.apply null, functionArgs), "exploded"
    tryLog = (e) => console.log e if @options.logErrors

    new Promise (resolve, reject) =>
      try
        output = tryRun args.concat(resolve)
        if not _.isUndefined output
          resolve output
      catch e then tryLog e ; reject e

  _tryTo: (doSomething, errorMessage) =>
    try doSomething()
    catch e
      throw new Error("The function #{errorMessage || e}: #{e.message}")

  _assertIsFunction: (func) =>
    if not _.isFunction func
      throw new Error("The function is not a function");
