const Environment = require("environment");
const TokenStream = require("parser");
const InputStream = require("inputstream");
const parse = require("parser");
const evaluate = require("evaluate");
/*
import Environment from environment;
import TokenStream from parser;
import InputStream from inputstream;
import parse from parser;
import evaluate from evaluate;
*/

const globalEnv = new Environment()

globalEnv.def("time", func => {
  try {
    console.time('time')
    return func()
  } finally {
    console.endTime('time')
  }
})

if (typeof process != "undefined") (function() {
  globalEnv.def("println", val => console.log(val))

  globalEnv.def("print", val => process.stdout.write(`${val}`))

  let code = ""
  process.stdin.setEncoding("utf8")
  process.stdin.on("readable", function() {
    const chunk = process.stdin.read()
    if (chunk) code += chunk
  })
  process.stdin.on("end", function() {
    const ast = parse(TokenStream(InputStream(code)))
    evaluate(ast, globalEnv)
  })
})()