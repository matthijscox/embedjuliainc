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

After succesfully running, you should see output on the command line like:
```
C++ myBoolean: 1        | Julia output: 1
C++ int_16: 37          | Julia output: 37
C++ int_32: -196        | Julia output: -196
C++ int_64: 9006271     | Julia output: 9006271
C++ uint_16: 5          | Julia output: 5
C++ uint_32: 0          | Julia output: 0
C++ uint_64: 128539223  | Julia output: 128539223
C++ float: 2.9671       | Julia output: 2.9671
C++ double: -9378.71    | Julia output: -9378.71
C++ const char*: String | Julia output: String
C++ string: String      | Julia output: String
C++ struct id: 19       | Julia output: 19
C++ struct parent id: 4 | Julia output: 4
C++ struct child id: 8  | Julia output: 8
C++ enum: 1             | Julia output: 1
C++ enum: 3             | Julia output: 3
C++ enum: 0             | Julia output: 0
C++ enum: -1            | Julia output: -1
```

