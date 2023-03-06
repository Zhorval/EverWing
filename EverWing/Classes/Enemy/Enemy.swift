//
//  Enemy.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import SpriteKit
import GameKit
import GameplayKit



class Enemy: SKSpriteNode,ProcotolHP{
   
    var delegate: GameInfoDelegate?
    
    typealias T = EnemyType
    
    typealias B = BossType
    
    var actionsDead:[SKTexture] = []
    
    var bossShadow:SKTexture {
        SKTexture(cgImage: bossType.shadow)
    }
    
    var enemys:[Enemy] = []
    // Shared Variables
    var enemyType: EnemyType = T.Regular
    var enemyModel:Enemy?
    var currency:Currency? = Currency(type: Currency.CurrencyType.Coin)
    var bossType:BossType =  B.allCases.randomElement()!
    var BossBaseHP:CGFloat = 1500.0
    var RegularBaseHP:CGFloat = 100.0
    let defeadTexturesAtlas = SKTextureAtlas().loadAtlas(name: "default_regular_dead", prefix: nil)
    var velocity:CGVector = CGVector(dx: 0, dy: -350)
    
    var hp:CGFloat = 0
    var maxHp:CGFloat = 0
    
    deinit{}
    
    convenience required init(hp: CGFloat){
        self.init()
        self.hp = hp
        self.maxHp = hp * 2
        self.enemyModel = self
}
    
    func addHealthBar(isHidden:Bool = true){
        let w:CGFloat = size.width * 0.9
        let h:CGFloat = 10.0
        
        let shape = CGRect(x: 0, y: -5, width: w, height: h)
        let border = SKShapeNode(rect: shape, cornerRadius: 5)
        border.glowWidth = 1.5
        border.strokeColor = .black
        border.name = "hpBorder"
        border.lineWidth = 1.5
        
        let bar = SKSpriteNode()
        bar.anchorPoint.x = -0.01
        bar.name = "hpBar"
        bar.size = CGSize(width: w*0.98, height: h*0.8)
        bar.color = .green
        bar.zPosition = -0.1
        bar.position.x = -(bar.size.width/2)
        bar.position.y = -size.height/2 - 10
        bar.isHidden = isHidden
        bar.addChild(border)
        
        let rootBar = SKSpriteNode()
        rootBar.size = bar.size
        rootBar.color = .clear
        rootBar.name = "rootBar"
        rootBar.addChild(bar)
        
        self.addChild(rootBar)
    }
   
    func Physics(speed:CGVector) {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.category = [.Enemy]
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = PhysicsCategory.Player.rawValue
        self.physicsBody?.allowsRotation = false
        self.physicsBody!.velocity =  speed
        self.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by magnetic
   }
}




extension Enemy {
    
    func move(dir:MoveStyle,node:SKSpriteNode) {
        
        let rightVec = CGVector(dx: random(min: -100, max: 100), dy: 0)
        
        switch dir {
            case .Left:
                let force = CGVector(dx: randomInt(min: -500, max: -100), dy: -100)
                            node.run(.applyImpulse(force, duration: 1))
            case .Right:
                let force = CGVector(dx: randomInt(min: 100, max: 200), dy: -100)

                node.run(.applyImpulse(force, duration: 1))
            case .Random:
                node.run(.repeatForever(SKAction.move(by: rightVec, duration: 0.5)))
                
            case .Down:
                node.run(SKAction.moveBy(x: 0, y: -100, duration: 1))
            case .Up:
                    node.run(SKAction.moveTo(y: screenSize.maxY - node.size.height/2, duration: 2))
        }  
            
            // whenever it moves, it has chance to attack after 2.5 sec
        node.run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.repeatForever(SKAction.sequence([SKAction.run {
                let r = randomInt(min: 0, max: 15)
                if r <= 5{
                    self.attack(node: self, texture: nil)
                }
                else if node.position.y > screenSize.height{
                   
                }
                }, SKAction.wait(forDuration: 2)]))]))
        }
    
    func attack(node:Enemy,texture:SKTexture?,size:CGSize = CGSize(width: 30, height: 30)){
    
        guard let scene = delegate?.getScene() else { fatalError()}
        let atlas = SKTextureAtlas().loadAtlas(name: "Fire_Animation", prefix: "fire")
        self.run(SKAction.repeat(SKAction.sequence([
            SKAction.wait(forDuration: random(min: 0, max: 2)),
            SKAction.run {
               
                let att = SKSpriteNode(texture: atlas.first!, size: CGSize(width: self.size.width/2, height: self.size.height))
                
                att.position = self.position
                att.name = "Enemy_Ball_Hand"
                att.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width/2))
                att.physicsBody!.isDynamic = true
                att.physicsBody!.affectedByGravity = true
                att.physicsBody!.category = [.Enemy]
                att.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Imune.rawValue
                att.physicsBody?.fieldBitMask =  GravityCategory.Player
                
                att.run(SKAction.sequence([
                    .animate(with: atlas, timePerFrame: 0.2),
                    SKAction.wait(forDuration: 1),
                    SKAction.removeFromParent()
                ]))
                
                scene.addChild(att)
            
        }]),count: randomInt(min: 2, max: 4)))
    }
    
    func defeated(){
        
        self.run( SKAction.sequence([
            
            SKAction.animate(with: defeadTexturesAtlas, timePerFrame: 0.11),
                                     SKAction.run {
            self.removeAllActions()
            self.removeAllChildren()
            self.removeFromParent()
        }]))

    }
    
    func parametricPath(in rect: CGRect, count: Int? = nil, function: (CGFloat) -> (CGPoint)) -> UIBezierPath {
        
       let numberOfPoints = count ?? max(Int(rect.size.width), Int(rect.size.height))

       let path = UIBezierPath()
       let result = function(0)
       path.move(to: convert(point: CGPoint(x: result.x, y: result.y), in: rect))
      
            for i in 1 ..< numberOfPoints {
               let t = CGFloat(i) / CGFloat(numberOfPoints - 1)
               let result = function(t)
               path.addLine(to: convert(point: CGPoint(x: result.x, y: result.y), in: rect))
           }
       return path
   }
   
    func convert(point: CGPoint, in rect: CGRect) -> CGPoint {
       return CGPoint(
           x: rect.origin.x + point.x * rect.size.width,
           y: rect.origin.y + rect.size.height - point.y * rect.size.height
       )
   }
    
    func path(in rect: CGRect, count: Int? = nil, function: (CGFloat) -> (CGFloat)) -> UIBezierPath {
        let numberOfPoints = count ?? Int(rect.size.width)

        let path = UIBezierPath()
        path.move(to: convert(point: CGPoint(x: 0, y: function(0)), in: rect))
        for i in 1 ..< numberOfPoints {
            let x = CGFloat(i) / CGFloat(numberOfPoints - 1)
            path.addLine(to: convert(point: CGPoint(x: x, y: function(x)), in: rect))
        }
        return path
    }
    
    //MARK: One sine curve as it progresses across the width of the of the rect:
    func sinePath(in rect: CGRect, count: Int? = nil) -> UIBezierPath {
        // note, since sine returns values between -1 and 1, let's add 1 and divide by two to get it between 0 and 1
       
        // MARK: original
        // return path(in: rect, count: count) { (sin($0 * .pi * 2.0) + 1.0) / 2.0 }
        
        return path(in: rect, count: count) { (sin($0 * .pi  / random(min: 90, max: 180)) + 1.0) / 2.0 }

    }
    
    //MARK: One sine curve as it progresses across the width of the of the rect:
    func spiralPath(in rect: CGRect, count: Int? = nil) -> UIBezierPath {
       return parametricPath(in: rect, count: count) { t in
           let r = 1.0 - sin(t * .pi / 2.0)
           return CGPoint(
               x: (r * sin(t * 10.0 * .pi * 2.0) + 1.0) / 2.0,
               y: (r * cos(t * 10.0 * .pi * 2.0) + 1.0) / 2.0
           )
       }
   }
    
    func verticalSinePath(in rect: CGRect, count: Int? = nil) -> UIBezierPath {
       // note, since sine returns values between -1 and 1, let's add 1 and divide by two to get it between 0 and 1
       return parametricPath(in: rect, count: count) { CGPoint(
           x: (sin($0 * .pi * 2.0) + 1.0) / 2.0,
           y: $0
       ) }
   }
    
    func moveAndRotate(spriteNode: SKSpriteNode, toPosition position: CGPoint) {
        let angle = atan2(position.y -  self.position.y, position.x - self.position.x)

        let rotateAction = SKAction.rotate(toAngle: angle - -(CGFloat(Double.pi / 2)), duration: 0.5, shortestUnitArc: true)
        self.run(rotateAction)

        let offsetX = position.x - self.position.x
        let offsetY = position.y - self.position.y
        let normal = simd_normalize(simd_double2(x: Double(offsetX), y: Double(offsetY)))

    //    velocity = CGVector(dx: CGFloat(normal.x) * movePointsPerSecond, dy: CGFloat(normal.y) * movePointsPerSecond)
    }
    
    //MARK: INITIAL SETUP ENEMY
    func initialSetup(category:UInt32){
        
        let delay:Double = (self.name == "Pinky_Clone") ? 1.0 : 0.5
        
        self.run(SKAction.fadeIn(withDuration: delay))
        self.physicsBody?.categoryBitMask =  category //PhysicsCategory.Enemy
        self.physicsBody?.contactTestBitMask =  PhysicsCategory.Wall.rawValue
        self.physicsBody?.linearDamping =  1
    }
}
