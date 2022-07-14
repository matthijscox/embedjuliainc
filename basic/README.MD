To illustrate the possibilities of transferring data between C++ and Julia this module contains examples of the different datatypes that can be passed between Julia and C++.


Because some types are not as straightforward as it may seem and the documentation
only covers C and not C++ this package contains example implementations for functions
that pass the following datatypes between Julia and C++:
* Booleans
* Integers
* Doubles
* Strings
* Structs
* Arrays
* Enumerations

## Instructions

You can compile using the Makefile. Make sure you have a good c++ compiler and `make` tool.

In a nutshell:
* git clone this repo in a folder
* on windows, open cmd, cd into that folder
* run `make` to compile a Julia library and the c++ executable
* run the exe: `compiled/bin/basic-cpp.exe`

