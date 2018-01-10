#!/bin/bash
#
# ~/.xinitrc

## export desktop environment
export DE=i3

## set up keyboard
setxkbmap de
numlockx on

## unmute alsa
/usr/bin/amixer sset Master Mono 90% unmute  &> /dev/null
/usr/bin/amixer sset Master 90% unmute  &> /dev/null
/usr/bin/amixer sset PCM 90% unmute &> /dev/null

## disable energy star and equivalent annoyance
/usr/bin/xset b off
/usr/bin/xset s off
/usr/bin/xset s noblank
/usr/bin/xset -dpms

## add optional fonts to the font path
#xset +fp "${MY_FONTPATH"}
#xset fp rehash

## Dbus fix
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

## source xresources
[[ -f "{MY_X11_HOME}" ]] && xrdb -merge -I${HOME} ~/.local/share/x11/xresources

####################
###  start windowmanager  ###
i3 & wmpid=$!

## enable if using proprietary nvidia driver
#[[ -x /usr/bin/nvidia-settings ]] && /usr/bin/nvidia-settings -l

## polkit agent
/usr/bin/lxpolkit &

## hide pointer when idle
{ unclutter -idle 5; } &

## terminal
{ stjerm -m shift -k tab -p right -h 83% -w 50%; } &

## update user-dirs
#/usr/bin/xdg-user-dirs-update

## wait for windowmanager to exit
wait $wmpid
###  WM EXIT  ###
############

## restore the x fontpath
#xset fp default
