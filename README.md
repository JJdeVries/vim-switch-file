# Vim Switch File
Helper method for quickly switching between source and header files of CPP / C projects.
It works by searching upwards from the current open file till either a `src` directory is found,
or the home directory is reached. From this directory we search for a file with the same filename,
but a (hard-coded) mapped extension. If multiple matches are found the user is given a choice which
file to open.

The switch can be invoked by calling `:SwitchFile` from within a c/cpp file. The file will be opened
in a vsplit. A suggestion is to add a mapping e.g. `nnoremap <Leader>s :SwitchFile<CR>`.

## Installation

### Vundle
Place this in the plugin section of your `.vimrc`
```
Plugin 'JJdeVries/vim-switch-file'
```

## The default mapping
The default mapped file extensions are as follows:
| file\_extension | mapped\_extensions |
|-----------------|--------------------|
|            .cpp |            .h .hpp |
|            .hpp |               .cpp |
|              .c |                 .h |
|              .h |            .cpp .c |

### Custom configuration
The mapping can be changed by defining the dictionary `g:VimSwitchFile_mapping`. This can be done by
adding the following to your `.vimrc`:
```
let g:VimSwitchFile_mapping = {
\    "cpp": ["hhpp", "xxx"],
\    "custom": "other",
\}
```

The extensions should be defined **without** the `.` separating the filename and the extension, also
note that defining an extensions means the default configured is not used (meaning the default options
are **not** extended).

## Open issues
A number of possible optimizations can still be implemented.

* Stop searching upwards if we find a `.git` folder.
* Possibility to customize the project root detection (which file/folder to find)
* Possibility to configure how to open the other file (e.g. split, another tab, another window).
* Avoid searching upwards if the header/source file is in the same directory.
