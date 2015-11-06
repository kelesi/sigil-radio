#!/bin/bash
dir=`dirname $0`
fn=`basename $0`
logf=$dir/$fn.log
echo "---" >> $logfile
date >> $logfile

url=http://live.slovakradio.sk:8000/FM_128.mp3
#url=http://icecast5.play.cz/crowave-128.mp3 

$dir/charging_wifiupdown.sh $dir/play_radio.sh "$url" >> $logf 2>&1 &

#Monitor lofgile size
while :; do
    if ((`cat $logf | wc -l` > 1000)); then
        echo Logfile cleanup
        tmpf=`mktemp`
        tail -100 $logf > $tmpf
        cat $tmpf > $logf
        rm $tmpf
    fi
    sleep 3600
done
