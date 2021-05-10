# Enclustra Build Environment - User Documentation


## Table of content

* [Introduction](./1_Introduction.md)
    - [Version Information](./1_Introduction.md#version-information)
    - [Build Environment](./1_Introduction.md#build-environment)
        - [Prerequisites](./1_Introduction.md#prerequisites)
        - [Directory Structure](./1_Introduction.md#directory-structure)
        - [Repositories Structure](./1_Introduction.md#repositories-structure)
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
    - [How to enable the eMMC flash on the Mercury+ PE1 base board?](./7_FAQ.md#how-to-enable-the-emmc-flash-on-the-mercury-pe1-base-board)



## FAQ

### How to script U-Boot?

All U-Boot commands can be automated by scripting, so that it is much more convenient to deploy flash images to the hardware.

For example, QSPI deployment:

Put the following commands as plain text to a file `cmd.txt`:

```
sf probe

echo "boot image"
mw.b ${bootimage_loadaddr} 0xFF ${bootimage_size}
tftpboot ${bootimage_loadaddr} ${bootimage_image}
sf erase ${qspi_bootimage_offset} ${bootimage_size}
sf write ${bootimage_loadaddr} ${qspi_bootimage_offset} ${filesize}

echo "boot script"
mw.b ${bootscript_loadaddr} 0xFF ${bootscript_size}
tftpboot ${bootscript_loadaddr} ${bootscript_image}
sf erase ${qspi_bootscript_offset} ${bootscript_size}
sf write ${bootscript_loadaddr} ${qspi_bootscript_offset} ${filesize}

echo "Linux kernel"
mw.b ${kernel_loadaddr} 0xFF ${kernel_size}
tftpboot ${kernel_loadaddr} ${kernel_image}
sf erase ${qspi_kernel_offset} ${kernel_size}
sf write ${kernel_loadaddr} ${qspi_kernel_offset} ${filesize}

echo "devicetree"
mw.b ${devicetree_loadaddr} 0xFF ${devicetree_size}
tftpboot ${devicetree_loadaddr} ${devicetree_image}
sf erase ${qspi_devicetree_offset} ${devicetree_size}
sf write ${devicetree_loadaddr} ${qspi_devicetree_offset} ${filesize}

echo "rootfs image"
mw.b ${jffs2_loadaddr} 0xFF ${jffs2_size}
tftpboot ${jffs2_loadaddr} ${jffs2_image}
sf erase ${qspi_rootfs_offset} ${jffs2_size}
sf write ${jffs2_loadaddr} ${qspi_rootfs_offset} ${filesize}

run qspiboot
```

Then generate an image cmd.img and put it onto the TFTP server on the host computer like following.

```
mkimage -T script -C none -n "QSPI flash commands" -d cmd.txt cmd.img
cp cmd.img /tftpboot
```

And finally, load the file on the target platform in U-boot and execute it, like this (after step 5 Setup U-Boot connection parameters, in the user documentation):

```
tftpboot 100000 cmd.img
source 100000
```




### How can the flash memory be programmed from Linux?

In order to program flash memory from Linux, a script like the following one can be used. - All required files need to be present in the current folder. They can be loaded via TFTP or from USB drive / SD card.

```
#!/bin/sh

getsize ()
{
        local  size=`ls -al $1 | awk '{ print $5 }'`
        echo "$size"
}

BOOTIMAGE_FILE="boot.bin"
KERNEL_FILE="Image"
DEVICETREE_FILE="devicetree.dtb"
SCRIPT_FILE="uboot.scr"
ROOTFS_FILE="rootfs.jffs2"

# write boot image
flash_erase /dev/mtd0 0 0
FILESIZE=`getsize ${BOOTIMAGE_FILE}`
echo Writing preloader file ${BOOTIMAGE_FILE} size ${FILESIZE}
mtd_debug write /dev/mtd0 0 ${FILESIZE} ${BOOTIMAGE_FILE}

# write Linux kernel
flash_erase /dev/mtd1 0 0
FILESIZE=`getsize ${KERNEL_FILE}`
echo Writing kernel file ${KERNEL_FILE} size ${FILESIZE}
mtd_debug write /dev/mtd1 0 ${FILESIZE} ${KERNEL_FILE}

# write devicetree
flash_erase /dev/mtd2 0 0
FILESIZE=`getsize ${DEVICETREE_FILE}`
echo Writing devicetree ${DEVICETREE_FILE} size ${FILESIZE}
mtd_debug write /dev/mtd2 0 ${FILESIZE} ${DEVICETREE_FILE}

# delete U-Boot configuration
flash_erase /dev/mtd3 0 0

# write boot script
flash_erase /dev/mtd4 0 0
FILESIZE=`getsize ${SCRIPT_FILE}`
echo Writing bootscript file ${SCRIPT_FILE} size ${FILESIZE}
mtd_debug write /dev/mtd4 0 ${FILESIZE} ${SCRIPT_FILE}

# write rootfs
flash_erase /dev/mtd5 0 0
FILESIZE=`getsize ${ROOTFS_FILE}`
echo Writing rootfs file ${ROOTFS_FILE} size ${FILESIZE}
mtd_debug write /dev/mtd5 0 ${FILESIZE} ${ROOTFS_FILE}
```

Just make the script executable and execute it like this:

```
chmod +x flash.sh
./flash.sh
```





### How to enable the eMMC flash on the Mercury+ PE1 base board?

The eMMC flash equipped on the Mercury+ PE1 base board is connected via a multiplexer to the SDIO pins on the module connector. The multiplexer connects either the eMMC flash signals or the SD card signals to the module connector pins and is controlled by a DIP switch (CFG A 3). When the CFG A 3 switch is ON, the eMMC flash is active, otherwise the SD card. For more information about the eMMC flash, please refer to Mercury+ PE1 User Manual. U-Boot by default is configured to recognize a SD card on the PE1 base board. If you want use eMMC flash instead of SD card, you have to make the following change in the uboot devicetree in file .

#### For Zynq Ultrascale+ modules

In file `xilinx-uboot/arch/arm/dts/zynqmp_enclustra_mercury_pe1.dtsi`, replace the following line in the `sdhci1` block:

```
&sdhci1 {
	wp-inverted;
```

with this lines:

```
&sdhci1 {
	non-removable;
	disable-wp;
```


#### For Zynq-7000 modules

In file `xilinx-uboot/arch/arm/dts/zynq_enclustra_mercury_pe1.dtsi`, add the following line in the `sdhci0` block:

```
&sdhci0 {
	non-removable;
```

> **_Note:_**  Zynq-7000 devices do not support eMMC boot.


Last Page: [Updating the binaries](./6_Binaries_Update.md)