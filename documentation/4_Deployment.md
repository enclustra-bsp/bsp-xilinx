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
* [Project mode](./5_Project_Mode.md)
* [Updating the binaries](./6_Binaries_Update.md)
* [FAQ](./7_FAQ.md)
    - [How to script U-Boot?](./7_FAQ.md#how-to-script-u-boot)
    - [How can the flash memory be programmed from Linux?](./7_FAQ.md#how-can-the-flash-memory-be-programmed-from-linux)
* [Known Issues](./8_Known_Issues.md)



## Deployment

This chapter describes how to prepare the hardware to boot from different boot media, using the binaries generated from the build environment. The boot process differs in its details on different hardware, but in general it covers the following steps:

1. The hardcoded BootROM of the SoC searches, depending on the selected boot mode, for a boot image with a FSBL (First Stage Bootloader).

2. First stage boot loader (FSBL, U-Boot SPL) is loaded into On Chip Memory, and executed.

3. First stage boot loader initializes RAM controller, clocks and loads second stage boot loader into RAM.

4. Second stage boot loader (U-Boot) loads the Linux kernel, device tree blob and any other required files into RAM and runs the Linux kernel.

5. Linux kernel configures peripherals, mounts user space root filesystem and executes the init application within it.

6. Init application starts the rest of the user space applications - the system is up and running.

For more detailed information about the boot process please refer to the technical reference manuals from Xilinx.

All the guides in this section require the user to build the required files for the chosen device, with the build environment, as described in the previous section. Once the files are built, they can be deployed to the hardware as described in the following sub sections.

> **_Note:_**  Default target output directories are named according to the following directory naming scheme: out_<timestamp>_<module>_<board>_<bootmode>

As a general note on U-Boot used in all the following guides: U-Boot is using variables from the default environment. Moreover, the boot scripts used by U-Boot also rely on those variables. If the environment was changed and saved earlier, U-Boot will always use these saved environment variables on a fresh boot, even after changing the U-Boot environment. To restore the default environment, run the following command in the U-Boot command line:

```
env default -a
```

This will not overwrite the stored environment but will only restore the default one in the current run. To permanently restore the default environment, the `saveenv` command has to be invoked.

> **_Note:_**  A `*** Warning - bad CRC, using default environment` warning message that appears when booting into U-Boot indicates that the default environment will be loaded.

Boot storage | Offset | Size
--- | --- | --- | ---
MMC | partition 1 (FAT) | 0x80000
eMMC | partition 1 (FAT) | 0x80000
QSPI | 0x1f00000 | 0x80000
NAND | ‘ubi-env’ partition | 0x18000








### SD Card (MMC)

In order to deploy images to an SD Card and boot from it, perform the following steps as root:

1. Create a FAT formatted BOOT partition as the first one on the SD Card. The size of the partition should be at least 64 MB. (For more information on how to prepare the boot medium, please refer to the official [Xilinx guide](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842385/How+to+format+SD+card+for+SD+boot) .)

2. Create an ext4 formatted partition (rootfs) as the second one on the SD Card. The size of the partition should be at least 64 MB.

3. Copy `boot.bin`, the kernel image (`uImage` for Zynq-7000 or `Image` for Zynq Ultrascale+), `devicetree.dtb` and `uboot.scr` file from the build environment output directory onto the BOOT partition (FAT formatted).

4. Mount the second (ext4) partition and extract the `rootfs.tar` archive from the build environment output directory onto the second partition (rootfs, ext4 formatted). `tar -xvf  rootfs.tar.gz -C /media/rootfs/`

5. Unmount all partitions mounted from the SD Card.

6. Insert the card into the SD Card slot on the board.

7. Configure the board to boot from the SD Card (refer to the board User Manual).

8. Power on the board.

9. The board should boot the Linux system.

If one wants to manually trigger booting from a SD Card, the following command has to be invoked from the U-Boot command line:

```
run sdboot
```

> **_Note:_**  If `saveenv` command is used in U-boot to save the U-Boot environment, a `‘uboot.env’` file will appear on the boot partition of the SD card.






### eMMC Flash

1. Prepare a bootable SD card with a ramdisk or persistent rootfs as described in [SD Card (MMC)](./4_Deployment.md#sd-card-mmc).

2. You’ll need the following files from eMMC build: `boot.bin`, `devicetree.dtb`, kernel image (`uImage` for Zynq-7000 or `Image` for Zynq Ultrascale+), `uboot.scr` and `rootfs.tar`.  Put all these files either in a subfolder on the first partition or in the rootfs on the second partition of the sd card.

3. Boot Linux on the device from the SD Card and login as root.


5. There are two /dev/mmcblkN devices. One of them is the SD card, and the other is the eMMC. To identify the eMMC, look which one has the boot0 partition:

```
ls /dev/mmcblk*boot0
```

6. Partition the eMMC. Create a FAT32 boot partition as the first partition on the device, make its size at least 64 MB. If you want to use a persistent rootfs, create a second ext4 `rootfs` partition (at least 64 MB large).

> **_Note:_**  For more information on how to prepare the boot medium, please refer to the official Xilinx guide. Remember to use eMMC device mmcblkX instead of sdX.

7. Mount the boot partition and copy boot files to it:

```
mkdir -p /mnt/boot  
mount /dev/mmcblkXp1 /mnt/boot

cp boot.bin devicetree.dtb uboot.scr /mnt/boot/  
cp uImage /mnt/boot/  # Zynq-7000 only  
cp Image  /mnt/boot/  # Zynq Ultrascale+ only  
# For eMMC with ramdisk:
cp uramdisk /mnt/boot/

umount /mnt/boot
```

8. Mount the `rootfs` partition and extract `rootfs.tar` (persistent rootfs only):

```
mkdir -p /mnt/rootfs  
mount /dev/mmcblkXp2 /mnt/rootfs

tar -xpv -C /mnt/rootfs/ -f rootfs.tar

umount /mnt/rootfs
```

> **_Note:_**  If `saveenv` command is used in U-boot to save the U-Boot environment, a ‘uboot.env’ file will appear on the boot partition of the eMMC flash.






### QSPI Flash

The file `boot_qspi.bin` is required for QSPI boot mode. This file contains the boot.bin, kernel image, device-tree, u-boot script and rootfs. Each of these files must be placed at a specific offset in the QSPI flash. The `boot_full.bin` file is already created with the right offsets and only this file needs to be programmed to the QSPI.

The Reference Design of the module describes the different options to program the QSPI flash of each module. The Reference Designs can be found here: [Enclustra Github Reference Designs](https://github.com/enclustra)

#### QSPI Flash Layouts

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0x1f00000
U-Boot environment | | 0x1f00000 | 0x80000
Bootscript | uboot.scr | 0x1f800000 | 0x80000
Fit image | image.ub | 0x2000000 | 0x2000000




### NAND Flash

Enclustra Build Environment does not support direct boot from the NAND Flash memory. The FSBL and the U-Boot have to be started from SD Card (MMC) or QSPI Flash. Please refer to SD Card (MMC) or QSPI Flash in order to boot U-Boot from SD Card or QSPI Flash. When U-Boot is booted it can load and boot the Linux system stored on the NAND Flash memory.

Select a boot mode to boot the FSBL and U-Boot and modify the U-Boot script in order to load the Linux images from NAND.

```
run nand_args && nand read ${kernel_loadaddr} nand-linux ${kernel_size} && bootm ${kernel_loadaddr}
```

Partition | Offset | Size
--- | --- | ---
Linux kernel | 0x0 | 0x2000000
Bootscript | 0x2000000 | 0x100000
Rootfs | 0x2100000 | 0x1DF00000

> **_Note:_**  Not all Xilinx-based modules come with NAND Flash memory.

In order to deploy images and boot the Linux system from NAND Flash, do the following steps:

1. Setup TFTP server on the host computer.

2. Power on the board and boot to U-Boot (e.g. from a SD Card (MMC)).

3. Connect an Ethernet cable to the device.

4. Connect a serial console to the device (e.g. using PuTTY or picocom).

5. Copy the kernel image (image.ub) and boot script (uboot.scr) files from the build environment output directory to the TFTP server directory.

6. Stop the U-Boot autoboot.

7. Setup the U-Boot connection parameters (in the U-Boot console):

```
setenv ipaddr 'xxx.xxx.xxx.xxx'  
# where xxx.xxx.xxx.xxx is the board address
setenv serverip 'yyy.yyy.yyy.yyy'  
# where yyy.yyy.yyy.yyy is the server (host computer) address
```

8. Set the memory pinmux to NAND Flash:

```
zx_set_storage NAND
```

9. Update the boot script image:

```
mw.b ${bootscript_loadaddr} 0xFF ${bootscript_size}  
tftpboot ${bootscript_loadaddr} ${bootscript_image}  
nand device 0  
nand erase.part nand-bootscript  
nand write ${bootscript_loadaddr} nand-bootscript ${filesize}
```

10. Update the Linux kernel:

```
mw.b ${kernel_loadaddr} 0xFF ${kernel_size}  
tftpboot ${kernel_loadaddr} image.ub  
nand device 0  
nand erase.part nand-linux  
nand write ${kernel_loadaddr} nand-linux ${filesize}
```

11. Trigger NAND Flash boot with:

```
run nandboot
```





Last Page: [Command Line Interface CLI](./3_CLI.md)

Next Page: [Project mode](./5_Project_Mode.md)
