# This is a Makefile for work with Raspberry Pi Pico
# Tested by Raspberry Pi Pico
# Just help to automate the compilation process
# With `make', 'make help' and `make clean'
# Created by: DG
# Date: 2025-03-27

### VARIABLEs ###
APP_NAME     := blink_ringosc
BOOT_2       := bs2_default
LINKER_SCR   := linker_script.ld
VECTOR_TABLE := vector_table
CC           := arm-none-eabi-gcc
MACH         := cortex-m0plus
CFLAGS       := -c -mcpu=$(MACH) -mthumb -std=gnu11 -Wall -O0
LFLAGS       := -nostdlib -T $(LINKER_SCR) -Wl,-Map=$(APP_NAME).map

.PHONY: default help uf2 upload clean clean-all

### ***  HELP ***  ###
define HELP

 [HELP COMMANDS]

  make all        : Building firmware
  make link       : Linking the code
  make uf2        : UF2 file creation
  make upload     : Upload UF2 file into MCU
  make clean      : Cleanup builded files
  make clean-all  : Cleanup all builded files

 [CURRENT VALUES] :

  CC              = $(CC)
  MACH            = $(MACH)
  APP_NAME        = $(APP_NAME)

 [NOTE]

  To make LSP working compile with : bear -- make all
  * Install bear before

endef
export HELP

default: help

help:
	@tput setaf 3
	@echo "$$HELP"
	@tput sgr0

all:  $(BOOT_2).o $(APP_NAME).o $(VECTOR_TABLE).o link uf2

$(BOOT_2).o: $(BOOT_2).s
	@$(CC) $(CFLAGS) -o $@ $^
	@echo "[ COMPILE... ]"

$(APP_NAME).o: $(APP_NAME).s
	@$(CC) $(CFLAGS) -o $@ $^

$(VECTOR_TABLE).o: $(VECTOR_TABLE).s
	@$(CC) $(CFLAGS) -o $@ $^

$(APP_NAME).elf: $(BOOT_2).o $(VECTOR_TABLE).o $(APP_NAME).o
	@$(CC) $(LFLAGS) -o $@ $^

link: $(APP_NAME).elf
	@echo "[ LINKING... ]"

uf2:
	@./elf2uf2 $(APP_NAME).elf $(APP_NAME).uf2
	@echo "[ FLASH CREATING... ]"

upload:
	$(info =>>> Flash the MCU firmware...)
	@picotool load $(APP_NAME).uf2; picotool reboot;
	@echo "[UPLOADING]"

clean:
	@rm -vf $(wildcard *.o) $(wildcard *.elf) $(wildcard *.uf2) $(wildcard *.map)
	@echo "[ CLEANING ]"

clean-all:
	@rm -vf $(wildcard *.o) $(wildcard *.elf) $(wildcard *.uf2) $(wildcard *.map) $(wildcard *.json)
	@echo "[ CLEANING ALL]"

