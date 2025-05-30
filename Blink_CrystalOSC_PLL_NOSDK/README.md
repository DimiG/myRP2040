Blink_CrystalOSC_PLL_NOSDK
==========================
This program demonstrates how you can use assembly language **WITHOUT USING** a proprietary [SDK][picosdk]. The manufacturer **DOES NOT RECOMMEND** abandoning the **SDK** as it is a way to introduce errors into the project. This example is intended for teaching purposes. In real projects, the use of proprietary tools is recommended.

Program description
-------------------
This is **NO SDK** *bare metal* assembler program to **blink LED** connected to the *Raspberry Pi PICO* **GPIO 25** (internal one).
The clocks default [XOSC][xosc] (Crystal Oscillator) and enabling the [PLL][pll].
The second method of installing [XOSC][xosc] is demonstrated here.

Some files were accidentally found on the Internet. To get info how to compile run `make` command for help. The code looks like core project for future experiments. The microcontroller manufacturer recommends using the official **SDK** for real-world applications.
Assembly language programming helps to understand how a microcontroller works due to the **SDK** usually hides a large number of routine operations.

In order for this example to work, it is necessary:
1. Setup `make` on Linux by : `sudo apt update && sudo apt install make`
2. Setup `picotool` (see link below). You can drop it into project directory
3. Setup `elf2uf2` (see link below). You can drop it into project directory
4. Run `make all && make upload`, compile and upload the code
5. Watch the blink result

Or use `make` to get **HELP**.

`Links`:
* `Picotool` official utility is located **[HERE][picotool]**
* `Elf2uf2`  utility is located **[HERE][elf2uf2]**

`To be continued...`

[picosdk]:https://github.com/raspberrypi/pico-sdk.git
[xosc]:https://en.wikipedia.org/wiki/Crystal_oscillator
[pll]:https://en.wikipedia.org/wiki/Phase-locked_loop
[picotool]:https://github.com/raspberrypi/picotool.git
[elf2uf2]:https://github.com/rej696/elf2uf2.git
