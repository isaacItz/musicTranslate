#!/usr/bin/fish
#set je (mpc -f "%file%" | head -n 1 | sed -r 's/.*\///' | sed -r 's/(\.mp3|\.flac)/.lrc/') ; find /home/lugo/DOWNLOADS/ -iname "*$je*"
#mpc -f "%artist% - %title%" | head -n 1 | sed 's/\///'
function __init
    set -g NOMBRE (mpc -f "%artist% - %title%" | head -n 1 | sed 's/\///g')
    set -g UBICACION /home/lugo/.lyrics/$NOMBRE.txt
    set -g tempPath /home/lugo/.letras/$NOMBRE.templyc
    if test -e /home/lugo/.letras
        return 0
    else
        mkdir /home/lugo/.letras
        test -e letras
        if test $status = 0
            return 0
        else
            return 1
        end
    end
end

function __yaModificada
    return (head -n 1 $UBICACION | grep -Pq '^\-\-\-$')
end

function __findLyrics
    set CANCIONACTUAL /home/lugo/DOWNLOADS/(mpc -f "%file%" | head -n 1 |  sed -r 's/\.\w{3,4}/.lrc/')
    if test -e $CANCIONACTUAL
        cp $UBICACION $UBICACION.bak
        yes | cp $CANCIONACTUAL $UBICACION
        return 0
    else
        return 1
    end
end

function __swap
    if test -e $UBICACION
        if ! __estaEnEspañol
            if ! __yaModificada
                #crow -t es -f $UBICACION | tee $tempPath
                #crow -t es -f $UBICACION
                cat $UBICACION | crow -t es -i > $tempPath # -f $UBICACION
                set RUTANUEVA (env tempPath=$tempPath /home/lugo/.letras/swaper.py)
                mv $UBICACION $UBICACION.bak
                rm $tempPath
                mv /home/lugo/.letras/$RUTANUEVA $UBICACION
                return 0
            else
                echo there is already swaped
                return 1
            end
        else
            echo "it's already in humilde"
            return 1
        end
    else
        echo txt does no exists
        return 1
    end
end

function __readLocalLyrics
    if test -e letra
        yes | cp letra $UBICACION
    end
end

function lyrics
    if __init
        switch $argv
        case '--find'
            if __findLyrics
                __swap
            else
                echo "there is no lrc file in song's directory"
            end
        case --create
            touch $UBICACION
            if test $status = 0
                echo file created
            end
            vim $UBICACION
        case --edit
            vim $UBICACION
        case --restore
            if test -e $UBICACION.bak
                mv $UBICACION.bak $UBICACION
                echo restored!
            else
                echo .bak file does not exists
            end
        case --watch-backup
            less $UBICACION.bak
        case '*'
            __swap
        end
    else
        echo 'can not make directory "letras"'
    end
end

function __estaEnEspañol
   set IDIOMAS (mpc -f "%albumartist% %album% %title%" | head -n 1 | crow -t es -i | grep -P '\[.*\]')
   echo $IDIOMAS
   if test $IDIOMAS = '[ Spanish -> Spanish ]'
       return 0
   else
       return 1
   end
end

funcsave __init
funcsave __yaModificada
funcsave __findLyrics
funcsave __swap
funcsave __readLocalLyrics
funcsave lyrics
funcsave __estaEnEspañol
yes | cp swaper.py /home/lugo/.letras/swaper.py

#lyrics $argv
