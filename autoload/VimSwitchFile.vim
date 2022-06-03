
"""""""""""""""""""""""""""""""""""
" Simple warning message function
"""""""""""""""""""""""""""""""""""
function! s:WarnMsg( msg )
  echohl WarningMsg
  echo a:msg
  echohl None
  return
endfunction

function! VimSwitchFile#FindProjectRoot()
    let b:home=fnamemodify('~', ':p:h')
    let b:proj_root=fnamemodify(finddir('src',";" . b:home), ':p:h:h')
    if b:proj_root == b:home
        let b:proj_root = "./"
    endif
    return b:proj_root
endfunction

function! VimSwitchFile#GetExpectedExtRegex( ext )
    if a:ext == "cpp"
        return "\\.\\(hpp\\|h\\)"
    elseif a:ext == "hpp"
        return "\\.\\(cpp\\|c\\)"
    if a:ext == "c"
        return "\\.h"
    else
        return ""
    endif
endfunction

function! VimSwitchFile#SwitchFile(...)
    let b:filename=expand('%:t:r')
    let b:ext=expand('%:e')

    let b:new_ext_regex=VimSwitchFile#GetExpectedExtRegex(b:ext)

    if b:new_ext_regex == ""
        call s:WarnMsg("Unsupported fileextension: '" . b:ext . "'")
        return
    endif

    let b:desired=".*/" . b:filename . b:new_ext_regex
    let b:proj_root=VimSwitchFile#FindProjectRoot()

    let b:find_call = 'find "' . b:proj_root . '" -regex "' . b:desired . '"'
    echo "Find call " . b:find_call
    let b:found_files = split(system(b:find_call), '\n')

    if len(b:found_files) == 1
        execute 'vsplit ' . get(b:found_files, 0)
    elseif len(b:found_files) == 0
        call s:WarnMsg("Did not find any file with the expected extension")
        return
    else
        let b:print_idx = 0
        for b:i in b:found_files
            echo b:print_idx . ": " . b:i
            let b:print_idx += 1
        endfor
        while 1
            call inputsave()
            let b:idx_str = input('Which file to open (q to quit    )? ')
            call inputrestore()
            let b:idx = str2nr(b:idx_str)

            if b:idx_str == "q"
                break
            elseif !(b:idx_str =~# '^\d\+$')
                call s:WarnMsg(" input is a not a (positive) number")
                continue
            elseif len(b:found_files) <= b:idx
                call s:WarnMsg(" Given index '" . b:idx . "' is too high, should be below " . len(b:found_files))
                continue
            endif

            execute 'vsplit ' . get(b:found_files, b:idx)
            break
        endwhile
    endif
endfunction
