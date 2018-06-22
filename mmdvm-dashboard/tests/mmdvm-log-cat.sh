#!/bin/sh

MAX_LINES_TOREAD=10
LOG_FILE="/opt/mmdvm/logs/MMDVM-2018-04-30.log"
LOG_FILE_HIST=${LOG_FILE}.hist

parse_log_entry(){
  echo "TODO - parse $1"
}

do_read_log(){
    if [ ! -f $LOG_FILE ];then
        echo "$LOG_FILE not found"
        return 1
    fi

    local _linesTotal=$(wc -l < $LOG_FILE)
    _linesTotal=${_linesTotal//[[:space:]]/}

    local _lastRead=0
    if [ -f $LOG_FILE_HIST ];then
        local _l=$(cat $LOG_FILE_HIST)
        case $_l in
            ''|*[!0-9]*) _lastRead=0 ;;
            *) _lastRead=$_l ;;
        esac
    fi

    if [ $_lastRead -eq $_linesTotal ];then # nothing changed
        echo "nothing to read"
        return 0
    fi

    if [ $_lastRead -gt $_linesTotal ];then
        echo "last read line is invalid, reset to 0"
        _lastRead=0
    fi

    # read only max_lines
    local _linesToRead=$((_linesTotal - _lastRead))
    if [ $_linesToRead -gt $MAX_LINES_TOREAD ];then
        _linesToRead=$MAX_LINES_TOREAD
    fi

    local _lineStart=$((_linesTotal - _linesToRead + 1))
    echo "Reading lines $_lineStart  to $_linesTotal"
    #sed -ne "${_lineStart},${_linesTotal}p" <$LOG_FILE | while read line;do
    #    parse_log_entry $line
    #done
    sed -ne "${_lineStart},${_linesTotal}p" <$LOG_FILE
    echo $_linesTotal>$LOG_FILE_HIST # update the read timestamp
}

#do_read_log | ./mmdvm-log-parse.lua
do_read_log