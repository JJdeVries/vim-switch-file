

if exists("g:VimSwitchFile_loaded")
    finish
endif
let g:VimSwitchFile_loaded = 1

" This dictionary defines the (user-configured) file mappings
" Will overrule the default mapping of a extension if it is present in the
" dict.
let g:VimSwitchFile_mapping = get(g:, 'VimSwitchFile_mapping', {})

command! -nargs=0 SwitchFile call VimSwitchFile#SwitchFile()
