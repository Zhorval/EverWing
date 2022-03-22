//
//  AVAudio.swift
//  Angelica Fighti
//
///  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

struct AVAudio {
    
    enum SoundType{
        case Coin
        case Puff
        case TicTack
    }
    
    enum BgroundSoundType{
        case Background_Start
    }
    
    //private var audio
    private var bground_1_player:AVAudioPlayer
    
    init(){
        
        let bground_1_player_dir = Bundle.main.url(forResource: "audioblock", withExtension: "mp3")
        
        guard let bground_1 = try? AVAudioPlayer(contentsOf: bground_1_player_dir! as URL) else{
            fatalError("Failed to initialize the audio player bground_1")
        }
        
        bground_1.volume = 1.0
        
        bground_1.prepareToPlay()
        
        bground_1_player = bground_1
    }
    
    func play(type: BgroundSoundType){
        switch type{
        case .Background_Start:
            bground_1_player.numberOfLoops = -1
            bground_1_player.currentTime = 0
            bground_1_player.play()
            
        }
    }
    
    
    
    func getAction(type: SoundType) -> SKAction{
        switch type{
            case .Coin:
                
                let skCoinAction = SKAction.playSoundFileNamed("getcoin.m4a", waitForCompletion: true)
                return skCoinAction
            case .Puff:
                
                let skPuffAction = SKAction.playSoundFileNamed("puff.m4a", waitForCompletion: true)
                return skPuffAction
                
            case .TicTack:
                let skCoinAction = SKAction.playSoundFileNamed("tictack.m4a", waitForCompletion: true)
                return skCoinAction
        }
    }
    
    func load() -> Bool{
        
        return true
    }
    
    func stop(){
        bground_1_player.stop()
    }
}
