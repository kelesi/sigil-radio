# sigil-radio
Turning an iPhone 2g with broken touch screen into a internet radio player (mp3 stream only). Possibly could work with iPhone 3/3s.

I revived an iPhone 2g with broken touch screen, to work as an internet radio player for the kitchen. When the iPhone is being charged, the script turns on wifi and starts playing the mp3 online stream. When charging is turned off, playing the stream is stopped and also wifi is turned off.

Unfortunately I have an IOS version where the working Erica Utilities had a version of play binary, which could not play online mp3 streams, only local mp3 files. So I am using a workaround, where I am downloading the mp3 stream with wget to a local file and then use the play app from Erica utilities to play the local mp3 file. Works perfect. 
One caveat though; wifi is turned off occasionally for no reason, even when I periodically try to get the en0 wifi interface up. Pressing the home button fixes this.

Working on iPhone 2G IOS version: 

Prerequisities:
 - Cydia
 - wget
 - Erica utilities (play binary)
 - bash
 
### Usage
functions.sh - helper functions

charging_wifiupdown.sh - handles the detection of charging and can start an optional script (play_radio.sh)

play_radio.sh - plays a online stream passed as a input parameter

chargin_radio - my custom example script, where the online mp3 stream is specified and runs the above scripts

com.sigil.radio.plist - example plist file to register the example script as application that start automatically

To register the plist:
launchctl load /private/var/root/com.sigil.radio.plist

To unregister the plist:
launchctl unload /private/var/root/com.sigil.radio.plist

Note: When you register the plist file, the script will be run automatically on iPhone start and the script will be automatically restarted by IOS when it's killed.

