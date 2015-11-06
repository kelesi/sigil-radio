#!/bin/bash
dir=`dirname $0`
fn=`basename $0`
date >> $dir/fn.log
url=http://live.slovakradio.sk:8000/FM_128.mp3
#url=http://icecast5.play.cz/crowave-128.mp3 
$dir/charging_wifiupdown.sh $dir/play_radio.sh "$url" >> $dir/$fn.log 2>&1
