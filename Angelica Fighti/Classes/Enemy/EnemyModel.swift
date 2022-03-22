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




protocol BossTypeProtocol {
    
     func getType()->BossType
     func getTextures(type:BossType,prefix:String) -> [SKTexture]
}

enum BossType:String,CaseIterable,BossTypeProtocol{
    
    func getTextures(type: BossType,prefix:String) -> [SKTexture] {
        
        return SKTextureAtlas().loadAtlas(name: type.rawValue, prefix: prefix)
    }
  
    func getType() -> BossType {
        return self
    }
    
     /*   case None
        case Pinky
        case Bomber*/
        case Robot
        case Pinky
        case Troll1
        case Troll2
        case Troll3
}

class Dragon:Enemy {
    
    
    deinit{
        print("Deinit Dragon")
    }
    
    convenience init(hp:CGFloat,texture:String){
        
        self.init()
        self.texture = SKTexture(imageNamed: DragonsModel.DragonType(rawValue: texture)!.rawValue)
        self.name = texture
        print("Inicializo dragon")
        size = CGSize(width: 70, height: 90)
        self.hp = hp
        self.maxHp = hp
        
        initialSetupDragon()
        addHealthBar()
    }
    
     func initialSetupDragon() {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.Player
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = PhysicsCategory.Enemy
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        self.physicsBody?.allowsRotation = false
    }
}


class DragonsModel:NSObject {
    
    enum DragonType:String {
        case dragon_Green
        case dragon_Pink
        
        
        var texture:SKTexture {
            
            switch self {
            case .dragon_Green:
                return SKTexture(imageNamed: self.rawValue)
            case .dragon_Pink:
                return SKTexture(imageNamed: self.rawValue)
            }
        }
    }
   
    
    var dragon:Dragon
    var typeDragon:DragonType
    
    private var bulletnode:Projectile?

     init(type:DragonType){

         dragon = Dragon(hp:100,texture: type.rawValue)
         dragon.name = type.rawValue
         typeDragon = type
         bulletnode = Projectile(posX: 0, posY: 0, texture: SKTexture(imageNamed: "FireRed"))
         

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot() -> SKSpriteNode {

        bulletnode?.setPos(x: self.dragon.position.x, y: dragon.position.y)
        
        return bulletnode!.shoot()
    }
    
    
}

protocol ProcotolHP {
   
}

extension ProcotolHP {
    
}

enum EnemyType: String,CaseIterable,ProcotolHP {
    
    
    case Boss = "Boss Type"
    case Regular = "Regular Type"
    case Fireball = "Fireball Type"
    case Special = "Special Type"
}

class EnemyModel: NSObject,ProcotolHP{
    var enemyType: EnemyType
    
    
    deinit{
        print("EnemyModel Class Deinitiated")
    }
    
 /*   enum EnemyType: String,CaseIterable{
        case Boss = "Boss Type"
        case Regular = "Regular Type"
        case Fireball = "Fireball Type"
        case Special = "Special Type"
    }*/
    
  
    
    var actionsDead:[SKTexture]   {
        
        switch bossType {
   
        case .Troll1,.Troll2,.Troll3,.Robot,.Pinky:
           return  bossType.getTextures(type: bossType, prefix: "enemy")
       
        }
    }
    
    
    // Shared Variables
    private var enemyType:EnemyType
    private var enemyModel:SKSpriteNode!
    private var currency:Currency?
    private var bossType:BossType
    private var BossBaseHP:CGFloat = 1500.0
    private var RegularBaseHP:CGFloat = 100.0

    
    private var velocity:CGVector = CGVector(dx: 0, dy: -350)
    
    
    // Boss Variables - Implement later
    private let PinkyPercentage:Int = 100
    private let BomberPercentage:Int = 0
    
    var delegate:GameInfoDelegate?
    
    init(type: EnemyType){
        currency = Currency(type: .Coin)
        enemyType = type
        enemyModel = SKSpriteNode()
        bossType = BossType.allCases.randomElement()!
        
        super.init()
    }
    
     func spawn(scene :SKScene){
        
        switch enemyType {
        case .Special: break
        case .Regular:
            enemyModel = RegularEnemy(baseHp: RegularBaseHP, speed: velocity)
        case .Boss:

            bossType = BossType.allCases.randomElement()!
            
            switch bossType {
            case .Pinky:
                enemyModel = Pinky(hp: BossBaseHP, lives: 2, isClone: false)
                
            case .Troll1,.Troll2,.Troll3,.Robot:
                enemyModel =  Bomber(hp: BossBaseHP, typeBoss: bossType )
                
            
            }
         /*   let chance = randomInt(min: 0, max: 100)
            
            switch chance {
                case 0...10:
                    bossType = BossType.allCases.randomElement()!
                    enemyModel =  Bomber(hp: BossBaseHP, typeBoss: bossType )
                case 11...100:
                    bossType = .Troll1
                    enemyModel = Bomber(hp: BossBaseHP,typeBoss:  bossType)
                
                case 52...100:
                    bossType = .Pinky
                    enemyModel = Pinky(hp: BossBaseHP, lives: 2, isClone: false)
                default: break
            }*/
        case .Fireball:
            enemyModel = Fireball(target: (delegate?.getCurrentToonNode())!, speed: velocity)
        
        }
        
         if enemyModel.name != nil {
             scene.addChild(enemyModel!)
         }
    }
    
     func increaseDifficulty(){
        // Increase HP & Speed
        switch enemyType {
        case .Regular:
            RegularBaseHP += 100
            velocity.dy -= 50
        case .Boss:
            BossBaseHP += 1500
        case .Fireball:
            velocity.dy -= 250
        default:
            print("No increase for \(enemyType.rawValue)")
        }
    }
    
     func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode){
        
        
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
                explode(sknode: ofTarget)
                return
            }
            else{
                if enemyHpBar.isHidden {
                    enemyHpBar.isHidden = false
                }
            }
        }
        
    }
    
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
    
     func explode(sknode: SKSpriteNode){
        let rewardCount:Int = randomInt(min: 1, max: 4)
        
        var posX = sknode.position.x
        var posY = sknode.position.y
        
        if self.enemyType == .Regular{
            // converting to position in scene's view... required because its parent is not the root view
            posX = sknode.position.x + screenSize.width/2
            posY = sknode.parent!.frame.size.height/2 + 200 + sknode.position.y  + screenSize.height
        }
        
        for _ in 0..<rewardCount{
            
            let reward = currency?.createCoin(posX: posX, posY: posY, width: 30, height: 30, createPhysicalBody: true, animation: true)
            
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
        switch (enemyType){
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
                
                if let mainBoss = enemyModel as? Enemy {
                    print("Es boss")
                    mainBoss.defeated(actionsDead: actionsDead)
                    sknode.run(.sequence([
                        (delegate?.mainAudio.getAction(type: .Puff))!,
                        
                        .run {
                            mainBoss.removeFromParent()
                            self.delegate?.createCloud()
                            
                            self.delegate?.changeGameState(.WaitingState)
                        }
                    ]))
                }
               
         //   }
            
        case .Regular:
            let mainReg = enemyModel as! RegularEnemy
            mainReg.defeated(sknode: sknode)
            sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
        default:
            sknode.removeFromParent()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
