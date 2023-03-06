//
//  Toon.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
import Foundation
import SpriteKit


protocol ProtocolToonTextures{
    
    var pathTextures:String  { get }
    var bgSword:[SKTexture]? { get }
    var sword:CGImage?       { get }
    var head:CGImage?        { get }
    var hair:CGImage?        { get }
    var mane:CGImage?        { get }
    var diadem:CGImage?      { get }
    var body:CGImage?        { get }
    var wing:CGImage?        { get }
    var wingShort:CGImage?   { get }
    var forearm:CGImage?     { get }
    var arm:CGImage?         { get }
    var hand:CGImage?        { get }
    var legL:CGImage?        { get }
    var legR:CGImage?        { get }
    var skirt:CGImage?       { get }
    var hat:CGImage?         { get }
    var extraSword:[SKTexture]? { get }
}

protocol ProtocolJoinToon {
    
    func joinToon(charType:Toon.Character) -> SKNode
    
    func joinAlice(charType:Toon.Character) -> SKNode
}



class Toon{
   
    
    enum Character:String,CaseIterable{
        case Arcana
        case Lyra
        case Trixie
        case Lucia
        case Neve
        case Alice
        case Fiona
        case Sophia
        case Lily
        case Aurora
        case Lenore
        case Jade
        
        var string:String{
            let name = String(describing: self)
            return name
        }
        
        var pathAura:String {
            "auras.png"
        }
        var auraEffect:[CGImage]  {
            [
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 7, y: 20, width: 100, height: 202)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 123, y: 12, width: 100, height: 202)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 227, y: 7, width: 100, height: 202)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 7, y: 242, width: 100, height: 181))
            ]
        }
        
        var ringBlueAuraEffect:[CGImage]  {
            [
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 2, y: 425, width: 115, height: 113)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 236, y: 242, width: 116, height: 114)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 237, y: 361, width: 116, height: 114)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 354, y: 359, width: 116, height: 114))
            ]
        }
        
        var ringPurpleAuraEffect:[CGImage]  {
            [
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 567, y: 3, width: 114, height: 111)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 567, y: 115, width: 114, height: 111)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 448, y: 117, width: 118, height: 118)),
                UIImage(named: pathAura)!.cgImage!.cropImage(to: CGRect(x: 566, y: 226, width: 110, height: 110))
            ]
        }
    }
    
    deinit {
        print("Toon deinit")
        
    }
    
    private var size:CGSize
    private var node:SKSpriteNode = SKSpriteNode()
    private var bullet:Projectile?
    private var description:[String] = []
    private var experience:CGFloat = 0
    private var title:String = "None"
    var level:Int = 1 // For future use
 
    // Initialize
    private var charType:Character
    
    
    init(char:Character){
        
        self.charType = .Alice
        self.size = CGSize(width: 100,height: 150)

        node.addChild(charType.joinToon(charType: charType))
        node.zPosition = 1
        node.name = "toon"
    }
    
     func load(infoDict:NSDictionary){

        self.level = infoDict.value(forKey: "Level") as! Int
        self.experience = infoDict.value(forKey: "Experience") as! CGFloat
        self.description = infoDict.value(forKey: "Description") as! [String]
        self.title = infoDict.value(forKey: "Title") as! String
        let bulletLevel = infoDict.value(forKey: "BulletLevel") as! Int
        
         // REVISAR EL BULLETEVEL  EN EL CONSTRUCTOR PROJECTILE 
        bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: bulletLevel)
        addPhysics()

         /*
        // Apply Magnetic Field
         let mfield =  SKFieldNode.radialGravityField()
         mfield.region = SKRegion(radius:  Float(size.height))
         mfield.strength =  120.0
         mfield.categoryBitMask = GravityCategory.Player
         node.addChild(mfield)*/
         if bullet == nil {
             fatalError("Error bullet")
         }
        
    }
    
    func addPhysics() {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width/2, height: size.height/2))
        node.physicsBody!.isDynamic = true 
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false
        node.physicsBody!.collisionBitMask =  0
        node.physicsBody!.category = [.Player]
        node.physicsBody!.contactTestBitMask =  PhysicsCategory.Enemy.rawValue
    }
    
     func getNode() -> SKSpriteNode{
         return  node
    }

     func updateProjectile(node:SKSpriteNode){
         bullet!.setPos(x: node.position.x,y:node.position.y)
     }
    
    
    func addRindBlueEffect(ringPurpleActive:Bool) -> SKSpriteNode {
        
        let ringAtlas = charType.ringBlueAuraEffect.compactMap { SKTexture(cgImage: $0)}
        
        let  fireAura = SKSpriteNode()
             fireAura.size = CGSize(width: size.width*3, height: size.width*3)
             fireAura.position.y = size.height/2
             fireAura.zPosition = self.node.zPosition-1
             fireAura.run(.repeatForever(.animate(with: ringAtlas, timePerFrame: 0.1,resize: true,restore: true)),withKey: "auraRingBlue")
    
        if ringPurpleActive {
            fireAura.addChild(addPurpleEffect(size:fireAura.size))
        }
        return fireAura
    }
    
    func addPurpleEffect(size:CGSize) -> SKSpriteNode {
        
        let ringAtlas = charType.ringPurpleAuraEffect.compactMap { SKTexture(cgImage: $0)}
        
        let  fireAura = SKSpriteNode()
             fireAura.size = size
             fireAura.run(.repeatForever(.animate(with: ringAtlas, timePerFrame: 0.1,resize: true,restore: true)),withKey: "auraPurpleBlue")
    
        return fireAura
    }
    
   
    // MARK: ANIMATE TEXTURE ATTACK
    func attack(scene:SKScene?,gameState:GameState) ->SKAction? {
        
        let  fireAtlas = charType.auraEffect.compactMap { SKTexture(cgImage: $0) }

        var sword:SKSpriteNode  {
            let bgsword = charType.animateSword
                bgsword.name = "swordNode"
                bgsword.position.y = 70
                bgsword.run(.sequence([
                    .run {
                        self.punch(location: bgsword.position)
                    },
                SKAction.wait(forDuration: 4),
                .run {
                    bgsword.removeAllChildren()
                    bgsword.removeAllActions()
                    bgsword.removeFromParent()
                }]))
            
            return bgsword
        }
      
        node.addChild(sword)
        
        let  fireAura = SKSpriteNode()
             fireAura.size = CGSize(width: size.width, height: size.width)
             fireAura.zPosition = node.zPosition-1
             fireAura.position.y = -60
             fireAura.run(.repeatForever(.animate(with: fireAtlas, timePerFrame: 0.1,resize: true,restore: true)),withKey: "aurafire")
        
             fireAura.addChild(addRindBlueEffect(ringPurpleActive: true))

            node.addChild(fireAura)
        
        return .sequence([
            .applyImpulse(CGVector(dx: 0, dy: 100), duration: 1),
            SKAction.run {
                self.node.physicsBody = nil
            },
            .wait(forDuration:1),
            SKAction.run {
                self.addPhysics()
                fireAura.removeAllChildren()
                fireAura.removeFromParent()
            },
            .move(to: CGPoint(x: screenSize.width/2, y: 150), duration: 0.1)
        ])
    }
    
    func punch(location:CGPoint) {
        
        let upperArmL =  (node.children.filter { $0.name == "nodeToon"}.first!.childNode(withName: "nodeArmL")?.childNode(withName: "upperArm"))!
       
        let upperArmR =  (node.children.filter { $0.name == "nodeToon"}.first!.childNode(withName: "nodeArmR")?.childNode(withName: "upperArm"))!
     
        upperArmL.run(.sequence([
            SKAction.rotate(toAngle: CGFloat(-190).toRadians(), duration: 0.5, shortestUnitArc: true),
            .wait(forDuration: 3),
            SKAction.rotate(toAngle: CGFloat(-25).toRadians(), duration: 0.5, shortestUnitArc: true)
            ]))
        
        upperArmR.run(.sequence([
            SKAction.rotate(toAngle: CGFloat(-190).toRadians(), duration: 0.5, shortestUnitArc: true),
            .wait(forDuration: 3),
            SKAction.rotate(toAngle: CGFloat(-25).toRadians(), duration: 0.5, shortestUnitArc: true)
            ]))
    }
    
    // MARK: SHOW AURA SHIELD PLAYER
    func showAuraShield(atlas:String = "Shield",gameState:GameState) -> SKSpriteNode{
    
        
        let spriteAura = SKSpriteNode()
        spriteAura.name = atlas
        spriteAura.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteAura.size =  CGSize(width: size.width*3, height: size.width*3)
        
        spriteAura.physicsBody = SKPhysicsBody(circleOfRadius: spriteAura.size.width/2)
        spriteAura.physicsBody?.category = [.Imune]
        spriteAura.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy.rawValue

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

        let size = size != nil ? size : self.size.width * 1.2

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
        
         bullet
    }

    func getToonDescription() -> [String]{
         description
    }
    
    func getToonName() -> String{
         charType.rawValue
    }
    
    func getToonTitle() -> String{
         title
    }
    
    func getBulletLevel() -> Int{
    
         bullet!.getBulletLevel()
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

    func getCharacter() -> Character{
        return charType
    }
    
    func getTextureCurrentToon() -> Global.Main? {
        
        let name = "Character_\(getToonName().capitalized)"
        print("Name \(name)")
        
        return   Global.Main.Character_Alpha
    }
}


extension Toon.Character:ProtocolToonTextures {
    
    
    var pathTextures: String {
        "fairy_\(self.rawValue)1".lowercased()
    }
    
    var bgSword: [SKTexture]? {
        switch self {
        case .Arcana: return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 192, y: 17, width: 72, height: 60))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 267, y: 4, width: 71, height: 70))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 193, y: 85, width: 69, height: 65))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 341, y: 3, width: 69, height: 65)))
        ]
        case .Lyra:   return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 533, y: 657, width: 43, height: 41))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 534, y: 725, width: 42, height: 41))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 614, y: 710, width: 43, height: 41))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 745, y: 251, width: 42, height: 41))),
            ]
            
        case .Trixie: return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 6, y: 757, width: 76, height: 81))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 94, y: 757, width: 77, height: 84))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 178, y: 755, width: 76, height: 84))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 265, y: 755, width: 76, height: 85))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 350, y: 753, width: 76, height: 85))),
            ]
        case .Lucia:  return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 8, y: 355, width: 22, height: 64))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 45, y:355, width: 23, height: 65))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 84, y: 355, width: 23, height: 64))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 357, y: 336, width: 22, height: 65))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 358, y: 259, width: 22, height: 65))),
            ]
        case .Neve:   return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 374, y: 577, width: 106, height: 49))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 481, y: 571, width: 106, height: 65))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 469, y: 644, width: 102, height: 90))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 897, y: 1, width: 49, height: 50)))
            ]
        case .Alice:  return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 239, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 280, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 323, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 366, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 410, y: 717, width: 34, height: 63))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 453, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 494, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 537, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 581, y: 717, width: 34, height: 62))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 621, y: 717, width: 34, height: 63))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 663, y: 717, width: 34, height: 63))),
        ]
        case .Fiona:  return  [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 224, y: 7, width: 54, height: 56))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 286, y: 5, width: 54, height: 56))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 359, y: 5, width: 54, height: 56))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 353, y: 81, width: 54, height: 56))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 268, y: 82, width: 54, height: 56))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 138, y: 131, width: 54, height: 56))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 267, y: 161, width: 54, height: 61)))
        ]
        case .Sophia: return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 290, y: 8, width: 44, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 344, y: 4, width: 53, height: 56))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 403, y: 7, width: 47, height: 55))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 404, y: 75, width: 46, height: 55))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 353, y: 73, width: 47, height: 55))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 297, y: 75, width: 47, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 391, y: 143, width: 47, height: 55))),
            ]
        case .Lily:   return nil
        case .Aurora: return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 277, y: 7, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 314, y: 7, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 313, y: 57, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 277, y: 57, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 314, y: 107, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 312, y: 156, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 275, y: 156, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 274, y: 205, width: 26, height: 38))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 311, y: 207, width: 26, height: 38))),
            ]
        case .Lenore: return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 269, y: 9, width: 61, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 351, y: 9, width: 61, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 433, y: 9, width: 61, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 420, y: 89, width: 61, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 268, y: 88, width: 61, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 228, y: 166, width: 61, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 311, y: 167, width: 61, height: 53))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 421, y: 168, width: 61, height: 53))),
            ]
        case .Jade:   return [
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 305, y: 5, width: 40, height: 40))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 175, y: 260, width: 47, height: 46))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 229, y: 260, width: 46, height: 46))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 214, y: 207, width: 46, height: 46))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 268, y: 299, width: 46, height: 46))),
            SKTexture(cgImage:UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 224, y: 305, width: 46, height: 46)))
        ]
        }
    }
    
    var extraSword: [SKTexture]? {
        switch self {
        case .Arcana: return nil
        case .Lyra:   return nil
        case .Trixie: return nil
        case .Lucia:  return nil
        case .Neve:   return nil
        case .Alice:  return nil
        case .Fiona:  return nil
        case .Sophia: return nil
        case .Lily:   return nil
        case .Aurora: return [
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 286, y: 105, width: 14, height: 20))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 364, y: 128, width: 14, height: 20))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 347, y: 101, width: 14, height: 20))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 364, y: 101, width: 14, height: 20))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 347, y: 124, width: 14, height: 20))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 364, y: 124, width: 14, height: 20))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 347, y: 147, width: 14, height: 20))),
            SKTexture(cgImage: UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 364, y: 147, width: 14, height: 20)))
            ]
        case .Lenore: return nil
        case .Jade:   return nil
        }
    }
    
    var sword: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 287, width: 34, height: 73))
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 262, y: 403, width: 52, height: 118))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 179, y: 271, width: 47, height: 74))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 266, y: 527, width: 106, height: 42))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 570, y: 246, width: 25, height: 60))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 116, y: 158, width: 16, height: 81))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 353, y: 271, width: 31, height: 51))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 163, y: 151, width: 28, height: 72))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 169, y: 142, width: 47, height: 84))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 162, y: 207, width: 13, height: 47))
        }
    }
        
    var animateSword:SKSpriteNode {
                
            let sword = SKSpriteNode(texture: SKTexture(cgImage: sword!))
            let bg = SKSpriteNode(texture: bgSword?.first!)
                bg.position.y = 30
                bg.run(.repeatForever(.animate(with: bgSword!, timePerFrame: 0.1)))
                if let extra = extraSword {
                    let  ex = SKSpriteNode(texture:  extra.first!)
                         ex.position.y = bg.position.y-30
                         ex.run(.repeatForever(.animate(with: extra, timePerFrame: 0.1)))
                         bg.addChild(ex)
                }
                sword.addChild(bg)
            return sword
    }
    var head: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 232, y: 298, width: 47, height: 41))
        case .Lyra:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 701, y: 330, width: 45, height: 52))
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 900, y: 94, width: 34, height: 33))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 230, y: 388, width: 44, height: 31))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 499, y: 816, width: 60, height: 46))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 705, y: 138, width: 39, height: 29))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 361, y: 155, width: 48, height: 36))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 410, y: 328, width: 40, height: 28))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 60, y: 270, width: 56, height: 36))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 326, y: 438, width: 34, height: 28))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 268, y: 221, width: 41, height: 29))
        }
    }
    var hair: CGImage? {
        switch self {
        case .Arcana: return nil
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 684, y: 570, width: 25, height: 41))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 458, y: 159, width: 27, height: 28))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 849, y: 273, width: 35, height: 76))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 316, y: 670, width: 19, height: 41))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 233, y: 82, width: 21, height: 24))
        case .Sophia: return nil
        case .Lily:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 385, y: 272, width: 21, height: 42))
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 348, y: 26, width: 25, height: 34))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 327, y: 470, width: 28, height: 25))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 172, y: 315, width: 18, height: 38))
        }
    }
    var mane: CGImage? {
        switch self {
        case .Arcana: return nil
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 796, y: 308, width: 49, height: 33))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 427, y: 204, width: 37, height: 23))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 809, y: 835, width: 53, height: 53))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 684, y: 463, width: 28, height: 32))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 186, y: 404, width: 18, height: 8))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 410, y: 361, width: 28, height: 31))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 348, y: 3, width: 38, height: 19))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 84, y: 324, width: 37, height: 21))
        case .Jade:   return nil
        }
    }
   
    var hat:CGImage? {
            switch self {
            case .Arcana: return nil
            case .Lyra:   return nil
            case .Trixie: return nil
            case .Lucia:  return nil
            case .Neve:   return nil
            case .Alice:  return nil
            case .Fiona:  return nil
            case .Sophia: return nil
            case .Lily:   return nil
            case .Aurora: return nil
            case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 219, y: 142, width: 17, height: 16))
            case .Jade:   return nil
            }
    }
    
    var diadem: CGImage? {
        switch self {
        case .Arcana: return nil
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 378, y: 559, width: 32, height: 12))
        case .Lucia:  return nil
        case .Neve:   return nil
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 714, y: 462, width: 30, height: 13))
        case .Fiona:  return nil
        case .Sophia: return nil
        case .Lily:   return nil
        case .Aurora: return nil
        case .Lenore: return nil
        case .Jade:   return nil
        }
    }
    
    var body: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 153, y: 114, width: 29, height: 26))
        case .Lyra:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 460, y: 432, width: 20, height: 29))
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 120, y: 887, width: 21, height: 25))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 420, y: 231, width: 25, height: 26))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 888, y: 756, width: 23, height: 26))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 714, y: 478, width: 21, height: 26))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 163, y: 208, width: 22, height: 27))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 3, y: 431, width: 21, height: 24))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 348, y: 66, width: 26, height: 30))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 383, y: 164, width: 25, height: 29))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 178, y: 209, width: 22, height: 26))
        }
    }
    
    
    var wing: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 339, y: 69, width: 59, height: 35))
        case .Lyra:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 586, y: 505, width: 83, height: 51))
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 433, y: 816, width: 63, height: 47))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 348, y: 3, width: 75, height: 41))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 81, y: 852, width: 72, height: 31))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 345, y: 522, width: 65, height: 24))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 186, y: 362, width: 65, height: 40))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 321, y: 211, width: 64, height: 57))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 193, y: 198, width: 63, height: 49))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 328, y: 400, width: 70, height: 34))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 120, y: 322, width: 39, height: 32))
        }
    }
    
    var wingShort: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 180, y: 329, width: 29, height: 25))
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 847, y: 435, width: 46, height: 24))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 230, y: 349, width: 66, height: 37))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 797, y: 275, width: 48, height: 26))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 420, y: 213, width: 45, height: 22))
        case .Fiona:  return nil
        case .Sophia: return nil
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 270, width: 55, height: 43))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 341, y: 114, width: 39, height: 28))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 312, y: 50, width: 26, height: 28))
        }
    }
    
    var forearm: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 78, y: 269, width: 8, height: 16))
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 694, y: 617, width: 10, height: 15))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 299, y: 410, width: 10, height: 16))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 681, y: 617, width: 10, height: 15))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 413, y: 534, width: 9, height: 15))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 117, y: 242, width: 7, height: 13))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 233, y: 351, width: 6, height: 13))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 105, y: 252, width: 10, height: 16))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 240, y: 141, width: 6, height: 16))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 178, y: 240, width: 9, height: 14))
        }
    }
    
    
    var arm: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 401, y: 70, width: 7, height: 22))
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 882, y: 248, width: 8, height: 21))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 481, y: 112, width: 7, height: 22))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 937, y: 96, width: 7, height: 20))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 152, y: 767, width: 8, height: 20))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 255, y: 392, width: 6, height: 19))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 233, y: 329, width: 6, height: 19))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 164, y: 227, width: 10, height: 22))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 493, y: 83, width: 6, height: 23))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 303, y: 51, width: 7, height: 20))
        }
    }
    
    var hand: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 211, y: 343, width: 9, height: 7))
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 414, y: 865, width: 10, height: 8))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 457, y: 191, width: 9, height: 9))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 886, y: 707, width: 12, height: 44))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 702, y: 497, width: 8, height: 8))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 207, y: 404, width: 8, height: 8))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 310, y: 240, width: 7, height: 6))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 376, y: 25, width: 9, height: 8))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 492, y: 110, width: 9, height: 7))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 203, y: 343, width: 8, height: 8))
        }
    }
    
    var legL: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 216, y: 287, width: 14, height: 46))
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 449, y: 750, width: 12, height: 44))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 216, y: 350, width: 11, height: 44))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 886, y: 708, width: 12, height: 42))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 413, y: 494, width: 10, height: 36))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 220, y: 82, width: 10, height: 37))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 296, y: 228, width: 10, height: 38))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 273, y: 105, width: 10, height: 43))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 489, y: 319, width: 10, height: 49))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 274, y: 168, width: 12, height: 49))
        }
    }
    
    var legR: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 216, y: 231, width: 13, height: 51))
        case .Lyra:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 887, y: 710, width: 10, height: 42))
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 434, y: 750, width: 11, height: 51))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 373, y: 48, width: 12, height: 47))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 882, y: 194, width: 11, height: 51))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 629, y: 651, width: 12, height: 42))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 331, y: 80, width: 11, height: 46))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 220, y: 329, width: 9, height: 43))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 270, y: 253, width: 10, height: 46))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 489, y: 370, width: 11, height: 44))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 274, y: 109, width: 11, height: 54))
        }
    }
    
    var skirt: CGImage? {
        switch self {
        case .Arcana: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 180, y: 298, width: 29, height: 28))
        case .Lyra:   return nil
        case .Trixie: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 901, y: 53, width: 42, height: 16))
        case .Lucia:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 428, y: 51, width: 59, height: 57))
        case .Neve:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 80, y: 887, width: 36, height: 23))
        case .Alice:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 706, y: 171, width: 33, height: 20))
        case .Fiona:  return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 135, y: 207, width: 24, height: 30))
        case .Sophia: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 259, y: 229, width: 32, height: 20))
        case .Lily:   return nil
        case .Aurora: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 194, y: 153, width: 72, height: 39))
        case .Lenore: return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 342, y: 83, width: 48, height: 28))
        case .Jade:   return UIImage(named: pathTextures)!.cgImage!.cropImage(to: CGRect(x: 313, y: 81, width: 16, height: 23))
        }
    }
}

extension Toon.Character:ProtocolJoinToon {
   
    
    func joinToon(charType chartType:Toon.Character) -> SKNode {
         joinAlice(charType: chartType)
    }
    
    func joinAlice(charType:Toon.Character) -> SKNode {
        
    let node = SKNode()
        node.name = "nodeToon"
        let body = SKSpriteNode(texture: SKTexture(cgImage: body!))
            body.name = "body"
            node.addChild(body)
                
        let skirt = SKSpriteNode(texture: SKTexture(cgImage: skirt!))
            skirt.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt.zPosition = body.zPosition-1
            skirt.constraints = [
                SKConstraint.positionX(SKRange(constantValue: 1), y: SKRange(constantValue: -body.frame.height*0.4)),
            //    SKConstraint.distance(SKRange(constantValue: -body.frame.height*0.51), to: body.centerRect.origin, in: body)
            ]
            body.addChild(skirt)
        
        let head =  SKSpriteNode(texture: SKTexture(cgImage: head!))
            head.anchorPoint = CGPoint(x: 0.5, y: 0)
            head.constraints = [
                SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 12)),
            ]
            body.addChild(head)
       
        if mane != nil {
            let mane = SKSpriteNode(texture: SKTexture(cgImage: mane!))
            head.addChild(mane)
        }
        
        if hair != nil {
            let hair = SKSpriteNode(texture: SKTexture(cgImage: hair!))
            hair.position.y = 8
            head.addChild(hair)
           
            if hat != nil {
                let hat = SKSpriteNode(texture: SKTexture(cgImage: hat!))
                hat.position = CGPoint(x: -10, y: head.frame.height)
                head.addChild(hat)
            }
            
            if diadem != nil {
                let diadem = SKSpriteNode(texture: SKTexture(cgImage: diadem!))
                hair.addChild(diadem)
            }
        }
        
        
        
        let rotationReachL = SKReachConstraints(lowerAngleLimit: CGFloat(-5).toRadians(), upperAngleLimit: CGFloat(-170).toRadians())
        let lookContraint = [SKConstraint.positionX(SKRange(constantValue: 0),y: SKRange(constantValue: 0))]
        
        let nodeArmL = SKNode()
            nodeArmL.name = "nodeArmL"
            nodeArmL.reachConstraints = rotationReachL
            nodeArmL.constraints = lookContraint
            nodeArmL.zPosition = head.zPosition-1
        
        let upperArm = SKSpriteNode(texture: SKTexture(cgImage: arm!))
            upperArm.name = "upperArm"
            upperArm.anchorPoint = CGPoint(x: 0, y: 1)
            upperArm.position = CGPoint(x: -10, y: arm!.height/2)
            upperArm.zRotation = CGFloat(-25).toRadians()
        
        let midArm = SKSpriteNode(texture: SKTexture(cgImage: forearm!))
            midArm.name = "midArm"
            midArm.anchorPoint = CGPoint(x: 0, y: 1)
            midArm.position = CGPoint(x: 0, y: -arm!.height)
            upperArm.addChild(midArm)
       
        let lowerArm = SKSpriteNode(texture: SKTexture(cgImage: hand!))
            lowerArm.name = "lowerArm"
            lowerArm.anchorPoint = CGPoint(x: 0, y: 1)
            lowerArm.position = CGPoint(x: 0, y: -(forearm!.height - hand!.height/2))
            midArm.addChild(lowerArm)
     
        nodeArmL.addChild(upperArm)
        node.addChild(nodeArmL)
        
        let nodeArmR = nodeArmL.copy() as! SKNode
            nodeArmR.xScale = -1
            nodeArmR.position.x = 1
            nodeArmR.name = "nodeArmR"
            nodeArmR.zRotation = CGFloat(0).toRadians()
            nodeArmR.constraints = lookContraint
            
            node.addChild(nodeArmR)
        
        let legL = SKSpriteNode(texture: SKTexture(cgImage: legL!))
            legL.constraints = [
                SKConstraint.positionX(SKRange(constantValue: -legL.frame.width/2), y: SKRange(constantValue: -body.frame.height*1.8)),
                SKConstraint.distance(SKRange(constantValue: body.frame.height*1.8), to: body.centerRect.origin, in: body)
            ]
            legL.zPosition = skirt.zPosition-1
            body.addChild(legL)
        
        let legR = SKSpriteNode(texture: SKTexture(cgImage: legR!))
            legR.constraints = [
                SKConstraint.positionX(SKRange(constantValue: legR.frame.width/2), y: SKRange(constantValue: -body.frame.height*2)),
                SKConstraint.distance(SKRange(constantValue: body.frame.height*2), to: body.centerRect.origin, in: body)
            ]
            legR.zPosition = skirt.zPosition-1
            body.addChild(legR)
   /*
        let nodeWingsL =  SKNode()
            nodeWingsL.name = "wings"
            
            let wing = SKSpriteNode(texture: SKTexture(cgImage: wing!))
                wing.anchorPoint = CGPoint(x: 1, y: 0.5)
                wing.run(.repeatForever(.sequence([.resize(toWidth: wing.size.width*0.1, duration: 0.3),.resize(toWidth: wing.size.width, duration: 0.3)])))
                nodeWingsL.addChild(wing)
        
        if wingShort != nil {
            let wingShort = SKSpriteNode(texture: SKTexture(cgImage: wingShort!))
            wingShort.anchorPoint = CGPoint(x: 1, y: 0.5)
            wingShort.position.y = -wing.size.height/2
            wingShort.run(.repeatForever(.sequence([.resize(toWidth: wingShort.size.width*0.1, duration: 0.3),.resize(toWidth: wingShort.size.width, duration: 0.3)])))
            nodeWingsL.addChild(wingShort)
        }
       
        body.addChild(nodeWingsL)
        
        let nodeWingR = nodeWingsL.copy() as! SKNode
            nodeWingR.xScale = -1
            body.addChild(nodeWingR)
        */
    
    return node
        
    }
    
    
}
