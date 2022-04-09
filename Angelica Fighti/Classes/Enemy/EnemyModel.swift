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
    var shield:Shield?              { get set}

}

protocol ProcotolHP:BaseProtocolHP {
   
    mutating func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode,scene:SKScene?)
    func update(sknode: SKSpriteNode, hpBar: SKNode)
    mutating func explode(sknode: Enemy,scene:SKScene?)
    mutating func spawn(scene :SKScene)
    mutating func increaseDifficulty()
    func showShadowBoss()->SKSpriteNode
  
}

extension ProcotolHP {
    
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
    mutating func explode(sknode: Enemy,scene:SKScene?) {
        
        
       let rewardCount:Int = randomInt(min: 5, max: 8)
       
       var posX = sknode.position.x
       var posY = sknode.position.y
        
          if  enemyType.self as! EnemyType == EnemyType.Regular{
            
           // converting to position in scene's view... required because its parent is not the root view
           posX = sknode.position.x + screenSize.width/2
           posY = sknode.parent!.frame.size.height/2 + 200 + sknode.position.y  + screenSize.height
       }

       for i in 0..<rewardCount{
           
           if i == rewardCount-1 {
               if shield == nil {
                   self.currency?.changeTypeCoin(type: .allCases.randomElement()!)
               }
           }
           
           let reward = self.currency?.createCoin(posX: posX, posY: posY, width: 50, height: 50, createPhysicalBody: true, animation: true)
        
           
           let impulse = CGVector(dx: random(min: -25, max: 25), dy: random(min:10, max:35))
           
           reward?.run(SKAction.sequence([SKAction.applyForce(impulse , duration: 0.2), SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
           
           
           if let r = reward{
               delegate?.addChild(r)
           }
           else{
               
               print("ERROR ON CLASS ENEMY. Check Method Explosion. ")
           }
       }

       sknode.removeAllActions()
        
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
                   mainBoss.defeated(actionsDead: actionsDead)
                   sknode.run(.sequence([
                       (delegate?.mainAudio.getAction(type: .Puff))!,
                       
                       .run { [self] in
                           mainBoss.removeFromParent()
                           
                           // CREATE CLOOUDS
                        //   self.delegate?.createCloud()
                           SKAction.wait(forDuration: 3)
                           self.delegate?.changeGameState(.WaitingState)
                       }
                   ]))
               }
              
        //   }
        
        case  .Regular :
           let mainReg = enemyModel as! RegularEnemy
           mainReg.defeated(sknode: sknode)
           shield = nil
           sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
    
        case .Goblin:
            guard let mainReg = enemyModel  else { sknode.removeFromParent(); return}
            mainReg.defeated(actionsDead: [])
            sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)

            
        case .Cofre:
            guard let mainReg = enemyModel,
                  let scene = scene else {

                sknode.removeFromParent()
                return
            }
            
            mainReg.defeated(actionsDead: [])
            sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
            velocity = CGVector(dx: 0, dy: -100)
           /* for child in scene.children {
                if child.name?.contains("Enemy") == true  && ((child as? Enemy) != nil){
                    
                    guard let child = child as? Enemy else {
                        print("Escena no es Enemy")
                        return
                        
                    }
                    print("Escena ",child.name)
                    child.defeated(actionsDead: [])
                    sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
                }
            }*/
            sknode.removeFromParent()
            

       default:
           sknode.removeFromParent()
       }
   }
    
    // MARK: SHOW SPAWN OF THE ENEMY REGULAR
    mutating func spawn(scene :SKScene){
        
        switch enemyType.self as! EnemyType {
            case .Regular:
              
            enemyModel = RegularEnemy(baseHp: RegularBaseHP, speed: velocity)
           
            case .Boss:
                    let chance = randomInt(min: 0, max: 100)
                
                    if chance > 10{
                        
                        var all = BossType.allCases
                        let _ = all.remove(at: BossType.allCases.firstIndex(of: .Pinky)!)
                        bossType =   all.randomElement()! as! Self.B
                        enemyModel = Bomber(hp: BossBaseHP,typeBoss: bossType as! BossType)
                    }
                    else{
                        bossType = BossType.Pinky as! Self.B
                        enemyModel = Pinky(hp: BossBaseHP, lives: 4, isClone: true)
                    }
            case .Fireball:
                    enemyModel = Fireball(target: (delegate?.getCurrentToonNode())!, speed: velocity)

            case .Goblin:
                if scene.childNode(withName: "Enemy_Goblin") != nil {
                     enemyModel = nil
                } else {
                    enemyModel = GoblinEnemy(hp: 1000)
                }
            
            case .Cofre:
           
            if random(min: 100, max: 200) > 150 {
                enemyModel = CofreEnemy(hp: RegularBaseHP,speed: velocity)
            }
           
            default:  break
        }
            
        guard let enemyModel = enemyModel,
        (scene.childNode(withName: enemyModel.name!) == nil) else { return }
        scene.addChild(enemyModel)
       
    }
    
    // MARK: INCREMENT DIFICULT WHEN PASS LEVEL
    mutating func increaseDifficulty(){
        
        switch enemyType.self as! EnemyType{
            case .Regular:
                RegularBaseHP += 100
                velocity.dy -= 1
            case .Boss:
                BossBaseHP += 1500
            case .Fireball:
                velocity.dy -= 1
            case .Cofre:
                velocity.dy -= 1
            default:
            print("No increase for \(enemyType.self as! EnemyType)")
       }
   }
    
    // MARK: SHOW SHADOW BOSS WHEN ENCOUNTER
    func showShadowBoss()->SKSpriteNode {
        
        let node = SKSpriteNode(texture: bossType.getTextureShadow())
        node.name =  "Shadow"
        node.size = CGSize(width: screenSize.width/2, height: screenSize.width/2)
        node.position = CGPoint(x: screenSize.midX, y: screenSize.height*0.7)
        
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
         SKTexture(imageNamed: "\(self.rawValue)_Shadow")
    }
  
    func getType() -> Self {
        return self
    }
    
    var audioFX:SKAction {
        switch self {
        case .Pinky:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:3)
        case .Ice_Queen:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:3)
        case .Mildred:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:3)
        case .Monster_King:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:3)
        case .Monster_Queen:
            return SKAction.repeat(SKAction.playSoundFileNamed("owl.m4a", waitForCompletion: true), count:3)
        case .Spike:
            return SKAction.repeat(SKAction.playSoundFileNamed("ice-cracking.m4a", waitForCompletion: false), count:1)


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
            return SKTexture(imageNamed: "Green_Weakness")
        case .Ice_Queen:
            return SKTexture(imageNamed: "Blue_Weakness")
        case .Mildred:
            return SKTexture(imageNamed: "Red_Weakness")
        case .Monster_King:
            return SKTexture(imageNamed: "Purle_Weakness")
        case .Monster_Queen:
            return SKTexture(imageNamed: "Yellow_Weakness")
        case .Spike:
            return SKTexture(imageNamed: "Blue_Weakness")
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
    case Goblin   = "Goblin"
    case Cofre    = "Cofre"
}

class EnemyModel: NSObject,ProcotolHP {
    
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
    
    var account = AccountInfo()
    
    var shield:Shield?
    
    init(type: T){
        
        currency = Currency(type: .Coin)
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

