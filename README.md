# atto
Portable Robotic Automation, 3D Design, Fabrication and Logistics Language and Framework in Lua

View the Demo on YouTube: https://www.youtube.com/watch?v=V09rg6WwFww

![screenshot](https://github.com/TheMindVirus/atto/blob/main/screenshot.png)

Atto is one over a kvintiljon times smaller than 1 unit of measurement. \
Atto is now also a logistical bytecode language used by robots.

Atto Creatix is an implementation of Atto in Modded Minecraft Java Edition 1.7.10 \
using the OpenComputers Creatix Robot API in Lua with implementations to fill in the gaps. \
Atto can be ported to other Turtles and can be extended to support various functionality.

The code included in this documentation repository contains my design of a Chiplet for testing. \
This custom Chiplet features a 4-bit shift register and memory cells. Designs may vary.

Several core functions which are missing from Lua have been implemented by the framework. \
Also included in the core is an interpreter which can follow some simple extensible instructions.

The basic feature-set contains instructions to move forward, back, up and down, \
turning left and right, mining, placing, toggling blocks and repeating entire lines.

View the Example Code on GitHub: https://github.com/TheMindVirus/atto/tree/main/atto.lua

Despite the production of a working example, there are several limitations that still remain. \
These limitations will also change depending on your choice of robot and its environment.