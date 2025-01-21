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

local line_begin = require('luasnip.extras.expand_conditions').line_begin

-- Return snippet tables
return {
  -- GENERIC ENVIRONMENT
  s(
    { trig = 'beg', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH ONE EXTRA ARGUMENT
  s(
    { trig = 'beg2', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH TWO EXTRA ARGUMENTS
  s(
    { trig = 'beg3', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>}{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(3),
        d(4, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- EQUATION
  s(
    { trig = 'nn', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ALIGN
  s(
    { trig = 'al', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{align*}
            <>
        \end{align*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ITEMIZE
  s(
    { trig = 'ul', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{enumerate}[label=\(\bullet\)]

            \item <>

        \end{enumerate}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- ENUMERATE
  s(
    { trig = 'ol', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{enumerate}[label=<>]

            \item <>

        \end{enumerate}
      ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  -- INLINE MATH
  s(
    { trig = '([^%l])im', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\( <> \\)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- INLINE MATH ON NEW LINE
  s(
    { trig = '^im', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('\\( <> \\)', {
      i(1),
    })
  ),
  -- DISPLAY MATH ON NEW LINE
  s(
    { trig = 'dm', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('\\[ <> \\]', {
      i(1),
    }),
    { condition = line_begin }
  ),
  -- FIGURE
  s(
    { trig = 'fig' },
    fmta(
      [[
        \begin{figure}[htb!]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    ),
    { condition = line_begin }
  ),
  -- PROBLEM AND SOLUTION
  s(
    { trig = 'psol', snippetType = 'autosnippet' },
    fmta(
      [=[
        \begin{problem}
        <>
        \end{problem}

        \begin{soln}
        <>
        \end{soln}
          ]=],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
}
