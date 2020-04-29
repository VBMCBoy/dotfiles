#!/bin/bash
SOURCE=$( pactl list short sources | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1 )
pactl set-source-mute $SOURCE toggle
