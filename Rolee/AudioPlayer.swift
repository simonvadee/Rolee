//
//  AudioPlayer.swift
//  Rolee
//
//  Created by Ammar Polat on 29-10-16.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer{
    
    var audioPlayer = AVAudioPlayer()
    
    func loadAudioFileNamed(fileName : String, fileExtension : String) {
        do {
            if !fileName.isEmpty && !fileExtension.isEmpty {
                audioPlayer = try
                    AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileExtension)!))
                audioPlayer.prepareToPlay()
            }
        }
        catch {
            print(error)
        }
    }
    
    func playBackgroundMusic() {
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    func playSound() {
        audioPlayer.play()
    }
    
    func stopSoundAndMusic() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }
}
