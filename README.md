myRP2040
========
This repository dedicated to the [Raspberry Pi microcontroller][rpi] based on **RP2040** [MCU][mcu]. The programs are NOT state of art ;). If you have any suggestions - let me know in the comments.

Programs description
--------------------
`HelloWorld`: This is an example of a **Hello World** program written in assembly language using the SDK. In order for this example to work, it is necessary:
1. Setup `make` on Linux by : `sudo apt update && sudo apt install make`
2. Setup `cmake` on Linux by : `sudo apt update && sudo apt install cmake`
3. Set an environment variable specifying the location of the SDK on your computer:  
`export PICO_SDK_PATH="$HOME/pico/pico-sdk"`
4. To compile it run from project directory - `cmake -S . -B build && cmake --build build`
5. To load firmware into microcontroller use such command:  
`picotool load build/HelloWorld.uf2; picotool reboot`
6. To test the program start the Raspberry Pi Pico with boot button pressed and run:  
`tio /dev/ttyACM0` (ctrl-t q for exit)

`BlinkRAW`: This is an example of a **Blink LED** program written in assembly language and using the SDK.  
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

`Blink_NOSDK`: This is an example of a **Blink LED** program written in assembly language and **NOT USING** the **SDK**.  
Some files were accidentally found on the Internet. It's strange that the chip manufacturer doesn't implement assembly language into their product itself.  
To get info how to compile run `make` command for help. The code looks like core project for future experiments.  
The microcontroller manufacturer recommends using the official **SDK** for real-world applications.  
Assembly language programming helps to understand how a microcontroller works due to the **SDK** usually hides a large number of routine operations.  
In order for this example to work, it is necessary:
1. Setup `make` on Linux by : `sudo apt update && sudo apt install make`
2. Setup `picotool` (see link below). You can drop it into project directory
3. Setup `elf2uf2` (see link below). You can drop it into project directory
4. Run `make`, compile and upload the code
5. Watch the blink result

`All`: **NOTE**
* For CMake based projects to clean the project target use - `cmake --build build --target clean`
* Picotool official utility is located **[HERE][picotool]**
* Elf2uf2 utility is located **[HERE][elf2uf2]**
* Powerful `tio` program is located **[HERE][tio]**
* Raspberry Pi Pico SDK is located **[HERE][picosdk]**  

***Requires :*** [Pico SDK][picosdk] preinstalled.

`To be continued...`

### License

This code has been written by **©2025 DG**  
Some of the code may belong to other authors from freely distributed sources.

[tio]:https://github.com/tio/tio.git
[rpi]:https://www.raspberrypi.com/products/raspberry-pi-pico
[mcu]:https://en.wikipedia.org/wiki/Microcontroller
[picotool]:https://github.com/raspberrypi/picotool.git
[picosdk]:https://github.com/raspberrypi/pico-sdk.git
[elf2uf2]:https://github.com/rej696/elf2uf2.git
