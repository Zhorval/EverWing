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
    deinit {
        print("Toon deinit")
        
    }
    
    private var size:CGSize
    private var node:SKSpriteNode
    private var bullet:Projectile?
    private var description:[String] = []
    private var experience:CGFloat = 0
    private var title:String = "None"
    var level:Int = 1 // For future use
    
    // Initialize
    private var charType:Character
    
    
    init(char:Character){
        
        var localMainTexture:SKTexture!
        var localWingTexture:SKTexture!
        
        switch char {
        case .Alpha:
           
               localMainTexture = global.getMainTexture(main: .Character_Alpha)
               localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        case .Beta:
           
            localMainTexture = global.getMainTexture(main: .Character_Beta)
                localWingTexture = global.getMainTexture(main: .Character_Beta_Wing)
        case .Celta:
            
            localMainTexture = global.getMainTexture(main: .Character_Celta)
              localWingTexture = global.getMainTexture(main: .Character_Celta_Wing)
        case .Delta:
           
            localMainTexture = global.getMainTexture(main: .Character_Delta)
           localWingTexture = global.getMainTexture(main: .Character_Delta_Wing)
        case .Arcana:
             localMainTexture = SKTexture(imageNamed: "\(char.string + "_idle1")")
             localWingTexture = global.getMainTexture(main: .Character_Delta_Wing)
        case .Alice:
             localMainTexture = SKTexture(imageNamed: "\(char.string + "_idle1")")
        case .Jade:
            localMainTexture = SKTexture(imageNamed: "\(char.string + "_idle1")")
            
        default:
            // default - Warning
            localMainTexture = global.getMainTexture(main: .Character_Alpha)
            localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        }
        
        self.charType = char
        self.size = localMainTexture.size()

        node = SKSpriteNode(texture: localMainTexture)
        node.name = "toon"
        node.position = CGPoint(x: screenSize.width/2, y: 100)
        node.size = self.size
       
        let texture = SKTextureAtlas().loadAtlas(name: charType.string + "_Idle", prefix: nil)
        if texture.count >  0 {
            node.run(.repeatForever(.animate(with: texture, timePerFrame: 0.1)))
        }
        
        let l_wing = SKSpriteNode()
        let ww = 100
        let wh = 100
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
        
        node.addChild(r_wing)
    }
    
     func load(infoDict:NSDictionary){
        //Level lv: Int, Experience exp: CGFloat, Description description:[String]
         self.level = infoDict.value(forKey: "Level") as! Int
        self.experience = infoDict.value(forKey: "Experience") as! CGFloat
        self.description = infoDict.value(forKey: "Description") as! [String]
        self.title = infoDict.value(forKey: "Title") as! String
        let bulletLevel = infoDict.value(forKey: "BulletLevel") as! Int
        
         // REVISAR EL BULLETEVEL  EN EL CONSTRUCTOR PROJECTILE 
        bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: bulletLevel)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false
        node.physicsBody!.collisionBitMask =  0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask =  PhysicsCategory.Enemy

        // Apply Magnetic Field
         let mfield =  SKFieldNode.radialGravityField()
        mfield.region = SKRegion(radius: Float(node.size.width))
        mfield.strength =  120.0
        mfield.categoryBitMask = GravityCategory.Player
        node.addChild(mfield)
         if bullet == nil {
             fatalError("Error bullet")
         }
        
    }
    
     func getNode() -> SKSpriteNode{
        return node
    }

     func updateProjectile(node:SKSpriteNode){
         bullet!.setPos(x: node.position.x,y:node.position.y)
     }
    
   
    // MARK: ANIMATE TEXTURE ATTACK
    func attack(scene:SKScene?,gameState:GameState) ->SKAction? {
       
        
        let textures = SKTextureAtlas().loadAtlas(name: "Alice_Attack", prefix: nil)
        
        guard let emitterFlame = SKEmitterNode(fileNamed: "flameSword") else { return nil}
        emitterFlame.name = "flameWord"
        
        let emitterAura = SKEmitterNode(fileNamed: "AuraFire")!
        emitterAura.name = "AuraFire"
        
        let action = SKAction.sequence([
            SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false),
            .run {
               
                emitterFlame.targetNode = self.node
                emitterFlame.position.y = 80
                emitterFlame.particleAlpha = 0.3
                emitterFlame.run(.sequence([.wait,.removeFromParent()]))
                emitterAura.targetNode = self.node
                emitterAura.position.y = -80
                emitterAura.run(.sequence([.wait,.removeFromParent()]))
                self.node.addChild(self.showAuraShield(atlas: "AuraPlayer",gameState: gameState))
                self.node.addChild(emitterFlame)
                self.node.addChild(emitterAura)
                self.node.run(.move(to: CGPoint(x: screenSize.width/2, y: screenSize.height/2-150), duration: 0.3))
                
            },
            .wait(forDuration: 2),
            .setTexture(textures.first!, resize: false),
            .run {
                self.node.childNode(withName: "AuraPlayer")?.removeFromParent()
                self.node.run(.move(to: CGPoint(x: screenSize.width/2, y: 100), duration: 0.3))
                emitterAura.removeFromParent()
                emitterFlame.removeFromParent()
            }
        ])
        
        return action
    }
    
    // MARK: SHOW AURA SHIELD PLAYER
    func showAuraShield(atlas:String = "Shield",gameState:GameState) -> SKSpriteNode{
    
        
        let spriteAura = SKSpriteNode()
        spriteAura.name = atlas
        spriteAura.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteAura.size =  CGSize(width: node.size.width*3, height: node.size.width*3)
        
        spriteAura.physicsBody = SKPhysicsBody(circleOfRadius: spriteAura.size.width/2)
        spriteAura.physicsBody?.categoryBitMask = PhysicsCategory.Imune
        spriteAura.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy

        spriteAura.physicsBody?.affectedByGravity = false
        spriteAura.physicsBody?.allowsRotation = false
        spriteAura.physicsBody?.isDynamic = false
        if gameState == .Running {
            spriteAura.addChild(liveShield(size:nil))
        }
        
        let atlas = SKTextureAtlas().loadAtlas(name: atlas, prefix: nil)
        let action = SKAction.repeatForever(.animate(with: atlas, timePerFrame: 0.05, resize: false, restore: false))
        
        spriteAura.run(.sequence([action,.wait(forDuration: 15),.removeFromParent()]))
        
       
        return spriteAura
    }
    
    //MARK: GENERATES THE COUNTER FOR THE TIME OF THE PLAYER'S SHIELD OR FOR THE BULLET ICON
    /* Params:
     @duration:Int   Duration time for shield o bullet
     @size:Float     radius by circle 
    */
                    
    
    func liveShield(duration:Int? = 15,size:CGFloat?) -> SKShapeNode {

        let size = size != nil ? size : self.node.size.width * 1.2

        let circle = SKShapeNode(circleOfRadius: size!)
        circle.fillColor = SKColor.green.withAlphaComponent(0.3)
        circle.glowWidth = 1
        circle.strokeColor = .white.withAlphaComponent(0.5)
        circle.zRotation = CGFloat.pi / 2
        circle.zPosition = -1

        countdown(circle: circle, steps: 15, duration: TimeInterval(duration!)) {
             self.node.childNode(withName: "spriteAura")?.removeFromParent()
             self.node.childNode(withName: "Shield")?.removeFromParent()
             self.node.childNode(withName: "AuraPlayer")?.removeFromParent()
        }
        
        return circle
    }
    
    // Creates an animated countdown timer
    func countdown(circle:SKShapeNode, steps:Int, duration:TimeInterval, completion:@escaping ()->Void) {
       
        guard let path = circle.path else {
            return
        }
        let radius = path.boundingBox.width/2
        let timeInterval = duration/TimeInterval(steps)
        let incr = 1 / CGFloat(steps)
        var percent = 1.0

        let animate = SKAction.run {
            percent -= incr
           
            if percent < 0.50 {
                circle.fillColor = .systemOrange.withAlphaComponent(0.5)
            } else  if  percent < 0.25 {
                circle.fillColor = .systemRed.withAlphaComponent(0.5)
            }
            
            circle.path = self.circle(radius: radius, percent:percent)
        }
        let wait = SKAction.wait(forDuration:timeInterval)
        let action = SKAction.sequence([wait, animate])

        circle.run(SKAction.repeat(action,count:steps-1)) {
            circle.run(SKAction.wait(forDuration:timeInterval)) {
                circle.path = nil
                completion()
            }
        }
    }
    
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath {
      
       let start:CGFloat = 0
       let end = CGFloat(Double.pi*2) * percent
       let center = CGPointZero
       let bezierPath = UIBezierPath()
            bezierPath.move(to: center)
            bezierPath.addArc(withCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            bezierPath.miterLimit = 10
            bezierPath.addLine(to: center)
        
        return bezierPath.cgPath
       }
    
    
    func changeTextureProjectile(level:Int) {
        
        self.level = level
        bullet?.bulletLevel = level
        bullet = Projectile(posX: 0, posY: 0, char: getCharacter(), bulletLevel: getBulletLevel())
     
    }
 
     func getBullet() -> Projectile?{
         
        return bullet ?? nil
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
    
      func lessLevel()  {
          
          if level > 1 {
              level -= 1
          } else {
              level = 1
          }
    }
    
     func getLevel() -> Int{
        level
    }
    
    func addLevel() {
        level += 1
        
    }
    
     func advanceBulletLevel() -> Bool{
         guard bullet != nil else { return false}

         return self.bullet!.upgrade()
    }
    // Remove below function later on. Combine it with getToonName
     func getCharacter() -> Character{
        return charType
    }
    
    
    func getTextureCurrentToon() -> Global.Main? {
        
        let name = "Character_\(getToonName().capitalized)"
        print("Name \(name)")
        
        return   Global.Main.Character_Alpha
    }
}
