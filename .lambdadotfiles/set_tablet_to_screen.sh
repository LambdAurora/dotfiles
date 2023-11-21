#!/bin/zsh

function set_tablet_to_display() {
	id=$(xsetwacom list | grep -oP '(?:id: )[0-9]{1,2}(?:[[:space:]]+type: STYLUS)' | sed 's/id: //' | sed 's/\ttype: STYLUS//')
	xsetwacom set $id MapToOutput ${1}
	echo "Set stylus ${id} to output ${1}."
}

while read -r output hex conn; do
	[[ -z "$conn" ]] && conn=${output%%-*}
	name=$(xxd -r -p <<< "$hex")

	if [[ "$name" == "Wacom One 13" ]]
	then
		set_tablet_to_display $output
	fi
done < <(xrandr --prop | awk '
	!/^[ \t]/ {
		if (output && hex) print output, hex, conn
		output=$1
		hex=""
	}
	/ConnectorType:/ {conn=$2}
	/[:.]/ && h {
		sub(/.*000000fc00/, "", hex)
		hex = substr(hex, 0, 26) "0a"
		sub(/0a.*/, "", hex)
		h=0
	}
	h {sub(/[ \t]+/, ""); hex = hex $0}
	/EDID.*:/ {h=1}
	END {if (output && hex) print output, hex, conn}
	' | sort
)
