
"""""""""""""""""""""""""""""""""""
" Simple warning message function
"""""""""""""""""""""""""""""""""""
function! s:WarnMsg( msg )
  echohl WarningMsg
  echo a:msg
  echohl None
  return
endfunction

function! s:FindProjectRoot()
    let l:home=fnamemodify('~', ':p:h')
    let l:proj_root=fnamemodify(finddir('src',";" . l:home), ':p:h:h')
    if l:proj_root == l:home
        let l:proj_root = "./"
    endif
    return l:proj_root
endfunction

function! s:GetExpectedExtRegex( ext )
    let l:default_extensions = {
\    "cpp": ["hpp", "h"],
\    "c": ["h"],
\    "hpp": ["cpp"],
\    "h": ["cpp", "c"],
\}

    if has_key(g:VimSwitchFile_mapping, a:ext)
        let l:mapping = g:VimSwitchFile_mapping[a:ext]
    elseif has_key(l:default_extensions, a:ext)
        let l:mapping = l:default_extensions[a:ext]
    else
        call s:WarnMsg("Unsupported extension '" . a:ext . "', maybe add it to the g:VimSwitchFile_mapping variable?")
        return ""
    endif

    if len(l:mapping) == 0
        call s:WarnMsg("No proper mapping defined for extension '" . a:ext . "'")
        return ""
    endif

    if type(l:mapping) is v:t_string
        return "\\." . l:mapping
    elseif type(l:mapping) is v:t_list
        elseif len(l:mapping) == 1
            return "\\." . l:mapping[0]
        endif

        " Let's create a group: \(ext1|ext2...\)
        " Note the extra escaping of a '\' char
        let l:output = "\\.\\("
        let l:idx = 0
        for l:map in l:mapping
            let l:output = l:output . l:map
            if l:idx < len(l:mapping) - 1
                " We need to avoid adding the '|' on the last iteration
                let l:output = l:output . "\\|"
            endif
            let l:idx += 1
        endfor

        return l:output . "\\)"
    endif
endfunction

function! s:OpenWindow( file )
    " Let's first check if the file is already open
    let l:winid = bufwinid(a:file)
    if l:winid != -1
        call win_gotoid(l:winid)
        return
    endif

    " TODO: Probably we want to configure the vsplit (or optionally give as an argument?!)
    execute 'vsplit ' . a:file
endfunction

function! s:PickFile( files )
    let l:print_idx = 0
    for l:i in a:files
        echo l:print_idx . ": " . l:i
        let l:print_idx += 1
    endfor
    while 1
        call inputsave()
        let l:idx_str = input('Which file to open (q to quit)? ')
        call inputrestore()
        let l:idx = str2nr(l:idx_str)

        if l:idx_str == "q"
            return ""
        elseif !(l:idx_str =~# '^\d\+$')
            call s:WarnMsg(" input is a not a (positive) number")
            continue
        elseif len(a:files) <= l:idx
            call s:WarnMsg(" Given index '" . l:idx . "' is too high, should be below " . len(a:files))
            continue
        endif

        return get(a:files, l:idx)
    endwhile
endfunction

function! VimSwitchFile#SwitchFile(...)
    let l:filename=expand('%:t:r')
    let l:ext=expand('%:e')

    let l:new_ext_regex=s:GetExpectedExtRegex(l:ext)

    if l:new_ext_regex == ""
        call s:WarnMsg("Unsupported fileextension: '" . l:ext . "'")
        return
    endif

    let l:proj_root=s:FindProjectRoot()

    let l:find_call = "find '" . l:proj_root . "' -regex '.*/" . l:filename . l:new_ext_regex . "'"
    let l:found_files = split(system(l:find_call), '\n')

    if len(l:found_files) == 0
        let l:open_file = ""
        call s:WarnMsg("Did not find a file with the configured extensions")
    elseif len(l:found_files) == 1
        let l:open_file = get(l:found_files, 0)
    else
        let l:open_file = call s:PickFile(l:found_files)
    endif

    if l:open_file != ""
        call s:OpenWindow(l:open_file)
    endif
endfunction
