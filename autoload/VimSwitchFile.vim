
function! VimSwitchFile#SwitchFile(...)
    let b:filename=expand('%:t:r')
    let b:ext=expand('%:e')

    if b:ext == 'cpp' || b:ext == "c"
        let b:new_ext = ".h"
    elseif b:ext == "hpp" || b:ext == "h"
        let b:new_ext = ".cpp"
    else
        echo "Unsupported file"
        let b:new_ext = ""
    endif

    let b:desired=b:filename . b:new_ext
    echo "Trying for file " . b:desired
    if filereadable(b:desired)
        echo "Found file!"
        execute 'vsplit' . " " . fnameescape(b:desired)
    else
        echo "Did not find file :-( " + b:desired
    endif
endfunction
