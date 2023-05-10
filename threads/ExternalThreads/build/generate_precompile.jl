# for testing, cd into ExternalThreads folder and run as follows:
# julia --startup-file=no --project=. build/generate_precompile.jl

# Note: to see help for Julia flags use julia -h, or julia --help-hidden.

using ExternalThreads

begin

    divide_function(Int32(5))

    try
        divide_function(Int32(12))
    catch e
        println("caught error")
    end

end
