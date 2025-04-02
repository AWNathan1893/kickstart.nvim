local helpers = require 'luasnip-helper-funcs'
local get_visual = helpers.get_visual

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

-- Return snippet tables
return {
  -- SUPERSCRIPT
  s(
    { trig = '([%w%)%]%}]):', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT
  s(
    { trig = '([%w%)%]%}]);', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT AND SUPERSCRIPT
  s(
    { trig = '([%w%)%]%}])__', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>^{<>}_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- TEXT SUBSCRIPT
  s({ trig = 'sd', snippetType = 'autosnippet', wordTrig = false }, fmta('_{\\mathrm{<>}}', { d(1, get_visual) }), { condition = tex.in_mathzone }),
  -- SUPERSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a superscript.
  s(
    { trig = '([%w%)%]%}])"([%w])', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a subscript.
  s(
    { trig = '([%w%)%]%}]):([%w])', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- EULER'S NUMBER SUPERSCRIPT SHORTCUT
  s(
    { trig = '([^%a])ee', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>e^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- MINUS ONE SUPERSCRIPT SHORTCUT
  s(
    { trig = '([%a%)%]%}])11', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '-1',
    }),
    { condition = tex.in_mathzone }
  ),
  -- PLUS SUPERSCRIPT SHORTCUT
  s(
    { trig = '([%a%)%]%}])%+%+', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '+',
    }),
    { condition = tex.in_mathzone }
  ),
  -- COMPLEMENT SUPERSCRIPT
  s(
    { trig = '([%a%)%]%}])CC', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '\\complement',
    }),
    { condition = tex.in_mathzone }
  ),
  -- CONJUGATE (STAR) SUPERSCRIPT SHORTCUT
  s(
    { trig = '([%a%)%]%}])%*%*', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '*',
    }),
    { condition = tex.in_mathzone }
  ),
  -- BMATRIX, i.e. \bmatrix env
  s(
    { trig = '([^%a])bm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta(
      [[
      <>\begin{bmatrix}
      <>
      \end{bmatrix}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- PMATRIX, i.e. \pmatrix env
  s(
    { trig = '([^%a])pm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta(
      [[
      <>\begin{pmatrix}
      <>
      \end{pmatrix}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  -- FRACTION
  s(
    { trig = '([^%a])ff', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{<>}{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INNER PRODUCT
  s(
    { trig = '([^%a])inp', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\left\\langle {<>},{<>} \\right\\rangle', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- FLOOR
  s(
    { trig = '([^%a])fl', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\left\\lfloor <> \\right\\rfloor', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- CEIL
  s(
    { trig = '([^%a])ce', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\left\\lceil <> \\right\\rceil', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ABSOLUTE VALUE
  s(
    { trig = '([^%a])aa', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\abs{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SQUARE ROOT
  s(
    { trig = '([^%a])sq', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sqrt{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BINOMIAL SYMBOL
  s(
    { trig = '([^%\\])bnn', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\binom{<>}{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- LOGARITHM
  s(
    { trig = '([^%a%\\])ll', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\log\\left({<>}\\right)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- EXPONENTIAL
  s(
    { trig = '([^%a%\\])mee', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\exp\\left({<>}\\right)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUM with lower limit
  s(
    { trig = '([^%a])sM', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sum_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUM with upper and lower limit
  s(
    { trig = '([^%a])smm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sum_{<>}^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL with lower limit
  s(
    { trig = '([^%a])intt', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\int_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL from positive to negative infinity
  s(
    { trig = '([^%a])intf', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\int_{\\infty}^{\\infty}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BOXED command
  s(
    { trig = '([^%a])bb', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\boxed{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- OVERLINE
  s({ trig = 'ovl', snippetType = 'autosnippet' }, fmta('\\overline{<>}', { i(1) }), { condition = tex.in_mathzone }),
  -- TILDE
  s({ trig = 'ovt', snippetType = 'autosnippet' }, fmta('\\widetilde{<>}', { i(1) }), { condition = tex.in_mathzone }),
  -- HAT
  s({ trig = 'ovh', snippetType = 'autosnippet' }, fmta('\\widehat{<>}', { i(1) }), { condition = tex.in_mathzone }),
  --
  -- BEGIN STATIC SNIPPETS
  --

  -- BASIC INTEGRAL SYMBOL, i.e. \int
  s({ trig = 'in1', snippetType = 'autosnippet' }, { t '\\int' }, { condition = tex.in_mathzone }),
  -- DOUBLE INTEGRAL, i.e. \iint
  s({ trig = 'in2', snippetType = 'autosnippet' }, {
    t '\\iint',
  }, { condition = tex.in_mathzone }),
  -- TRIPLE INTEGRAL, i.e. \iiint
  s({ trig = 'in3', snippetType = 'autosnippet' }, {
    t '\\iiint',
  }, { condition = tex.in_mathzone }),
  -- CLOSED SINGLE INTEGRAL, i.e. \oint
  s({ trig = 'oi1', snippetType = 'autosnippet' }, {
    t '\\oint',
  }, { condition = tex.in_mathzone }),
  -- CLOSED DOUBLE INTEGRAL, i.e. \oiint
  s({ trig = 'oi2', snippetType = 'autosnippet' }, {
    t '\\oiint',
  }, { condition = tex.in_mathzone }),
  -- GRADIENT OPERATOR, i.e. \grad
  s({ trig = 'gdd', snippetType = 'autosnippet' }, {
    t '\\grad ',
  }, { condition = tex.in_mathzone }),
  -- CURL OPERATOR, i.e. \curl
  s({ trig = 'cll', snippetType = 'autosnippet' }, {
    t '\\curl ',
  }, { condition = tex.in_mathzone }),
  -- DIVERGENCE OPERATOR, i.e. \divergence
  s({ trig = 'DI', snippetType = 'autosnippet' }, {
    t '\\div ',
  }, { condition = tex.in_mathzone }),
  -- LAPLACIAN OPERATOR, i.e. \laplacian
  s({ trig = 'laa', snippetType = 'autosnippet' }, {
    t '\\laplacian ',
  }, { condition = tex.in_mathzone }),
  -- CDOTS, i.e. \cdots
  s({ trig = 'cdd', snippetType = 'autosnippet' }, {
    t '\\cdots',
  }),
  -- LDOTS, i.e. \ldots
  s({ trig = 'ldd', snippetType = 'autosnippet' }, {
    t '\\ldots',
  }),
  -- EQUIV, i.e. \equiv
  s({ trig = 'eqq', snippetType = 'autosnippet' }, {
    t '\\equiv ',
  }),
  -- SETMINUS, i.e. \setminus
  s({ trig = 'stm', snippetType = 'autosnippet' }, {
    t '\\setminus ',
  }),
  -- SUBSET, i.e. \subset
  s({ trig = 'sbb', snippetType = 'autosnippet' }, {
    t '\\subset ',
  }),
  -- COLON, i.e. \colon
  s({ trig = '::', snippetType = 'autosnippet' }, {
    t '\\colon ',
  }),
  -- IMPLIES, i.e. \implies
  s({ trig = '>>', snippetType = 'autosnippet' }, {
    t '\\implies ',
  }),
  -- DOT PRODUCT, i.e. \cdot
  s({ trig = ',.', snippetType = 'autosnippet' }, {
    t '\\cdot ',
  }),
  -- CROSS PRODUCT, i.e. \times
  s({ trig = 'xx', snippetType = 'autosnippet' }, {
    t '\\times ',
  }, {
    condition = tex.in_mathzone(),
  }),
  -- MAPSTO
  s({ trig = ';mt', snippettype = 'autosnippet' }, {
    t '\\mapsto ',
  }, {
    condition = tex.in_mathzone(),
  }),
  -- CONTRADICTION
  s({ trig = 'cqed', snippettype = 'autosnippet' }, {
    t '\\hfill \\rightarrow \\leftarrow',
  }, {
    condition = tex.in_mathzone(),
  }),
  -- PROOF END
  s({ trig = 'qed', snippettype = 'autosnippet' }, {
    t '\\hfill \\blacksquare',
  }, {
    condition = tex.in_mathzone(),
  }),
}
