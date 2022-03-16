killall -q compton
while pgrep -x compton > /dev/null; do sleep 1; done
picom --experimental-backends --config ~/.config/picom/picom.conf &
