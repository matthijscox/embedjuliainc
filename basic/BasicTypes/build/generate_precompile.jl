# for testing, run as follows:
# julia --startup-file=no --project=. build/generate_precompile.jl

using BasicTypes

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
    )
)

arr = [1,2,3]
test_array()
