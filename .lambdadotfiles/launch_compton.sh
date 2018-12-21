killall -q compton
while grep -x compton > /dev/null; do sleep 1; done
compton --config $HOME/.config/compton/config
