# Enclustra Build Environment - User Documentation


## Table of content

* [Introduction](./1_Introduction.md)
    - [Version Information](./1_Introduction.md#version-information)
    - [Build Environment](./1_Introduction.md#build-environment)
        - [Prerequisites](./1_Introduction.md#prerequisites)
        - [Directory Structure](./1_Introduction.md#directory-structure)
        - [General Build Environment Configuration](./1_Introduction.md#general-build-environment-configuration)
    - [Supported Devices](./1_Introduction.md#supported-devices)
* [Graphical User Interface GUI](./2_GUI.md)
* [Command Line Interface CLI](./3_CLI.md)
* [Deployment](./4_Deployment.md)
    - [SD Card (MMC)](./4_Deployment.md#sd-card-mmc)
    - [eMMC Flash](./4_Deployment.md#emmc-flash)
    - [QSPI Flash](./4_Deployment.md#qspi-flash)
    - [NAND Flash](./4_Deployment.md#nand-flash)
    - [USB Drive](./4_Deployment.md#usb-drive)
    - [NFS](./4_Deployment.md#nfs)
        - [NFS Preparation Guide](./4_Deployment.md#nfs-prepatration-guide)
    - [QSPI Flash Layouts](./4_Deployment.md#qspi-flash-layouts)
* [Project mode](./5_Project_Mode.md)
* [Updating the binaries](./6_Binaries_Update.md)
* [FAQ](./7_FAQ.md)
    - [How to script U-Boot?](./7_FAQ.md#how-to-script-u-boot)
    - [How can the flash memory be programmed from Linux?](./7_FAQ.md#how-can-the-flash-memory-be-programmed-from-linux)
* [Known Issues](./8_Known_Issues.md)



## Known Issues

### 1. USB host not working on PE1 base boards

#### Affected modules:
All variants and revisions of following modules are affected:
- Mercury+ XU1
- Mercury XU5
- Mercury+ XU7
- Mercury+ XU8
- Mercury+ XU9

#### Description
USB PHY 0 is enabled by default in all reference designs and Linux BSPs but it can not be used in combination with PE1 base boards. The USB data signals are routed from the module to the USB hub device on the PE1 base board through multiplexers. The USB_ID signal controlling one of the multiplexer devices is routed to the USB 1 PHY which affects the signal.

#### Workaround
If USB is required, the Vivado design and Linux devicetree need to be modified to enable USB PHY 1. On some modules USB PHY 1 and ETH 1 share the same MIO pins and therefore, ETH 1 is not available when using USB 1.


Last Page: [FAQ](./7_FAQ.md)
