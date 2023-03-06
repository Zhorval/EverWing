//
//  Enemy.swift
//  Angelica Fighti
//
//  Created by P.Cebrian on 03/09/22
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit
import CryptoKit
import SwiftUI

protocol BaseProtocolHP {
    
    associatedtype T:ProtocolBossType
    
    associatedtype B:BossTypeProtocol
    
    var delegate:GameInfoDelegate?  { get set}
    var actionsDead:[SKTexture]     { get}
    var velocity:CGVector           { get set}
    var enemyType:T                 { get set}
    var enemyModel:Enemy?           { get set}
    var currency:Currency?          { get set}
    var bossType:B                  { get set}
    var BossBaseHP:CGFloat          { get set}
    var RegularBaseHP:CGFloat       { get set}

}

protocol ProcotolHP:BaseProtocolHP {
   
    
    mutating func decreaseHP(ofTarget: SKNode, hitBy: SKNode,scene:SKScene?)
    func update(sknode: SKSpriteNode, hpBar: SKNode)
    mutating func explode(sknode: Enemy?,scene:SKScene?)
    mutating func spawn(scene :SKScene?,typeBoss:BossType?,baseHP:CGFloat?,isAttack:Bool?)
    mutating func increaseDifficulty()
    mutating func addVelocity(velocity:CGFloat)
    mutating func reduceVelocity(velocity:CGFloat)
    mutating func rewardCoin(skNode:SKNode,scene:SKScene)
    func showShadowBoss(typeBoss:BossType)->SKSpriteNode
}

extension ProcotolHP {
    
    //MARK: ADD VELOCITY ENEMY
    mutating func addVelocity(velocity:CGFloat) {
        self.velocity.dy -= velocity
    }
    // MARK: REDUCE VELOCITY ENEMY
    mutating func reduceVelocity(velocity:CGFloat) {
        self.velocity.dy += velocity
    }
    
    // MARK: DECREASE ADDHEALTH ENEMY
    mutating func decreaseHP(ofTarget: SKNode, hitBy: SKNode,scene:SKScene?){
       
       
       guard let rootBar = ofTarget.childNode(withName: "rootBar") as? SKSpriteNode,
             let enemyHpBar = rootBar.childNode(withName: "hpBar")
             else {return}
       
       guard let ofTarget = ofTarget as? Enemy else{
           return
       }
    
       ofTarget.hp = ofTarget.hp - hitBy.power
       
       if (hitBy.name == "bullet"){
          
           let percentage = ofTarget.hp > 0.0 ? ofTarget.hp/ofTarget.maxHp : 0.0
           let originalBarSize = rootBar.size.width
               enemyHpBar.run(SKAction.resize(toWidth: originalBarSize * percentage, duration: 0.03))
               update(sknode: ofTarget, hpBar: enemyHpBar)
           
           if (ofTarget.hp <= 0){
               ofTarget.physicsBody?.category = [.None]
               enemyHpBar.removeFromParent()
               
               explode(sknode: ofTarget,scene: scene)
               
               return
           }
           else{
               if enemyHpBar.isHidden {
                   enemyHpBar.isHidden = false
               }
           }
       }
       
   }
   
    // MARK: UPDATE BAR ADDHEALTH ENEMY
    func update(sknode: SKSpriteNode, hpBar: SKNode){
       guard let sknode = sknode as? Enemy else{
           return
       }
       
       let percentage = sknode.hp/sknode.maxHp
       if (percentage < 0.3){
               hpBar.run(SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.1))
           }
       else if (percentage < 0.55){
               hpBar.run(SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 0.1))
           }
   }
    
    // MARK: EXPLODE ENEMY REGULAR
    mutating func explode(sknode: Enemy?,scene:SKScene?) {
        
        guard let sknode = sknode,
              let delegate = delegate,
              let scene = delegate.getScene() else {  return }
   
        rewardCoin(skNode: sknode,scene: scene) //scene!)
        
        switch enemyType.self as? EnemyType{
        case .Boss:
            
         /*  if bossType == .Pinky{
               let minion = sknode.parent! as! Pinky
               minion.multiply()
               
               let mainBoss = enemyModel as! Pinky
               print("calling is defeated....")
               if mainBoss.isDefeated(){
                   self.delegate?.changeGameState(.WaitingState)
               }
           }
           else {*/
            
               
            if let mainBoss = enemyModel {
                
                   mainBoss.defeated()
                   sknode.run(.sequence([
                       (delegate.mainAudio.getAction(type: .Puff)),
                       .run { [self] in
                         
                           for x in scene.children where ((x.name?.contains("FX")) == true){
                               x.run(.sequence([
                                .fadeOut(withDuration: 1),
                                .removeFromParent()
                               ]))
                           }
                           // CREATE CLOOUDS
                           DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                               self.delegate?.createCloud(completion: { _ in
                                   DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                       self.delegate?.changeGameState(.WaitingState)
                                   }
                               })
                           }
                       }
                   ]))
                let velocity = velocity.dy - 10
                enemyModel?.addVelocity(velocity: velocity)
            }
              
        //   }
        
        case  .Regular,.Armored,.Buitre,.Cofre :
            guard let mainReg = enemyModel as? RegularEnemy else { sknode.removeFromParent(); return }
            
            mainReg.defeated(sknode: sknode)
            
            sknode.run((delegate.mainAudio.getAction(type: .Puff)))
     /*
    
        case .Armored:
            guard let mainReg = enemyModel else {  sknode.removeFromParent(); return}
            mainReg.defeated()
            sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
            
        case .Buitre:
            
            guard let mainReg = enemyModel else {  sknode.removeFromParent(); return}
            mainReg.defeated()
            sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
            
        case .Cofre:
            guard let mainReg = enemyModel else {

                sknode.removeFromParent()
                return
            }
            */
            if let emiter = SKEmitterNode(fileNamed: "trail") {
                mainReg.addChild(emiter)
                sknode.run(.sequence([
                    .run {
                        
                        sknode.run((delegate.mainAudio.getAction(type: .Puff)))
                        SKAction.wait(forDuration: 5)
                        mainReg.defeated()
                        sknode.removeFromParent()
                        emiter.removeFromParent()
                    }
                ]))
            }
       default:
           sknode.removeFromParent()
       }
        

   }
    
    // MARK: GET YOU COIN WHEN DESTROY ENEMY
    mutating func rewardCoin(skNode:SKNode,scene:SKScene) {
       
        let posX = skNode.position.x
        let posY = skNode.position.y
        
        let rewardCount:Int = enemyType.self as! EnemyType == EnemyType.Regular ? 1 : randomInt(min: 1, max: 1)
 
        /// ELIMINAR DEPURACION
        self.currency?.type =  .Coin
        for i in 0..<rewardCount{
            
            if i == rewardCount-1  {//}&& enemyType as! EnemyType != EnemyType.Regular{
            
                self.currency?.type = Currency.CurrencyType.allCases.randomElement()!
            }
            
            let reward = self.currency?.createCoin(posX: posX ,posY: posY, width: 50, height: 50, createPhysicalBody: true, animation: false)
                
            let impulse = CGVector(dx: random(min: -25, max: 25), dy: random(min:10, max:35))
            
            reward?.run(SKAction.sequence([.applyForce(impulse , duration: 0.2), .wait(forDuration: 1), .removeFromParent()]))
            
            if let r = reward{
                delegate?.addChild(r)
                
            }
            else{
                
                print("ERROR ON CLASS ENEMY. Check Method REWARDCOIN. ")
            //    fatalError()
            }
        }
        skNode.removeAllActions()

    }
    
    // MARK: SHOW SPAWN OF THE ENEMY REGULAR
    /*
     PARAMS: @scene:    Scene game
             @typeBoss: Choose a enemy for scene
             @basHP:    HP  life for enemy
             @isAttack: It's mode Attack for player
     */
    mutating func spawn(scene :SKScene?,typeBoss:BossType?,baseHP:CGFloat?,isAttack:Bool? = nil){
        
        guard let scene = scene,
              let delegate = delegate else { return }

        
        switch enemyType.self as! EnemyType {
            case .Regular:
              
            enemyModel = RegularEnemy(baseHp: 1500, speed: isAttack != nil ? CGVector(dx: 0, dy: -500) : velocity  ,type: .Regular)
                
            case .Boss:
                
                scene.childNode(withName: "Enemy_Boss")?.removeFromParent()
                let chance = randomInt(min: 0, max: 100)
            
                if chance > 10{
                    guard let typeBoss = typeBoss else { return }

                    enemyModel = Bomber(hp: 10000,typeBoss: typeBoss,scene:scene,gameInfo: delegate)
                }
                else{
                    bossType = BossType.Pinky as! Self.B
                    enemyModel = Pinky(hp: baseHP ?? BossBaseHP, lives: 4, isClone: true)
                    
                }
            case .Fireball:
                let fireball = delegate.getCurrentToonNode()
                enemyModel = Fireball(target: fireball, speed: velocity)
            
            case .Buitre:
                    scene.run((delegate.mainAudio.getAction(type: .Halcon)))

                    enemyModel = BuitreEnemy(hp: 1000, gameInfo: delegate)
           
            case .Armored:
                if scene.childNode(withName: "Enemy_Armored") != nil || delegate.getGameState == .BossEncounter {
                         return
                    } else {
                        
                        enemyModel = ArmoredEnemy(hp: 1000,gameInfo:delegate)
                        
                        enemyModel?.name = "Enemy_Armored"
                    }
            
            case .Cofre:
           
                    enemyModel = CofreEnemy(hp: RegularBaseHP,speed: velocity)
           
            default:  break
        }
            
        guard let enemyModel = enemyModel else { return }
        
        delegate.addChild(enemyModel)
      //  scene.addChild(enemyModel)
        
       
        scene.physicsWorld.speed = 1
    }
    
    // MARK: INCREMENT DIFICULT WHEN PASS LEVEL
    mutating func increaseDifficulty(){
        
        switch enemyType.self as! EnemyType{
            case .Regular:
                RegularBaseHP += 5
                velocity.dy -= 5
            case .Boss:
                BossBaseHP += 10
            case .Fireball:
                velocity.dy -= 5
            case .Cofre:
                velocity.dy -= 5
            default:
            print("No increase for \(enemyType.self as! EnemyType)")
       }
   }
    
    // MARK: SHOW SHADOW BOSS WHEN ENCOUNTER
    func showShadowBoss(typeBoss:BossType)->SKSpriteNode {
        
        let node = SKSpriteNode(texture: SKTexture(cgImage: typeBoss.shadow))
        node.name =  "Boss_Shadow"
        node.size = CGSize(width: screenSize.width/2, height: screenSize.width/2)
        node.position = CGPoint(x: screenSize.midX, y: screenSize.height*0.7)
        node.alpha = 0.8
        
        return node
    }
    
}

protocol BossTypeProtocol {
    
     associatedtype T:BossTypeProtocol
     func getType()->T
    
}

protocol ProtocolEnemyType {}

protocol ProtocolBossType {}


protocol ProtocolContrainstBoss {
    
    var headContraint:[SKConstraint]?      { get }
    var mouthContraint:[SKConstraint]?     { get }
    var bgMouthContraing:[SKConstraint]?   { get }
    var helmetContraint: [SKConstraint]?   { get }
    var diademContraint:[SKConstraint]?    { get }
    var padLContraint:[SKConstraint]?      { get }
    var padRContraint:[SKConstraint]?      { get }
    var padArmContraint: [SKConstraint]?   { get }
    var armLContraint:[SKConstraint]?      { get }
    var forearmLContraint:[SKConstraint]?  { get }
    var armRContraint:[SKConstraint]?      { get }
    var handContraint:[SKConstraint]?      { get }
    var irisEyeContraint:[SKConstraint]?   { get }
    var hornLContraint:[SKConstraint]?     { get }
    var hornRContraint:[SKConstraint]?     { get }
    var miniHornRContraint:[SKConstraint]? { get }
    var miniHornLContraint:[SKConstraint]? { get }
    var eyeRContraint:[SKConstraint]?      { get }
    var eyeLContraint:[SKConstraint]?      { get }
    var eyelidLContraint:[SKConstraint]?   { get }
    var legRContraint:[SKConstraint]?      { get }
    var legLContraint:[SKConstraint]?      { get }
    var footLContraint:[SKConstraint]?     { get }
    var footRContraint:[SKConstraint]?     { get }
    var wingRContraint:[SKConstraint]?     { get }
    var wingLContraint:[SKConstraint]?     { get }
    var skirtContraint:[SKConstraint]?     { get }

}


protocol ProtocolPartBoss {
    
    var pathTextures:String  { get }
   
    var bossPicture:CGImage      { get }
    var shadow:CGImage           { get }
    var head:[SKSpriteNode]?     { get }
    var hornL:SKSpriteNode?      { get }
    var hornR:SKSpriteNode?      { get }
    var miniHorn:SKSpriteNode?   { get }
    var helmet:SKSpriteNode?     { get }
    var diadem:SKSpriteNode?     { get }
    var nose:SKSpriteNode?       { get }
    var mouth:[SKTexture]?       { get }
    var mouthExtraEffect:SKSpriteNode? { get }
    var eye:[SKTexture]?         { get }
    var iris: SKSpriteNode?      { get }
    var eyelid:SKSpriteNode?     { get }
    var eyelashes:SKSpriteNode?  { get }
    var ear:SKSpriteNode?        { get }
    var body:SKSpriteNode?       { get }
    var tail:SKSpriteNode?       { get }
    var wing:SKSpriteNode?       { get }
    var wingShort:SKNode?        { get }
    var forearm:SKSpriteNode?    { get }
    var pad:SKSpriteNode?        { get }
    var padArm:SKSpriteNode?     { get }
    var arm:SKSpriteNode?        { get }
    var miniArm:SKSpriteNode?    { get }
    var handL:[SKSpriteNode]?    { get }
    var handR: [SKSpriteNode]?   { get }
    var leaf:SKSpriteNode?       { get }
    var miniHand:CGImage?        { get }
    var legL:SKSpriteNode?       { get }
    var legR:SKSpriteNode?       { get }
    var footL:[SKTexture]?       { get }
    var footR:[SKTexture]?       { get }
    var extraLegL:SKSpriteNode?  { get }
    var extraLegR:SKSpriteNode?  { get }
    var skirt:SKNode?            { get }
    var ballProjectile: SKSpriteNode?    { get }
    var ballHand:SKSpriteNode?           { get }
    var bigProjectile: [SKTexture]?      { get }
    var effectfxProjectile: [SKSpriteNode]? { get }
}

enum BossType:String,CaseIterable,BossTypeProtocol{
  
  
    func getType() -> Self {
        return self
    }
    
    
    /// Audio when appear Boss in the screen
    var audioFX:SKAction {
        switch self {
        case .Pinky:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:2)
        case .Ice_Queen:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:2)
        case .Mildred:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:2)
        case .Monster_King:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:2)
        case .Monster_Queen:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:2)
        case .Spike:
            return AVAudio().getAction(type: .Ice_Cracking)
          //  SKAction.repeat(SKAction.playSoundFileNamed("ice-cracking.m4a", waitForCompletion: false), count:1)
        }
    }
   
    case Pinky          = "Pinky"
    case Ice_Queen      = "Ice Queen"
    case Mildred        = "Mildred"
    case Monster_King   = "Monster King"
    case Monster_Queen  = "Monster Queen"
    case Spike          = "Spike"
    
    var weakness:SKTexture {
        switch self {
        case .Pinky:
            return SKTexture(imageNamed: "Nature_Weakness")
        case .Ice_Queen:
            return SKTexture(imageNamed: "Water_Weakness")
        case .Mildred:
            return SKTexture(imageNamed: "Fire_Weakness")
        case .Monster_King:
            return SKTexture(imageNamed: "Shadow_Weakness")
        case .Monster_Queen:
            return SKTexture(imageNamed: "Light_Weakness")
        case .Spike:
            return SKTexture(imageNamed: "Prismatic_Weakness")
        }
    }
}



extension BossType:ProtocolContrainstBoss {
    
    var headContraint: [SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Mildred: return nil
            case .Spike:                        return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 30))]
            case .Monster_Queen,.Ice_Queen:     return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: CGFloat(head![0].frame.height)*0.6))]
        }
    }
    
    var noseContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Mildred,.Spike,.Monster_Queen,.Ice_Queen: return nil
            case .Monster_King:    return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 2))]
        }
        
    }
    
    var bgMouthContraing:[SKConstraint]? {
        switch self {
            case .Pinky,.Spike,.Mildred:    return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 15))]
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -18))]
        }
    }
    
    var mouthContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Spike:             return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 15))]
            case .Mildred:                  return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(lowerLimit: -15, upperLimit: 15))]
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -10))]
        }
    }
    
    var helmetContraint: [SKConstraint]? {
        switch self {
            case .Pinky,.Mildred,.Spike:    return nil
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 50))]
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 60))]
        }
    }
    
    var diademContraint: [SKConstraint]? {
        switch self {
            case .Pinky,.Mildred,.Spike:    return nil
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -helmet!.frame.height*0.5))]
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -helmet!.frame.height*0.5))]
        }
    }
    
    var padLContraint: [SKConstraint]? {
        switch self {
            case .Pinky,.Mildred,.Monster_Queen,.Ice_Queen: return nil
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: -57), y: SKRange(constantValue: 25))]
            case .Spike:        return [SKConstraint.positionX(SKRange(constantValue: -60), y: SKRange(constantValue: 10))]
        }
    }
    var padArmContraint: [SKConstraint]? {
        switch self {
        case .Pinky,.Mildred,.Spike,.Monster_King: return nil
            case .Monster_Queen,.Ice_Queen:        return [SKConstraint.positionX(SKRange(constantValue: -15), y: SKRange(constantValue: -10))]
      
        }
    }
    
    var padRContraint: [SKConstraint]? {
        switch self {
            case .Pinky,.Mildred,.Monster_Queen,.Ice_Queen: return nil
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: 57), y: SKRange(constantValue: 25))]
            case .Spike:        return [SKConstraint.positionX(SKRange(constantValue: 60), y: SKRange(constantValue: 10))]
        }
    }
    
    var armLContraint:[SKConstraint]? {
        switch self {
            case .Pinky:                    return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: -22), y: SKRange(constantValue: 25))]
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: -50), y: SKRange(constantValue: -45))]
            case .Mildred:                  return [SKConstraint.positionX(SKRange(constantValue: -50), y: SKRange(constantValue: -30))]
            case .Spike:                    return [SKConstraint.positionX(SKRange(constantValue: -65), y: SKRange(constantValue: 10))]
        }
    }
    
    var armRContraint:[SKConstraint]? {
        switch self {
            case .Pinky: return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 22), y: SKRange(constantValue: 25))]
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: 50), y: SKRange(constantValue: -45))]
            case .Mildred:                  return [SKConstraint.positionX(SKRange(constantValue: 50), y: SKRange(constantValue: -30))]
            case .Spike:                    return [SKConstraint.positionX(SKRange(constantValue: 65), y: SKRange(constantValue: 10))]
        }
    }
    
    var forearmLContraint:[SKConstraint]? {
        switch self {
        case .Pinky,.Spike,.Mildred:    return nil
        case .Monster_Queen,.Ice_Queen: return [ SKConstraint.positionX(SKRange(constantValue: -30),y: SKRange(constantValue: -30))]
        case .Monster_King:             return [ SKConstraint.positionX(SKRange(constantValue: -5), y: SKRange(constantValue: -10))]
        }
    }
    
    var handContraint:[SKConstraint]? {
        switch self {
            case .Pinky:                    return nil
            case .Spike:                    return [ SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -60))]
            case .Monster_Queen,.Ice_Queen: return [ SKConstraint.positionX(SKRange(constantValue: -35), y: SKRange(constantValue: -50))]
            case .Monster_King:             return [ SKConstraint.distance(SKRange(constantValue: 0), to: .zero, in: forearm!),
                                                     SKConstraint.zRotation(SKRange(constantValue: .pi)),
                                                     SKConstraint.positionX(SKRange(constantValue: -20), y: SKRange(constantValue: -10))]
            case .Mildred:                  return [ SKConstraint.positionX(SKRange(constantValue: 8), y: SKRange(constantValue: -75))]
        }
    }
    
    var irisEyeContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Monster_Queen,.Ice_Queen,.Spike: return nil
            case .Mildred:  return [SKConstraint.positionX(SKRange(lowerLimit: -10, upperLimit: 10), y: SKRange(constantValue: -2))]
        }
    }
    
    
    
    var hornLContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Monster_Queen,.Ice_Queen,.Spike: return nil
            case .Mildred:
                return [SKConstraint.positionX(SKRange(constantValue: -45), y: SKRange(constantValue:  body!.size.height/2 + 15))]
        }
    }
    
    var hornRContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Monster_Queen,.Ice_Queen,.Spike: return nil
            case .Mildred:
                return [SKConstraint.positionX(SKRange(constantValue: 45), y: SKRange(constantValue: body!.size.height/2 + 15))]
        }
    }
    
    var miniHornRContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Monster_Queen,.Ice_Queen,.Spike: return nil
            case .Mildred:  return [SKConstraint.positionX(SKRange(constantValue: -43), y: SKRange(constantValue: 50))]
        }
    }
    
    var miniHornLContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Monster_Queen,.Ice_Queen,.Spike: return nil
            case .Mildred:  return [SKConstraint.positionX(SKRange(constantValue: 43), y: SKRange(constantValue: 50))]
        }
    }
    
    var eyeRContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Spike: return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 15), y: SKRange(constantValue: 30))]
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: 25), y: SKRange(constantValue: 0))]
            case .Mildred:      return [SKConstraint.positionX(SKRange(constantValue: 20), y: SKRange(constantValue: 15))]
        }
    }
    
    var eyeLContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Spike: return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: -15), y: SKRange(constantValue: 30))]
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: -25), y: SKRange(constantValue: 0))]
            case .Mildred:      return [SKConstraint.positionX(SKRange(constantValue: -20), y: SKRange(constantValue: 15))]
        }
    }
    
    var eyelidLContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Spike,.Mildred : return nil
            case .Ice_Queen,.Monster_Queen: return [
                SKConstraint.positionX(SKRange(constantValue: -15), y: SKRange(constantValue: 35)),
                SKConstraint.zRotation(SKRange(constantValue: CGFloat(0).toRadians()))]
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 15))]
        }
    }
    
    var eyelidRContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Spike,.Mildred,.Monster_King : return nil
            case .Ice_Queen,.Monster_Queen: return [
                SKConstraint.positionX(SKRange(constantValue: 15), y: SKRange(constantValue: 35)),
                SKConstraint.zRotation(SKRange(constantValue: CGFloat(0).toRadians()))]
        }
    }
    
    var skirtContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Mildred: return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -55))]
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: CGFloat(-body!.frame.height)*0.62))]
            case .Spike:        return [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -48))]
        }
    }
    
    var legRContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_Queen,.Ice_Queen: return nil
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: 20), y: SKRange(constantValue: -60))]
            case .Mildred:      return [SKConstraint.positionX(SKRange(constantValue: 13), y: SKRange(constantValue: -83))]
            case .Spike:        return [SKConstraint.positionX(SKRange(constantValue: 22), y: SKRange(constantValue: -67))]
        }
    }
    
    var legLContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_Queen,.Ice_Queen: return nil
            case .Monster_King: return [SKConstraint.positionX(SKRange(constantValue: -20), y: SKRange(constantValue: -60))]
            case .Mildred:      return [SKConstraint.positionX(SKRange(constantValue: -13), y: SKRange(constantValue: -85))]
            case .Spike:        return [SKConstraint.positionX(SKRange(constantValue: -22), y: SKRange(constantValue: -70))]
        }
    }
    
    var footLContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Monster_Queen,.Ice_Queen,.Mildred: return nil
            case .Spike:   return [SKConstraint.positionX(SKRange(constantValue: -22), y: SKRange(constantValue: -90))]
        }
    }
    
    var footRContraint:[SKConstraint]? {
        switch self {
            case .Pinky,.Monster_King,.Monster_Queen,.Ice_Queen,.Mildred: return nil
            case .Spike:   return [SKConstraint.positionX(SKRange(constantValue: 22), y: SKRange(constantValue: -90))]
        }
    }
    
    
    var wingRContraint:[SKConstraint]? {
        switch self {
            case .Pinky: return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: 80), y: SKRange(constantValue: 60))]
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: 60), y: SKRange(constantValue: 0))]
            case .Mildred:                  return [SKConstraint.positionX(SKRange(constantValue: 70), y: SKRange(constantValue: 20))]
            case .Spike:                    return [SKConstraint.positionX(SKRange(constantValue: 30), y: SKRange(constantValue: 50))]
        }
    }
    
    var wingLContraint:[SKConstraint]? {
        switch self {
            case .Pinky: return nil
            case .Monster_Queen,.Ice_Queen: return [SKConstraint.positionX(SKRange(constantValue: -80), y: SKRange(constantValue: 60))]
            case .Monster_King:             return [SKConstraint.positionX(SKRange(constantValue: -60), y: SKRange(constantValue: 0))]
            case .Mildred:                  return [SKConstraint.positionX(SKRange(constantValue: -70), y: SKRange(constantValue: 20))]
            case .Spike:                    return [SKConstraint.positionX(SKRange(constantValue: -30), y: SKRange(constantValue: 50))]
        }
    }
    
   
    
}
extension BossType:ProtocolPartBoss {
  
    
    var pathTextures: String {
        self.rawValue
    }
    
    var shadow: CGImage {
        switch self {
            case .Pinky:         return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 449, y: 2, width: 102, height: 106))
            case .Ice_Queen:     return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 134, y: 2, width: 120, height: 97))
            case .Mildred:       return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 248, width: 109, height: 117))
            case .Monster_King:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 48, y: 2, width: 123, height: 106))
            case .Monster_Queen: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 134, y: 2, width: 120, height: 97))
            case .Spike:         return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 83, y: 0,  width: 124, height: 105))
        }
    }
    
    var bossPicture: CGImage {
        switch self {
            case .Pinky:         return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 289, y: 306, width: 110, height: 117))
            case .Ice_Queen:     return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 153, width: 113, height: 91))
            case .Mildred:       return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 113, y: 248, width: 107, height: 115))
            case .Monster_King:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 1, y: 154, width: 114, height: 95))
            case .Monster_Queen: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 154, width: 111, height: 89))
            case .Spike:         return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 207, y: 0, width: 119, height: 101))
        }
    }
    
    var head: [SKSpriteNode]? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:    return nil
        case .Mildred:         return nil
        case .Ice_Queen:
            return  [SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 124, y: 337, width: 50, height: 56))))]
        case .Monster_Queen:
            return  [SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 188, y: 343, width: 50, height: 56))))]
        case .Spike:
            return  [SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 362, width: 52, height: 49)))),
                     SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 334, y: 238, width: 50, height: 45)))),
                     SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 333, y: 286, width: 51, height: 49))))]
        }
    }
    
   
    var hornL: SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                let horn =  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 277, y: 235, width: 56, height: 61))))
            
                    let leafUp = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 121, y: 405, width: 22, height: 11))))
                        leafUp.constraints = [SKConstraint.positionX(SKRange(constantValue: -22), y: SKRange(constantValue: 15))]
                        horn.addChild(leafUp)
            
                    let leafDown = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 146, y: 404, width: 16, height: 10))))
                        leafDown.zRotation = -CGFloat(135).toRadians()
                        leafDown.constraints = [SKConstraint.positionX(SKRange(constantValue: -22), y: SKRange(constantValue: -10))]
                        horn.addChild(leafDown)
            
                    let leafRigth = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 146, y: 404, width: 16, height: 10))))
                        leafRigth.xScale = -1
                        leafRigth.zRotation = CGFloat(15).toRadians()
                        leafRigth.constraints = [SKConstraint.positionX(SKRange(constantValue: 20), y: SKRange(constantValue: 5))]
                        horn.addChild(leafRigth)
                    
            return horn
         
        }
    }
    
    var hornR: SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                let horn =  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 384, y: 186, width: 57, height: 62))))
            
                let leafUp = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 121, y: 405, width: 22, height: 11))))
                    leafUp.constraints = [SKConstraint.positionX(SKRange(constantValue: -15), y: SKRange(constantValue: 15))]
                    horn.addChild(leafUp)
        
                let leafDown = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 146, y: 404, width: 16, height: 10))))
                    leafDown.zRotation = -CGFloat(135).toRadians()
                    leafDown.constraints = [SKConstraint.positionX(SKRange(constantValue: -22), y: SKRange(constantValue: -10))]
                    horn.addChild(leafDown)
        
                let leafRigth = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 146, y: 404, width: 16, height: 10))))
                    leafRigth.xScale = -1
                    leafRigth.zRotation = CGFloat(15).toRadians()
                    leafRigth.constraints = [SKConstraint.positionX(SKRange(constantValue: 35), y: SKRange(constantValue: 5))]
                    horn.addChild(leafRigth)
            
            return horn
        }
    }
    
   
    
    var miniHorn: SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 192, y: 210, width: 28, height: 28))))
        }
    }
    
   
    
    var helmet: SKSpriteNode? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 254, width: 85, height: 40))))
        case .Mildred:         return nil
        case .Monster_Queen,.Ice_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 3, y: 331, width: 52, height: 72))))
        case .Spike:           return nil
        }
    }
    
    var diadem: SKSpriteNode? {
        switch self {
        case .Pinky,.Ice_Queen,.Monster_Queen,.Spike,.Mildred: return nil
            case .Monster_King:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 174, y: 106, width: 95, height: 48))))
        }
    }
    
    var nose: SKSpriteNode? {
        switch self {
        case .Pinky,.Mildred,.Monster_Queen,.Ice_Queen,.Spike:  return nil
        case .Monster_King:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 46, y: 139, width: 21, height: 12))))
        }
    }
    
    var mouth: [SKTexture]? {
        switch self {
        case .Pinky:         return nil
        case .Monster_King:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 282, y: 2, width: 81, height: 15))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 282, y: 36, width: 81, height: 14))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 282, y: 68, width: 81, height: 14))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 282, y: 100, width: 81, height: 15))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 272, y: 133, width: 81, height: 15))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 260, y: 166, width: 81, height: 15))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 89, y: 252, width: 83, height: 27)))
            ]
        case .Mildred:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 361, y: 112, width: 69, height: 18))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 210, width: 118, height: 34))),
            ]
        case .Ice_Queen:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 125, y: 396, width: 16, height: 5))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 144, y: 396, width: 16, height: 5))),
            ]
        case .Monster_Queen:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 126, y: 399, width: 16, height: 6))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 392, y: 340, width: 15, height: 5))),
            ]
        case .Spike:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 328, y: 118, width: 53, height: 26))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 328, y: 2, width: 63, height: 50))),
            ]
        }
    }
    
    var eye: [SKTexture]? {
        switch self {
        case .Pinky:         return nil
        case .Monster_King:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 362, y: 336, width: 21, height: 15))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 359, y: 373, width: 21, height: 23)))
            ]
        case .Mildred: return  [
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 160, y: 229, width: 29, height: 14))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 275, y: 211, width: 39, height: 17)))
                ]
        case .Ice_Queen:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 117, y: 231, width: 10, height: 10))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 334, y: 50, width: 19, height: 12))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 334, y: 70, width: 17, height: 13))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 335, y: 87, width: 18, height: 13))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 334, y: 104, width: 18, height: 13)))
            ]
        case .Monster_Queen:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 114, y: 153, width: 18, height: 16))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 387, y: 322, width: 19, height: 14))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 298, y: 318, width: 17, height: 13))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 389, y: 31, width: 18, height: 10))),
            ]
        case .Spike:        return nil
        }
    }
    
    var iris: SKSpriteNode? {
        switch self {
            case .Pinky:           return nil
            case .Monster_King:
                return SKSpriteNode(texture:SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 260, y: 158, width: 5, height: 4))))
            case .Mildred:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 193, y: 242, width: 4, height: 3))))
            case .Ice_Queen:       return nil
            case .Monster_Queen:   return nil
            case .Spike:           return nil
        }
    }
    
    var eyelashes:SKSpriteNode? {
        switch self {
            case .Pinky:           return nil
            case .Monster_King:    return SKSpriteNode(texture:SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 331, y: 335, width: 28, height: 15))))
            case .Mildred:
                let eyelashes = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 224, y: 344, width: 42, height: 19))))
                let extra = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 123, y: 230, width: 33, height: 13))))
                    eyelashes.addChild(extra)
                return eyelashes
            case .Ice_Queen:       return nil
            case .Monster_Queen:   return nil
            case .Spike:           return nil
        }
    }
    
    var eyelid: SKSpriteNode? {
        switch self {
        case .Pinky,.Mildred,.Spike,.Monster_King:  return nil
        case .Ice_Queen:     return SKSpriteNode(texture:SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 279, y: 343, width: 19, height: 25))))
        case .Monster_Queen: return SKSpriteNode(texture:SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 362, y: 2, width: 19, height: 25))))
        }
    }
    
    var ear: SKSpriteNode? {
        switch self {
        case .Pinky:         return nil
        case .Monster_King:  return nil
        case .Mildred:
            return SKSpriteNode(texture:SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 316, y: 186, width: 67, height: 46))))
        case .Ice_Queen:
            return SKSpriteNode(texture:SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 320, y: 284, width: 13, height: 29))))
        case .Monster_Queen:
            return SKSpriteNode(texture:SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 320, y: 160, width: 13, height: 29))))
        case .Spike:        return nil
        }
    }
   
    var body: SKSpriteNode? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 173, y: 2, width: 106, height: 99))))
        case .Mildred:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 184, y: 72, width: 130, height: 135))))
        case .Ice_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 59, y: 330, width: 63, height: 61))))
        case .Monster_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 60, y: 336, width: 63, height: 61))))
        case .Spike:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 4, y: 166, width: 114, height: 87))))
        }
    }
    var tail: SKSpriteNode? {
        switch self {
        case .Pinky,.Mildred,.Monster_Queen,.Ice_Queen,.Spike:  return nil
        case .Monster_King:
            let tail =  SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 359, y: 301, width: 28, height: 31))))
            
            let tail1 =  SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 343, y: 166, width: 20, height: 20))))
            tail1.zRotation = -.pi/2
            tail1.constraints = [SKConstraint.positionY(SKRange(constantValue: -18)) ]
            tail.addChild(tail1)
            return tail
        }
    }
    
    var wing: SKSpriteNode? {
        switch self {
            case .Pinky:            return nil
            case .Monster_King:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 118, y: 159, width: 94, height: 77))))
            case .Mildred:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 317, y: 186, width: 65, height: 46))))
            case .Monster_Queen,.Ice_Queen:
                let node =  self == .Ice_Queen ?
                SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 4, y: 3, width: 128, height: 149)))) :  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 1, y: 2, width: 130, height: 149))))
                let wingShort = wingShort!
                    wingShort.constraints = [ SKConstraint.positionX(SKRange(constantValue: 15))]
                node.addChild(wingShort)
                return node
            case .Spike:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 329, y: 147, width: 51, height: 39))))
        }
    }
    
    var wingShort: SKNode? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:    return nil
        case .Mildred:         return nil
        case .Monster_Queen, .Ice_Queen:
            let node = SKNode()
                node.name = "nodeWing"
            
            let wing0 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 239, y: 319, width: 57, height: 22))))
                wing0.constraints = [SKConstraint.positionX(SKRange(constantValue: wing0.frame.width*0.4), y: SKRange(constantValue: 25))]
                node.addChild(wing0)
            
            let wing1 =  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 115, y: 177, width: 94, height: 51))))
                node.addChild(wing1)
            
            let wing2 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 135, y: 101, width: 105, height: 73))))
                wing2.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -wing0.frame.height))]
                node.addChild(wing2)
            
            let wing3 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 166, y: 310, width: 70, height: 23))))
                wing3.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -wing2.frame.height*0.8))]
                node.addChild(wing3)
            return node
        case .Spike:           return nil
        }
    }
    
    var pad: SKSpriteNode? {
        switch self {
        case .Pinky,.Monster_Queen,.Ice_Queen,.Mildred:           return nil
        case .Monster_King:
            return  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 360, y: 353, width: 26, height: 16)))).mirrorSprite()
        case .Spike:
            return  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 327, y: 63, width: 59, height: 45))))
        }
    }
    
    var padArm: SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Mildred,.Spike: return nil
            case .Monster_Queen:
                return  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 353, y: 323, width: 32, height: 18))))
            case .Ice_Queen:
                return  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 243, y: 384, width: 33, height: 19))))

        }
    }
    
    var ballProjectile: SKSpriteNode? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 9, y: 338, width: 55, height: 52))))
        case .Mildred:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 295, y: 323, width: 33, height: 26))))
        case .Ice_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 361, y: 0, width: 41, height: 41))))
        case .Monster_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 327, y: 242, width: 18, height: 19))))
        case .Spike:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 244, y: 295, width: 59, height: 58))))
        }
    }
    
    var ballHand:SKSpriteNode? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:    return nil
        case .Mildred:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 295, y: 323, width: 33, height: 26))))
        case .Ice_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 369, y: 234, width: 35, height: 35))))
        case .Monster_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 319, y: 234, width: 34, height: 41))))
        case .Spike:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 293, y: 361, width: 43, height: 41))))
        }
    }
    
    var effectfxProjectile:[SKSpriteNode]?  {
        switch self {
            case .Pinky,.Monster_Queen,.Ice_Queen,.Mildred,.Monster_King:  return nil
            case .Spike: return [
                 SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 135, y: 375, width: 21, height: 29)))),
                 ]
            }
    }
    
    
     var bigProjectile: [SKTexture]? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:
            return [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 365, y: 2, width: 63, height: 62))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 365, y: 67, width: 63, height: 62))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 365, y: 131, width: 63, height: 61))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 343, y: 194, width: 63, height: 61))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 266, y: 297, width: 63, height: 61))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 202, y: 330, width: 63, height: 61))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 138, y: 332, width: 63, height: 61)))
            ]
        case .Mildred:
            return [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 184, y: 4, width: 136, height: 66))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 3, y: 127, width: 153, height: 84))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 0, y: 4, width: 183, height: 122)))]
        case .Monster_Queen,.Ice_Queen:
            return [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 253, y: 2, width: 79, height: 73))),
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 85, y: 246, width: 79, height: 78)))]
        case .Spike:
            return  [
                SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 244, y: 295, width: 59, height: 58)))]
        }
    }
    
    var forearm: SKSpriteNode? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 298, y: 199, width: 34, height: 26))))
        case .Mildred:         return nil
        case .Ice_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 335, y: 3, width: 24, height: 44))))
        case .Monster_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 362, y: 31, width: 24, height: 44))))
        case .Spike:           return nil
        }
    }
    
    var arm: SKSpriteNode? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 384, y: 372, width: 19, height: 21))))
        case .Mildred:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 316, y: 113, width: 42, height: 67))))
        case .Ice_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 329, y: 343, width: 33, height: 26)))).mirrorSprite()
        case .Monster_Queen:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 356, y: 258, width: 33, height: 26)))).mirrorSprite()
        case .Spike:
            return SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 312, y: 280, width: 18, height: 51))))
        }
    }
    
    var leaf:SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                 return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 157, y: 168, width: 23, height: 22))))
        }
    }
    var miniArm:SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                let arm = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 84, y: 368, width: 42, height: 28))))
                let leaf =  leaf!.mirrorSprite()
                    leaf.constraints = [SKConstraint.positionX(SKRange(constantValue: 10), y: SKRange(constantValue: 8))]
                    arm.addChild(leaf)
                return arm
        }
    }
    
    var handL: [SKSpriteNode]? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:    return [SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 6, y: 0, width: 39, height: 144)))).mirrorSprite()]
        case .Mildred:
            return [
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 340, y: 252, width: 56, height: 48)))),
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 331, y: 53, width: 68, height:56)))).mirrorSprite()
            ]
        case .Ice_Queen:
            return [
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 298, y: 319, width: 38, height: 22)))),
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 203, y: 388, width: 37, height: 16)))).mirrorSprite()
                  ]
        case .Monster_Queen:
            return [
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 353, y: 196, width: 37, height: 22)))),
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 268, y: 384, width: 36, height: 16))))

            ]
        case .Spike:
            return [
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 170, y: 215, width: 52, height: 77)))),
                SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 122, y: 107, width: 50, height: 85)))).mirrorSprite()
              ]
        }
    }
    
    var handR: [SKSpriteNode]? {
        switch self {
        case .Pinky:           return nil
        case .Monster_King:   return [SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 216, y: 159, width: 41, height: 28))))]
        case .Mildred:        return [handL![0].mirrorSprite(),handL![1].mirrorSprite()]
        case .Ice_Queen:      return [handL![0].mirrorSprite(),handL![1].mirrorSprite()]
        case .Monster_Queen:  return [handL![0].mirrorSprite(),handL![1].mirrorSprite()]
        case .Spike:          return [handL![0].mirrorSprite(),handL![1].mirrorSprite()]
        }
    }
    
    var mouthExtraEffect:SKSpriteNode? {
        switch self {
        case .Pinky,.Mildred,.Ice_Queen,.Monster_Queen,.Spike:           return nil
        case .Monster_King:
            let bg =  SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 345, y: 258, width: 43, height: 39))))
            let noise = SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 393, y: 259, width: 32, height: 27))))
                noise.run(.repeatForever(.sequence([.fadeAlpha(to: 0, duration: 0.5),.fadeAlpha(to: 1, duration: 0.5 )])))
            let pointsLight = SKSpriteNode(texture: SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 273, y: 105, width: 6, height: 6))))
                bg.addChild(pointsLight)
            let radius = noise.frame.width/3
            for i in 1...8 {
                let angle = (2 * .pi) / 8.0 * CGFloat(i)
                let p = pointsLight.copy() as! SKSpriteNode
                 p.name = "Points\(i)"
                 let circleX = radius * cos(angle)
                 let circleY = radius * sin(angle)
                 p.position = CGPoint(x: circleX + bg.frame.midX, y: circleY + bg.frame.midY)
                 p.run(.repeatForever(.sequence([.fadeOut(withDuration: 0.5),.fadeIn(withDuration: 0.5)])))
                 bg.addChild(p)
            }
            bg.addChild(noise)
            bg.setScale(0.8)
            return bg
        }
        
    }
    
    var miniHand: CGImage? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 36, y: 369, width: 44, height: 36))
        }
    }
    
    var legL: SKSpriteNode? {
        switch self {
        case .Pinky:                     return nil
        case .Monster_King:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 135, y: 111, width: 23, height: 37))))

        case .Mildred:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 369, width: 31, height: 46))))
        case .Monster_Queen,.Ice_Queen:  return nil
        case .Spike: return legR?.mirrorSprite()
        }
    }
    
    var legR: SKSpriteNode? {
        switch self {
        case .Pinky:                         return nil
        case .Ice_Queen:                     return nil
        case .Mildred:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 399, y: 359, width: 40, height: 46))))
        case .Monster_Queen:   return nil
        case .Monster_King:    return legL?.mirrorSprite()
        case .Spike:
            return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 339, y: 341, width: 24, height: 27))))
        }
    }
    
    var footL:[SKTexture]?      {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Mildred: return nil
            case .Spike: return footR
        }
    }
    var footR:[SKTexture]?      {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Mildred: return nil
            case .Spike:
               return [
                    SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 110, y: 378, width: 23, height: 28))),
                    SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 251, y: 363, width: 40, height: 42)))
                ]
        }
    }
    
    var extraLegL: SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 400, y: 253, width: 33, height: 49))))
        }
    }
    
    var extraLegR: SKSpriteNode? {
        switch self {
            case .Pinky,.Monster_King,.Ice_Queen,.Monster_Queen,.Spike: return nil
            case .Mildred:
                return SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 401, y: 55, width: 33, height: 49))))
        }
    }
    
    var skirt: SKNode? {
        var skirt:SKNode? = nil
        
        switch self {
            case .Pinky:           return nil
            case .Monster_King:
            skirt = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 266, y: 362, width: 60, height: 28))))
            case .Mildred:         return nil
            case .Ice_Queen:
                
                skirt = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 363, y: 171, width: 38, height: 33))))
                
                let skirt0 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 366, y: 209, width: 34, height: 21))))
                    skirt0.constraints = [ SKConstraint.positionX(SKRange(constantValue: -22), y: SKRange(constantValue: -10)) ]
                                           skirt?.addChild(skirt0)
                
                let skirt1 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 215, y: 178, width: 24, height: 46))))
                    skirt1.constraints = [SKConstraint.positionX(SKRange(constantValue: 5), y: SKRange(constantValue: 3))]
                    skirt?.addChild(skirt1)
                
                let skirt2 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 177, y: 344, width: 23, height: 55))))
                    skirt2.constraints = [SKConstraint.positionX(SKRange(constantValue: -5), y: SKRange(constantValue: 0))]
                    skirt?.addChild(skirt2)
                
                let skirt3 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 329, y: 207, width: 27, height: 41))))
                    skirt3.constraints = [SKConstraint.positionX(SKRange(constantValue: -15), y: SKRange(constantValue: 6))]
                    skirt?.addChild(skirt3)
            
                let skirt4 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 328, y: 161, width: 31, height: 43))))
                    skirt4.constraints = [SKConstraint.positionX(SKRange(constantValue: -19), y: SKRange(constantValue: 8))]
                    skirt?.addChild(skirt4)
           
                let skirt5 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 324, y: 372, width: 35, height: 31))))
                    skirt5.constraints = [SKConstraint.positionX(SKRange(constantValue: -26), y: SKRange(constantValue: 18))]
                    skirt?.addChild(skirt5)
            
                let skirt6 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 203, y: 338, width: 25, height: 46))))
                    skirt6.constraints = [SKConstraint.positionX(SKRange(constantValue: 16), y: SKRange(constantValue: 8))]
                    skirt?.addChild(skirt6)
            
                let skirt7 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 361, y: 88, width: 28, height: 35))))
                    skirt7.constraints = [SKConstraint.positionX(SKRange(constantValue: 26), y: SKRange(constantValue: 18))]
                    skirt?.insertChild(skirt7, at: 2)
            
                let skirt8 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 366, y: 267, width: 29, height: 13))))
                    skirt8.constraints = [SKConstraint.positionX(SKRange(constantValue: 30), y: SKRange(constantValue: 21))]
                    skirt?.insertChild(skirt8, at: 1)
            
            case .Monster_Queen:
                 skirt = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 242, y: 344, width: 22, height: 54))))
                 skirt?.constraints = [SKConstraint.positionX(SKRange(constantValue: -12), y: SKRange(constantValue: -2))]
            
                let skirt0 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 368, y: 79, width: 28, height: 41))))
                    skirt0.constraints = [SKConstraint.positionX(SKRange(constantValue: -15), y: SKRange(constantValue: 1))]
                    skirt?.addChild(skirt0)
                
                let skirt1 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 335, y: 79, width: 31, height: 43))))
                    skirt1.constraints = [SKConstraint.positionX(SKRange(constantValue: -19), y: SKRange(constantValue: 8))]
                    skirt?.addChild(skirt1)
                
                let skirt2 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 318, y: 362, width: 34, height: 31))))
                    skirt2.constraints = [SKConstraint.positionX(SKRange(constantValue: -26), y: SKRange(constantValue: 18))]
                    skirt?.addChild(skirt2)
                
                let skirt3 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 336, y: 3, width: 24, height: 46))))
                    skirt3.constraints = [SKConstraint.positionX(SKRange(constantValue: 15), y: SKRange(constantValue: 6))]
                    skirt?.addChild(skirt3)
                
                let skirt4 = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 356, y: 288, width: 33, height: 31))))
                    skirt4.constraints = [SKConstraint.positionX(SKRange(constantValue: 29), y: SKRange(constantValue: 20))]
                    skirt?.addChild(skirt4)
            
            case .Spike:
                skirt = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 107, y: 350, width: 50, height: 23))))
        }
        return skirt
    }
}

enum DragonType:String,ProtocolEnemyType {
    
    case Roa
    case Bubbles
    
    var typeBullet:SKTexture {
        switch self {
            case .Roa,.Bubbles:
                return SKTexture(imageNamed: self.rawValue)
        }
    }
    
    var texture:[SKTexture] {
        
        switch self {
            case .Roa,.Bubbles:
                return SKTextureAtlas().loadAtlas(name: self.rawValue, prefix: nil)
        }
    }
}

enum EnemyType: String,CaseIterable, ProtocolBossType {
    
    case Boss     = "Boss Type"
    case Regular  = "Regular Type"
    case Fireball = "Fireball Type"
    case Special  = "Special Type"
    case Armored  = "Armored"
    case Cofre    = "Cofre"
    case Buitre   = "Buitre"
}

class EnemyModel: NSObject ,ProcotolHP {
    
    weak var delegate: GameInfoDelegate?
    
    typealias T = EnemyType
    
    typealias B = BossType
    
    deinit{ }
    
    var actionsDead:[SKTexture]  = []
    
    var bossShadow:SKTexture {
        SKTexture(cgImage:  bossType.shadow)
    }
    
    // Shared Variables
    var enemyType: EnemyType
    internal var enemyModel:Enemy?
    internal var currency:Currency?
    internal var bossType:BossType
    internal var BossBaseHP:CGFloat = 1500.0
    internal var RegularBaseHP:CGFloat = 100.0
    
    var velocity:CGVector = CGVector(dx: 0, dy: -350)
    
    init(type: T){
        
        currency = Currency(type: Currency.CurrencyType.Coin)
        enemyType = type
        enemyModel =  SKSpriteNode() as? Enemy
        bossType = B.allCases.randomElement()!
        
        super.init()
    }
        
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DragonsModel:NSObject {
    
    var dragon:Dragon
    
    var typeDragon:DragonType
    
    private var bulletnode:Projectile?
    
    enum DragonSide {
        case Left
        case Right
    }
    

    init(type:DragonType){

         dragon = Dragon(hp:100, type: type)
         typeDragon = type
         bulletnode = Projectile(posX: dragon.position.x, posY: dragon.position.y, texture: type.typeBullet)

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot() -> SKSpriteNode {
        
        return (bulletnode?.shoot())!
    }
    
    func updateProjectile(node:SKSpriteNode,direcction:DragonSide){
        bulletnode!.setPos(x: direcction == .Left ?  node.position.x-75 : node.position.x+75,y:node.position.y-50)
   }
}

