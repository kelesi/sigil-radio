# sigil-radio
Turning an iPhone 2g with broken touch screen into a internet radio player. Possibly could work with iPhone 3/3s.

I revived an iPhone 2g with broken touch screen, to work as an internet radio player for the kitchen. When the iPhone is being charged, the script turns on wifi and starts playing the mp3 online stream. When charging is turned off, playing the stream is stopped and also wifi is turned off.

Unfortunately I have an IOS version where the working Erica Utilities had a version of play binary, which could not play online mp3 streams, only local mp3 files. So I am using a workaround, where I am downloading the mp3 stream with wget to a local file and then use the play app from Erica utilities to play the local mp3 file. Works perfect. 
One caveat though; wifi is turned off occasionally for no reason, even when I periodically try to get the en0 wifi interface up. Pressing the home button fixes this.

Working on iPhone 2G IOS version: 

Prerequisities:
 - Cydia
 - wget
 - Erica utilities (play binary)
 - bash
 
