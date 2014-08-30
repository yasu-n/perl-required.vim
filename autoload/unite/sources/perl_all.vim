" output plackup commands
let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ "name": "perl/all",
      \ "default_action": {'common': "insert"},
      \ }

function! unite#sources#perl_all#define()
  return s:source
endfunction

let s:file_path = expand('<sfile>:p:h')

function! s:source.gather_candidates(args, context)
  let mod_list = split(unite#util#system("perl -I" . s:git() . " " . s:file_path . "/modules.pl --all"), '\n')
  if empty(mod_list)
    return []
  endif

  return map(copy(mod_list), '{
        \ "word": v:val,
        \ "source": "perl/all",
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
