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
end
