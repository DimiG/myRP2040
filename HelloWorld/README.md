HelloWorld
===========
This project demonstrates how you can use assembly language using a proprietary [SDK][picosdk].

Program description
-------------------
This is an example of a **Hello World** program written in assembly language using the [SDK][picosdk].  
To get info how to compile run `make` command for help.  
In order for this example to work, it is necessary:
1. Setup `make` on Linux by : `sudo apt update && sudo apt install make`
2. Setup `cmake` on Linux by : `sudo apt update && sudo apt install cmake`
3. Set an environment variable specifying the location of the SDK on your computer:  
`export PICO_SDK_PATH="$HOME/pico/pico-sdk"`
4. To compile it run from project directory - `cmake -S . -B build && cmake --build build`
5. To load firmware into microcontroller use such command:  
`picotool load build/HelloWorld.uf2; picotool reboot`
6. To test the program start the Raspberry Pi Pico with boot button pressed and run:  
`tio /dev/ttyACM0` (ctrl-t q for exit)

Or use `make` to get **HELP**.

`To be continued...`

[picosdk]:https://github.com/raspberrypi/pico-sdk.git
