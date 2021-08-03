#!/usr/bin/fish
set nombre (mpc -f "%artist% - %title%" | head -n 1)
set ubicacion /home/lugo/.lyrics/$nombre.txt
crow -t es -f $ubicacion | tee $nombre.templyc
