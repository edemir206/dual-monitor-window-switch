#!/bin/bash

# screen width (the effective resolution! just set yours here.)
#Manual Older Way
#screen_width1=1920
#screen_width2=1920

#Automatic get horizontal resolution (new way) 
screen_width1=`xrandr | fgrep '*' | awk -F'[ +x]' '{print $4}' | sed -n 1p`
screen_width2=`xrandr | fgrep '*' | awk -F'[ +x]' '{print $4}' | sed -n 2p`

swap()
{
    # get active window size and position
    x=`xwininfo -id $1 | grep "Absolute upper-left X" | awk '{print $4}'`
    w=`xwininfo -id $1 | grep "Width" | awk '{print $2}'`

    maximized=false
    maximized_h=false
    maximized_v=false

    if xprop -id $1|egrep "_NET_WM_STATE.*_NET_WM_STATE_MAXIMIZED_HORZ" -q; then
        maximized_h=true
    fi
    if xprop -id $1|egrep "_NET_WM_STATE.*_NET_WM_STATE_MAXIMIZED_VERT" -q; then
        maximized_v=true
    fi
    if $maximized_h && $maximized_v; then
        maximized=true
    fi

    if $maximized; then
        wmctrl -ir $1 -b remove,maximized_vert,maximized_horz
    elif $maximized_h; then
        wmctrl -ir $1 -b remove,maximized_horz
    elif $maximized_v; then
        wmctrl -ir $1 -b remove,maximized_vert
    fi

    # window on left monitor
    if [ "$x" -lt "$screen_width1" ]; then

        #if both screens sizes are the same position windows in left corner
        if [ "$screen_width2" -eq "$screen_width1" ]; then
            h_position=$(($screen_width1+$x))
        else
            h_position=$screen_width1
        fi

    # window on right monitor
    else

        #if both screens sizes are the same position windows in left corner
        if [ "$screen_width2" -eq "$screen_width1" ]; then
            h_position=$(($x-$screen_width1))
        else
            h_position=0
        fi

    fi

    wmctrl -ir $1 -e 0,$h_position,-1,-1,-1

    if $maximized; then
        wmctrl -ir $1 -b add,maximized_vert,maximized_horz
    elif $maximized_h; then
        wmctrl -ir $1 -b add,maximized_horz
    elif $maximized_v; then
        wmctrl -ir $1 -b add,maximized_vert
    fi
}

#Get user current workspace
workspace=`wmctrl -d | grep '*' | cut -d ' ' -f1`

#Get current workspace windows
#current_windows=`wmctrl -l | grep "  $workspace " |  awk '{print $1;}'`
current_windows=`wmctrl -l | awk '{ if ($2 == '$workspace') { print } }' | awk '{print $1}'`

#Loop throught all windows swapping them between monitors
for i in $current_windows; do
  swap $i
done
