# for testing, cd into BasicTypes folder and run as follows:
# julia --startup-file=no --project=. build/generate_precompile.jl

# Note: to see help for Julia flags use julia -h, or julia --help-hidden.

using ExceptionHandler

# enable debug printing
# ENV["JULIA_DEBUG"]=ExceptionHandler

begin
    throw_basic_error()
end
