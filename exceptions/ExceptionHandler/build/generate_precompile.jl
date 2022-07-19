# for testing, cd into BasicTypes folder and run as follows:
# $env:JULIA_DEBUG="ExceptionHandler" in powershell
# julia --startup-file=no --project=. build/generate_precompile.jl

# Note: to see help for Julia flags use julia -h, or julia --help-hidden.

using ExceptionHandler

# enable debug printing inside Julia if you want
#ENV["JULIA_DEBUG"]=ExceptionHandler

begin
    try
        throw_basic_error()
    catch e
    end

    function get_ptr(ref_val::Ref{T}) where T<:Real
        return reinterpret(Ptr{T}, pointer_from_objref(ref_val))
    end

    input_value = Ref{Cint}(Cint(2.0))
    output_value = Ref{Cint}(Cint(0.0))
    input_ptr = get_ptr(input_value)
    output_ptr = get_ptr(output_value)

    GC.@preserve input_value output_value status = divide_function(input_ptr, output_ptr)
    @assert output_value[] == Cint(6)
    @assert status.code == Cint(0)
    @assert unsafe_string(status.errorMessage) |> isempty

    # trigger the integer division error
    input_ptr = get_ptr(Ref{Cint}(Cint(0.0)))
    GC.@preserve input_value output_value status = divide_function(input_ptr, output_ptr)
    @assert status.code == Cint(3)
    msg = unsafe_string(status.errorMessage)
    @assert msg == "DivideError: integer division error"

    # trigger the generic error
    input_ptr = get_ptr(Ref{Cint}(Cint(20.0)))
    GC.@preserve input_value output_value status = divide_function(input_ptr, output_ptr)
    @assert status.code == Cint(2)

end
