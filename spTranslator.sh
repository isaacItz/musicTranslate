#!/usr/bin/fish
#set je (mpc -f "%file%" | head -n 1 | sed -r 's/.*\///' | sed -r 's/(\.mp3|\.flac)/.lrc/') ; find /home/lugo/DOWNLOADS/ -iname "*$je*"
#mpc -f "%artist% - %title%" | head -n 1 | sed 's/\///'
function __init
    set -g NOMBRE (mpc -f "%artist% - %title%" | head -n 1 | sed 's/[/:*?]//g')
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
        if test -e $UBICACION
            mv $UBICACION $UBICACION.bak
        end
        cp $CANCIONACTUAL $UBICACION
        return 0
    else
        return 1
    end
end

function __swap -a BACKUP
    if test -e $UBICACION
        if ! __estaEnEspañol
            if ! __yaModificada
                #crow -t es -f $UBICACION | tee $tempPath
                #crow -t es -f $UBICACION
                cat $UBICACION | crow -t es -i > $tempPath # -f $UBICACION
                set RUTANUEVA (env tempPath=$tempPath /home/lugo/.letras/swaper.py)
                if test $BACKUP -eq 0
                    mv $UBICACION $UBICACION.bak
                end
                rm $tempPath
                mv /home/lugo/.letras/$RUTANUEVA $UBICACION
                ln -s -f $RUTANUEVA /home/lugo/.lyrics/index.html
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
        case find
            if __findLyrics
                __swap 1
            else
                echo "there is no lrc file in song's directory"
            end
        case create
            touch $UBICACION
            if test $status = 0
                echo file created
                vim $UBICACION
            else
                echo can not create txt file
                return $status
            end
        case edit
            vim $UBICACION
        case restore
            if test -e $UBICACION.bak
                mv $UBICACION.bak $UBICACION
                echo restored!
            else
                echo .bak file does not exists
            end
        case watch-backup
            less $UBICACION.bak
        case ''
            __swap 0
        case help
            __help_lyrics
        case diff
            __diff
        case remove
            __remove_all
        case '*'
            echo -e lyrics has no command \"$argv\".\n
            echo -e "to see al lyrics's commands, run:\n  lyrics help"
        end
    else
        echo 'can not make directory "letras"'
    end
end

function __help_lyrics
    #find, restore, create, edit, watch-backup, help
    echo "Usage: lyrics [COMMAND]"
    echo -e "\vRead and translate lyrics\n"
    echo "Main commands:"
    echo -e "  find\t\tfinds the lrc file in the song's directory and puts it in the .lyrics directory"
    echo -e "  restore\treplace original txt for the generated by this function"
    echo -e "  create\tcreate a new txt file for put your own lyrics"
    echo -e "  edit\t\tedit the current txt file"
    echo -e "  watch-backup\tless the backup file (the file generated when lyrics without arguments is used)"
    echo -e "  diff\t\tsee differences between bakup and acutal lyrics"
    echo -e "  remove\tremove backup(original lyrics) and the actual lyrics displayed"
    echo -e "  help\t\tdisplays this message"
end

function __estaEnEspañol
   set IDIOMAS (mpc -f "%albumartist% %album% %title%" | head -n 1 | crow -t es -i | grep -P '\[\ \w*\ \->\ \w*\ \]')
   if test $IDIOMAS = '[ Spanish -> Spanish ]'
       return 0
   else
       return 1
   end
end

function __diff
    if test -e $UBICACION -a -e $UBICACION.bak
        vimdiff $UBICACION $UBICACION.bak
    end
end

function __remove_all
    if test -e $UBICACION
        rm $UBICACION
    end
    if test -e $UBICACION.bak
        rm $UBICACION.bak
    end
end

set add __init __remove_all __yaModificada __findLyrics __swap __readLocalLyrics __estaEnEspañol __help_lyrics __diff lyrics
for i in $add
    funcsave $i
end
yes | cp swaper.py /home/lugo/.letras/swaper.py

#comando diff compara entre la letra acutal y el backup. util cuando remplazas una letra con la original(la de la song de deezer)
