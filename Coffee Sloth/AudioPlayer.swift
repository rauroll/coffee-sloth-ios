//
//  Audio.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 12/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import AVFoundation

 class AudioPlayer {
    
    var backgroundPlayer: AVAudioPlayer!
    var coffeeSounds: [AVAudioPlayer]!
    var deathSound: AVAudioPlayer!
    
    
    init() {
        
        backgroundPlayer = AVAudioPlayer()
        let backgroundMusicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("theme", ofType: "mp3")!)
        let coffeeSoundUrl1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coffee1", ofType: "mp3")!)
        let coffeeSoundUrl2 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coffee2", ofType: "mp3")!)
        let coffeeSoundUrl3 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coffee3", ofType: "mp3")!)
        
        let deathSoundUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "mp3")!)
        
        do {
            try backgroundPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicUrl)
            try coffeeSounds = [
                                AVAudioPlayer(contentsOfURL: coffeeSoundUrl1),
                                AVAudioPlayer(contentsOfURL: coffeeSoundUrl2),
                                AVAudioPlayer(contentsOfURL: coffeeSoundUrl3)
                                ]
            try deathSound = AVAudioPlayer(contentsOfURL: deathSoundUrl)
            
            
            loop(backgroundPlayer)
            
        } catch {
            print("Failed to load the music to the player")
        }
        
        
        
        
    }
    
    func loop(avPlayer: AVAudioPlayer) {
        avPlayer.numberOfLoops = -1
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    func playOnce(avPlayer: AVAudioPlayer) {
        avPlayer.numberOfLoops = 0
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    func pause(avPlayer: AVAudioPlayer) {
        avPlayer.pause()
    }
    
    func stop(avPlayer: AVAudioPlayer) {
        avPlayer.stop()
    }
    
    func playCoffeeSound() {
        let r = Int(arc4random_uniform(2))
        playOnce(coffeeSounds[r])
    }
    
    
    
    
}