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

Opening the Julia system image, the correct path needs to be added as the first param inside the main function

    jl_init_with_image("/embedjuliainc/basic/main-cpp", "basic.dll");

Update the Makefile with your location of Julia.

