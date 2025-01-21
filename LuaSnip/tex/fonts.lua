local helpers = require 'luasnip-helper-funcs'
local get_visual = helpers.get_visual

-- A logical OR of `line_begin` and the regTrig '[^%a]trig'
function line_begin_or_non_letter(line_to_cursor, matched_trigger)
  local line_begin = line_to_cursor:sub(1, -(#matched_trigger + 1)):match '^%s*$'
  local non_letter = line_to_cursor:sub(-(#matched_trigger + 1), -(#matched_trigger + 1)):match '[^%a]'
  return line_begin or non_letter
end

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

local line_begin = function(line_to_cursor, matched_trigger)
  -- +1 because `string.sub("abcd", 1, -2)` -> abc
  return line_to_cursor:sub(1, -(#matched_trigger + 1)):match '^%s*$'
end

-- Return snippet tables
return {
  -- TYPEWRITER i.e. \texttt
  s(
    { trig = '([^%a])tt', regTrig = true, wordTrig = false, snippetType = 'autosnippet', priority = 2000 },
    fmta('<>\\texttt{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_text }
  ),
  -- ITALIC i.e. \textit
  s(
    { trig = '([^%a])tii', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\textit{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- BOLD i.e. \textbf
  s(
    { trig = 'tbb', snippetType = 'autosnippet' },
    fmta('\\textbf{<>}', {
      d(1, get_visual),
    })
  ),
  -- MATH ROMAN i.e. \mathrm
  s(
    { trig = '([^%a])mrm', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathrm{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH SCRIPT i.e. \mathscr
  s(
    { trig = '([^%a])msc', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathscr{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH FRAKTUR i.e. \mathfrak
  s(
    { trig = '([^%a])mfr', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathfrak{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH CALIGRAPHY i.e. \mathcal
  s(
    { trig = '([^%a])mcc', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathcal{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH BOLDFACE i.e. \mathbf
  s(
    { trig = '([^%a])mbf', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathbf{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- MATH BLACKBOARD i.e. \mathbb
  s(
    { trig = '([^%a])mbb', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\mathbb{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- REGULAR TEXT i.e. \text (in math environments)
  s(
    { trig = '([^%a])tee', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\text{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- OPERATORS
  s(
    { trig = '([^%a])mop', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\operatorname{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- RATIONALS
  s({ trig = 'mqq', snippetType = 'autosnippet' }, { t '\\mathbbm{Q}' }, { condition = tex.in_mathzone }),
  -- REALS
  s({ trig = 'mrr', snippetType = 'autosnippet' }, { t '\\mathbbm{R}' }, { condition = tex.in_mathzone }),
  -- COMPLEX
  s({ trig = 'mcz', snippetType = 'autosnippet' }, { t '\\mathbbm{C}' }, { condition = tex.in_mathzone }),
  -- INTEGERS
  s({ trig = 'mzz', snippetType = 'autosnippet' }, { t '\\mathbbm{Z}' }, { condition = tex.in_mathzone }),
  -- SPHERES
  s(
    { trig = 'mss', snippetType = 'autosnippet' },
    fmta('\\mathbbm{S}^{<>}', {
      i(1, 'n'),
    }),
    { condition = tex.in_mathzone }
  ),
  -- HYPERBOLIC SPACE
  s(
    { trig = 'mhh', snippetType = 'autosnippet' },
    fmta('\\mathbbm{H}^{<>}', {
      i(1, 'n'),
    }),
    { condition = tex.in_mathzone }
  ),
}
