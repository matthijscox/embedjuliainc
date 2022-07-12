
.PHONY: all build-julia

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
BUILD := $(ROOT_DIR)/build

JULIA ?= julia
JULIA_DIR := $(shell $(JULIA) --startup-file=no -e 'print(dirname(Sys.BINDIR))')
DLEXT := $(shell $(JULIA) --startup-file=no -e 'using Libdl; print(Libdl.dlext)')
VERSION := 0.1.0
#VERSION := $(shell sed -n 's/^version *= *"\(.*\)"/\1/p' $(ROOT_DIR)/Project.toml)
#OS := $(shell uname)
#DEPS := $(shell find . build src -maxdepth 1 -and \( -name \*.toml -or -name \*.jl -or -name Makefile \) -and -not -type l)

# Note: NAME should not include the "lib" prefix
NAME := basic
NAME_VERSION := $(NAME)-$(VERSION)

DEST_DIR ?= $(NAME_VERSION)
OUT_DIR := $(DEST_DIR)/$(NAME)
BIN_DIR := $(OUT_DIR)/bin
INCLUDE_DIR = $(OUT_DIR)/include
LIB_DIR := $(OUT_DIR)/lib

LIB_NAME := lib$(NAME).$(DLEXT)
INCLUDES = $(INCLUDE_DIR)/julia_init.h $(INCLUDE_DIR)/$(NAME).h
LIB_PATH := $(LIB_DIR)/$(LIB_NAME)

all: build-julia

# build cpp code and link it against the julia library
# build-cpp: build-julia
# 	g++ -o DatatypeConversionExe DatatypeConversion.cpp -L./ -lDatatypeConversion -O2 
#     -fPIE -I/boa_prd/daasperb/julia-1.6.0/include/julia 
# 	-L/boa_prd/daasperb/julia-1.6.0/lib -ljulia -L/boa_prd/daasperb/julia-1.6.0/lib/julia 
# 	-ljulia-internal -lLLVM-11jl /boa_prd/daasperb/julia-1.6.0/lib/julia/libstdc++.so.6 
# 	-Wl,-rpath,/boa_prd/daasperb/julia-1.6.0/lib/julia

build-julia: BasicTypes/build/build.jl
	$(JULIA) --startup-file=no --project=. -e 'using Pkg; Pkg.instantiate()'
	$(JULIA) --startup-file=no --project=$(BUILD) -e 'using Pkg; Pkg.instantiate()'
	$(JULIA) --startup-file=no --project=$(BUILD) $< $(OUT_DIR)

# build-cpp: build-julia
