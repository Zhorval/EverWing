//
//  Structs.swift
//  EverWing
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.


import Foundation
import SpriteKit
import AVFoundation

struct AVAudio {
    
    enum SoundType:String {
        case Coin             = "getcoin.m4a"
        case Gem              = "gem_collect.m4a"
        case Result_Coin      = "result_coin.m4a"
        case Puff             = "puff.m4a"
        case TicTack          = "tictack.m4a"
        case ChangeOption     = "changeOptions.m4a"
        case Boss_Alarm       = "boss_alarm.m4a"
        case Jade_Attack      = "vfx_jade_attack_4.m4a"
        case GameIntro        = "gameIntro.m4a"
        case Player_Death     = "player_death.m4a"
        case Clover           = "getClover.m4a"
        case Owl              = "owl.m4a"
        case Mildred_Attack   = "boss_tree_attack.m4a"
        case Meteor_Warn      = "meteor_warn.m4a"
        case Meteor_Flames    = "meteor_flames.m4a"
        case Boss_King_Burp   = "boss_king_burp.m4a"
        case Snow_Roar        = "snow_roar.m4a"
        case Ice_Appear       = "ice_walls_appear.m4a"
        case Ice_Cracking     = "ice-cracking.m4a"
        case Magnet           = "item_collect_magnet.m4a"
        case BallToIce        = "icicle_fall_1.m4a"
        case Halcon           = "halcon.m4a"
        case Egg_Hatch_End_Common = "egg_hatch_end_common.m4a"
        case Egg_Hatch_Start      = "egg_hatch_start.m4a"
        case Buy_DragonFruit      = "buy_dragonfruit.m4a"
    }
    
    
    enum BgroundSoundType{
        case Background_Start
        case CharacterMenuScene
        case DragonsMenu
        case DragonBuy
    }
    
    //private var audio
    private var bground_1_player:AVAudioPlayer?
    
    init(){
        
        let bground_1_player_dir = Bundle.main.url(forResource: "audioblock", withExtension: "mp3")
        
        bground_1_player = try? AVAudioPlayer(contentsOf: bground_1_player_dir! as URL)
        
        bground_1_player?.volume = 1.0
       
    }
    
    func play(type: BgroundSoundType){
        switch type{
            case .Background_Start:
                bground_1_player?.numberOfLoops = 1
                bground_1_player?.currentTime = 0
                bground_1_player?.play()
        case .CharacterMenuScene,.DragonsMenu,.DragonBuy:
                stop()
        }
    }
    
    func getAction(type: SoundType) -> SKAction{
        .sequence([.changeVolume(by: 1, duration: 0.5),.playSoundFileNamed(type.rawValue, waitForCompletion: true)])
    }
    
    func load() -> Bool{
        
        return true
    }
    
    func pause(){
        bground_1_player?.pause()
    }
    
    func stop(){
        bground_1_player?.stop()
    }
}
