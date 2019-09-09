#!/bin/bash

# Options
power_off="  Power off"
reboot="  Reboot"
lock="Lock"
suspend="  Suspend"
log_out="Log out"

options="$power_off\n$reboot\n$lock\n$suspend\n$log_out"

chosen="$(echo -e "$options" | rofi -dmenu -selected-row 2)"
case $chosen in
    $power_off)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        light-locker-command -l
        ;;
    $suspend)
        amixer set Master mute
        systemctl suspend
        ;;
    $log_out)
        i3-msg exit
        ;;
esac

