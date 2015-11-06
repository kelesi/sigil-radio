#!/bin/bash
# Script enables wifi when phone is charging.
#   Optionally it can run a script when charging and killing it when on battery.
#
# History
#   20150524 - Not disabling wifi - issues with enabling again
#   20151106 - Move kill to general functions script

BASEDIR=`dirname $0`
#source helper functions
. $BASEDIR/functions.sh

function cleanup
{
    if [[ -n "$pid_script" ]]; then
        myecho "Cleaning up"
        kill_pid -15 $pid_script 15 20
    fi
    exit
}
trap cleanup EXIT SIGHUP SIGKILL SIGSTOP SIGINT SIGTERM

loopsleep=20
pid_script=""

#Check if we are running already
self="$0"
if ((`ps -e | grep "$self" | grep -v grep | wc -l` > 2)); then
    myecho "Script already running ($0)"
    exit
fi

#Do we need to execute a script?
script=""
[[ -f "$1" ]] && script=$1
shift

cd $BASEDIR

#If charing turn on wifi otherwise turn off
charging_prev=0
while :; do
    charging=`powerlog -B | grep "charging = yes" | wc -l`
    charged=`powerlog -B | grep "fully_charged=yes" | wc -l`

    [ $charging -gt 1 ] && charging=1
    [ $charged -gt 0 ] && charging=1

    if [ $charging -eq 1 ]; then
        #Try to periodicaly start wifi to avoid sleep
        ifconfig en0 up
    fi

    if ((charging != charging_prev)); then
        case $charging in
        0)
            #kill_script
            [[ -n "$pid_script" ]] && kill_pid -15 $pid_script 15 20
            #myecho "Disabling wifi"
            #ifconfig en0 down
            ;;

        1)
            myecho "Enabling wifi"
            ifconfig en0 up
            sleep 5
            myecho "Wifi enabled"
            if [ -n "$script" ]; then
                $script $@ &
                pid_script=$!
                myecho "Running script $script [$pid_script]"
            fi
            ;;
        esac
    fi

    charging_prev=$charging
    sleep $loopsleep
done
