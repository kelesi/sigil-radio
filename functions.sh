#!/bin/bash

function myecho
{
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] "$*
}

function kill_pid
{
    sig=""
    if [[ $1 =~ ^-[0-9]{1,2}$ ]]; then
        sig=$1
        shift
    fi
    pid=$1
    slp=$2
    loops=$3

    if [[ -z "$pid" || ! "$pid" =~ ^[0-9]*$ ]]; then
        echo "No pid specified $1"
        echo "Usage: kill_pid <-n> [pid] <sleep_time> <max_loops>"
        echo "  Will kill a proces specified by [pid]"
        echo "  <-n> - signal to use for kill (like -9, optional)"
        echo "  <sleep_time> - seconds to sleep during a loop (optional, default 3s)"
        echo "  <max_loops> - how many times to retry the kill (optional, default 20)"
        echo "  Example: kill_pid -9 3432 3 20"
        return 2
    fi
    [[ -z "$slp" ]] && slp=3
    [[ -z "$loops" ]] && loops=20

    i=0
    printf "Killing process [$pid]."
    while ((`ps -e | awk -v p="$pid" '{ if ($1==p) print 1; }' | wc -l` > 0)); do
	printf "."
        kill $sig $pid
        sleep $slp
        ((i=i+1))
        if ((i>$loops)); then
            echo "could not kill"
            return 1
        fi
    done
    echo "down"
    return 0
}
