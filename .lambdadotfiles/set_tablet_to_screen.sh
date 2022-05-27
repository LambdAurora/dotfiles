#!/bin/zsh
xsetwacom set $(xsetwacom list | grep -oP '(?:id: )[0-9][0-9](?:	type: STYLUS)' | sed 's/id: //' | sed 's/	type: STYLUS//') MapToOutput HEAD-2
