//
//  Sounds.swift
//  
//
//  Created by  on 4/8/19.
//  Copyright © 2019 . All rights reserved.
//

import SpriteKit
import AVFoundation

private let SoundInstance = Sounds()

open class Sounds {
    
    open class func sharedInstance() -> Sounds { return SoundInstance}
    
    //MARK: - Sounds
    open var sceneForPlayingSounds: SKScene?
    
    /**
     It's interface for playing sounds.
     */
    open func playSound(soundName: String) {
        if UserDefaults.standard.bool(forKey: SoundConfig.playSounds) {
            sceneForPlayingSounds?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: false))
        }
        else { print("Sound class: Class not have output object for playing sound")}        
    }
    
    /**
     Change settings of sounds. Possible to play or not
     */
    open func changeSoundState() {
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: SoundConfig.playSounds), forKey: SoundConfig.playSounds)
    }
    
    //MARK: - Music
    fileprivate var musicPlayer: AVAudioPlayer?
    
    /**
     Create music and play it if it's possible by settings.
     
     Better for use in launch game part of app.
     */
    open func playMusic(musicName: String) {
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: musicName, withExtension: nil)!)
            musicPlayer!.numberOfLoops = -1
            musicPlayer!.prepareToPlay()
            if UserDefaults.standard.bool(forKey: SoundConfig.playMusic) {
                musicPlayer!.play()
            }
        } catch { print("Sound class: Not can create AVAudioPlayer for music")}
    }
    
    func pauseMusic() {
        if musicPlayer!.isPlaying { musicPlayer!.pause()}
    }
    
    func resumeMusic() {
        if !musicPlayer!.isPlaying { musicPlayer!.play()}
    }
    
    func stopMusic() {
        if !musicPlayer!.isPlaying { musicPlayer!.stop()}
    }
    
    /**
     Change playing setting for music.
     
     If you change settings it's function make pause or contine to play music.
     */
    open func changeMusicState() {
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: SoundConfig.playMusic), forKey: SoundConfig.playMusic)
    
        if UserDefaults.standard.bool(forKey: SoundConfig.playMusic) { resumeMusic()}
        else { pauseMusic()}
        
    }
    
    open func changeSoundAndMusicState() {
        changeSoundState()
        changeMusicState()
    }
}


