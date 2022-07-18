# for testing, cd into BasicTypes folder and run as follows:
# julia --startup-file=no --project=. build/generate_precompile.jl

# Note: to see help for Julia flags use julia -h, or julia --help-hidden.

using BasicTypes

# enable debug printing
# ENV["JULIA_DEBUG"]=BasicTypes

begin
    test_boolean(UInt8(1))
    test_int16(Int16(1))
    test_int32(Int32(1))
    test_int64(Int64(1))
    test_uint16(UInt16(1))
    test_uint32(UInt32(1))
    test_uint64(UInt64(1))
    test_cfloat(Float32(1))
    test_cdouble(Float64(1))

    # CString as pointer
    c_string_ptr = Base.unsafe_convert(Cstring, "String") |> Ptr{UInt8}
    test_cstring(c_string_ptr)

    test_struct(BasicTypes.SimpleStruct(Cint(1)))

    test_nested_structs(
        BasicTypes.ParentStruct(
            Cint(1),
            BasicTypes.ChildStruct(Cint(2)),
            (Cint(1),Cint(3),Cint(7)),
        )
    )

    # pointers... https://giordano.github.io/blog/2019-05-03-julia-get-pointer-value/
    arr = Cint[1,2,3]
    arr_pointer = Ptr{Cint}(pointer_from_objref(arr))
    len_arr = Base.cconvert(Cint, length(arr))
    # please garbage collector, preserve my variables during execution
    GC.@preserve arr test_array(arr_pointer, len_arr)

    test_simple_enum(BasicTypes.mySecondEnumType)
    test_complex_enum(BasicTypes.mySecondComplexEnumType)

    # pointer magic for primitive values...
    ref_val = Ref{Int16}(Int16(15))
    int16_ptr = reinterpret(Ptr{Int16}, pointer_from_objref(ref_val))
    BasicTypes.test_int16_ptr(int16_ptr)

    try
        throw_basic_error()
    catch e
        # OK
    end
end
