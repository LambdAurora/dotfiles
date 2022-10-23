killall -q picom
while pgrep -x picom > /dev/null; do sleep 1; done
picom --experimental-backends --config ~/.config/picom/picom.conf &
