#!/bin/bash
# History
#   20131101 - Not disabling wifi - issues with enabling again
#   20151106 - Move kill to general functions script

BASEDIR=`dirname $0`
#source helper functions
. $BASEDIR/functions.sh

function show_help
{
    echo "Usage `basename $0` <url of mp3 stream>"
}

function cleanup
{
    if [[ -n "$pid_wget""$pid_play" ]]; then
        myecho "Cleaning up"
        kill_radio
    fi
    exit
}
trap cleanup EXIT SIGHUP SIGKILL SIGSTOP SIGTERM SIGINT

function kill_radio
{
    ret=0
    myecho "function: kill_radio"
    myecho "Killing play"
    if [[ -n "$pid_play" ]]; then
        kill_pid -9 $pid_play 3 20
        (($?==1)) && ((ret=ret+1))
    fi
    myecho "Killing wget"
    if [[ -n "$pid_play" ]]; then
        kill_pid -9 $pid_wget 3 20
        (($?==1)) && ((ret=ret+1))
    fi

    i=0
    while ((`ls -1 | grep $wgetfile | wc -l` > 0)); do
        myecho "Deleting $wgetfile"
        rm -f "$wgetfile"
        sleep 3
        ((i=i+1))
        if ((i>20)); then
            ((ret=ret+1))
            myecho "Failed to delete wgetfile [$wgetfile]"
            break
        fi
    done
    return $ret
}

function check_wget_up
{
    if ((`ps -e | awk -v p=$pid_wget '{ if ($1==p) print 1; }' | wc -l` > 0)); then
    is_wget_up=1
    else
        is_wget_up=0
    fi
}

function check_play_up
{
    if ((`ps -e | awk -v p=$pid_play '{ if ($1==p) print 1; }' | wc -l` > 0)); then
    is_play_up=1
    else
        is_play_up=0
    fi
}

function run_wget
{
    wget "$stream" -O "$wgetfile" 2> /dev/null  &
    pid_wget=$!
    myecho "Started wget [$pid_wget]"
}

function run_play
{
    play $wgetfile 2> /dev/null  &
    pid_play=$!
    myecho "Started play [$pid_play]"
}


#SCRIPT BODY
#===========
basedir=$(readlink -f `dirname $0`)
wgetfile=radio.mp3
limit=102400 #how much free space can be left
loopsleep=20
pid_wget=""
pid_play=""
stream="$1"
if [ -z "$1" ]; then
    show_help
    exit 3
fi

cd `dirname $0`
myecho $wgetfile
rm -f $wgetfile 2> /dev/null

while :; do
    run_wget
    check_play_up
    while ((is_play_up < 1)); do
        sleep 5
        run_play
        check_play_up
    done

    while ((`ls -1 | grep $wgetfile | wc -l` > 0)); do
        size=`du -ks0 $wgetfile 2>/dev/null | cut -f1`
        [ -z "$size" ] && size=0
    #    echo "$wgetfile size is $size kB"
        check_wget_up
        check_play_up
        if ((is_play_up<1)); then
            myecho "play is not running. Trying to restart.."
            break
        fi
        if ((is_wget_up<1)); then
            myecho "wget is not running. Trying to restart.."
            break
        fi
        if ((`df $basedir | tail -1 | awk '{ print $4 }'` < limit)); then
            myecho "Running out of space on "$basedir". Restarting.."
            break
        else
            sleep $loopsleep
        fi
    done
    kill_radio
    #(($?>0)) && reboot
done
