Change Log
==========

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
