//
//  SoundManager.swift
//  MatchApp
//
//  Created by Adwithya Magow on 20/08/20.
//  Copyright © 2020 Adwithya Magow. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager{
    
    var audioPLayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(_ effect: SoundEffect){
        
        var soundFileName: String
        
        switch effect{
            
        case .flip:
            soundFileName = "cardFlip"
        case .match:
            soundFileName = "dingcorrect"
        case .nomatch:
            soundFileName = "dingwrong"
        case .shuffle:
            soundFileName = "shuffle"
        }
     
        //Get path to resource
        let path = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        //Check if it's not nil
        guard path != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: path!)
        
        do{
            audioPLayer = try AVAudioPlayer(contentsOf: url)
            audioPLayer?.play()
        }
        catch{
            print("Could not create an Audio Player")
            return
        }
        
    }
    
}
