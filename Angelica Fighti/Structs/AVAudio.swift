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
    
    enum SoundType:String {
        case Coin           = "getcoin.m4a"
        case Result_Coin    = "result_coin.m4a"
        case Puff           = "puff.m4a"
        case TicTack        = "tictack.m4a"
        case ChangeOption   = "changeOptions.m4a"
        case Boss_Alarm     = "boss_alarm.m4a"
        case Jade_Attack    = "vfx_jade_attack_4.m4a"
        case GameIntro      = "gameIntro.m4a"
        case Player_Death   = "player_death.m4a"
        case Clover         = "getClover.m4a"
        case Owl            = "owl.m4a"
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
        return SKAction.playSoundFileNamed(type.rawValue, waitForCompletion: true)
    }
    
    func load() -> Bool{
        
        return true
    }
    
    func stop(){
        bground_1_player.stop()
    }
}
