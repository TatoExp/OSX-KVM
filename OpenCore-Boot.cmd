REM!/usr/bin/env bash

 Special thanks to:
REM https://github.com/Leoyzen/KVM-Opencore
REM https://github.com/thenickdude/KVM-Opencore/
REM https://github.com/qemu/qemu/blob/master/docs/usb2.txt
REM
REM qemu-img create -f qcow2 mac_hdd_ng.img 128G
REM
REM echo 1 > /sys/module/kvm/parameters/ignore_msrs (this is required)


REM NOTE: Tweak the "MY_OPTIONS" line in case you are having booting problems!

SET MY_OPTIONS=+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check

REM This script works for Big Sur, Catalina, Mojave, and High Sierra. Tested with
REM macOS 10.15.6, macOS 10.14.6, and macOS 10.13.6

SET ALLOCATED_RAM=3072
SET CPU_SOCKETS=1
SET CPU_CORES=2
SET CPU_THREADS=4

SET REPO_PATH=.
SET OVMF_DIR=.

REM This causes high cpu usage on the *host* side
REM qemu-system-x86_64 -enable-kvm -m 3072 -cpu Penryn,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,hypervisor=off,vmx=on,kvm=off,%MY_OPTIONS%\

REM shellcheck disable=SC2054

qemu-system-x86_64 -m %ALLOCATED_RAM%^
  -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,%MY_OPTIONS%^
  -machine q35^
  -usb -device usb-kbd -device usb-tablet^
  -smp %CPU_THREADS%,cores=%CPU_CORES%,sockets=%CPU_SOCKETS%^
  -device usb-ehci,id=ehci^
  -device usb-kbd,bus=ehci.0^
  -device usb-mouse,bus=ehci.0^
  -device nec-usb-xhci,id=xhci^
  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"^
  -drive if=pflash,format=raw,readonly,file=%REPO_PATH%/%OVMF_DIR%/OVMF_CODE.fd^
  -drive if=pflash,format=raw,file=%REPO_PATH%/%OVMF_DIR%/OVMF_VARS-1024x768.fd^
  -smbios type=2^
  -device ich9-intel-hda -device hda-duplex^
  -device ich9-ahci,id=sata^
  -drive id=OpenCoreBoot,if=none,snapshot=on,format=qcow2,file=%REPO_PATH%/OpenCore-Catalina/OpenCore.qcow2^
  -device ide-hd,bus=sata.2,drive=OpenCoreBoot^
  -device ide-hd,bus=sata.3,drive=InstallMedia^
  -drive id=InstallMedia,if=none,file=%REPO_PATH%/BaseSystem.img,format=raw^
  -drive id=MacHDD,if=none,file=%REPO_PATH%/mac_hdd_ng.img,format=qcow2^
  -device ide-hd,bus=sata.4,drive=MacHDD^
  -netdev user,id=net0 -device vmxnet3,netdev=net0,id=net0,mac=52:54:00:c9:18:27^
  -monitor stdio^
  -vga vmware^
