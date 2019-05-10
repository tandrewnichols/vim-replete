let s:types = exists('s:types') ? s:types : {}

function! replete#byArg(cmd, completeTypes, ...) abort
  let s:types[ a:cmd ] = { 'types': a:completeTypes }
  if a:0 > 0
    let s:types[ a:cmd ].pattern = a:1
  endif
  return 'customlist,replete#handleCompletion'
endfunction

function! replete#handleCompletion(arg, line, pos) abort
  let line = a:line
  let parts = split(line, ' ')
  let cmd = parts[0]
  let rest = join(parts[1:], ' ')
  if has_key(s:types[cmd], 'pattern')
    let line = substitute(rest, s:types[cmd].pattern, '', 'g')
  endif

  let splitChar = replete#findSplitChar(line)
  let args = replete#getWords(line, splitChar)
  let types = s:types[ cmd ].types
  let type = types[ index(args, a:arg) ]

  try
    exec 'let list = ' type . '(a:arg, a:line, a:pos)'
  catch /E117/
    try
      let list = getcompletion(a:arg, type)
    catch /E475/
      let list = []
    endtry
  endtry

  return list
endfunction

function! replete#findSplitChar(line) abort
  let splitChars = ['_', '|', '%', '&', '+', '/']
  for char in splitChars
    if stridx(a:line, char) > -1
      return char
    endif
  endfor
endfunction

function! replete#getWords(line, char) abort
  let line = substitute(a:line, '"[^ ]\+\zs \ze[^"]\+', a:char, 'g')
  let line = substitute(line, '"', '', 'g')
  let words = split(line, ' ')
  return map(words, {i, word -> substitute(word, a:char, ' ', 'g')})
endfunction
