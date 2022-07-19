module ExceptionHandler

    export throw_basic_error, divide_function

    Base.@ccallable function throw_basic_error()::Cint
        @debug "We now throw a generic ErrorException"
        throw(ErrorException("this is an error"))
        return 0
    end

    struct Status
        code::Cint
        errorMessage::Cstring
    end

    # Example of how to turn exceptions into error codes.
    Base.@ccallable function divide_function(inputPtr::Ptr{Cint}, outputPtr::Ptr{Cint})::Status
        resultCode::Cint = 0
        msg::Cstring = Base.unsafe_convert(Cstring, "")
        try
            inputValue = unsafe_load(inputPtr)
            if inputValue > 10
                throw(ErrorException("Blocked. Throwing a generic error"))
            end
            outputValue::Cint = div(12, inputValue)
            unsafe_store!(outputPtr, outputValue)
            @debug "We succesfully executed div(12, $inputValue)"
        catch e
            # https://discourse.julialang.org/t/is-it-possible-to-get-an-exception-message-as-a-string/3201
            msg_string = sprint(showerror, e)
            msg = Base.unsafe_convert(Cstring, msg_string)
            resultCode = error_code(e)
            @debug "Converted error type $(typeof(e)) to integer $resultCode"
        end
        return Status(resultCode, msg)
    end

    # you'll have to invent your own error codes here:
    error_code(::Exception)::Cint = 2 # default return 2
    error_code(::DivideError)::Cint = 3

end # module
