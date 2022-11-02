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



## Updating the binaries

### Changes in the FPGA design

If you want to modify the FPGA design, you can update the binaries in two ways:

1. By changing the path to custom binaries when you choose the device option in the Enclustra Build Environment.

2. By using the project mode:

   1. Enable project mode in the Enclustra Build Environment.

   2. Copy to the output directory (the directory with the boot sources created by the Enclustra Build Environment):

      - the new *.bit file (if you introduced changes to the FPGA programmable logic (PL)),

      - the new fsbl.elf file (if you introduced changes to the processing system (PS) of the FPGA SoC),

      - the new pmufw.elf file (in case of an XU module and if you introduced changes to the PMU firmware),

      - the new atf.elf file (in case of an XU module and if you introduced changes to the Arm Trusted Firmware),

      - the new boot.bif file (in you introduced changes to the boot.bin format).

      	Please note that with the default boot.bif, the files should be named `fpga.bit`, `fsbl.elf`, `pmufw.elf` and `atf.elf`.

   3. Run the Enclustra Build Environment.

   4. The new ‘boot.bin’ file will be generated in the output directory. You can then place this file to boot the device (for example, in case of an SD Card, please refer to SD Card (MMC)).




### Changes in U-boot, Linux or Buildroot

If you want to modify U-boot, Linux or Buildroot, perform the following steps:

1. Go to the ‘sources/’ directory, where U-boot, Linux and Buildroot repositories are placed.

2. Introduce your changes in the selected repository.

3. Run the Enclustra Build Environment in project mode to compile and build the modified sources.

4. Replace the files on the target device, depending on which repository you changed:

   - xilinx-linux: the devicetree.dtb and the kernel image files (‘uImage’ for Zynq-7000 or ‘Image’ for Zynq Ultrascale+).
   
   - xilinx-uboot: the ‘uboot.scr’ and the ‘boot.bin’ file (containing the u-boot binary).
   
   - buildroot-rootfs: the ‘rootfs.tar’ archive (or the ‘rootfs.jffs2’ or ‘uramdisk’, depending on which the target device you choose).


Last Page: [Project mode](./5_Project_Mode.md)

Next Page: [FAQ](./7_FAQ.md)
