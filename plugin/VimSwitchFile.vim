

if exists("g:VimSwitchFile_loaded")
    finish
endif
let g:VimSwitchFile_loaded = 1

command! -nargs=0 SwitchFile call VimSwitchFile#SwitchFile()
