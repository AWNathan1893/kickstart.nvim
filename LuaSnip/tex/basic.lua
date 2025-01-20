local helpers = require 'luasnip-helper-funcs'
local get_visual = helpers.get_visual

local line_begin = require('luasnip.extras.expand_conditions').line_begin

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
  -- BASE STYLE
  s(
    { trig = 'bsty', snippetType = 'autosnippet' },
    fmta(
      [=[
        \documentclass[a4paper,11pt]{article}
        \usepackage{../BaseStyle}

        \title{<>}
        \author{Aaratrick Basu}
        \date{}

        \begin{document}

        \maketitle

        <>

        \end{document}
        ]=],
      {
        i(1, 'Title'),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
  -- BEAMER STYLE
  s(
    { trig = 'psty', snippetType = 'autosnippet' },
    fmta(
      [=[
        \documentclass[aspectratio=169]{beamer}
        \usetheme[progressbar=frametitle]{Hannover}
        \usepackage{../BeamerStyle}

        \title{<>}
        \subtitle{<>}
        \author{Aaratrick Basu}
        \institute[UVA]{University of Virginia}
        \date{}

        \begin{document}

        \begin{frame}
        \maketitle
        \end{frame}

        <>

        \end{document}
        ]=],
      {
        i(1, 'Title'),
        i(2, 'Subtitle'),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- REFERENCE
  s(
    { trig = ' RR', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[
      ~\ref{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- USE A LATEX PACKAGE
  s(
    { trig = 'pack', snippetType = 'snippet' },
    fmta(
      [[
        \usepackage{<>}
        ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- LABEL
  s(
    { trig = 'lbl', snippetType = 'autosnippet' },
    fmta(
      [[
      \label{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- href command with URL in visual selection
  s(
    { trig = 'LU', snippetType = 'snippet' },
    fmta([[\href{<>}{<>}]], {
      d(1, get_visual),
      i(2),
    })
  ),
  -- href command with text in visual selection
  s(
    { trig = 'LL', snippetType = 'snippet' },
    fmta([[\href{<>}{<>}]], {
      i(1),
      d(2, get_visual),
    })
  ),
  -- HSPACE
  s(
    { trig = 'hss', snippetType = 'autosnippet' },
    fmta([[\hspace{<>}]], {
      d(1, get_visual),
    })
  ),
  -- VSPACE
  s(
    { trig = 'vss', snippetType = 'autosnippet' },
    fmta([[\vspace{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SMALLSKIP
  s(
    { trig = 'ssk', snippetType = 'autosnippet' },
    fmta(
      [[
    \smallskip{}
    
    <> ]],
      {
        i(0),
      }
    )
  ),
  -- MEDSKIP
  s(
    { trig = 'msk', snippetType = 'autosnippet' },
    fmta(
      [[
    \medskip{}
    
    <> ]],
      {
        i(0),
      }
    )
  ),
  -- BIGSKIP
  s(
    { trig = 'bsk', snippetType = 'autosnippet' },
    fmta(
      [[
    \bigskip{}
    
    <> ]],
      {
        i(0),
      }
    )
  ),
  -- SECTION
  s(
    { trig = 'h1', snippetType = 'autosnippet' },
    fmta([[\section{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SUBSECTION
  s(
    { trig = 'h2', snippetType = 'autosnippet' },
    fmta([[\subsection{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SUBSUBSECTION
  s(
    { trig = 'h3', snippetType = 'autosnippet' },
    fmta([[\subsubsection{<>}]], {
      d(1, get_visual),
    })
  ),
}
