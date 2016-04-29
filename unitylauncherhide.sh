#!/bin/bash
#--------------------------------
# AUTHOR: AARON GRIFFITH
# PURPOSE: SCRIPT TO HIDE UNITY LAUNCHER. BEST USED AS A KEYBOARD SHORTCUT
#          System Settings -> Keyboard -> Shortcut
#          Tested on Ubuntu 15.10
# WEBSITE: AARONGRIFFITH.NET
# TWITTER: AJG9K
#--------------------------------
unitylauncher=$(gsettings get \
         org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ \
         launcher-hide-mode)

echo $unitylauncher

if [ $unitylauncher -eq 1 ]; then
    gsettings set \
    org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ \
    launcher-hide-mode 0
else
    gsettings set \
    org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ \
    launcher-hide-mode 1
fi
