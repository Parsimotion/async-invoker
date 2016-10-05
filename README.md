# Async invoker

[![NPM version](https://badge.fury.io/js/async-invoker.png)](http://badge.fury.io/js/async-invoker)

Create a promise with result of the invoke your code.

## Sync function - example
```coffee
    AsyncInvoker = require "async-invoker"
    code = " function (a, b) { return a + b; } "
    
    new AsyncInvoker(code)
    .invoke (1, 2)
    .tap console.log  # 3
```

## Async function - example
```CoffeeScript

    AsyncInvoker = require "async-invoker"
    code = " function (callback) { callback(1 + 2); } "
    
    new AsyncInvoker(code)
    .invoke()
    .tap console.log  # 3
```
    
