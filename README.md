# WayOut
GUI for kloader/multi_kloader in the spirit of old classic iOS Setup assistant (Setup.app) for dualboots to iOS 6 and older (nothing will prevent booting older or newer iOS versions though)

# Dependencies
`cd .../WayOut-master`

`mkdir Dependencies`

`cd Dependencies`

`git clone https://github.com/NyanSatan/iOS6Switch.git`

`git clone https://github.com/NyanSatan/iOS6AlertView.git`

# Notes

Please note that in order to make this program actually load ARM images you must convinience it to run as root user (http://blog.ib-soft.net/2013/01/ios-run-application-with-root-privileges.html)

Xcode usually re-sign embedded binaries, that means it will break kloader/multi_kloader's entitlements

# Credits
@winocm, @xerub, @JonathanSeals - for kloader/multi_kloader