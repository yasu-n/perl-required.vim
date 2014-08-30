" output plackup commands
let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ "name": "perl/core",
      \ "default_action": {'common': "insert"},
      \ }

function! unite#sources#perl_core#define()
  return s:source
endfunction

let s:file_path = expand('<sfile>:p:h')

function! s:source.gather_candidates(args, context)
  let mod_list = split(vimproc#system("perl -I" . s:git() . " " . s:file_path . "/modules.pl --core"), '\n')
  if empty(mod_list)
    return []
  endif

  return map(copy(mod_list), '{
        \ "word": v:val,
        \ "source": "perl/core",
        \ }')
endfunction

" return git root directory
function! s:git()
    let s:ret = substitute(vimproc#system('git rev-parse --show-toplevel'), '\n', '', 'g')
    let s:code = vimproc#get_last_status()

    if s:code
        let s:ret = './'
    endif

    return s:ret
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
