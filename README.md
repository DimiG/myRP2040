myRP2040
========
This repository dedicated to the [Raspberry Pi microcontroller][rpi] based on **RP2040** [MCU][mcu]. The programs are NOT state of art ;). If you have any suggestions - let me know in the comments.

Programs description
--------------------
`HelloWorld`: This is an example of a **Hello World** program written in assembly language using the SDK. In order for this example to work, it is necessary:
1. Set an environment variable specifying the location of the SDK on your computer:  
`export PICO_SDK_PATH="$HOME/pico/pico-sdk"`;
2. To compile it run from project directory - `cmake -S . -B build && cmake --build build`;
3. To load firmware into microcontroller use such command:  
`picotool load build/app_name.uf2; picotool reboot`;
4. To test the program start the Raspberry Pi Pico with boot button pressed and run:  
`tio /dev/ttyACM0` (ctrl-t q for exit)

`All`: **NOTE**
* For CMake based projects to clean the project target use - `cmake --build build --target clean`;
* Picotool official utility located **[HERE][picotool]**;
* Powerful `tio` program located **[HERE][tio]**;
* Raspberry Pi Pico SDK located **[HERE][picosdk]**.  

***Requires :*** [Pico SDK][picosdk] preinstalled.

`To be continued...`

### License

This code has been written by **©2025 DG**  
Some of the code may belong to other authors from freely distributed sources.

[rpi]:https://www.raspberrypi.com/products/raspberry-pi-pico
[mcu]:https://en.wikipedia.org/wiki/Microcontroller
[picotool]:https://github.com/raspberrypi/picotool.git
[tio]:https://github.com/tio/tio.git
[picosdk]:https://github.com/raspberrypi/pico-sdk.git
