
function! VimSwitchFile#SwitchFile(...)
    let b:ext=expand('%:e')

    if ext == 'cpp' || ext == 'c'
        echo "In cpp file"
    elseif ext == "hpp" || ext = "h"
        echo "In cpp header file"
    else
        echo "Unsupported file"
    endif
endfunction
