//
//  Toon.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
import Foundation
import SpriteKit



class Toon{
    
    enum Character:String,CaseIterable{
        case Alpha = "ALPHA"
        case Beta = "BETA"
        case Celta = "CELTA"
        case Delta = "DELTA"
//        case Felta = "FELTA"
        case Gelta = "GELTA"
        case Jade = "JADE"
        case Arcana = "ARCANA"
        case Alice = "ALICE"
        
        var string:String{
            let name = String(describing: self)
            return name
        }
    }
    deinit {}
    
    private var size:CGSize
    private var node:SKSpriteNode
    private var bullet:Projectile?
    private var shield:Shield?
    private var description:[String] = []
    private var experience:CGFloat = 0
    private var title:String = "None"
    private var level:Int = 1 // For future use
    private var isActiveShield:Bool = false
    private var isActiveAuraFire:Bool = false
    private var delegate:GameInfoDelegate?
    
    // Initialize
    private var charType:Character
    
    
    init(char:Character){
        
        var localMainTexture:SKTexture!
        
        switch char {
        case .Alpha:
           
            localMainTexture = global.getMainTexture(main: .Character_Alpha)
            //   localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        case .Beta:
           
            localMainTexture = global.getMainTexture(main: .Character_Beta)
            //    localWingTexture = global.getMainTexture(main: .Character_Beta_Wing)
        case .Celta:
            
            localMainTexture = global.getMainTexture(main: .Character_Celta)
            //  localWingTexture = global.getMainTexture(main: .Character_Celta_Wing)
        case .Delta:
           
            localMainTexture = global.getMainTexture(main: .Character_Delta)
       
         //   localWingTexture = global.getMainTexture(main: .Character_Delta_Wing)
        case .Arcana:
             localMainTexture = SKTexture(imageNamed: "\(char.string + "_idle1")")
         //   localWingTexture = global.getMainTexture(main: .Character_Delta_Wing)
        case .Alice:
             localMainTexture = SKTexture(imageNamed: "\(char.string + "_idle1")")
        case .Jade:
            localMainTexture = SKTexture(imageNamed: "\(char.string + "_idle1")")
            
        default:
            // default - Warning
            localMainTexture = global.getMainTexture(main: .Character_Alpha)
        //    localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        }
        
        self.charType = char
        self.size = localMainTexture.size()

        node = SKSpriteNode(texture: localMainTexture)
        node.name = "toon"
        node.position = CGPoint(x: screenSize.width/2, y: 100)
        node.size = self.size
    //    node.run(SKAction.scale(to: 0.7, duration: 0.0))
       
        let texture = SKTextureAtlas().loadAtlas(name: charType.string + "_Idle", prefix: nil)
        if texture.count >  0 {
            node.run(.repeatForever(.animate(with: texture, timePerFrame: 0.1)))
        }
        
      /*  let l_wing = SKSpriteNode()
        l_wing.texture = localWingTexture
        l_wing.size = CGSize(width: ww, height: wh)
        l_wing.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        l_wing.position = CGPoint(x: -2.0, y: 20.0)
        l_wing.run(SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: screenSize.width * 0.097, duration: 0.3), SKAction.resize(toWidth: screenSize.height * 0.105, duration: 0.15)])))
        
        node.addChild(l_wing)
        
        let r_wing = SKSpriteNode()
        r_wing.texture = localWingTexture
        r_wing.size = CGSize(width: ww, height: wh)
        r_wing.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        r_wing.position = CGPoint(x:2.0, y: 20.0)
        r_wing.xScale = -1.0
        r_wing.run(SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: screenSize.width * 0.097, duration: 0.3), SKAction.resize(toWidth: screenSize.height * 0.105, duration: 0.15)])))
        
        node.addChild(r_wing)*/
    }
    
     func load(infoDict:NSDictionary){
        //Level lv: Int, Experience exp: CGFloat, Description description:[String]
        self.level = infoDict.value(forKey: "Level") as! Int
        self.experience = infoDict.value(forKey: "Experience") as! CGFloat
        self.description = infoDict.value(forKey: "Description") as! [String]
        self.title = infoDict.value(forKey: "Title") as! String
        let bulletLevel = infoDict.value(forKey: "BulletLevel") as! Int
        
         // REVISAR EL BULLETEVEL  EN EL CONSTRUCTOR PROJECTILE 
        bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: 50)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
       

        // Apply Magnetic Field
         let mfield =  SKFieldNode.radialGravityField()
        mfield.region = SKRegion(radius: Float(node.size.width))
        mfield.strength =  120.0
        mfield.categoryBitMask = GravityCategory.Player
        node.addChild(mfield)
        
    }
    
     func getNode() -> SKSpriteNode{
        return node
    }

     func updateProjectile(node:SKSpriteNode){
         bullet!.setPos(x: node.position.x,y:node.position.y)
     }
    
    
    func shieldActive()->Bool {
        isActiveShield
    }
    
    // MARK: ANIMATE TEXTURE ATTACK
    func attack(_ completion:@escaping()->Void) ->SKAction {
        
       
        let action = SKAction.sequence([
            
            SKAction.animate(with: SKTextureAtlas().loadAtlas(name: "Alice_Attack", prefix: nil), timePerFrame: 0.2),
            SKAction.wait(forDuration: 4),
            SKAction.animate(with: SKTextureAtlas().loadAtlas(name: "Alice_Idle", prefix: nil), timePerFrame: 0.5),
            SKAction.run {
                completion()
            }
            
            ])
        return action
    }
    
    
    // MARK: SHOW AURA FIRE PLAYER
    func showAuraFire() -> SKSpriteNode {
        
        let spriteAura = SKSpriteNode(imageNamed: "AuraFire1")
        spriteAura.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteAura.name = "auraFire"
        spriteAura.size = CGSize(width: getNode().frame.width * 1.1, height: getNode().frame.height * 1.5)
        spriteAura.zPosition = -2
        spriteAura.position.y = -getNode().frame.height/2
        
        
        let action = SKAction.repeatForever(.sequence([
            .animate(with: SKTextureAtlas().loadAtlas(name: "AuraFire", prefix: nil), timePerFrame: 0.1),
            .wait(forDuration: 4),
            .run {
                spriteAura.removeAllActions()
                spriteAura.removeFromParent()
            }
            ]))
        
        spriteAura.run(action)
        
        return spriteAura
    }
    
    // MARK: SHOW AURA SHIELD PLAYER
    func showAuraShield() -> SKSpriteNode {
        
        let spriteAura = SKSpriteNode()
        spriteAura.name = "auraPlayer"
        spriteAura.size = CGSize(width: 150, height: 150)
        spriteAura.position.y = 20
        spriteAura.zPosition = 10
        
        let atlas = SKTextureAtlas().loadAtlas(name: "AuraPlayer", prefix: nil)
        let action = SKAction.animate(with: atlas, timePerFrame: 1, resize: false, restore: true)
        let action1 = SKAction.removeFromParent()
        
        spriteAura.run(.sequence([action,action1]))
        
        return spriteAura
    }
    
    
    func changeTextureProjectile(restore:Bool) {
        
        if !restore {
            bullet = Projectile(posX: 0, posY: 0, char: getCharacter(), bulletLevel: 0, texture: SKTexture(imageNamed: "FireRed"))
        } else {        
            bullet = Projectile(posX: 0, posY: 0, char: getCharacter(), bulletLevel: getLevel())
        }
    }
 
     func getBullet() -> Projectile{
        return bullet!
    }
    
     func getToonDescription() -> [String]{
        return description
    }
    
     func getToonName() -> String{
        return charType.rawValue
    }
    
     func getToonTitle() -> String{
        return title
    }
    
     func getBulletLevel() -> Int{

         return bullet!.getBulletLevel()
    }
    
     func getLevel() -> Int{
        return level
    }
    
    func addLevel() {
        level += 1
    }
    
     func advanceBulletLevel() -> Bool{
        return bullet!.upgrade()
    }
    // Remove below function later on. Combine it with getToonName
     func getCharacter() -> Character{
        return charType
    }
    
    func getTextureCurrentToon() -> Global.Main? {
        
        let name = "Character_\(getToonName().capitalized)"
        print("Name \(name)")
        
        return Global.Main.Character_Alpha
    }
}
