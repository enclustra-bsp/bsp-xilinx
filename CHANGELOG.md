Change Log
==========

Version 1.7 (2018-11-22)
---------------------

* bumped Linux kernel version to 4.14
* bumped U-Boot version to V2018.01
* bumped Buildroot version to V2018.05.1
* bumped GCC version to 7.2.0
* bumped mkbootimage version to 2.2
* upgraded Vivado binaries version to 2018.2 (compatible with this kernel version)
* updated ATF binaries for Zynq Ultrascale+ devices
* added new sections to the documentation:
    - "Updating Binaries"
    - "QSPI Flash using full image"
* updated the build script help message documentation
* new Cosmos XZQ10 boot modes support:
    - USB
    - NET
* added Mercury XU5 to the Ultrascale+ family, available variants:
    - ZU2EG, Industrial Temperature, Speed Grade 1
    - ZU3EG, Industrial Temperature, Speed Grade 2
    - ZU4EV, Industrial Temperature, Speed Grade 1
    - ZU5EV, Industrial Temperature, Speed Grade 2
    - ZU5EV, Extended Temperature, Speed Grade 3
* new Cosmos XZQ10 variants support:
    - Zynq-7030 Industrial Grade, Speed 2
    - Zynq-7045 Industrial Grade, Speed 2
* new Mars XU3 variant support:
    - ZU2EG, Industrial Temperature, Speed Grade 1
* removed Mars XU3 variant support:
    - ZU3EG ES, Extended Temperature, Speed Grade 1
* minor bug fixes

Version 1.6.1 (2018-05-30)
------------------------

* U-Boot fixes, including:
    - wrong MAC address programmed to EEPROM on some modules

Version 1.6 (2018-03-21)
------------------------

* rootfs overlays mechanism (for example for installing kernel modules into buildroot rootfs)
* proper binaries versioning using a new templates mechanism in config files
* automatic detection for number of threads to build on (based on host CPU)
* minor project mode fixes
* bug fixes
* updated user documentation
* full bootimages (bootimages with Linux images) support for Zynq US+ modules
* cosmos XZQ10 support
* added support for all possible boot modes for Zynq Ultrascale+ devices
* new Mercury+ XU1 variants support:
    - ZU9EG, Industrial Temperature, Speed Grade 1
    - ZU6EG, Industrial Temperature, Speed Grade 1
    - ZU15EG, Industrial Temperature, Speed Grade 2
* new Mars XU3 variants support:
    - ZU3EG, Industrial Temperature, Speed Grade 2
    - ZU2CG, Industrial Temperature, Speed Grade 1
* U-Boot fixes, including:
    - custom flash maps for 9eg, 6eg and 2cg US+ chips added
    - QPSI flash driver for Zynq US+
    - Zynq US+ version detection fixes

Version 1.5 (2017-06-28)
------------------------

* dropped container repositories
* added support for custom binaries
* GUI improvements
* offline building support
* bug fixes
* added support for MAC address reading from ATSHA EEPROM
* added Ultrascale+ family support:
    - added static ARM64 cross-compiler
    - added PMUFW support to mkbootimage tool
    - added Mercury XU1 support
    - added Mars XU3 support
    - added dual Ethernet support for XU1
* dropped support for 16MB QSPI flash memories
* dynamic QSPI flash partitions layout
* added persistent QSPI rootfs support for Mars ZX2/ZX3
* moved persistent QSPI and ramdisk QSPI targets to one QSPI target
* bumped Linux kernel version to 4.9
* bumped U-Boot version to V2016.07
