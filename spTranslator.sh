#!/usr/bin/fish
#set je (mpc -f "%file%" | head -n 1 | sed -r 's/.*\///' | sed -r 's/(\.mp3|\.flac)/.lrc/') ; find /home/lugo/DOWNLOADS/ -iname "*$je*"
set nombre (mpc -f "%artist% - %title%" | head -n 1)
set ubicacion /home/lugo/.lyrics/$nombre.txt
set tempPath letras/$nombre.templyc

function yaModificada -a ruta
    return (head -n 1 $ruta | grep -Pq '^\-\-\-$')
end

if test -e $ubicacion
    if ! yaModificada $ubicacion
        echo hola
        #crow -t es -f $ubicacion | tee $tempPath
        #crow -t es -f $ubicacion
        cat $ubicacion | crow -t es -i > $tempPath # -f $ubicacion
        set rutaNueva (env tempPath=$tempPath ./swaper.py)
        mv $ubicacion $ubicacion.bak
        cp letras/$rutaNueva $ubicacion
    else
        echo there is already swaped
    end
else
    echo file does no exists reading for lyrics
    if test -e letra
        yes | cp letra $ubicacion
    end
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
