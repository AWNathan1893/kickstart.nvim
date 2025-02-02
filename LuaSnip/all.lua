local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node

return {
  -- A snippet that expands the trigger "hi" into the string "Hello, world!".
  s({ trig = 'hi' }, { t 'Hello, world!' }),

  -- To return multiple snippets, use one `return` statement per snippet file
  -- and return a table of Lua snippets.
  require('luasnip').snippet({ trig = 'foo' }, { t 'Another snippet.' }),

  s({ trig = ';a', snippetType = 'autosnippet' }, {
    t '\\alpha',
  }),
}
