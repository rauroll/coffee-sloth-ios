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
    
    static var backgroundPlayer: AVAudioPlayer!
    static var coffeeSounds: [AVAudioPlayer]!
    static var deathSound: AVAudioPlayer!
    static var owlSound: AVAudioPlayer!
    
    
    static func setup() {
        
        AudioPlayer.backgroundPlayer = AVAudioPlayer()
        let backgroundMusicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("theme", ofType: "mp3")!)
        let coffeeSoundUrl1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coffee1", ofType: "mp3")!)
        let coffeeSoundUrl2 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coffee2", ofType: "mp3")!)
        let coffeeSoundUrl3 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coffee3", ofType: "mp3")!)
        
        let deathSoundUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "mp3")!)
        
        let owlSoundUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("owl", ofType: "mp3")!)
        
        do {
            try AudioPlayer.backgroundPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicUrl)
            try AudioPlayer.coffeeSounds = [
                                AVAudioPlayer(contentsOfURL: coffeeSoundUrl1),
                                AVAudioPlayer(contentsOfURL: coffeeSoundUrl2),
                                AVAudioPlayer(contentsOfURL: coffeeSoundUrl3)
                                ]
            try AudioPlayer.deathSound = AVAudioPlayer(contentsOfURL: deathSoundUrl)
            try AudioPlayer.owlSound = AVAudioPlayer(contentsOfURL: owlSoundUrl)
            
            AudioPlayer.loopBackgroundMusic()
            
        } catch {
            print("Failed to load the music to the player")
        }
        
        
        
        
    }
    
    static func loop(avPlayer: AVAudioPlayer) {
        avPlayer.numberOfLoops = -1
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    static func playOnce(avPlayer: AVAudioPlayer) {
        avPlayer.numberOfLoops = 0
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    static func pause(avPlayer: AVAudioPlayer) {
        avPlayer.pause()
    }
    
    static func stop(avPlayer: AVAudioPlayer) {
        avPlayer.stop()
    }
    
    static func playCoffeeSound() {
        let r = Int(arc4random_uniform(2))
        playOnce(AudioPlayer.coffeeSounds[r])
    }
    
    
    static func playDeathSound() {
        AudioPlayer.playOnce(AudioPlayer.deathSound)
    }
    
    static func playOwlSound() {
        AudioPlayer.playOnce(AudioPlayer.owlSound)
    }
    
    static func loopBackgroundMusic() {
        AudioPlayer.loop(AudioPlayer.backgroundPlayer)
    }
    
    
    
    
}