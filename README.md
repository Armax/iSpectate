# iSpectate
A simple swift League Of Legends spectator tool for Os X currently under development and a swift module implementing some of the basic API calls of riotgames
Download: [here](http://ispectate.arm4x.net)

###Developed by:
[@Arm4x](https://twitter.com/Arm4x)
Feel free to contact me for help or anything else

###lolSwift 
Method:<br>
getPlatformId(region: String) -> String<br>
getGameIpPort(region: String) -> String<br>
getLolGameClientVer() -> String<br>
getLolGameClientSlnVer() -> String<br>
getSummonerId(name: String, region: String) -> Int<br>
getGameIdForCurrentGame(id: Int, region: String) -> Int<br>
getEncryptionKeyForCurrentGame(id: Int, region: String) -> String<br>
Currently under development


###Watching game without starting and logging the lol client:
For doing this you must set an environment variable riot_launched=true

###Third part library:
SwiftJSON more information: [here](https://github.com/SwiftyJSON/SwiftyJSON)

###Remember:
iSpectate isn’t endorsed by Riot Games and doesn’t reflect the views or opinions of Riot Games or anyone officially involved in producing or managing League of Legends. League of Legends and Riot Games are trademarks or registered trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.

###License:
GNU GENERAL PUBLIC LICENSE 2.0<br>
More info in the LICENSE file