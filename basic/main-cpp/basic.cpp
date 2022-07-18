
#include <julia.h>
#include <iostream>
#include <iomanip>

// to avoid name mangling we use extern C
// google for 'name mangling and extern C in C++'
extern "C"
{
    #include "julia_init.h"
    #include "basic.h"
}

//-----------------------------------------------------------------------------------------//
//-------------------------------- Calling the Julia code  --------------------------------//
//-----------------------------------------------------------------------------------------//

int main(int argc, char *argv[])
{
    // Setting Julia options with jl_options
    //jl_options.compile_enabled = 0;
    //jl_options.debug_level = -1;

    init_julia(argc, argv);

    if(!jl_is_initialized())
    {
       std::cout << "Julia was unable to initialize, check if the path to the .so file is correct" << std::endl;
       return 0;
    }

    //-------------------------------------------------------------------------------------//
    //-----------------------------------  Booleans  --------------------------------------//
    //-------------------------------------------------------------------------------------//

    bool myBoolean = true;
    std::cout << std::left <<"C++ myBoolean: " << std::setw(8) << myBoolean << " | Julia output: " << test_boolean(myBoolean) << std::endl;

    //-------------------------------------------------------------------------------------//
    //-----------------------------------  Integers  --------------------------------------//
    //-------------------------------------------------------------------------------------//

    int16_t myInt16 = 37;
    std::cout << std::left << "C++ int_16: " << std::setw(11) << myInt16 << " | Julia output: " << test_int16(myInt16) << std::endl;
    int32_t myInt32 = -196;
    std::cout << std::left << "C++ int_32: " << std::setw(11) << myInt32 << " | Julia output: " << test_int32(myInt32) << std::endl;
    int64_t myInt64 = 9006271;
    std::cout << std::left << "C++ int_64: " << std::setw(11) << myInt64 << " | Julia output: " << test_int64(myInt64) << std::endl;
    uint16_t myUInt16 = 5;
    std::cout << std::left << "C++ uint_16: " << std::setw(10) << myUInt16 << " | Julia output: " << test_uint16(myUInt16) << std::endl;
    uint32_t myUInt32 = 0;
    std::cout << std::left << "C++ uint_32: " << std::setw(10) << myUInt32 << " | Julia output: " << test_uint32(myUInt32) << std::endl;
    uint64_t myUInt64 = 128539223;
    std::cout << std::left << "C++ uint_64: " << std::setw(10) << myUInt64 << " | Julia output: " << test_uint64(myUInt64) << std::endl;

    //-------------------------------------------------------------------------------------//
    //------------------------------------  Doubles  --------------------------------------//
    //-------------------------------------------------------------------------------------//

    float myFloat = 2.9671;
    std::cout << std::left << "C++ float: " << std::setw(12) << myFloat << " | Julia output: " << test_cfloat(myFloat) << std::endl;
    double myDouble = -9378.7147;
    std::cout << std::left << "C++ double: " << std::setw(11) << myDouble << " | Julia output: " << test_cdouble(myDouble) << std::endl;

    //-------------------------------------------------------------------------------------//
    //------------------------------------  Strings  --------------------------------------//
    //-------------------------------------------------------------------------------------//

    // Passing strings directly will not work, either use a const char* or alternatively use c_str()
    const char* myCharPtr = "String";
    std::cout << std::left << "C++ const char*: " << std::setw(6) << myCharPtr << " | Julia output: " << test_cstring(myCharPtr) << std::endl;
    std::string myString = "String";
    std::cout << std::left << "C++ string: " << std::setw(11) << myString << " | Julia output: " << test_cstring(myString.c_str()) << std::endl;

    //-------------------------------------------------------------------------------------//
    //------------------------------------  Structs  --------------------------------------//
    //-------------------------------------------------------------------------------------//

    SimpleStruct mySimpleStruct = {19};
    std::cout << std::left << "C++ struct id: " << std::setw(8) << mySimpleStruct.SimpleStructId << " | Julia output: " << test_struct(mySimpleStruct).SimpleStructId << std::endl;

    ChildStruct myChildStruct = {8};
    ParentStruct myParentStruct = {4, myChildStruct, {1, 3, 7}};
    std::cout << std::left << "C++ struct parent id: " << std::setw(1) << myParentStruct.ParentStructId << " | Julia output: " << test_nested_structs(myParentStruct).ParentStructId << std::endl;
    std::cout << std::left << "C++ struct child id: " << std::setw(2) << myParentStruct.myChildStruct.ChildStructId << " | Julia output: " << test_nested_structs(myParentStruct).myChildStruct.ChildStructId << std::endl;

    //-------------------------------------------------------------------------------------//
    //-------------------------------------  Array  ---------------------------------------//
    //-------------------------------------------------------------------------------------//

    // Turn on debug mode to see the array testing
    int myArraySize = 5;
    int myArray[myArraySize] = {1, 3, 7, 13, 21};
    int* myArrayPtr = &myArray[0];
    test_array(myArrayPtr, myArraySize);

    //-------------------------------------------------------------------------------------//
    //----------------------------------  Enumerations  -----------------------------------//
    //-------------------------------------------------------------------------------------//

    std::cout << std::left << "C++ enum: " << std::setw(13) << myFirstEnumType << " | Julia output: " << test_simple_enum(myFirstEnumType) << std::endl;
    std::cout << std::left << "C++ enum: " << std::setw(13) << myThirdEnumType << " | Julia output: " << test_simple_enum(myThirdEnumType) << std::endl;

    std::cout << std::left << "C++ enum: " << std::setw(13) << myFirstComplexEnumType << " | Julia output: " << test_complex_enum(myFirstComplexEnumType) << std::endl;
    std::cout << std::left << "C++ enum: " << std::setw(13) << mySecondComplexEnumType << " | Julia output: " << test_complex_enum(mySecondComplexEnumType) << std::endl;

    //-------------------------------------------------------------------------------------//
    //------------------------------------  Exceptions  -----------------------------------//
    //-------------------------------------------------------------------------------------//

    try
    {
        throw_basic_error();
    }
    catch (const std::exception& e)
    {
        std::cout << "\n a standard exception was caught, with message '"
                  << e.what() << std::endl;
    }
    catch (...)
    {
        std::cout << "\n unknown exception caught" << std::endl;
    }

    // Notify Julia the program is about to terminate, it is not mandatory but it allows
    // julia time to cleanup pending write reqeuests and run all finalizers
    // jl_atexit_hook(0); // from julia.h
    shutdown_julia(0); // julia_init.h comes with it's own shutdown function
    return 0;
}