
#include <julia.h>
#include <iostream>
#include <iomanip>

// to avoid name mangling we use extern C
// google for 'name mangling and extern C in C++'
extern "C"
{
    #include "julia_init.h"
    #include "exceptions_from_julia.h"
}

//-----------------------------------------------------------------------------------------//
//-------------------------------- Calling the Julia code  --------------------------------//
//-----------------------------------------------------------------------------------------//

int main(int argc, char *argv[])
{
    // Setting Julia options with jl_options
    //jl_options.compile_enabled = 0;
    //jl_options.debug_level = -1;

    init_julia(argc, argv);

    if(!jl_is_initialized())
    {
       std::cout << "Julia was unable to initialize, check if the path to the .so file is correct" << std::endl;
       return 0;
    }

    //-----------------------------------------------------------------------------------------//
    //--------------------------- Handle errors via returned structure ------------------------//
    //-----------------------------------------------------------------------------------------//

    int inputValue = 0;
    int outputValue = 0;
    Status status = divide_function(&inputValue, &outputValue);
    std::cout << "got status code: " << status.code << std::endl;
    std::cout << "error message: " << status.errorMessage << std::endl;

    //-----------------------------------------------------------------------------------------//
    //--------------------------- You cannot catch exceptions normally ------------------------//
    //-----------------------------------------------------------------------------------------//

    // try
    // {
    //     throw_basic_error();
    // }
    // catch (const std::exception& e)
    // {
    //     std::cout << "\n a standard exception was caught, with message '"
    //               << e.what() << std::endl;
    // }
    // catch (...)
    // {
    //     std::cout << "\n unknown exception caught" << std::endl;
    // }

    //-----------------------------------------------------------------------------------------//
    //----------------------------------- JL_TRY/CATCH macros ---------------------------------//
    //-----------------------------------------------------------------------------------------//

    // example found here: https://github.com/JuliaLang/julia/blob/24f1316e91de029f71f636db23aced49156b44ad/ui/repl.c#L32-L62
    JL_TRY {
        throw_basic_error();
    }
    JL_CATCH {
        jl_value_t *errs = jl_stderr_obj();
        std::cout << "A Julia exception was caught" << std::endl;
        if (errs) {
            jl_value_t *showf = jl_get_function(jl_base_module, "showerror");
            if (showf != NULL) {
                jl_call2(showf, errs, jl_current_exception());
                jl_printf(jl_stderr_stream(), "\n");
            }
        }
        return 1;
    }

    // Notify Julia the program is about to terminate, it is not mandatory but it allows
    // julia time to cleanup pending write reqeuests and run all finalizers
    // jl_atexit_hook(0); // from julia.h
    shutdown_julia(0); // julia_init.h comes with it's own shutdown function
    return 0;
}