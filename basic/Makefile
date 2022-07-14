
.PHONY: all build-julia

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
PKG_ROOT_DIR := $(ROOT_DIR)/BasicTypes
BUILD := $(PKG_ROOT_DIR)/build

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

DEST_DIR := $(ROOT_DIR)/$(NAME_VERSION)
OUT_DIR := $(DEST_DIR)/$(NAME)
BIN_DIR := $(OUT_DIR)/bin
INCLUDE_DIR := $(OUT_DIR)/include

CPP_DIR := $(ROOT_DIR)/main-cpp
CPP_FILE := $(CPP_DIR)/basic.cpp

LIB_DIR := $(OUT_DIR)/lib
LIB_NAME := $(NAME).$(DLEXT)

MAIN := basic-cpp
ifeq ($(OS), Windows)
  LIBDIR := $(BINDIR)
  MAIN := basic-cpp.exe
endif

INCLUDES = $(INCLUDE_DIR)/julia_init.h $(INCLUDE_DIR)/$(NAME).h
LIB_PATH := $(LIB_DIR)/$(LIB_NAME)

ifneq ($(OS), Windows)
  WLARGS := -Wl,-rpath,"$(LIBDIR)" -Wl,-rpath,"$(LIBDIR)/julia"
endif
CFLAGS+=-O2 -fPIE -I$(JULIA_DIR)/include/julia -I$(INCLUDE_DIR)
LDFLAGS+=-lm -L$(LIBDIR) -ljulia $(WLARGS)

CC = g++

all: $(LIB_PATH) $(INCLUDES) build-cpp

$(LIB_PATH) $(INCLUDES): $(BUILD)/build.jl $(PKG_ROOT_DIR)/src/BasicTypes.jl
	$(JULIA) --startup-file=no --project=$(PKG_ROOT_DIR) -e 'using Pkg; Pkg.instantiate()'
	$(JULIA) --startup-file=no --project=$(BUILD) -e 'using Pkg; Pkg.instantiate()'
	$(JULIA) --startup-file=no --project=$(BUILD) $< $(OUT_DIR)

basic.o: $(CPP_FILE) $(INCLUDES)
	$(CC) $< -c -o $@ $(CFLAGS)

$(MAIN): basic.o
	$(CC) -o $@ $< $(LDFLAGS) -lcg

# build cpp code and link it against the julia library
build-cpp: $(MAIN)

# build-cpp: build-julia
