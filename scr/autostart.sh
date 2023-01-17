#! /bin/bash

# This script launch the selected application (front-end or MAME emulator) and respawn it if quit unexpectedly.

if [ !  -z  $FRONTEND ] ;  then 
  while 
    case  ${FRONTEND,,}  in 
      attract)   # Attract Mode 
        if [ " $AUTOROM "  !=  " " ] && [ $( wc -w <<<  " $AUTOROM " )  == 2 ] ;  then 
          read -r EMULNAME ROMNAME <<<  $AUTOROM 
          CFGFILE= $( find /home/pi/.attract/emulators -type f -iname $EMULNAME .cfg| head -n 1 )
           if [ -f  $CFGFILE ] ;  then 
            while  read var value ;  do 
              [ !  -z  $var ] && [ " ${var : 0 : 1} "  !=  " # " ] &&  export  " $var " = " $value "
             done  <  $CFGFILE 
            ARGS= ${args // \[ name \]/ $ROMNAME } 
            ARGS= ${ARGS // \$ HOME / $HOME } 
            EXEC= ${executable // \$ HOME / $HOME } 
            FRAMEFILE= $( sed ' s/^.*\s-framefile\s\ (\S*\)\s.*$/\1/ '  <<<  $ARGS )
           fi 
          if [ !  -z  $FRAMEFILE ] && [ -f  $FRAMEFILE ] && [ !  -z  $EXEC ] && [-x  $EXEC ] ;  then 	# Automatic ROM Launch mode 
            $EXEC  $ARGS -nolog > /dev/null 2> /dev/null
           else
            stty-echo
            /usr/local/bin/attract --loglevel silent > /dev/null 2>&1 
          fi 
        else
          stty-echo
          /usr/local/bin/attract --loglevel silent > /dev/null 2>&1 
        fi
        ;;advance 
      )   #AdvanceMENU
        /home/pi/frontend/advance/advmenu
        ;;
      mame)      # MAME GUI or Automatic ROM Launch mode if AUTOROM is set 
        /home/pi/mame/mame $( [ !  -z  $AUTOROM ] && [ -f /home/pi/.mame/roms/ $AUTOROM .zip ] &&  echo  $AUTOROM )  > /dev/null 2> /dev/null
        ;;
    esac 
    ((  $?  !=  0  ))
   do 
    : 
  done 
else 
    echo  $0 - FRONTEND variable is not defined ! 
    read -n 1 -s -r -p ' Press any key to continue... '
     echo 
fi