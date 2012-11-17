#!/bin/sh
#
# Beep the Imperial March theme from Star Wars
# Taken from a message board or something somewhere; I don't recall.
# No copyright infringement is intended.
#
# Requirements:
#
# sudo modprobe pcspkr        # enable pc speaker
# sudo apt-get install beep   # install beep
# alsamixer                   # adjust beep volume
#
beep -f 392 -l 450 -r 3 -D 150 -n -f 311.13 -l 400 -D 50 -n -f 466.16 -l 100 -D 50 -n -f 392 -l 500 -D 100 -n -f 311.13 -l 400 -D 50 -n -f 466.16 -l 100 -D 50 -n -f 392 -l 600 -D 600 -n -f 587.33 -l 450 -r 3 -D 150 -n -f 622.25 -l 400 -D 50 -n -f 466.16 -l 100 -D 50 -n -f 369.99 -l 500 -D 100 -n -f 311.13 -l 400 -D 50 -n -f 466.16 -l 100 -D 50 -n -f 392 -l 500 -D 100
