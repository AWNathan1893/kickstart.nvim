local helpers = require 'luasnip-helper-funcs'
local get_visual = helpers.get_visual

local line_begin = require('luasnip.extras.expand_conditions').line_begin

-- Environment/syntax context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end
tex.in_tikz = function()
  local is_inside = vim.fn['vimtex#env#is_inside'] 'tikzpicture'
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

-- Return snippet tables
return {
  s({ trig = 'q' }, {
    t '\\quad ',
  }),
  s({ trig = 'qq', snippetType = 'snippet' }, {
    t '\\qquad ',
  }),
  s({ trig = 'pbrk', snippetType = 'autosnippet' }, {
    t { '\\pagebreak', '' },
  }, { condition = line_begin }),
  s({ trig = 'which', snippetType = 'snippet' }, {
    t '\\text{ for which } ',
  }, { condition = tex.in_mathzone }),
  s({ trig = 'and', snippetType = 'snippet' }, {
    t '\\quad \\text{and} \\quad',
  }, { condition = tex.in_mathzone }),
  s({ trig = 'uall', snippetType = 'autosnippet' }, {
    t '\\text{ for all } ',
  }, { condition = tex.in_mathzone }),
  s({ trig = 'toc', snippetType = 'autosnippet' }, {
    t '\\tableofcontents',
  }, { condition = line_begin }),
  s({ trig = ';8', snippetType = 'autosnippet' }, {
    t '\\infty',
  }),
  s({ trig = '([^%a])ii', snippetType = 'autosnippet' }, {
    t '\\item ',
  }, { condition = line_begin }),
  s({ trig = '--', snippetType = 'snippet' }, { t '% --------------------------------------------- %' }, { condition = line_begin }),
  -- HLINE WITH EXTRA VERTICAL SPACE
  s({ trig = 'hl' }, { t '\\hline {\\rule{0pt}{2.5ex}} \\hspace{-7pt}' }, { condition = line_begin }),
}
