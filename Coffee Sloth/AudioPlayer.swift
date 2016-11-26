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
        let backgroundMusicUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "background-music", ofType: "mp3")!)
        let coffeeSoundUrl1 = URL(fileURLWithPath: Bundle.main.path(forResource: "coffee1", ofType: "mp3")!)
        let coffeeSoundUrl2 = URL(fileURLWithPath: Bundle.main.path(forResource: "coffee2", ofType: "mp3")!)
        let coffeeSoundUrl3 = URL(fileURLWithPath: Bundle.main.path(forResource: "coffee3", ofType: "mp3")!)
        
        let deathSoundUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: "mp3")!)
        
        let owlSoundUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "owl", ofType: "mp3")!)
        
        do {
            try AudioPlayer.backgroundPlayer = AVAudioPlayer(contentsOf: backgroundMusicUrl)
            try AudioPlayer.coffeeSounds = [
                                AVAudioPlayer(contentsOf: coffeeSoundUrl1),
                                AVAudioPlayer(contentsOf: coffeeSoundUrl2),
                                AVAudioPlayer(contentsOf: coffeeSoundUrl3)
                                ]
            try AudioPlayer.deathSound = AVAudioPlayer(contentsOf: deathSoundUrl)
            try AudioPlayer.owlSound = AVAudioPlayer(contentsOf: owlSoundUrl)
            
            AudioPlayer.loopBackgroundMusic()
            
        } catch {
            print("Failed to load the music to the player")
        }
        
        
        
        
    }
    
    static func loop(_ avPlayer: AVAudioPlayer) {
        avPlayer.numberOfLoops = -1
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    static func playOnce(_ avPlayer: AVAudioPlayer) {
        avPlayer.numberOfLoops = 0
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    static func pause(_ avPlayer: AVAudioPlayer) {
        avPlayer.pause()
    }
    
    static func stop(_ avPlayer: AVAudioPlayer) {
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
