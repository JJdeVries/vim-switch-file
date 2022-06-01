

if exists("g:vim_switch_file_plugin")
    finish
endif
let g:vim_switch_file_plugin = 1

command! -nargs=0 SwitchFile call vim_switch_file#SwitchFile()
