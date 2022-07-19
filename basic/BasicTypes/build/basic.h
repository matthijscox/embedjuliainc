#include <iomanip>

// datatypes to be used on the interface
struct SimpleStruct
{
    int SimpleStructId;
};

struct ChildStruct
{
    int ChildStructId;
};

struct ParentStruct
{
    int ParentStructId;
    ChildStruct myChildStruct;
    int staticArray[3];
};

enum SimpleEnum
{
    myFirstEnumType = 1,
    mySecondEnumType = 2,
    myThirdEnumType = 3
};

enum ComplexEnum
{
    myFirstComplexEnumType = 0,
    mySecondComplexEnumType = -1
};

// prototype of the C entry points in our application
bool test_boolean(bool myBoolean);

// using fixed width integer types
int16_t test_int16(int16_t myInt16);
int32_t test_int32(int32_t myInt32);
int64_t test_int64(int64_t myInt64);
uint16_t test_uint16(uint16_t myUInt16);
uint32_t test_uint32(uint32_t myUInt32);
uint64_t test_uint64(uint64_t myUInt64);

float test_cfloat(float myFloat);
double test_cdouble(double myDouble);

const char* test_cstring(const char* myCString);

const char* test_cstring(const char* myCString);

SimpleStruct test_struct(SimpleStruct mySimpleStruct);
ParentStruct test_nested_structs(ParentStruct myParentStruct);

void test_array(int* myArrayPtr, int myArraySize);

SimpleEnum test_simple_enum(SimpleEnum mySimpleEnum);
ComplexEnum test_complex_enum(ComplexEnum myComplexEnum);
