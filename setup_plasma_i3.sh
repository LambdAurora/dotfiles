#!/bin/sh

systemctl mask plasma-kwin_x11.target --user
systemctl enable plasma_i3 --user
