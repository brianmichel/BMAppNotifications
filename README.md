BMAppNotifications
==================

The basic idea of this was to make something that could be as easy to use as NSNotificationCenter, but with some of the niceties of NSUserNotificationCenter on OS X. This is still a work in progress, but I've provided a sample project that will let you get the picture of what it does. 

I know people say you shouldn't use other UIWindow objects in your iOS app, but it just felt like this was the perfect candidate to do so. Please let me know if you see something I could be doing better. The rotation stuff feels kind of gross, but it works with minimal WTFness.

Requirements
------------

1. The QuartzCore framework needs to be linked (may be going away).

Demo
----

Here's a video demo of what it can do [Awesome Demo](http://f.cl.ly/items/2i1t2w3W2B1j1s1F2S0X/BMAppNotificationsMovie%20-%20Broadband.m4v)

Known Issues
-----------

Please check the [Issues](https://github.com/brianmichel/BMAppNotifications/issues) for the most up to date list of issues, feature enhancements, questions,etc.

1. The change style functionality only works reliably if you register a class **BEFORE** sending any notifications. The reason is there doesn't seem to be a way to clear the reuse queue of the table view so it's pulling out potentially the wrong class.

2. ~~There is a strange issue where you'll scroll the notifications off scren, then back on, and they will seem to be missing, but they are still there, and you can dismiss them. Very strange.~~

Contributing
-----------

You know the drill with this, fork, make a topic branch and then send me a pull request. I will do my best to keep everything merged in. Feel free to send me a message or a [tweet](http://www.twitter.com/brianmichel) if there's something I can help you with!

License
--------
<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">BMAppNotifications</span> by <span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Brian Michel</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.en_US">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/brianmichel/BMAppNotifications" rel="dct:source">https://github.com/brianmichel/BMAppNotifications</a>.