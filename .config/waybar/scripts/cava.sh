#!/bin/sh
# Waveform visualization using Unicode block elements
cava -p ~/.config/cava/config 2>/dev/null | sed -u 's/;//g;
 s/0/▁/g;
 s/1/▂/g;
 s/2/▃/g;
 s/3/▄/g;
 s/4/▅/g;
 s/5/▆/g;
 s/6/▇/g;
 s/7/█/g;
 s/8/█/g'
