#include <iostream>
#include <cstdlib>

#include <sys/types.h>
#include <unistd.h>

#include <julia.h>

#include <thread>
#include <mutex>

#ifdef __cplusplus
extern "C" {
#endif

#include "julia_init.h"
#include "threads_into_julia.h"

std::mutex mtx;
extern void jl_enter_threaded_region();
int8_t (jl_gc_safe_enter)(void);

bool CheckInit()
{
    try
    {
        return jl_is_initialized() != 0;
    }
    catch (...)
    {
        return false;
    }
}

// initialize_julia(const char* cpath, const char* clibName)
void initialize_julia()
{
	// std::string path(cpath);
	// std::string libName(clibName);

	mtx.lock();
	if (!CheckInit())
	{
        // std::string sysimage_path("");
        // sysimage_path = path + "/" + libName;

        // jl_options.image_file = sysimage_path.c_str();
        // julia_init(JL_IMAGE_JULIA_HOME);
        init_julia();

        if (jl_get_pgcstack() == NULL)
            jl_adopt_thread();

        (jl_gc_safe_enter)();
        jl_enter_threaded_region();
	}

	mtx.unlock();
}



void call_and_catch(int x)
{
    // to make sure every thread is adopted by Julia, and only once!
	if (jl_get_pgcstack() == NULL)
	    jl_adopt_thread();

    // JL_TRY requires the thread to be adopted, else it won't work
	JL_TRY
	{
		divide_function(1); // should always work
		divide_function(x); // may throw an error depending on your input
	}
	JL_CATCH
	{
		std::cout << "Caught error for x = " << x << std::endl;
	}
}

int main()
{
	const size_t n_of_threads(15);
    initialize_julia();
	// std::string path("");
    // std::string libName("libJuliaError.so");
    // initialize_julia(path.c_str(),libName.c_str());

	std::thread all_threads[n_of_threads];
	for(int i=0; i<n_of_threads; i++)
		all_threads[i] = std::thread(call_and_catch, 30);

	for(auto& thread : all_threads)
		thread.join();

	return 0;
}

#ifdef __cplusplus
}
#endif
