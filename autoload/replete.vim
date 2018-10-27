let s:types = {}

function! replete#byArg(cmd, completeTypes) abort
  let s:types[ a:cmd ] = a:completeTypes
  return 'customlist,replete#handleCompletion'
endfunction

function! replete#handleCompletion(arg, line, pos) abort
  let parts = split(a:line, ' ')
  let cmd = parts[0]
  let args = parts[1:]
  let types = s:types[ cmd ]
  let type = types[ index(args, a:arg) ]
  exec 'let list =' type . '(a:arg, a:line, a:pos)'
  return list
endfunction
