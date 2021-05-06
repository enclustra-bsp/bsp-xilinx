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




## Introduction

This is the user documentation for the Enclustra Build Environment project. It can be used to create a bootable Linux image for Enclustra's SoC modules. Enclustra also provides reference designs and packages for Petalinux. Both can be found on [https://github.com/enclustra](https://github.com/enclustra) .

### Version Information

Date | Rev | Author | Changes
--- | --- | --- | --- 
2015-05-08 | 0.1.0 | Karol Gugala | Buildsystem description
2015-05-11 | 0.1.1 | Aleksandra Szawara | Language check
2015-07-06 | 0.1.2 | Aurelio Lucchesi | Minor corrections
2015-11-20 | 0.1.3 | Tomasz Gorochowik | Major reorganization
2016-06-21 | 0.1.4 | Tomasz Gorochowik | Project mode section
2017-06-23 | 0.1.5 | Maciej Mikunda | Updates for release v1.5
2018-03-21 | 0.1.6 | Mariusz Glebocki | Updates for release v1.6
2018-11-22 | 0.1.7 | Wojciech Tatarski | Updates for release v1.7
2019-02-22 | 0.1.8 | Joanna Brozek | Updates for release v1.8






###  Build Environment

This chapter describes the usage of the build environment. The whole build environment is written in Python. Its internal functionality is determined by ini files placed in a specific directory layout.
      
#### Prerequisites

The supported OS for the build environment are: Ubuntu 16.04 LTS and Ubuntu 18.04 LTS

To run the build script a Python interpreter is required. The system is compatible with both, Python 2 and Python 3.

The build environment requires additional software to be installed as listed below:

Tool |  Comments
--- | --- 
dialog |  Required only in the GUI mode
make | 
git | 
mercurial |  
tar | 
unzip |  
curl |  
wget | 
bc |  
libssl-dev |  
patch | 
rsync | 
autoconf |  Required to build a buildroot rootfs
g++ |  Required to build a buildroot rootfs
gcc | 
flex | 
bison |


The required packages can be installed with the following commands:

```
sudo apt update
sudo apt install python3 dialog make git mercurial tar unzip curl wget bc libssl-dev patch rsync autoconf g++ gcc flex bison
```





### Directory Structure

The build environment is designed to work with a specific directory structure depicted below:

    |-- bin
    |-- binaries
    |-- buildscripts
    |-- sources
    |   |-- target_submodule_1
    |   |-- target_submodule_2
    |   |-- target_submodule_3
    |   |-- target_submodule_4
    |-- targets
    |   |-- Module_1
    |       |-- BaseBoard_1
    |       |-- BaseBoard_2
    |   |-- Module_2
    |       |-- BaseBoard_1
    |-- target_output

Folder | function
--- | ---
bin | Remote toolchains installation folder.
binaries | Additional target binaries download folder.
sources | master_git_repository clone folder. It contains submodule folders.
buildscripts | Build system executable files.
targets | Target configurations are placed here.
target_output | Folders generated during the build process, that contain the output files after a successful build of every specifc target.

> **_Important:_**  By default, the target output folders are named according to this folder naming scheme:  
> `out_<timestamp>_<module>_<board>_<bootmode>.`  
> The default name can be overwriten during the build process.



### General Build Environment Configuration

Environment settings are stored in the enclustra.ini file in the main directory of the build environment. Before starting the build script, one may need to adjust the general settings of the build environment by editing this file. One of the most crucial setting is the number of build threads used in a parallel. This parameter is set in the [general] section by changing the nthreads key. Additionally, parameters in the [debug] section allow the user to adjust the logging settings:

- If the debug-calls option if set to true, the output of all external tool calls (such as make, tar etc.) will be displayed in the terminal.
- If the quiet-mode option is set to true, the build log of the targets will not be printed to the terminal, only informations about actual build state will be shown. This option does not affect the build-logfile option.
- If the build-logfile option is set to a file name, the build environment will write the whole build log output to that file. If the option is not set, the output will not be logged.
- If the break-on-error option is set to true, the build environment will interrupted on the first error. Otherwise the build environment will only print an error message and continue to work on a next available target.





## Supported Devices

Family | Module | Base boards
--- | --- | ---
Xilinx | Cosmos XZQ10 |
Xilinx | Mars ZX2 | Mars EB1 / PM3 / ST3
Xilinx | Mars ZX3 | Mars EB1 / PM3 / ST3
Xilinx | Mars XU3 | Mars EB1 / ST3
Xilinx | Mercury ZX1 | Mercury PE1 / ST1
Xilinx | Mercury ZX5 | Mercury PE1 / ST1
Xilinx | Mercury+ XU1 | Mercury PE1 / ST1
Xilinx | Mercury XU5 | Mercury PE1 / ST1
Xilinx | Mercury+ XU7 | Mercury PE1 / ST1
Xilinx | Mercury+ XU8 | Mercury PE1 / ST1
Xilinx | Mercury+ XU9 | Mercury PE1 / ST1

> **_Note:_**  Since release 1.7, the ZU3EG ES variant of the Mars XU3 module is no longer supported.


Next Page: [Graphical User Interface GUI](./2_GUI.md)
