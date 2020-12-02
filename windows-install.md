# Installing on windows
QEMU offers a windows binary for installing QEMU on windows, theoretically, because of this MacOS should be able to run on windows aswell as on linux.

## Download QEMU
You will want to download QEMU from the [official QEMU site](https://www.qemu.org/download/#windows), using the windows x64 (Recommended) or x86 installer.

## Add QEMU to PATH
To help with the install, we will add QEMU to path, this means we can just type `qemu` into the command line instead of `install-location\qemu` to execute commands

Go to your search bar, and type environment, then click `Edit the system environment variables`, click this and click `Environment Variables` at the bottom, then double click Path, click new and add the install location for QEMU. Click OK and ensure you have applied changes, you will need to close and re-open command line.

