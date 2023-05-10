To illustrate the possibility of external multi-threading from c++ into Julia 1.9.

## Instructions

You can compile using the Makefile. Make sure you have a good c++ compiler and `make` tool.

In a nutshell:
* git clone this repo in a folder
* on windows, open cmd, cd into the `threads` folder
* run `make` to compile a Julia library and the c++ executable
* run the exe: `compiled/bin/julia_threads-cpp.exe`

You can also run `make build-cpp` to skip the Julia compilation.

