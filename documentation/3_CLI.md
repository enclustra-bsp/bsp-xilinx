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



## Command Line Interface CLI

The build process can be invoked from the command line. All options that are available in the GUI are present on the command line interface as well. A list of the available command line options can be obtained like this:

```
./build.sh --help

usage: tool [-h] [--release ver] [-L] [--list-devices-raw] [-d device] [-l]
    [--list-targets-raw] [-x target] [-f target] [-b target]
    [--custom-build target steps] [--fetch-history target]
    [--list-dev-options] [--list-dev-binaries] [-B file path]
    [--anti-unicorn] [--expert-mode] [-o index] [--generate-project]
    [--build-project project_file] [--build-project-auto project_file]
    [-s cfg] [-c] [-C] [-v]

Enclustra Build Environment

optional arguments:
  -h, --help                    show this help message and exit
  --release ver                 specify release version of the buidscripts
  -L, --list-devices            list all available devices
  --list-devices-raw            list all available devices in a script
                                friendly way
  -d device, --device device    specify device as follows:
                                <family>/<module>/<base_board>/<boot_device>
  -l, --list-targets            list all targets for chosen device
  --list-targets-raw            list all targets for chosen device in a script
                                friendly way
  -x target                     fetch and build specific target
  -f target, --fetch target     fetch specific target
  -b target, --build target     build specific target
  --custom-build target steps   build specific target with specific steps
                                (comma separated)
  --fetch-history target        fetch specific target with history
  --list-dev-options            list all available device options for chosen
                                device
  --list-dev-binaries           list all available binary files for chosen
                                device
  -B file path, --custom-binary file path
                                exchange selected binary file with the one
                                pointed by the path
  --anti-unicorn                disables colored output
  --expert-mode                 expert mode: prepare the environment for
                                building the whole system manually
  -o index, --dev-option index  set device option by index, the default one
                                will be used if not specified
  --generate-project            generate project directory instead of a
                                regular output
  --build-project project_file  build project
  --build-project-auto project_file
                                build project automatically, skip the gui
  -s cfg, --saved-config cfg    use previously saved configuration file
  -c, --clean-all               delete all downloaded code, binaries, tools
                                and built files
  -C, --clean-soft              run clean commands for all specified targets
                                (if available)
  -v, --version                 print version

```


In order to list all available devices use the following command:

    ./build.sh -L

If the build.sh script is invoked with the -d option, the build environment switches to console mode. This mode requires a valid device specifier in order to locate the device configuration within the targets directory for the specific device, e.g. for the Mars ZX3 module on the Mars PM3 base board in QSPI boot mode, the command would look like this:

    ./build.sh -d Zynq-7000/Mars_ZX3/Mars_PM3/QSPI

Such a command will fetch and build all the default targets for a selected device. To list all the available targets for a selected device, the user needs to add the -l switch to the command, e.g.:

     ./build.sh -d Zynq-7000/Mars_ZX3/Mars_PM3/QSPI -l

The -x option will fetch and build only the selected target, e.g.:

    ./build.sh -d Zynq-7000/Mars_ZX3/Mars_PM3/QSPI -x Linux

That will fetch and build only the Linux target for the selected device.

To only fetch or build a specific target, the user can specify those targets with the -f (fetch) and -b (build) options. It is possible to choose multiple targets, e.g. like this:

    ./build.sh -d Zynq-7000/Mars_ZX3/Mars_PM3/QSPI -f Linux -b Buildroot -x U-Boot

This will fetch Linux, build Buildroot and fetch/build U-Boot.

The `--list-dev-options` option will list all the available device options for the chosen device. It can be used like this:

    ./build.sh -d Zynq-7000/Mars_ZX3/Mars_PM3/QSPI -x Linux --list-dev-options

This will print out an indexed list of device options.

The `-o` option allows the user to choose a device option for the selected device by providing the index of a specific device option, like this:

    ./build.sh -d Zynq-7000/Mars_ZX3/Mars_PM3/QSPI -x Linux -o 1

If no device option is selected, the default one will be used.

To reset the build environment and delete all downloaded code, binaries, tools and built files, the --clean option can be used:

    ./build.sh --clean


Last Page: [Graphical User Interface GUI](./2_GUI.md)

Next Page: [Deployment](./4_Deployment.md)