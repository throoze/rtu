#!/bin/sh
#
#
# MD5FILE-parameter specifies where we want to save our md5print for
# later use.


# The FILE_TO_CHECK-parameter specifies the file we want to monitor
# changes
PROJECT_DIR=/home/victor/projects/rtu
FILE_TO_CHECK=udt_types.sql
MD5FILE=/tmp/$FILE_TO_CHECK.md5savefile
LDC_USER=05-38087
COMMAND="scp $FILE_TO_CHECK $LDC_USER@serena.ldc.usb.ve:~/projects/rtu/"
VERBOSE=false

echo "Monitor running with variables: "
echo "1. File to monitor: $FILE_TO_CHECK"
echo "2. Command after noticing changes: <$COMMAND>"
echo "3. Verbose: $VERBOSE"

while true 
do

    if [ ! -f $FILE_TO_CHECK ]
    then
        echo "ERROR Couldnt locate file to check:$FILE_TO_CHECK"
        exit
    fi

    if $VERBOSE
    then
        echo "Taking a print on $FILE_TO_CHECK with md5sum"
    fi
    MD5PRINT=`md5sum $FILE_TO_CHECK | cut -d " " -f1`

    if [ -z $MD5PRINT ]
    then
        echo "ERROR Recived an empty MD5PRINT thats not valid, aborting"
        exit
    else
        if $VERBOSE
        then
            echo "MD5PRINT we got was:$MD5PRINT"
        fi
    fi

    if [ -f $MD5FILE ]
    then
        if $VERBOSE
        then
            echo "Found an old savefile:$MD5FILE we trying to match prints"
        fi
        OLDMD5PRINT=`cat $MD5FILE`

        if [ -z $OLDMD5PRINT ]
        then
            echo "WARNING Got an empty string from the oldfile, creating new one"
            echo $MD5PRINT > $MD5FILE     
            exit
        fi
        if [ "$OLDMD5PRINT" = "$MD5PRINT" ]
        then
            if $VERBOSE
            then
                echo "New and old md5print are identical, the file hasnt been changed"
            fi
        else
            if $VERBOSE
            then
                echo "WARNING the old and new md5print doesnt match, the file has been changed"
            fi
            echo "Cambio detectado." 
            # espeak "New version detected, starting upload"  2> /dev/null
            espeak "Brace yourself!"  2> /dev/null
            date +%l:%M        
            $COMMAND 2> /dev/null
            if [ $? = 0 ]
            then
                echo "File updated OK"
                # espeak "File updated at the LDC" 2> /dev/null
                espeak "Winter is coming..." 2> /dev/null
            else
                espeak "There was a problem with the upload"
                exit
            fi
            if $VERBOSE
            then
                echo "Saving to new md5print in logfile:$MD5FILE for later checks"
            fi
            echo $MD5PRINT > $MD5FILE 
            
            if $VERBOSE
            then
                if [ $? = 0 ]
                then
                    echo "Wrote to file OK"
                else
                    echo "Writing to file failed...why??"
                    exit
                fi
            fi
        fi
        
    else
        if $VERBOSE
        then
            echo "md5 file not found, creating one"
        fi
        touch $MD5FILE
        echo $MD5PRINT > $MD5FILE 
    fi
    sleep 1
done