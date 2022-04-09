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





class Enemy: SKSpriteNode{
    
    
    var hp:CGFloat = 0
    var maxHp:CGFloat = 0
    
     convenience required init(hp: CGFloat){
        self.init()
        self.hp = hp
        self.maxHp = hp
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
        rootBar.size = bar.size//abs(border.frame.minX) + abs(border.frame.maxX)
        rootBar.color = .clear
        rootBar.name = "rootBar"
        rootBar.addChild(bar)
        
        self.addChild(rootBar)
    }
    
    func Physics(speed:CGVector) {
       
   
       self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
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
                    self.attack()
                }
                else if node.position.y > screenSize.height{
                   
                }
                }, SKAction.wait(forDuration: 2)]))]))
        }
    
    func attack(){
       
        print("Atack \(self.name)")
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run {
            let random = randomInt(min: 0, max: 100)
            if (random > 80){
              
                let att = SKSpriteNode(texture: global.getAttackTexture(attack: .Boss1_type_1))
                att.size = CGSize(width: 30, height: 30)
                att.name = "\(String(describing: self.name))_Attack"
                att.physicsBody = SKPhysicsBody(circleOfRadius: 15)
                att.physicsBody!.isDynamic = true
                att.physicsBody!.affectedByGravity = true
                att.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
                att.physicsBody!.contactTestBitMask = PhysicsCategory.Player
                att.physicsBody!.fieldBitMask = GravityCategory.Player
                att.physicsBody!.collisionBitMask = 0
                

                att.run(SKAction.sequence([SKAction.wait(forDuration: 3.5), SKAction.removeFromParent()]))
                self.addChild(att)
                
                let force = CGVector(dx: 0, dy: randomInt(min: -100, max: 0))
                att.run(SKAction.applyForce(force, duration: 1))
                
              
            }
        }])))
    }
    
    func defeated(actionsDead:[SKTexture]){
        self.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.run( SKAction.sequence([SKAction.animate(with: SKTextureAtlas().loadAtlas(name: "default_regular_dead", prefix: nil), timePerFrame: 0.11),SKAction.run {
            self.removeAllActions()
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
        self.physicsBody?.contactTestBitMask =  PhysicsCategory.Wall
        self.physicsBody?.linearDamping =  1
  
     //    self.run(.applyForce(CGVector(dx: Bool.random() ? 100 : -100, dy: -100), duration: 1))
        
    }
}
