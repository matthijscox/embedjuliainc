module BasicTypes

    # note that exporting is not necessary for the library, only for ease of use in generate_precompile.jl
    export test_boolean, test_int16, test_int32, test_int64, test_uint16, test_uint32, test_uint64
    export test_cfloat, test_cdouble, test_cstring, test_struct, test_nested_structs
    export test_array, test_simple_enum, test_complex_enum

    #-----------------------------------------------------------------------------------------#
    #-------------------------------------  Booleans  ----------------------------------------#
    #-----------------------------------------------------------------------------------------#

    Base.@ccallable function test_boolean(myBoolean::UInt8)::UInt8
        @debug "Julia received boolean with value: $myBoolean"
        return myBoolean
    end

    #-----------------------------------------------------------------------------------------#
    #-------------------------------------  Integers  ----------------------------------------#
    #-----------------------------------------------------------------------------------------#

    # Note that the Int16 datatype is similar to the Cshort datatype
    Base.@ccallable function test_int16(myInt16::Int16)::Int16
        @debug "Julia received int16 with value: $myInt16"
        return myInt16
    end

    Base.@ccallable function test_int16_ptr(myInt16Ptr::Ptr{Int16})::Cvoid
        myInt16 = unsafe_load(myInt16Ptr)
        @debug "Julia received Ptr{Int16} with value: $myInt16"
        return Cvoid()
    end

    # Note that the Int32 datatype is similar to the Cint datatype
    Base.@ccallable function test_int32(myInt32::Int32)::Int32
        @debug "Julia received int32 with value: $myInt32"
        return myInt32
    end

    # Note that the Int64 datatype is similar to the Clonglong datatype
    Base.@ccallable function test_int64(myInt64::Int64)::Int64
        @debug "Julia received int64 with value: $myInt64"
        return myInt64
    end

    # Note that the UInt16 datatype is similar to the Cushort datatype
    Base.@ccallable function test_uint16(myUInt16::UInt16)::UInt16
        @debug "Julia received usigned int16 with value: $myUInt16"
        return myUInt16
    end

    # Note that the UInt32 datatype is similar to the Cuint datatype
    Base.@ccallable function test_uint32(myUInt32::UInt32)::UInt32
        @debug "Julia received unsigned int32 with value: $myUInt32"
        return myUInt32
    end

    # Note that the UInt64 datatype is similar to the Culonglong datatype
    Base.@ccallable function test_uint64(myUInt64::UInt64)::UInt64
        @debug "Julia received usigned int64 with value: $myUInt64"
        return myUInt64
    end

    #-----------------------------------------------------------------------------------------#
    #--------------------------------------  Doubles  ----------------------------------------#
    #-----------------------------------------------------------------------------------------#

    # Note that the Float32 datatype is similar to the Cfloat datatype
    Base.@ccallable function test_cfloat(myCfloat::Float32)::Float32
        @debug "Julia received float with value: $myCfloat"
        return myCfloat
    end

    # Note that the Float64 datatype is similar to the Cdouble datatype
    Base.@ccallable function test_cdouble(myCdouble::Float64)::Float64
        @debug "Julia received Cdouble with value: $myCdouble"
        return myCdouble
    end

    #-----------------------------------------------------------------------------------------#
    #--------------------------------------  Strings  ----------------------------------------#
    #-----------------------------------------------------------------------------------------#

    # Note that the Ptr{Uint8} datatype is similar to the Cstring datatype
    Base.@ccallable function test_cstring(myCstring::Ptr{UInt8})::Ptr{UInt8}
        # When using myCstring first cast it from a Ptr{UInt8} to the Julia String format
        myString::String = unsafe_string(myCstring)
        @debug "Julia received String with value: $myString"
        return myCstring
    end

    #-----------------------------------------------------------------------------------------#
    #--------------------------------------  Structs  ----------------------------------------#
    #-----------------------------------------------------------------------------------------#

    # Simple struct definition that uses Cint as example but can hold any primative datatype
    struct SimpleStruct
        SimpleStructId::Cint
    end

    Base.@ccallable function test_struct(mySimpleStruct::SimpleStruct)::SimpleStruct
        @debug "Julia received SimpleStruct.SimpleStructId with value: $(mySimpleStruct.SimpleStructId)"
        return mySimpleStruct
    end

    # More complex struct definition to show the possibilities with nested structs
    struct ChildStruct
        ChildStructId::Cint
    end

    struct ParentStruct
        ParentStructId::Cint
        myChildStruct::ChildStruct
    end

    Base.@ccallable function test_nested_structs(myParentStruct::ParentStruct)::ParentStruct
        @debug "Julia received ParentStruct.ParentStructId with value: $(myParentStruct.ParentStructId)"
        @debug "Julia received ParentStruct.myChildStruct.ChildStructId with value: $(myParentStruct.myChildStruct.ChildStructId)"
        return myParentStruct
    end

    #-----------------------------------------------------------------------------------------#
    #---------------------------------------  Array  -----------------------------------------#
    #-----------------------------------------------------------------------------------------#

    # Note that this function doesn't copy the array but actually receives a pointer to the
    # start of the array (myArrayPtr) and the size of the array (myArraySize) which we need
    # to correctly unload the data from the array
    Base.@ccallable function test_array(myArrayPtr::Ptr{Cint}, myArraySize::Cint)::Cvoid
        myArray = unsafe_wrap(Array{Cint}, myArrayPtr, myArraySize, own=false)
        @debug "Julia received an array with size: $myArraySize"
        @debug "Julia received the following array: $myArray"
    end

    #-----------------------------------------------------------------------------------------#
    #------------------------------------  Enumerations  -------------------------------------#
    #-----------------------------------------------------------------------------------------#

    @enum SimpleEnum begin
        myFirstEnumType = 1
        mySecondEnumType = 2
        myThirdEnumType = 3
    end

    Base.@ccallable function test_simple_enum(myEnum::SimpleEnum)::SimpleEnum
        @debug "Julia received enum type with value: $myEnum"
        return myEnum
    end

    @enum ComplexEnum begin
        # The number 0 is allowed as enum qualifier
        myFirstComplexEnumType = 0

        # Negative values are allowed
        mySecondComplexEnumType = -1

        # Values must be unique, thus defining two enumtypes with the same value throws an error
        # myThirdComplexEnumType = 7
        # myFourthComplexEnumType = 7
        # Defining an enumtype with another enumtype is also not allowed (breaking the rule above)
        # myFifthComplexEnumType = myFourthComplexEnumType
    end

    Base.@ccallable function test_complex_enum(myEnum::ComplexEnum)::ComplexEnum
        @debug "Julia received enum type with value: $myEnum"
        return myEnum
    end

end # module
