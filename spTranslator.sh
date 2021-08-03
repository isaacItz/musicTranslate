#!/usr/bin/fish
#set je (mpc -f "%file%" | head -n 1 | sed -r 's/.*\///' | sed -r 's/(\.mp3|\.flac)/.lrc/') ; find /home/lugo/DOWNLOADS/ -iname "*$je*"
set nombre (mpc -f "%artist% - %title%" | head -n 1)
set ubicacion /home/lugo/.lyrics/$nombre.txt

if test -e $ubicacion
    crow -t es -f $ubicacion | tee letras/$nombre.templyc
else
    echo file does no exists
end

function estaEnEspañol
   set idiomas (mpc -f "%albumartist% %album% %title%" | head -n 1 | crow -t es -i | grep -P '\[.*\]')
   echo $idiomas
   if test $idiomas = '[ Spanish -> Spanish ]'
       return 0
   else
       return 1
   end
end
