

if exists("g:vim_switch_file-plugin")
    finish
endif
let g:vim_switch_file-plugin = 1

command! -nargs=0 SwitchFile call vim-switch-file#SwitchFile()
