module ExceptionHandler

    export throw_basic_error

    Base.@ccallable function throw_basic_error()::Cint
        @debug "We now throw a generic ErrorException"
        throw(ErrorException("this is an error"))
        return 0
    end

end # module
