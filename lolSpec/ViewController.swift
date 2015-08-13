//
//  ViewController.swift
//  lolSpec
//
//  Created by Arm4x on 26/07/15.
//  Copyright (c) 2015 Arm4x. All rights reserved.
//

import Cocoa

// Riot API key

private let riot_key:String = "your-key";




// Initialize Riot API
let riotapi = riotApi(riot_key)

// Directory of league of legends
var lol_game_client_ver = riotapi.getLolGameClientVer()
var lol_game_client_sln_ver = riotapi.getLolGameClientSlnVer()


class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if al ready loaded.
        }
    }
    
    @IBOutlet var nickname: NSTextField!
    @IBOutlet var region: NSComboBox!
    @IBOutlet var status: NSTextField!
    
    
   
    func spectate(arguments: [AnyObject]) {
        let task = NSTask()
        // impostiamo come cartella attuale quella in cui è presente l'eseguibile
        task.currentDirectoryPath = "/Applications/League of Legends.app/Contents/LoL/RADS/solutions/lol_game_client_sln/releases/\(lol_game_client_ver)/deploy/LeagueOfLegends.app/Contents/MacOS"
        // impostiamo il programma da eseguire
        task.launchPath = "/Applications/League of Legends.app/Contents/LoL/RADS/solutions/lol_game_client_sln/releases/\(lol_game_client_ver)/deploy/LeagueofLegends.app/Contents/MacOS/LeagueofLegends"
        // impostiamo gli argomenti che vengono passati al momento dell'esecuzione
        task.arguments = arguments
        // maggiori info sull'environment più avanti nel tutorial
        var info = NSProcessInfo.processInfo().environment
        info.updateValue(true, forKey: "riot_launched")
        task.environment = info
        let pipe = NSPipe()
        task.standardOutput = pipe
        // eseguiamo la task
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        print(output)
    }
    
    @IBAction func spectateStart(sender: AnyObject) {
        
        if(nickname.stringValue=="") {return;}
        if(region.stringValue=="") {return;}

        // Recuperiamo il summoner id utilizzando i metodi di lolSwift
        let id:Int! = riotapi.getSummonerId(nickname.stringValue, region: region.stringValue)
        // In caso non viene trovato il summoner restituisce un errore
        if(id==0){println("[Error] Summoner not found");status.stringValue="Error: Summoner not found";return;}
        
        // Asking for encryption key

        let encryption_key:String! = riotapi.getEncryptionKeyForCurrentGame(id, region: region.stringValue);
        if(encryption_key==""){println("[Error] Summoner isn't in game");status.stringValue="Error: Summoner isn't in game";return;} // Summoner not in game
        
        // Asking for game ID

        let game_id:Int! = riotapi.getGameIdForCurrentGame(id, region: region.stringValue)
        
        // Starting spectate task
        
        status.stringValue = "Starting..."
        spectate(["8394","LoLLauncher", "/Applications/League\\ of\\ Legends.app/Contents/LoL/RADS/projects/lol_air_client/releases/\(lol_game_client_sln_ver)/deploy/bin/LolClient"," spectator \(riotapi.getGameIpPort(region.stringValue)) \(encryption_key) \(game_id) \(riotapi.getPlatformId(region.stringValue))"])
    }

    
  


}