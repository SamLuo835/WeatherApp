//
//  MusicUtility.swift
//  WeatherApp
//
//  Created by Vikki Wong on 2019-04-14.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import AVFoundation

class MusicUtility: NSObject {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    func playBackgroundMusic() {
        let soundURL = Bundle.main.path(forResource: "background_music", ofType: "mp3")
        let url = URL(fileURLWithPath: soundURL!)
        
        //Assigns the actual music to the music player
        backgroundMusicPlayer = try! AVAudioPlayer.init(contentsOf: url)
        
        //A negative means it loops forever
        backgroundMusicPlayer?.currentTime = 0
        backgroundMusicPlayer?.volume = 3
        backgroundMusicPlayer?.numberOfLoops = -1
        backgroundMusicPlayer?.play()
    }

}
