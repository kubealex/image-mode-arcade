#!/bin/bash
# Needed to prevent gnome from asking permissions
/usr/bin/flatpak permission-set gnome shortcuts-inhibitor org.mamedev.MAME.desktop GRANTED
# Run MAME with the required ROM
/usr/bin/flatpak run org.mamedev.MAME mamerom.zip
