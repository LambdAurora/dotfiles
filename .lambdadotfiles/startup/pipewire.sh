#!/bin/zsh

# Definitions
PIPEWIRE_BIN=pipewire
PIPEWIRE_PULSEAUDIO_BIN=pipewire-pulse
PIPEWIRE_MEDIA_SESSION_BIN=pipewire-media-session

# Cleaning up
killall -q ${PIPEWIRE_BIN}
while pgrep -x ${PIPEWIRE_BIN} > /dev/null; do sleep 1; done

killall -q ${PIPEWIRE_PULSEAUDIO_BIN}
while pgrep -x ${PIPEWIRE_PULSEAUDIO_BIN} > /dev/null; do sleep 1; done

killall -q ${PIPEWIRE_MEDIA_SESSION_BIN}
while pgrep -x ${PIPEWIRE_MEDIA_SESSION_BIN} > /dev/null; do sleep 1; done

# Start-up
if ! command -v ${PIPEWIRE_BIN} &> /dev/null
then
	echo "${PIPEWIRE_BIN} could not be found."
	exit 1
fi

${PIPEWIRE_BIN} &

if ! command -v ${PIPEWIRE_PULSEAUDIO_BIN} &> /dev/null
then
	echo "${PIPEWIRE_PULSEAUDIO_BIN} could not be found, applications using PulseAudio won't be able to work."
else
	${PIPEWIRE_PULSEAUDIO_BIN} &
fi

if ! command -v ${PIPEWIRE_MEDIA_SESSION_BIN} &> /dev/null
then
	echo "${PIPEWIRE_MEDIA_SESSION_BIN} could not be found."
else
	${PIPEWIRE_MEDIA_SESSION_BIN} &
fi
