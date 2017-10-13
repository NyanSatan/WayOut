# Way Out
GUI for **kloader**/**multi_kloader** in the spirit of old classic iOS Setup assistant (Setup.app) for dualboots to iOS 6 and older (nothing will prevent booting newer iOS versions though)

# Notes
* Since Way Out now runs as ```mobile```, you shouldn't place your images to load at places where ```mobile``` can't read them (e.g. at ```/private/var/root```) 

* For the same reason you must also build **WayOutHelper** now, add it to the project and give it ```SetUID``` and ```SetGID``` permission bits

* Xcode usually re-sign embedded binaries, that means it will break kloader/multi_kloader's entitlements

# Credits
@winocm, @xerub, @JonathanSeals, @axi0mX - for kloader/multi_kloader