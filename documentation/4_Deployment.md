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



## Deployment

This chapter describes how to prepare the hardware to boot from different boot media, using the binaries generated from the build environment. The boot process differs in its details on different hardware, but in general it covers the following steps:

1. BootRom embedded in a CPU starts execution after reset. It searches through a predefined storages for a next (first) stage boot loader.

2. First stage boot loader (FSBL, U-Boot SPL) is loaded into On Chip Memory, and executed.

3. First stage boot loader initializes RAM controller, clocks and loads second stage boot loader into RAM.

4. Second stage boot loader (U-Boot) loads the Linux kernel, device tree blob and any other required files into RAM and runs the Linux kernel.

5. Linux kernel configures peripherals, mounts user space root filesystem and executes the init application within it.

6. Init application starts the rest of the user space applications - the system is up and running.

For more detailed information about the boot process on a Xilinx Zynq devices please refer to:

- Xilinx Zynq technical reference guide (chapters 6 and 32).

All the guides in this section require the user to build the required files for the chosen device, with the build environment, as described in the previous section. Once the files are built, they can be deployed to the hardware as described in the following sub sections.

> **_Note:_**  Default target output directories are named according to the following directory naming scheme:  
> `out_<timestamp>_<module>_<board>_<bootmode>.`

As a general note on U-Boot used in all the following guides: U-Boot is using variables from the default environment. Moreover, the boot scripts used by U-Boot also rely on those variables. If the environment was changed and saved earlier, U-Boot will always use these saved environment variables on a fresh boot, even after changing the U-Boot environment.

Boot storage | Environment storage | Offset | Size
--- | --- | --- | ---
MMC | MMC | partition 1 (FAT) | 0x80000
eMMC | eMMC | partition 1 (FAT) | 0x80000
QSPI/NET/USB | QSPI | 0x3f80000 | 0x80000
NAND | NAND | ‘ubi-env’ partition | 0x18000

To restore the default environment, run the following command in the U-Boot command line:

```
env default -a
```

This will not overwrite the stored environment but will only restore the default one in the current run. To permanently restore the default environment, the saveenv command has to be invoked.

> **_Note:_**  A `*** Warning - bad CRC, using default environment` warning message that appears when booting into U-Boot indicates that the default environment will be loaded.




### SD Card (MMC)

In order to deploy images to an SD Card and boot from it, perform the following steps as root:

1. Create a FAT formatted BOOT partition as the first one on the SD Card. The size of the partition should be at least 64 MB. (For more information on how to prepare the boot medium, please refer to the official Xilinx guide.)

2. Create an ext4 formatted partition (rootfs) as the second one on the SD Card. The size of the partition should be at least 64 MB.

3. Copy boot.bin, the kernel image (uImage for Zynq-7000 or Image for Zynq Ultrascale+), devicetree.dtb and uboot.scr (or uboot_ramdisk.scr file when using RAMDISK, which must be renamed to uboot.scr) from the build environment output directory onto the BOOT partition (FAT formatted). Copy uramdisk to the same partition (only when using RAMDISK).

4. Extract the rootfs.tar archive from the build environment output directory onto the second partition (rootfs, ext4 formatted).

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

1. Prepare a bootable SD card with a ramdisk or persistent rootfs as described in SD Card (MMC).

2. You’ll need the following files from eMMC build: boot.bin, devicetree.dtb, Image (Zynq Ultrascale+ only), uImage (Zynq-7000 only). Additionally, you’ll need uramdisk, uboot_ramdisk.scr when you want to use a ramdisk, and rootfs.tar, uboot.scr to use a persistent rootfs. Copy the files to a TFTP server’s directory to load them later through the network. If you don’t want to use the network connection on the board, copy the files to the emmc directory on the SD card’s rootfs partition instead.

3. Boot Linux on the device from the SD Card (ramdisk or persistent rootfs) and login as root.

4. If you’ve put eMMC build files on the SD card, and you’re booting from a ramdisk, mount the SD card’s second partition in /mnt. When booting from a persistent rootfs, the files are already in /emmc. In either case, cd to a directory with the files. In the case of files located on a TFTP server, connect to the network by running dhcpcd eth0 and download the files:

```
tftp -g -r boot.bin       $SERVER_IP  
tftp -g -r devicetree.dtb $SERVER_IP  
tftp -g -r uImage         $SERVER_IP  # Zynq-7000 only  
tftp -g -r Image          $SERVER_IP  # Zynq Ultrascale+ only  

# For eMMC with persistent rootfs:  
tftp -g -r rootfs.tar     $SERVER_IP  
tftp -g -r uboot.scr      $SERVER_IP  

# For eMMC with ramdisk:  
tftp -g -r uramdisk       $SERVER_IP  
tftp -g -r uboot_ramdisk.scr -l uboot.scr $SERVER_IP
```

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

The QSPI Flash is divided into 6 partitions based on U-Boot environment variables. Those variables are calculated and set automatically, so in most cases there is no need to change them. For more detailed information on partition offsets and sizes, please refer to QSPI Flash Layouts.

> **_Note:_**  Since release 1.5, 16MB QSPI Flash memories are no longer supported.

In order to deploy images to QSPI Flash and boot from it, do the following steps:

1. Setup a TFTP server on the host computer.

2. Power on the board and boot to U-Boot (e.g. from a SD Card (MMC)).

3. Connect an Ethernet cable to the device.

4. Connect a serial console to the device (e.g. using PuTTY or picocom).

5. Setup the U-Boot connection parameters (in the U-Boot console):

```
setenv ipaddr 'xxx.xxx.xxx.xxx'  
# where xxx.xxx.xxx.xxx is the board address
setenv serverip 'yyy.yyy.yyy.yyy'  
# where yyy.yyy.yyy.yyy is the server (host computer) address
```

6. Copy `boot.bin`, the kernel image (uImage for Zynq-7000 or Image for Zynq Ultrascale+), `devicetree.dtb, uboot.scr` (or `uboot_ramdisk.scr` file which must be renamed to `uboot.scr`) and `rootfs.jffs2` (or uramdisk when using RAMDISK) from the build environment output directory to the TFTP server directory.

7. Set memory pinmux to QSPI Flash:

> **_Note:_**  This step is required only for modules equipped with Zynq-7000 devices.

```
zx_set_storage QSPI
```

8. Before accessing the QSPI Flash for the first time, the flash device must be enumerated:

```
sf probe
```

9. Update the boot image:

```
mw.b ${bootimage_loadaddr} 0xFF ${bootimage_size}  
tftpboot ${bootimage_loadaddr} ${bootimage_image}  
sf erase ${qspi_bootimage_offset} ${bootimage_size}  
sf write ${bootimage_loadaddr} ${qspi_bootimage_offset} ${filesize}
```

10. Update the boot script image:

```
mw.b ${bootscript_loadaddr} 0xFF ${bootscript_size}  
tftpboot ${bootscript_loadaddr} ${bootscript_image}  
sf erase ${qspi_bootscript_offset} ${bootscript_size}  
sf write ${bootscript_loadaddr} ${qspi_bootscript_offset} ${filesize}
```

11. Update the Linux kernel:

```
mw.b ${kernel_loadaddr} 0xFF ${kernel_size}  
tftpboot ${kernel_loadaddr} ${kernel_image}  
sf erase ${qspi_kernel_offset} ${kernel_size}  
sf write ${kernel_loadaddr} ${qspi_kernel_offset} ${filesize}
```

12. Update the devicetree image:

```
mw.b ${devicetree_loadaddr} 0xFF ${devicetree_size}  
tftpboot ${devicetree_loadaddr} ${devicetree_image}  
sf erase ${qspi_devicetree_offset} ${devicetree_size}  
sf write ${devicetree_loadaddr} ${qspi_devicetree_offset} ${filesize}
```

13. Update the rootfs image:

This step depends on the chosen boot device.

If QSPI RAMDISK was selected:

```
mw.b ${ramdisk_loadaddr} 0xFF ${ramdisk_size}  
tftpboot ${ramdisk_loadaddr} ${ramdisk_image}  
sf erase ${qspi_ramdisk_offset} ${ramdisk_size}  
sf write ${ramdisk_loadaddr} ${qspi_ramdisk_offset} ${filesize}
```

 If QSPI was selected:

```
mw.b ${jffs2_loadaddr} 0xFF ${jffs2_size}  
tftpboot ${jffs2_loadaddr} ${jffs2_image}  
sf erase ${qspi_rootfs_offset} ${jffs2_size}  
sf write ${jffs2_loadaddr} ${qspi_rootfs_offset} ${filesize}
```

> **_Note:_**  For Zynq Ultrascale+ modules, QSPI boot mode with persistent rootfs is implemented using the SD card for the rootfs image. A .tar archive is generated for these modules instead of a .jffs2 file. This archive must be extracted to the Linux partition of the SD card. (For more information on how to prepare the boot medium, please refer to the official Xilinx guide.)


1. Power off the board.
2. Configure the board to boot from the QSPI Flash (refer to the board User Manual).
3. Power on the board.
4. The board should boot the Linux system.

If one wants to manually trigger booting from the QSPI Flash, the following command has to be invoked from the U-Boot command line:

```
run qspiboot
```

> **_Note:_**  Note that step 8 to 12 can be invoked independently.






##### QSPI Flash using the full image

1. Copy the boot_full.bin (or boot_full_ramdisk.bin when using RAMDISK, which must be renamed to boot_full.bin) file from the build environment output directory to the TFTP server directory.

   > **_Note:_**  The boot_full.bin file is available only for modules equipped with Zynq-7000 devices.

2. Flash the QSPI memory:

```
mw.b ${bootfull_loadaddr} 0xFF 0x4000000  
tftpboot ${bootfull_loadaddr} boot_full.bin  
sf probe  
sf erase 0x0 0x4000000  
sf write ${bootfull_loadaddr} 0x0 ${filesize}
```

3. Configure the board to boot from the QSPI flash (refer to the board’s User Manual).
4. Reset the board.
5. The board should boot the Linux system.

If you want to manually trigger booting from the QSPI flash, the following command has to be invoked from the U-Boot command line:

```
run qspiboot
```





### NAND Flash

Enclustra Build Environment does not support direct boot from the NAND Flash memory. The FSBL and the U-Boot have to be started from SD Card (MMC) or QSPI Flash. Please refer to SD Card (MMC) or QSPI Flash in order to boot U-Boot from SD Card or QSPI Flash. When U-Boot is booted it can load and boot the Linux system stored on the NAND Flash memory.

Partition | Offset | Size
--- | --- | ---
Linux kernel | 0x0 | 0x500000
Linux Device Tree | 0x500000 | 0x100000
Bootscript | 0x600000 | 0x100000
Rootfs | 0x700000 | Rest of the NAND Storage space

> **_Note:_**  Not all Xilinx-based modules come with NAND Flash memory.

In order to deploy images and boot the Linux system from NAND Flash, do the following steps:

1. Setup an TFTP server on the host computer.

2. Power on the board and boot to U-Boot (e.g. from a SD Card (MMC)).

3. Connect an Ethernet cable to the device.

4. Connect a serial console to the device (e.g. using PuTTY or picocom).

5. Copy the kernel image (uImage for Zynq-7000 or Image for Zynq Ultrascale+), devicetree.dtb, uboot.scr and rootfs.ubi files from the build environment output directory to the TFTP server directory.

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
tftpboot ${kernel_loadaddr} ${kernel_image}  
nand device 0  
nand erase.part nand-linux  
nand write ${kernel_loadaddr} nand-linux ${filesize}
```

11. Update the devicetree image:

```
mw.b ${devicetree_loadaddr} 0xFF ${devicetree_size}  
tftpboot ${devicetree_loadaddr} ${devicetree_image}  
nand device 0  
nand erase.part nand-device-tree  
nand write ${devicetree_loadaddr} nand-device-tree ${filesize}
```

12. Update the rootfs image:

```
mw.b ${ubifs_loadaddr} 0xFF ${ubifs_size}  
tftpboot ${ubifs_loadaddr} ${ubifs_image}  
nand device 0  
nand erase.part nand-rootfs  
nand write ${ubifs_loadaddr} nand-rootfs ${filesize}
```

13. Setup the U-boot environment partition:

```
nand device 0  
nand erase.part ubi-env  
ubi part ubi-env  
ubi create uboot-env ${env_size} dynamic
```

    > **_Note:_**  This step is required only when you want use the saveenv command to save the U-Boot environment on the NAND device. This can also be done at a later point, when U-Boot is actually run from NAND, but the zx_set_storage NAND command has to be executed beforehand.

14. Trigger NAND Flash boot with:

```
run nandboot
```

> **_Note:_**  Note that step 8 to 11 can be invoked independently.





### USB Drive

The Xilinx family devices cannot boot directly from a USB Drive. The FSBL and the U-Boot have to be started from SD Card (MMC) or QSPI Flash. Please refer to SD Card (MMC) or QSPI Flash in order to boot U-Boot from SD Card or QSPI Flash. When U-Boot is booted it can load and boot the Linux system stored on the USB Drive.

In order to deploy images and boot the Linux system from a USB Drive, perform the following steps:

1. Create a FAT formatted partition as the first partition on the drive. The size of the partition should be at least 64 MiB. (For more information on how to prepare the boot medium, please refer to the official Xilinx guide.)

2. Copy the kernel image (uImage for Zynq-7000 or Image for Zynq Ultrascale+), devicetree.dtb, uramdisk and uboot_ramdisk.scr (which must be renamed to uboot.scr) from the build environment output directory to the FAT formatted partition.

3. Insert the USB drive into the USB port of the board.

4. Configure the board to boot from the SD Card (MMC) or QSPI Flash (refer to the board User Manual).

5. Power on the board and stop the U-Boot autoboot.

6. Trigger USB boot with:

```
run usbboot
```




### NFS

The Xilinx family devices cannot boot directly from NFS.

The FSBL and the U-Boot have to be started from SD Card (MMC), with the images generated by the build environment. When U-Boot is booted it can load and boot the Linux system from the host machine via Ethernet. Please refer to NFS Preparation Guide to prepare your system for NFS boot.

In order to deploy images and boot the Linux system over NFS, do the following steps as root:

1. Create a FAT formatted BOOT partition as the first one on the SD Card. The size of the partition should be at least 64 MB. (For more information on how to prepare the boot medium, please refer to the official Xilinx guide.)

2. Copy boot.bin and uboot.scr from the build environment output directory onto the BOOT partition.

3. Extract the rootfs.tar archive from the build environment output directory into the NFS folder.

```
sudo tar -xpf rootfs.tar -C /path/to/NFS
```

4. Copy the kernel image (uImage for Zynq-7000 or Image for Zynq Ultrascale+), devicetree.dtb and uboot.scr to the TFTP folder.

5. Insert the card into the SD Card slot on the board.

6. Configure the board to boot from the SD Card (MMC).

7. Power on the board and stop the U-Boot autoboot.

8. Set the server’s and target’s IP address, and the path to the rootfs NFS folder.

```
env default -a  
setenv ipaddr 192.168.1.10  
setenv serverip 192.168.1.2  
setenv serverpath /path/to/NFS  
saveenv
```

9. Trigger NFS boot with:

```
run netboot
```

> **_Note:_**  Saving the U-Boot environment this way will ensure that NFS boot runs automatically after reboot.



#### NFS Preparation Guide

For development, it can be very handy to mount the root filesystem via NFS (nfsroot).

To prepare the host machine several preparatory steps are required.

The following servers need to be installed on the host machine, and configured properly:


- NFS server (e.g. on Ubuntu nfs-kernel-server)
- TFTP server (e.g. on Ubuntu tftpd)
- DHCP server (e.g. on Ubuntu isc-dhcp-server)

For demonstration purpose, the TFTP folder on the host is /tftpboot. It can be configured like this:

```
$ sudo mkdir /tftpboot
$ sudo chown nobody /tftpboot
$ nano /etc/xinetd.d/tftp
$ cat /etc/xinetd.d/tftp
service tftp
{
	protocol = udp
	port = 69
	socket_type = dgram
	wait = yes
	user = nobody
	server = /usr/sbin/in.tftpd
	server_args = /tftpboot
	disable = no
}
$ sudo /etc/init.d/xinetd restart
```

For demonstration purpose, the NFS export folder is /nfs_exp. In can be configured like this:

```
$ sudo mkdir /nfs_exp
$ sudo chown root:root /nfs_exp
$ sudo chmod 777 /nfs_exp
$ sudo nano /etc/exports
$ cat /etc/exports
/nfs_exp 192.168.1.0/24(fsid=0,rw,no_subtree_check,no_root_squash)
$ sudo exportfs -a
```

Sometimes it is also necessary to restart the NFS server:

```
$ sudo /etc/init.d/nfs-kernel-server restart
```

To configure the DHCP server do this:

```
$ cat /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.1.255;
option domain-name-servers 192.168.1.1, 192.168.1.2;
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.10 192.168.1.255;
}
$ sudo /etc/init.d/isc-dhcp-server restart
```

To select your ethernet interface edit `/etc/default/isc-dhcp-server`:

```
$ sudo sed -i -r 's/INTERFACES="(.+)"/INTERFACES="eth1"/g' /etc/default/isc-dhcp-server  
sudo /etc/init.d/isc-dhcp-server restart
```

On the target in the Linux console, the NFS folder from the host should now accessible like this

```
# mkdir /nfs
# mount -t nfs -o port=2049,nolock,proto=tcp,ro,vers=3 <server_ip>:/nfs_exp /nfs
# cd /nfs
```

> **_Note:_**  Note that currently our Linux only supports NFS version 3, not 4. So the target folder needs to be specified, and the version is 3 (vers=3).

> **_Note:_**  Take care to properly handle the permissions on the server. They should match those used on the client.

After configuring your system, you can now deploy the new boot images to your TFTP folder, and extract the rootfs TAR archive to your NFS folder.




### QSPI Flash Layouts

The QSPI flash layout depends on the version of the Zynq chip that is present in the module.

#### Xilinx Zynq-7010/7015/7020 Family QSPI Flash Layout

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0x600000
Linux kernel | uImage | 0x600000 | 0x500000
Linux Device Tree | devicetree.dtb | 0xB00000 | 0x80000
U-Boot environment | | 0x3F80000 | 0x80000
Bootscript | uboot.scr/uboot_ramdisk.scr | 0xB80000 | 0x80000
Rootfs | rootfs.jffs2/uramdisk | 0xC00000 | 0x3380000


#### Xilinx Zynq-7030 Family QSPI Flash Layout

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0x700000
Linux kernel | uImage | 0x700000 | 0x500000
Linux Device Tree | devicetree.dtb | 0xC00000 | 0x80000
U-Boot environment | | 0x3F80000 | 0x80000
Bootscript | uboot.scr/uboot_ramdisk.scr | 0xC80000 | 0x80000
Rootfs | rootfs.jffs2/uramdisk | 0xD00000 | 0x3280000


#### Xilinx Zynq-7035/7045 Family QSPI Flash Layout

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0xE00000
Linux kernel | uImage | 0xE00000 | 0x500000
Linux Device Tree | devicetree.dtb | 0x1300000 | 0x80000
U-Boot environment | | 0x3F80000 | 0x80000
Bootscript | uboot.scr/uboot_ramdisk.scr | 0x1380000 | 0x80000
Rootfs | rootfs.jffs2/uramdisk | 0x1400000 | 0x2B80000


#### Xilinx Zynq Ultrascale+ ZU2CG/ZU2EG/ZU3EG/ZU4EV/ZU4CG/ZU5EV Family QSPI Flash Layout

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0x900000
Linux kernel | Image | 0x900000 | 0xE00000
Linux Device Tree | devicetree.dtb | 0x1700000 | 0x80000
U-Boot environment | | 0x3F80000 | 0x80000
Bootscript | uboot_ramdisk.scr | 0x1780000 | 0x80000
Rootfs | uramdisk | 0x1800000 | 0x2780000


#### Xilinx Zynq Ultrascale+ ZU7EV Family QSPI Flash Layout

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0x1500000
Linux kernel | Image | 0x1500000 | 0xE00000
Linux Device Tree | devicetree.dtb | 0x2300000 | 0x80000
U-Boot environment | | 0x3F80000 | 0x80000
Bootscript | uboot_ramdisk.scr | 0x2380000 | 0x80000
Rootfs | uramdisk | 0x2400000 | 0x1B80000


#### Xilinx Zynq Ultrascale+ ZU6EG/ZU9EG Family QSPI Flash Layout

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0x1D00000
Linux kernel | Image | 0x1D00000 | 0xE00000
Linux Device Tree | devicetree.dtb | 0x2B00000 | 0x80000
U-Boot environment | | 0x3F80000 | 0x80000
Bootscript | uboot_ramdisk.scr | 0x2B80000 | 0x80000
Rootfs | uramdisk | 0x2C00000 | 0x1380000


#### Xilinx Zynq Ultrascale+ ZU15EG Family QSPI Flash Layout

Partition | Filename | Offset | Size
--- | --- | --- | ---
Boot image | boot.bin | 0x0 | 0x1F00000
Linux kernel | Image | 0x1F00000 | 0xE00000
Linux Device Tree | devicetree.dtb | 0x2D00000 | 0x80000
U-Boot environment | | 0x3F80000 | 0x80000
Bootscript | uboot_ramdisk.scr | 0x2D80000 | 0x80000
Rootfs | uramdisk | 0x2E00000 | 0x1180000


Last Page: [Command Line Interface CLI](./3_CLI.md)

Next Page: [Project mode](./5_Project_Mode.md)