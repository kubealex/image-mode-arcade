#!/bin/bash
# Note: You need to download a NES ROM and place it in the same directory as the Containerfile
# and replace "nesrom.nes" in this retro_arcade.sh and in the Containerfile with the filename of the nes ROM file.

# Needed to prevent gnome from asking permissions - Uncomment if you are using this container image to deploy a VM using bootc-image-builder
/usr/bin/flatpak permission-set gnome shortcuts-inhibitor org.mamedev.MAME.desktop GRANTED


/usr/bin/flatpak run org.libretro.RetroArch -L /opt/retroarch/cores/nestopia_libretro.so /opt/retroarch/roms/nesrom.nes
