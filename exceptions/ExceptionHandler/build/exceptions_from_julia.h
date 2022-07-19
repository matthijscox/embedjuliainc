struct Status
{
    int code;
    const char* errorMessage;
};

int throw_basic_error();
Status divide_function(int* inputPtr, int* outputPtr);
