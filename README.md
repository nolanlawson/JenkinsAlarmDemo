Jenkins Alarm Demo
==================

Demo of a simple script that checks if any Jenkins build is broken.  If it is, the script raises a physical flag, plays some beep music, and sends some text to be spoken aloud from an Android device.

Full explanation in this blog post: [Make your workplace more fun with a Jenkins alarm system][4]

Developers
-----------

* [Nolan Lawson][2]
* [Alexandre Masselot][3]

License
-----------

[WTFPL][1], although attribution would be nice.

Prerequesites
-------------

For the flag, you'll need a [Yoctopuce Yocto-Servo][5] setup.

For "beep" to work, you'll probably have to do the following (assuming a Debian/Ubuntu machine):

```
sudo modprobe pcspkr        # enable pc speaker
sudo apt-get install beep   # install beep
alsamixer                   # adjust beep volume
```

For the Android-powered text-to-speech, you'll need my [SimpleTalker app][6], the [Android SDK][7], and an Android device attached via USB.

Components
-------------

**jenkins_alarm.pl** is the main script that should be called in a crontab, probably every 5 minutes or so, e.g.

```
*/5 * * * * /my/path/to/jenkins_alarm.pl
```

**flagit** is an executable that sets the angle on the servo.  Takes two arguments: 1) the servo we're calling (numbered 1-5), and 2) the angle to set (between -1000 and 1000), e.g.

```
flagit 1 -1000
```

sets the 1st connected servo to the lowest position.

**play_imperial_march.sh** plays DUH DUH DUH, DUH da DUH, DUH da DUH.

**play_star_wars_theme.sh** plays DUUUH DUH dadada DUUUH DUH, dadada DUUUH DUH, dadada DUUUH.

[1]: http://sam.zoy.org/wtfpl/
[2]: http://nolanlawson.com
[3]: http://alexandre-masselot.blogspot.ch/
[4]: http://nolanlawson.com/2012/11/18/make-your-workplace-more-fun-with-a-jenkins-alarm-system
[5]: http://www.yoctopuce.com/EN/products/yocto-servo
[6]: https://github.com/nolanlawson/SimpleTalker
[7]: http://developer.android.com/sdk/index.html
