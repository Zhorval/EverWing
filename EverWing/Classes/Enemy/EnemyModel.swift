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
   
    mutating func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode,scene:SKScene?)
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
    mutating func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode,scene:SKScene?){
       
       
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
               ofTarget.physicsBody?.categoryBitMask = PhysicsCategory.None
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
        
        guard let sknode = sknode else {  return }
   
        rewardCoin(skNode: sknode,scene:scene!)
        
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
                       (delegate?.mainAudio.getAction(type: .Puff))!,
                       .run { [self] in
                           guard let scene = scene else {
                               return
                           }
                           for x in scene.children where ((x.name?.contains("FX_")) == true){
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
        
        case  .Regular :
            guard let mainReg = enemyModel as? RegularEnemy else {
                
                sknode.removeFromParent(); return }
            
            mainReg.defeated(sknode: sknode)
            sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
            
    
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
            
            let emiter = SKEmitterNode(fileNamed: "trail")!
            mainReg.addChild(emiter)
            sknode.run(.sequence([
                .run { [self] in
                    
                    sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
                    SKAction.wait(forDuration: 5)
                    mainReg.defeated()
                    sknode.removeFromParent()
                    emiter.removeFromParent()
                }
                ]))
       default:
           sknode.removeFromParent()
       }
        

   }
    
    // MARK: GET YOU COIN WHEN DESTROY ENEMY
    mutating func rewardCoin(skNode:SKNode,scene:SKScene) {
       
        let posX = skNode.position.x
        let posY = skNode.position.y
        
        let rewardCount:Int = enemyType.self as! EnemyType == EnemyType.Regular ? 1 : randomInt(min: 1, max: 3)
 
        /// ELIMINAR DEPURACION
   //    self.currency?.changeTypeCoin(type:  Currency.CurrencyType.Flower)

        
        for i in 0..<rewardCount{
            
            if i == rewardCount-1  {//}&& enemyType as! EnemyType != EnemyType.Regular{
            
                self.currency?.changeTypeCoin(type:  Currency.CurrencyType.allCases.randomElement()!)
               
            }
            
            let reward = self.currency?.createCoin(posX: posX ,posY: posY, width: 50, height: 50, createPhysicalBody: true, animation: true)
       
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
        
        guard let scene = scene else { return }

        switch enemyType.self as! EnemyType {
            case .Regular:
              
                enemyModel = RegularEnemy(baseHp: 1500, speed: velocity  ,type: .Regular)
                
            case .Boss:
                
                scene.childNode(withName: "Enemy_Boss")?.removeFromParent()
                let chance = randomInt(min: 0, max: 100)
            
                if chance > 10{
                    guard let typeBoss = typeBoss else { return }

                    enemyModel = Bomber(hp: baseHP ?? BossBaseHP,typeBoss: typeBoss,scene:scene)
                }
                else{
                    bossType = BossType.Pinky as! Self.B
                    enemyModel = Pinky(hp: baseHP ?? BossBaseHP, lives: 4, isClone: true)
                    
                }
            case .Fireball:
                guard let fireball = delegate?.getCurrentToonNode() else { return }
                enemyModel = Fireball(target: fireball, speed: velocity)
            
            case .Buitre:
                    guard let delegate = delegate else {return }
                    scene.run((delegate.mainAudio.getAction(type: .Halcon)))

                    enemyModel = BuitreEnemy(hp: 1000, gameInfo: delegate)
           
            case .Armored:
                if scene.childNode(withName: "Enemy_Armored") != nil || delegate?.getGameState == .BossEncounter {
                         return
                    } else {
                        guard let delegate = delegate else {return }
                        
                        enemyModel = ArmoredEnemy(hp: 1000,gameInfo:delegate)
                        
                        enemyModel?.name = "Enemy_Armored"
                    }
            
            case .Cofre:
           
                    enemyModel = CofreEnemy(hp: RegularBaseHP,speed: velocity)
           
            default:  break
        }
            
        guard let enemyModel = enemyModel else { return }
        
        scene.addChild(enemyModel)
        
        if isAttack != nil {
         //   enemyModel.enemyModel?.removeFromParent()
        explode(sknode: enemyModel.enemyModel!, scene: scene)

             
        }
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
        
        let node = SKSpriteNode(texture: typeBoss.getTextureShadow())
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
     func getTextures(type:T, prefix:String?) -> [SKTexture]
     func getTexture() -> SKTexture
     func getTextureShadow()->SKTexture
    
}

protocol ProtocolEnemyType {}

protocol ProtocolBossType {}

enum BossType:String,CaseIterable,BossTypeProtocol{
   
    func getTextures(type: Self, prefix:String?) -> [SKTexture] {        
         SKTextureAtlas().loadAtlas(name: type.rawValue , prefix: prefix)
    }
    
    func getTexture() -> SKTexture {
        getTextures(type: getType(), prefix: nil).first!
    }
    
    func getTextureShadow() -> SKTexture {
        SKTexture(imageNamed: "\(self.rawValue.replacingOccurrences(of: " ", with: "_"))_Shadow")
    }
  
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
    
    var delegate: GameInfoDelegate?
    
    typealias T = EnemyType
    
    typealias B = BossType
    
    deinit{ }
    
    var actionsDead:[SKTexture]   {
         bossType.getTextures(type: bossType, prefix: nil)
    }
    
    var bossShadow:SKTexture {
        bossType.getTextureShadow()
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

