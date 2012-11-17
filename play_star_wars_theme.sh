#!/bin/sh
#
# Beep the main theme from Star Wars
# Taken from a message board or something somewhere; I don't recall.
# No copyright infringement is intended.
#
# Requirements:
#
# sudo modprobe pcspkr        # enable pc speaker
# sudo apt-get install beep   # install beep
# alsamixer                   # adjust beep volume
#
beep -f 523.25 -l 800 -n -f 783.99 -l 800 -n -f 698.455 -l 200 -n -f 659.255 -l 200 -n -f 587.33 -l 200 -n -f 1046.5 -l 800 -n -f 783.99 -l 800 -n -f 698.455 -l 200 -n -f 659.255 -l 200 -n -f 587.33 -l 200 -n -f 1046.5 -l 800 -n -f 783.99 -l 800 -n -f 698.455 -l 200 -n -f 659.255 -l 200 -n -f 698.455 -l 200 -n -f 587.33 -l 800
