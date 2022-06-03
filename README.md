# Vim Switch File
Helper method for quickly switching between source and header files of CPP / C projects.
It works by searching upwards from the current open file till either a `src` directory is found,
or the home directory is reached. From this directory we search for a file with the same filename,
but a (hard-coded) mapped extension. If multiple matches are found the user is given a choice which
file to open.

The switch can be invoked by calling `:SwitchFile` from within a c/cpp file. The file will be opened
in a vsplit. A suggestion is to add a mapping e.g. `nnoremap <Leader>s :SwitchFile<CR>`.

## The mapping
The mapped file extensions are as follows:
| file\_extension | mapped\_extensions |
|-----------------|--------------------|
|            .cpp |            .h .hpp |
|            .hpp |               .cpp |
|              .c |                 .h |
|              .h |            .cpp .c |

## Open issues
A number of possible optimizations can still be implemented.

* Possibility to configure/extend the mapped extensions in your .vimrc
* Stop searching upwards if we find a `.git` folder.
* Possibility to customize the project root detection (which file/folder to find)
* Avoid opening another vsplit if we already have the file open.
* Possibility to configure how to open the other file (e.g. split, another tab, another window).
* Avoid searching upwards if the header/source file is in the same directory.
