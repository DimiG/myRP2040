cmake_minimum_required(VERSION 3.18)

# Set variables required for importing libraries
set(PICO_SDK_PATH $ENV{PICO_SDK_PATH})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Import libraries
include(${PICO_SDK_PATH}/external/pico_sdk_import.cmake)

project(HelloWorld C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize the SDK
pico_sdk_init()

include_directories(${CMAKE_SOURCE_DIR})

add_executable(${PROJECT_NAME}
  ${PROJECT_NAME}.S
)

# ENABLE USB output and DISABLE UART output
pico_enable_stdio_usb(${PROJECT_NAME} 1)
pico_enable_stdio_uart(${PROJECT_NAME} 0)

# Create map/bin/hex file etc.
pico_add_extra_outputs(${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME} pico_stdlib)

