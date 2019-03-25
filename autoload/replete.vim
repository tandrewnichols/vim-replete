let s:types = exists('s:types') ? s:types : {}

function! replete#byArg(cmd, completeTypes) abort
  let s:types[ a:cmd ] = a:completeTypes
  return 'customlist,replete#handleCompletion'
endfunction

function! replete#echoTypes() abort
  echo s:types
endfunction

function! replete#handleCompletion(arg, line, pos)
  let splitChar = replete#findSplitChar(a:line)
  let words = replete#getWords(a:line, splitChar)
  let cmd = words[0]
  let args = words[1:]
  let types = s:types[ cmd ]
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
