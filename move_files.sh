#!/bin/bash
FTPUSER="{FTPUSER}"
FTPPASS="{FTPPASS}"
FTPHOST="{FTPHOST}"
FTPDIR="{FTPDIR}"
FTPEXT="*.csv"
DESTDIR="/home/bthompso/git/ftp_move_files/reports"
LOGFILE="/var/log/ftp_move"
LOCKFILE="/tmp/ftp_move.lock"
CHECKDRDIR="/usr/local/bin/"

if [[ ! -f $LOGFILE ]]; then
    echo "Log file does not exist, or user does not have permissions --  exiting"
    exit 1
fi

/usr/local/bin/check_dr

if [[ $? == 0 ]]; then
    if [[ -f $LOCKFILE ]]; then
        PID=`cat $LOCKFILE`
        ps -p $PID
        if [[ $? == 0 ]]; then
            echo "Process is still running, exiting" >> $LOGFILE
            exit
        else
            echo $$ > $LOCKFILE
        fi
    else
        echo $$ > $LOCKFILE
    fi
    
            

    echo "+++++`date`+++++" >> $LOGFILE
    lftp sftp://$FTPUSER:$FTPPASS@$FTPHOST:$FTPDIR -e "lcd $DESTDIR; mget $FTPEXT" --Remove-source-files >> $LOGFILE
    for file in "$DESTDIR/*"; do
        newname=`echo $file | sed 's/\ /_/g'`
        if [ ! $newname == $file ]; then
            mv $file $newname
        fi
    done

    echo "------------------------" >> $LOGFILE
    rm -f $LOCKFILE
    exit 0
else
    echo "System is in DR State, if you are not in DR then update check_dr whitelist"
    echo "System is in DR State, update check_dr whitelist" >> $LOGFILE
#    rm -f $LOCKFILE
    exit 1
fi
