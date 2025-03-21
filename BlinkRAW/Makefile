# This is a Makefile for work with Pico C SDK
# Tested by Raspberry Pico
# Just help to automate the compilation process
# With `make', 'make help' and `make clean'
# Useful for Lazy People ;)

# Created by: DG
# Date: 2025-03-25

# Note: Setup picotool path and application name below

# Import the dotenv (.env) file
# ifneq (,$(wildcard ./dotenv))
#     include dotenv
#     export
# endif

### VARIABLEs ###
# SHELL := /bin/bash
BUILD_PATH := build
PICOTOOL := $(HOME)/.local/bin/picotool
APP_NAME := BlinkRAW

.PHONY: default help all init build upload clean clean-all

### ***  HELP ***  ###
define HELP

 [HELP COMMANDS]

  make init      : CMake INIT
  make build     : Building firmware
  make upload    : Flashing into MCU
  make clean     : Cleanup built files
  make clean-all : Cleaning ALL built files

endef
export HELP

default: help

help:
	@tput setaf 3
	@echo "$$HELP"
	@tput sgr0

all: build upload

init:
	$(info =>>> CMake INIT...)
	@cmake -S . -B $(BUILD_PATH)
	@echo "[ CMAKE INIT ]"

build:
	$(info =>>> Build the MCU firmware...)
	@cmake --build $(BUILD_PATH)
	@echo "[ BUILDING ]"

upload:
	$(info =>>> Flash the MCU firmware...)
	@$(PICOTOOL) load $(BUILD_PATH)/$(APP_NAME).uf2; $(PICOTOOL) reboot;
	@echo "[ UPLOADING ]"

clean:
	@cmake --build $(BUILD_PATH) --target clean
	@echo "[ CLEANING ]"

clean-all:
	@rm -rvf $(BUILD_PATH)
	@echo "[ CLEANING ALL ]"

