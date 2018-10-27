function! replete#complete#bufwords(arg, line, pos) abort
  let list = []
  let back = @a
  %yank a
  call substitute(@a, '\<' . a:arg . '\k*', '\=add(list, submatch(0))', 'g')
  let @a = back
  return uniq(sort(copy(list)))
endfunction

function! replete#complete#file(arg, line, pos) abort
  let list = globpath('./', a:arg . '*', 0, 1)
  return map(list, 'substitute(v:val, "^./", "", "")')
endfunction
