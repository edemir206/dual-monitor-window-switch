#!/bin/bash
 
# screen width (the effective resolution! just set yours here.)
#Manual Older Way
#screen_width1=1920
#screen_width2=1920

#Automatic get horizontal resolution (new way) 
screen_width1=`xrandr | fgrep '*' | awk -F'[ \+x]' '{print $4}' | sed -n 1p`
screen_width2=`xrandr | fgrep '*' | awk -F'[ \+x]' '{print $4}' | sed -n 2p`

swap()
{
    # get active window size and position
    x=`xwininfo -id $1 | grep "Absolute upper-left X" | awk '{print $4}'`
    w=`xwininfo -id $1 | grep "Width" | awk '{print $2}'`
    
    maximized=false
    
    # window on left monitor
    if [ "$x" -lt "$screen_width1" ]; then
        if [ "$w" -eq "$screen_width1" ]; then
            maximized=true
        fi
    
        if $maximized; then
            wmctrl -ir $1 -b remove,maximized_vert,maximized_horz
        fi
    
        #if both screens sizes are the same position windows in left corner
        if [ "$screen_width2" -eq "$screen_width1" ]; then
            h_position=$(($screen_width1+$x))
        else
            h_position=$screen_width1
        fi

        wmctrl -ir $1 -e 0,$h_position,-1,-1,-1

        if $maximized; then
            wmctrl -ir $1 -b add,maximized_vert,maximized_horz
        fi
    
    # window on right monitor
    else
        if [ "$w" -eq "$screen_width2" ]; then
            maximized=true
        fi
    
        if $maximized; then
            wmctrl -ir $1 -b remove,maximized_vert,maximized_horz
        fi

        #if both screens sizes are the same position windows in left corner
        if [ "$screen_width2" -eq "$screen_width1" ]; then
            h_position=$(($x-$screen_width1))
        else
            h_position=0
        fi
    
        wmctrl -ir $1 -e 0,$h_position,-1,-1,-1
    
        if $maximized; then
            wmctrl -ir $1 -b add,maximized_vert,maximized_horz
        fi
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