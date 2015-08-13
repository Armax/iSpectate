//
//  riotApi.swift
//  lolSpec
//
//  Created by Arm4x on 26/07/15.
//  Copyright (c) 2015 Arm4x. All rights reserved.
//

import Foundation

class riotApi
{
    // Wait time after every call to the API (Set 0 in case of no limit)
    private func rateLimit() {sleep(1)}
    
    var riot_key: String
    
    // Spectator Grids & Platform IDS
    // Region, PlatformId, Domain, Port
    var na = ["NA","NA1","spectator.na.lol.riotgames.com",80]
    var euw = ["EUW","EUW1","spectator.euw1.lol.riotgames.com",80]
    var eune = ["EUNE","EUN1","spectator.eu.lol.riotgames.com",8088]
    var kr = ["KR","KR","spectator.kr.lol.riotgames.com",80]
    var oce = ["OCE","OC1","spectator.oc1.lol.riotgames.com",80]
    var br = ["BR","BR1","spectator.br.lol.riotgames.com",80]
    var lan = ["LAN","LA1","spectator.la1.lol.riotgames.com",80]
    var las = ["LAS","LA2","spectator.la2.lol.riotgames.com",80]
    var ru = ["RU","RU","spectator.ru.lol.riotgames.com",80]
    var tr = ["TR","TR1","spectator.tr.lol.riotgames.com",80]
    
    func getPlatformId(region: String) -> String {
        var platformId:String! = "";
        if(region=="NA"){platformId = na[1] as String;}
        if(region=="EUW"){platformId = euw[1] as String;}
        if(region=="EUNE"){platformId = eune[1] as String;}
        if(region=="KR"){platformId = kr[1] as String;}
        if(region=="OCE"){platformId = oce[1] as String;}
        if(region=="BR"){platformId = br[1] as String;}
        if(region=="LAN"){platformId = lan[1] as String;}
        if(region=="LAS"){platformId = las[1] as String;}
        if(region=="RU"){platformId = ru[1] as String;}
        if(region=="TR"){platformId = tr[1] as String;}
        return platformId
    }
    
    func getGameIpPort(region: String) -> String {
        var gameIpPort:String! = "";
        if(region=="NA"){gameIpPort = "\(na[2]):\(na[3])";}
        if(region=="EUW"){gameIpPort = "\(euw[2]):\(euw[3])";}
        if(region=="EUNE"){gameIpPort = "\(eune[2]):\(eune[3])";}
        if(region=="KR"){gameIpPort = "\(kr[2]):\(kr[3])";}
        if(region=="OCE"){gameIpPort = "\(oce[2]):\(oce[3])";}
        if(region=="BR"){gameIpPort = "\(br[2]):\(br[3])";}
        if(region=="LAN"){gameIpPort = "\(lan[2]):\(lan[3])";}
        if(region=="LAS"){gameIpPort = "\(las[2]):\(las[3])";}
        if(region=="RU"){gameIpPort = "\(ru[2]):\(ru[3])";}
        if(region=="TR"){gameIpPort = "\(tr[2]):\(tr[3])";}
        return gameIpPort
    }
    
    init(_ riot_key: String)
    {
        self.riot_key = riot_key
    }
    
   
    func getLolGameClientVer() -> String {
        let filemgr = NSFileManager.defaultManager()
        let arrDirContent:[AnyObject]! = filemgr.contentsOfDirectoryAtPath("/Applications/League of Legends.app/Contents/LoL/RADS/solutions/lol_game_client_sln/releases/", error: nil)!
        return String(arrDirContent.last! as NSString)
    }
    
    func getLolGameClientSlnVer() -> String {
        let filemgr = NSFileManager.defaultManager()
        let arrDirContent:[AnyObject]! = filemgr.contentsOfDirectoryAtPath("/Applications/League of Legends.app/Contents/LoL/RADS/projects/lol_air_client/releases/", error: nil)!
        return String(arrDirContent.last! as NSString)
    }
    
    
    func getSummonerId(name: String, region: String) -> Int {
        // Escaped name trasforma il nome in formato url
        var escapedName:String! = name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        // Il trimmedname è semplicemente il nome tutto minuscolo e senza spazi
        var trimmedName:String! = name.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
        // Alcune scritte di log
        println("[i] Calling Riot API: summoner-v1.4")
        println("[Parameter] Summoner: \(name)")
        println("[Parameter] Region: \(region)")
        // Creo l'url a cui mandare la richiesta utilizzando la regione, il nome in formato url e la riot key con cui è stato creato l'oggetto
        let url = NSURL(string: "https://\(region.lowercaseString).api.pvp.net/api/lol/\(region)/v1.4/summoner/by-name/\(escapedName)?api_key=\(self.riot_key)")
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        //
        rateLimit()
        if data != nil {
            var json = JSON(data: data!)
            let id:Int = json[trimmedName]["id"].intValue
            println("[Response] ID: \(id)")
            return id
        }
        return 0
    }
    
    func getGameIdForCurrentGame(id: Int, region: String) -> Int {
        println("[i] Calling Riot API: current-game-v1.0")
        println("[Parameter] ID: \(id)")
        println("[Parameter] Region: \(region)")
        
        let platformId:String! = getPlatformId(region)
        
        let url:NSURL! = NSURL(string: "https://\(region.lowercaseString).api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/\(platformId)/\(id)?api_key=\(self.riot_key)");
        
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        rateLimit()
        if data != nil {
            var json = JSON(data: data!)
            let gameId:Int = json["gameId"].intValue
            println("[Response] Game Id: \(gameId)")
            return gameId
        }
        
        return 0
    }

    
    func getEncryptionKeyForCurrentGame(id: Int, region: String) -> String {
        println("[i] Calling Riot API: current-game-v1.0")
        println("[Parameter] ID: \(id)")
        println("[Parameter] Region: \(region)")
        
        var platformId:String! = "";
        if(region=="NA"){platformId = na[1] as String;}
        if(region=="EUW"){platformId = euw[1] as String;}
        if(region=="EUNE"){platformId = eune[1] as String;}
        if(region=="KR"){platformId = kr[1] as String;}
        if(region=="OCE"){platformId = oce[1] as String;}
        if(region=="BR"){platformId = br[1] as String;}
        if(region=="LAN"){platformId = lan[1] as String;}
        if(region=="LAS"){platformId = las[1] as String;}
        if(region=="RU"){platformId = ru[1] as String;}
        if(region=="TR"){platformId = tr[1] as String;}
        
        let url:NSURL! = NSURL(string: "https://\(region.lowercaseString).api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/\(platformId)/\(id)?api_key=\(self.riot_key)");
        
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        rateLimit()
        if data != nil {
            var json = JSON(data: data!)
            let encryptionKey:String = json["observers"]["encryptionKey"].stringValue
            println("[Response] Encryption Key: \(encryptionKey)")
            return encryptionKey
        }

        return ""
    }

}