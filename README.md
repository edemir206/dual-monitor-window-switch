# dual-monitor-window-switch
A script to switch windows between dual monitors in current workspace.

## What does it do ?   

This script switches all windows from one monitor to another in current workspace when using dual screen mode in linux.

## Installation

1) Clone this repo
2) Edit swap.sh and set screen_width1 with the resolution of your first monitor and screen_width2 with the resolution of your second monitor.
4) install wmctrl: sudo apt install wmctrl
5) make executable: sudo chmod +x swap.sh
6) run using: ./swap.sh
7) I suggest you set a custom shortcut for easy activation.
8) Last step and most important, have fun.

## This script was tested in the following environment

1) Debian 9.8
2) Two 1920 x 1080 monitors (one DELL and the other is LG)
3) wmctrl v1.07
4) KDE Plasma 5.8.6

Based on the work of https://github.com/contribucious who posted a script to manipulate current active windows on cinnamon repo https://github.com/linuxmint/Cinnamon/issues/2190#issuecomment-19863084
