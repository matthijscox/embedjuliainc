module ExternalThreads

    export divide_function

    Base.@ccallable function divide_function(input::Cint)::Cint
        if input > 10
            throw(ErrorException("You cannot divide by more than 10"))
        end
        outputValue::Cint = div(12, input)
        return outputValue
    end

end # module
