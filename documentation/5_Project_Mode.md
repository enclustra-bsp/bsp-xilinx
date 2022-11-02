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



## Project Mode

For users who want to use the Enclustra Build Environment, but still be able to modify the parts of the system, a ‘project mode’ is available.

Project mode is similar to regular mode, but enables user to fully customize all the parts of the system.

To enable project mode, choose “Advanced” option on the very last screen of the GUI workflow.

![Project Mode](./images/project_name.png)

Check the ‘enable’ option on.

![Enable Project Mode](./images/project_enable.png)

Continue as usual.

After the regular build has finished, the sources of the components that were chosen to be fetched, are going to be copied to the output directory. User is free to modify those sources and add a git upstream to them to keep them versioned.

Besides the sources, a new build script called build.sh is generated. This script will run the Enclustra Build Environment in a special project mode. In this mode the step for choosing components to fetch is skipped, and the user is prompted to choose which of the components to build. If any of the components of the system were modified, the Build system will build them, and include the output files in the final boot images.


Last Page: [Deployment](./4_Deployment.md)

Next Page: [Updating the binaries](./6_Binaries_Update.md)
