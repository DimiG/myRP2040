BlinkRAW
========
This project demonstrates how you can use assembly language using a proprietary [SDK][picosdk].

Program description
-------------------
This is an example of a **Blink LED** program written in assembly language and using the [SDK][picosdk].  
To get info how to compile run `make` command for help.
The control is performed by direct writing to the registers of the microcontroller.  
The `main.c` is used as an example of integrating the code written in `Assembler` with `C` code.  
In order for this example to work, it is necessary:
1. Setup `make` on Linux by : `sudo apt update && sudo apt install make`
2. Setup `cmake` on Linux by : `sudo apt update && sudo apt install cmake`
3. Set an environment variable specifying the location of the SDK on your computer:  
`export PICO_SDK_PATH="$HOME/pico/pico-sdk"`
4. Prepare the CMake environment by: `cmake -S . -B build`
5. Compile the code by: `cmake --build build`
6. Load **FIRMWARE** into microcontroller by: `picotool load build/BlinkRAW.uf2`
7. Reboot microcontroller by: `picotool reboot`
8. Watch the blink result

Or use `make` to get **HELP**.

`To be continued...`

[picosdk]:https://github.com/raspberrypi/pico-sdk.git
