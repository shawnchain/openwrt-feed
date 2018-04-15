#!/bin/sh

REBOOTCMD="/etc/init.d/mmdvmhost restart"
COUNT=0
LogFilePath="/var/log/"
#LogFilePath="./"
LogFileRoot="MMDVM"
tailPID=""
checklog(){
    #local LOGFILE="/var/log/MMDVM-$(date -u +%Y-%m-%d).log"
    #local LOGFILE="MMDVM-$(date -u +%Y-%m-%d).log"
    local LOGFILE=$1
    #echo "checking $LOGFILE"
    [ -f $LOGFILE ] || return 1
    #echo "parsing log file $LOGFILE"
    tail -n 0 -F $LOGFILE | while read line;do
        foo=$(echo $line | grep -e "Error returned from sendto, err: 13")
        if [ $? -eq 0 ];then
            # found the errors and increase the count
            COUNT=$(expr $COUNT + 1)
            echo $COUNT
            #echo "network error detected, count=$count"
            if [ $COUNT -eq 5 ];then
                echo "detected network error count=$COUNT, will reboot"
                eval $REBOOTCMD
                COUNT=0
            fi
        fi
    done & 2>/dev/null #run tail in background
    tailPID=$(($! - 1))
    echo "tail pid $tailPID"
    return 0
}

currentDate="foo"
while (true);do
    checkDate=$(date -u +%Y-%m-%d)
    if [ "$checkDate" != "$currentDate" ];then
        if ! [ -z $tailPID ];then
            echo "Killing tail pid=$tailPID"
            kill $tailPID 2>/dev/null
            tailPID=""
        fi
        logFile=$LogFilePath$LogFileRoot-$checkDate.log
        checklog $logFile
        if [ $? = 0 ];then
            echo "Open $logFile success"
            currentDate=$checkDate # checklog running success
        else
            echo "Open $logFile failed"
        fi
    fi
    /bin/sleep 5 # check every 5 seconds
done
