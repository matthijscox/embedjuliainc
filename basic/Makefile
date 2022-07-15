
.PHONY: all build-julia build-cpp

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
PKG_ROOT_DIR := $(ROOT_DIR)/BasicTypes
BUILD := $(PKG_ROOT_DIR)/build

JULIA ?= julia
JULIA_DIR := $(shell $(JULIA) --startup-file=no -e 'print(dirname(Sys.BINDIR))')
DLEXT := $(shell $(JULIA) --startup-file=no -e 'using Libdl; print(Libdl.dlext)')

# Note: NAME should not include the "lib" prefix
NAME := basic
NAME_VERSION := $(NAME)-$(VERSION)

DEST_DIR := $(ROOT_DIR)/compiled
OUT_DIR := $(DEST_DIR)
BIN_DIR := $(OUT_DIR)/bin
INCLUDE_DIR := $(OUT_DIR)/include

CPP_DIR := $(ROOT_DIR)/main-cpp
CPP_FILE := $(CPP_DIR)/basic.cpp

LIB_DIR := $(OUT_DIR)/lib
LIB_NAME := $(NAME).$(DLEXT)

MAIN := basic-cpp

# Windows...
LIB_DIR := $(BIN_DIR)
MAIN := basic-cpp.exe

INCLUDES = $(INCLUDE_DIR)/julia_init.h $(INCLUDE_DIR)/$(NAME).h
LIB_PATH := $(LIB_DIR)/$(LIB_NAME)

# only needed on Linux, not windows?
# WLARGS := -Wl,-rpath,"$(JULIA_DIR)/lib" -Wl,-rpath,"$(JULIA_DIR)/lib/julia"

# compiling flags:
# -O2 is a compiler optimization
# -fPIE: https://stackoverflow.com/questions/2463150/what-is-the-fpie-option-for-position-independent-executables-in-gcc-and-ld
# we want to use julia.h from your local julia installation
CFLAGS+=-O2 -fPIE -I$(JULIA_DIR)/include/julia -I$(INCLUDE_DIR)

# linking flags
# -lm - Compiles against the shared library libm (basic math library, mostly C only)
# -L$(LIB_DIR) -l$(NAME): use our basic.dll compiled from Julia build.jl
# -L$(JULIA_DIR)/lib -ljulia: use the julia library, seems it's included in the library directory, else get it from $(JULIA_DIR)/lib
LDFLAGS+=-lm -L$(LIB_DIR) -l$(NAME) -L$(LIB_DIR) -ljulia $(WLARGS)

# use the c++ compiler, for c use gcc
CC = g++

all: $(LIB_PATH) $(INCLUDES) build-cpp

$(LIB_PATH) $(INCLUDES): $(BUILD)/build.jl $(PKG_ROOT_DIR)/src/BasicTypes.jl
	$(JULIA) --startup-file=no --project=$(PKG_ROOT_DIR) -e 'using Pkg; Pkg.instantiate()'
	$(JULIA) --startup-file=no --project=$(BUILD) -e 'using Pkg; Pkg.instantiate()'
	$(JULIA) --startup-file=no --compile=all --project=$(BUILD) $< $(OUT_DIR)

$(LIB_DIR)/basic.o: $(CPP_FILE) $(INCLUDES)
	$(CC) $< -c -o $@ $(CFLAGS)

$(MAIN): $(LIB_DIR)/basic.o
	$(CC) -o $(LIB_DIR)/$@ $< $(LDFLAGS)

# build cpp code and link it against the julia library
build-cpp: $(MAIN)

clean:
	rm *.o
