# Enclustra Build Environment

> **_DISCLAIMER:_** The Enclustra Build Environment is deprecated. The latest release of the reference design is compatible with AMD tools release 2022.1. For reference design releases starting at 2024.2, the [Enclustra Yocto BSP layer](https://github.com/enclustra/meta-enclustra-amd) is provided instead.

Enclustra Build Environment is a tool which allows the user to quickly set up and run all of the Enclustra modules running a Xilinx Zynq device.
It allows the user to choose the desired target, and downloads all the required binaries, such as the bitstream and FSBL. It also downloads and compiles software such as U-Boot, Linux, and Buildroot based root file system.

Running the build.sh script without any arguments starts the Build Environment in GUI mode; in GUI mode, the user is prompted to select the desired module and base board combination, and the boot mode and software for later use.

For automating the build process, a command line interface is available.

Please refer to the [user documentation](documentation/1_Introduction.md) for more information on the usage of the build system.

Copyright (c) 2015-2021, Enclustra GmbH, Switzerland
