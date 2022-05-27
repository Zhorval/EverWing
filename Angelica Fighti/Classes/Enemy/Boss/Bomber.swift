//
//  Bomber.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftUI


class Bomber:Enemy {
    
    
    
    private var currency:Currency = Currency(type: .Coin)
    
    private var typeBoss:BossType?
    
    private var timer:Timer?
    
    private var emitter:SKEmitterNode?
    
    // Main type ball fire BossType
    private var mainBallBoster:SKSpriteNode?
    
    // Hand type ball fire BossType
    private var handBallBoster:SKSpriteNode?
    
    private var actionsStandBy:[SKTexture] {
    
        return  typeBoss!.getTextures(type:  typeBoss!, prefix: nil)

    }
   
    private var gameToon = GameInfo()
    
    convenience init(hp:CGFloat,typeBoss:BossType){

        self.init()
        
      //  timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Attack), userInfo: self, repeats: true)

        self.typeBoss =   .Monster_Queen
        self.hp = 10000
        name = "Enemy_Boss"
        
        getAllBallHand()
        
        if self.typeBoss == .Monster_King {
            self.addChild(MonsterKingParts())
        
        } else if self.typeBoss == .Mildred {
            self.addChild(MildredParts())
            
        } else if self.typeBoss == .Ice_Queen {
            self.addChild(IceQueenParts())
            
        }  else if self.typeBoss == .Spike {
            self.addChild(SpikeParts())
            
        } else if self.typeBoss == .Monster_Queen {
            self.addChild(MonsterQueenParts())
            
        } else {
            texture =  actionsStandBy.first ??  global.getMainTexture(main: .Boss_1)
        }
        
        size = CGSize(width: 180, height: 130)
        position = CGPoint(x: screenSize.size.width/2, y: screenSize.size.height - size.height)
        alpha = 0
        userData = NSMutableDictionary()
        self.hp = hp
        self.maxHp = hp
        
        currency  = Currency(type: .Coin)

        
        // Set initial alpha
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.Imune
        self.physicsBody!.friction = 0
        self.physicsBody!.collisionBitMask = PhysicsCategory.Wall
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Wall
        self.physicsBody!.restitution = 1
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.linearDamping = 1
        self.physicsBody!.fieldBitMask = GravityCategory.None
        
       
        // adding healthbar
        self.addHealthBar()
        self.initialSetup(category: PhysicsCategory.Enemy)
        setAnimation()
    }
    
    deinit {
        guard let timer = timer else {
            return
        }

        timer.invalidate()
    }
    
    
    //MARK: GET BALL FIRE BY HAND TYPEBOSS
    private func getAllBallHand() {
        
        switch typeBoss {
            case .Ice_Queen:
                self.handBallBoster = SKSpriteNode(imageNamed: "Bubbles")
            case .Monster_King:
                self.handBallBoster = SKSpriteNode(imageNamed: "Bubbles")
                self.mainBallBoster = SKSpriteNode(imageNamed: self.typeBoss!.rawValue + "_Projectile")
            case .Mildred:
                self.handBallBoster = SKSpriteNode(imageNamed: "ballMildred")
            case .Spike:
                self.handBallBoster = SKSpriteNode(imageNamed: self.typeBoss!.rawValue + "_Projectile_Hand")
            default:
                self.handBallBoster =  SKSpriteNode(imageNamed: "Bubbles")
        }
    }
    
    // MARK: ANIMATION MONSTERS TYPE
    private func setAnimation(){
        
        switch typeBoss {
        case .Monster_King,.Mildred,.Ice_Queen,.Spike:
            self.run(.repeatForever(.sequence([
                SKAction.move(to: CGPoint(x: 100, y: screenSize.maxY - self.frame.height), duration: 3),
                SKAction.move(to: CGPoint(x: screenSize.maxX - (self.frame.width/2), y: screenSize.maxY - self.frame.height), duration: 3),
                SKAction.move(to: CGPoint(x: screenSize.midX, y: screenSize.midY), duration: 3)
            ])))
            
        default: break
            
            func randomPoint() -> CGPoint {
                
                let screenRect = UIScreen.main.bounds

                let xPos = arc4random() % UInt32(screenRect.size.width)
                let yPos = arc4random() % UInt32(screenRect.size.height)

                return CGPoint(x: CGFloat(xPos), y: CGFloat(yPos))
            }

            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: screenSize.maxY))
            for _ in 0...20 {
                
                path.addCurve(to: randomPoint(), controlPoint1: randomPoint(), controlPoint2: randomPoint())
            }
            
            self.run(.repeatForever(.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 200)))
        }
    }
    
    // MARK: GET EMITTER TYPEBOSS
    private func getEmitter(nodePosition:SKNode?) -> SKEmitterNode {
        
        switch typeBoss {
            case .Ice_Queen:
                emitter =  SKEmitterNode.getBallHandIceQueen
            case .Monster_King:
                emitter =  SKEmitterNode().addBallMosterKing(node: nodePosition! as! SKSpriteNode)
            case .Spike:
                emitter =  SKEmitterNode(fileNamed: "SpikeArm")!
            
            default: break
        }
        emitter?.run(.sequence([.wait(forDuration: 3),.removeFromParent()]))
        return emitter!
    }
    
    // MARK: SEQUENCE LEAF ARM MILFRED
    private func addPhysicsBall(node:[SKSpriteNode],gravity:Bool = true,velocity:CGVector? = nil) {
       
        for x in 0..<node.count {
            node[x].physicsBody = SKPhysicsBody(circleOfRadius: node[x].size.width/2)
            node[x].physicsBody!.isDynamic = true
            node[x].physicsBody!.affectedByGravity = gravity
            node[x].physicsBody!.categoryBitMask = PhysicsCategory.Enemy
            node[x].physicsBody!.contactTestBitMask = PhysicsCategory.Player
          //  node[x].physicsBody!.fieldBitMask = GravityCategory.Player
            node[x].physicsBody!.collisionBitMask = 0
            node[x].physicsBody?.allowsRotation = false
           
            if velocity != nil {
                node[x].physicsBody?.velocity = velocity!
            }
        }
    }
    
    // MARK: SEQUENCE BALL ARM MILFRED AND PATH
    private func addBallMoster(nodePosition:SKSpriteNode,path:CGPath) ->SKSpriteNode {
        
        guard let handBallBoster = handBallBoster else {
            return SKSpriteNode()
        }

        let copy = handBallBoster.copy() as! SKSpriteNode
        
         copy.blendMode = .screen
         copy.texture = handBallBoster.texture
         copy.name = "Enemy_Ball_Clone_\(UUID().uuidString)"
         copy.position.x = nodePosition.position.x - 60
         copy.position.y = nodePosition.position.y - 5
         copy.run(SKAction.repeatForever( SKAction.sequence([
            SKAction.follow(path, duration: 5),
            SKAction.wait(forDuration: 2),
            SKAction.removeFromParent()
         ])))
        return copy
    }
    
    // MARK: SEQUENCE BALL ARM SPIKE AND PATH
    private func addBallMosterSpike(nodeHand:SKSpriteNode,nodePlayer:CGPoint) ->SKSpriteNode {
        
        var path:SKSpriteNode = SKSpriteNode()
        
        guard let handBallBoster = handBallBoster else {
            return SKSpriteNode()
        }
       
            path = handBallBoster.copy() as! SKSpriteNode
            path.name = "Enemy_Ball_Clone_\(UUID().uuidString)"
            path.texture = handBallBoster.texture
            path.position = CGPoint(x: nodeHand.position.x , y: nodeHand.position.y - 50)
        
        return path
    }
    
    //MARK: ANIMATION FOR MONSTER_QUEEN JOIN PART
    private func MonsterQueenParts()->SKNode {
        let node = SKNode()
        node.name = "Node"
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Head")
            node.addChild(head)
       
        let body = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Body")
            body.zPosition = -1
        body.position.y = head.position.y - head.frame.height/1.5
            node.addChild(body)

        
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Wing")
            wingsL.anchorPoint = CGPoint(x: 1, y: 0.5)
            wingsL.name = typeBoss!.rawValue + "_WingL"
        wingsL.position = CGPoint(x: -head.frame.width * 0.25, y: head.frame.height*0.4)
            wingsL.zPosition = -1
            wingsL.run(.moveWings)
            node.addChild(wingsL)
        
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.xScale = -1
        wingsR.position = CGPoint(x: head.frame.width*0.25, y: head.frame.height*0.4)
            wingsR.zPosition = -1
            node.addChild(wingsR)
      
        
        return node
    }
    
    
 
    // MARK: ANIMATION FOR MONSTER_KING JOIN PART
    private func SpikeParts() ->SKNode {
        
        let node = SKNode()
        node.name = "Node"
        
        
        let body = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Body")
        body.run(.repeatForever(.animate(with: SKTextureAtlas().loadAtlas(name: typeBoss!.rawValue + "_Body_Animation", prefix: nil), timePerFrame: 0.5)))
            node.addChild(body)
        
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Wing")
            wingsL.name = typeBoss!.rawValue + "_WingL"
            wingsL.position = CGPoint(x: -20, y: body.frame.height/2)
            wingsL.zPosition = -1
            wingsL.run(.moveWings)
            node.addChild(wingsL)
       
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.xScale = -1
            wingsR.position = CGPoint(x: 20, y: body.frame.height/2)
            wingsR.zPosition = -1
            wingsL.run(.moveWings)
            node.addChild(wingsR)
        
        
        let armR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Arm")
        armR.anchorPoint = CGPoint(x: 0, y: 1)
            armR.xScale = -1
            armR.zPosition = -1
            armR.name = typeBoss!.rawValue + "_ArmR"
            armR.position = CGPoint(x: -40, y: 50)
            node.addChild(armR)

       
        let armL = armR.copy() as! SKSpriteNode
            armL.xScale = 1
            armL.position = CGPoint(x: 40, y: 50)
            armL.name = typeBoss!.rawValue + "_ArmL"
            node.addChild(armL)

        
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Head")
            head.position = CGPoint(x: 0, y: head.frame.height/2.2)
            node.addChild(head)
        
        
        let actionRotateArm = { (node:SKSpriteNode) -> (SKAction) in
            
            let isArmR =  node.name?.contains("_ArmR")
            let count:CGFloat = 6
            var index:CGFloat = 0.0
            var dx:CGFloat = 0.0
            var dy:CGFloat = 0.0
            
            let action =
            SKAction.sequence([
                .rotate(toAngle: CGFloat(isArmR! ? -Int.random(in: 45...90) : Int.random(in: 45...90)).toRadians(), duration: 0.05, shortestUnitArc: true),
                .wait(forDuration: 1),
                .rotate(toAngle: isArmR! ? -CGFloat.random(in: 0...30).toRadians() : CGFloat.random(in: 0...30).toRadians(), duration: 0.05, shortestUnitArc: true),
                .run {
                    head.run(.animate(with: SKTextureAtlas().loadAtlas(name: self.typeBoss!.rawValue + "_Head_Animation", prefix: nil), timePerFrame: 0.3))

                    node.run(SKAction.repeat(.sequence([
                        .run {
                            let copy = self.handBallBoster?.copy() as! SKSpriteNode
                            copy.name = "Enemy_\(UUID().uuidString)"
                            copy.setScale(0.5)
                            let emitter = self.getEmitter(nodePosition: copy)
                            emitter.targetNode = copy
                            
                            copy.addChild(emitter)
                            dx = screenSize.midX/count * index
                            dy =  screenSize.height/2
                            index += 1
                            self.addPhysicsBall(node: [copy],gravity: false,velocity: isArmR! ?  CGVector(dx: dx, dy: -dy) : CGVector(dx: dx, dy: -dy))
                            node.addChild(copy)
                        },
                        .wait(forDuration: 0.05)
                    ]), count: Int(count)))
                    
                },
                GameInfo().mainAudio.getAction(type: .Boss_Tree_Attack),
                .wait(forDuration: 2)
                
            ])
            
            return action
        }
        
        
       
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { time in
            switch Int.random(in: 0..<3) {
                case 0:
                    armR.run(actionRotateArm(armR))
                case 1:
                    armL.run(actionRotateArm(armL))
                default  :
                    armR.run(actionRotateArm(armR))
                    armL.run(actionRotateArm(armL))
            }
        }
        return node
    }
    
    // MARK: ANIMATION FOR MONSTER_KING JOIN PART
    private func MonsterKingParts() ->SKNode {
        
       
       /* let pathToFollow = UIBezierPath()
        pathToFollow.move(to: .zero)
        pathToFollow.addArc(withCenter: CGPoint(x: 300, y: 0), radius: 300, startAngle: .pi  , endAngle: .pi/180, clockwise: true)*/
      
        let node = SKNode()
        node.name = "Node"
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Head")
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Wing")
            wingsL.name = typeBoss!.rawValue + "_WingL"
            wingsL.position = CGPoint(x: -head.frame.width/2, y: 0)
            wingsL.zPosition = -1
            wingsL.run(.moveWings)
            head.addChild(wingsL)

       
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.xScale = -1
            wingsR.position = CGPoint(x: head.frame.width/2, y: 0)
            wingsR.zPosition = -1
            head.addChild(wingsR)
            wingsR.run(.moveWings)
        
       

        let mouth = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Mouth")
            mouth.name = typeBoss!.rawValue + "_Mouth"
            mouth.alpha = 0
            head.addChild(mouth)
        
        let breathR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Breath")
            breathR.name = typeBoss!.rawValue + "_BreathR"
            breathR.alpha = 0
            breathR.position.x = -10
            breathR.run(.sequence([.fadeIn(withDuration: 0.3),.moveBy(x: 0, y: -50, duration: 0.5),.removeFromParent()]))
       
        
        let lance = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Lance")
            lance.name = typeBoss!.rawValue + "_Lance"
            lance.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            lance.position = CGPoint(x: -head.frame.width/2, y: 0)
            lance.zPosition = -1
            head.addChild(lance)

   
        let actionLance = SKAction.run {
                lance.run(SKAction.sequence([
                    .wait(forDuration: 5),
                    .run {
                        let copy =  SKEmitterNode().addBallMosterKing(node: lance).copy() as! SKEmitterNode
                //        self.addPhysicsBall(node: [copy])
                        copy.position = CGPoint(x: lance.position.x+25, y: lance.frame.height/2-20)
                        copy.targetNode = lance
                        copy.run(.sequence([
                            .wait(forDuration: 0.1),
                            .move(by: CGVector(dx: GameInfo.currentPlayerPosition.x, dy: -screenSize.height), duration: 0.8),
                            .wait(forDuration: 10),
                             .removeFromParent()]))
                       
                        lance.addChild(copy)
                    }]))}
            
        
        
        lance.run(.repeatForever(.group([
                actionLance,
                .run {
                    let copy =  self.mainBallBoster?.copy() as! SKSpriteNode
                    copy.position = .zero
                    mouth.alpha = 1
                    copy.name = "Enemy_\(UUID().uuidString)"
                    self.addPhysicsBall(node: [copy])
                    copy.run(.repeat(.sequence([
                        .move(by: CGVector(dx: CGFloat.random(in: -screenSize.width/2...screenSize.width/2) ,
                                           dy: -800), duration: 2),
                        .wait(forDuration: 0.1),
                        .fadeOut(withDuration: 0.5),
                        .removeFromParent(),
                    ]),count: 3))
                            
                            let breath = breathR.copy() as! SKSpriteNode
                            let breathL = breath.copy() as! SKSpriteNode
                                breathL.xScale  = -1
                                breathL.position.x = breath.position.x + 20
                                mouth.addChild(breath)
                                mouth.addChild(breathL)
                                mouth.addChild(copy)
                    },
                GameInfo().mainAudio.getAction(type: .Boss_King_Burp),
               
        ])))
      
       
        node.addChild(head)
        return node
    }
    
    // MARK: ANIMATION FOR MILDRED JOIN PARTS
    private func MildredParts()->SKNode {
        
        guard let handBallBoster = handBallBoster else {

            return SKNode()
        }
        
        let spritNodeLeaf = SKSpriteNode(imageNamed: "leaf")


        // MARK: SEQUENCE BALL ARM MILFRED
        func addBallMoster(nodePosition:SKSpriteNode) ->SKSpriteNode {
            
             let copy = handBallBoster.copy() as! SKSpriteNode
             let valueRotation:Bool = nodePosition.name?.contains("_ArmL") ?? false
            
             copy.blendMode = .screen
             copy.texture = SKTexture(imageNamed: "ballMildred")
             copy.name = "Enemy_Ball_Clone_\(UUID().uuidString)"
             copy.position = nodePosition.position
             copy.run(SKAction.repeatForever( SKAction.sequence([
                SKAction.follow(pathToFollow(valueRotation), duration: 1),
                SKAction.wait(forDuration: 2),
                SKAction.removeFromParent()
             ])))
            return copy
        }
        
        // MARK: SEQUENCE LEAF ARM MILFRED
        func addLeafMoster() ->SKSpriteNode {
            
            let emiterLeaf = spritNodeLeaf.copy() as! SKSpriteNode
                emiterLeaf.position.y = -self.frame.height/2
                emiterLeaf.run(SKAction.repeatForever( SKAction.sequence([
                    .rotate(byAngle: CGFloat.random(in: -100...100) > 0 ? .pi : .pi/3, duration: 0.1),
                    SKAction.move(by: CGVector(dx: -Int.random(in: -300...300), dy: -Int.random(in: 50...500)), duration: 1),
                         SKAction.removeFromParent()
                 ])))
            return emiterLeaf
        }
        
        let node = SKNode()
            node.name = "Node"
            node.run(.upDown(10,1))
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Body")
            head.name = typeBoss!.rawValue + "_Body"
            head.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let pathToFollow   = { (node:Bool) -> (CGPath) in
            
            let path = UIBezierPath(arcCenter: .zero,
                                    radius: 50,
                                    startAngle: .pi ,
                                    endAngle: .pi*2,
                                    clockwise: node)
            
            let transform = CGAffineTransform(scaleX: 1.1, y: 2)
            path.apply(transform)
            return path.cgPath
        }
        
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Wing")
            wingsL.anchorPoint = CGPoint(x: 1, y: 0.5)
            wingsL.name = typeBoss!.rawValue + "_WingL"
            wingsL.position = CGPoint(x: -head.frame.width/3, y: 0)
            wingsL.zPosition = -1
       
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            wingsR.xScale = -1
            wingsR.position = CGPoint(x: head.frame.width/3, y: 0)
            wingsR.zPosition = -1
        
        let legL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Leg")
            legL.name = typeBoss!.rawValue + "_LegL"
            legL.position = CGPoint(x: 10, y: -head.frame.height/2)
            legL.zPosition = 1
       
        let legR = legL.copy() as! SKSpriteNode
            legR.name = typeBoss!.rawValue + "_LegR"
            legR.xScale = -1
            legR.position = CGPoint(x: -30, y: -head.frame.height/2)
            legR.zPosition = 1
        
        let armR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Arm_R")
            armR.anchorPoint = CGPoint(x: 0, y: 1)
            armR.name = typeBoss!.rawValue + "_ArmR"
            armR.position = CGPoint(x: 25, y: -50)
            armR.zPosition = 1
       
        let armL = armR.copy() as! SKSpriteNode
            armL.name = typeBoss!.rawValue + "_ArmL"
            armL.xScale = -1
            armL.position = CGPoint(x: -50, y: -50)
            armL.zPosition = 1
        
        let handR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Hand_R")
            handR.anchorPoint = CGPoint(x: 1, y: 1)
            handR.name = typeBoss!.rawValue + "_HandR"
            handR.position = CGPoint(x: -60, y: -10)
            handR.zPosition = -1
            
       
        let handL = handR.copy() as! SKSpriteNode
            handL.name = typeBoss!.rawValue + "_HandL"
            handL.xScale = -1
            handL.zPosition = -1
            handL.position = CGPoint(x: 30, y: 0)
           
        
        wingsL.run(.moveWings)
        wingsR.run(.moveWings)
        
        
        let actionRotateArm = { (node:SKSpriteNode) -> (SKAction) in
            
            let action =
            SKAction.repeatForever(.sequence([
                .rotate(toAngle: (node.name?.contains("_ArmL"))! ? -.pi/2 : .pi/2, duration: 0.5),
                .run {
                    handR.run(
                    SKAction.repeatForever(.sequence([
                        .rotate(toAngle:  0, duration: 0.75),
                        .wait(forDuration: 2.5),
                        .rotate(toAngle:  .pi/2, duration: 0.5),
                        ])))
                   
                    handL.run(
                    SKAction.repeatForever(.sequence([
                        .rotate(toAngle:  0, duration: 0.75),
                        .wait(forDuration: 2.5),
                        .rotate(toAngle:  -.pi/2, duration: 0.5),
                        ])))
                },
                .wait(forDuration: 1),
                .rotate(toAngle: (node.name?.contains("_ArmL"))! ? Double.pi/2 : -.pi/2, duration: 0.01),
                
                .run {
                    
                    let fx =  SKSpriteNode(imageNamed: node.name! + "_FX")
                    fx.position = CGPoint(x: (node.name?.contains("ArmL"))! ? -75 : 100, y: -head.frame.height/2)
                    fx.run(.sequence([
                        GameInfo().mainAudio.getAction(type: .Boss_Tree_Attack),
                        .fadeOut(withDuration: 1),
                        .removeFromParent()
                    ]))
                    head.addChild(fx)
                    
                    armL.run(SKAction.repeat(SKAction.sequence([
                        .run {
                            
                            let copy = addBallMoster(nodePosition: node)
                            let emitterLeaf = addLeafMoster()
                            self.addPhysicsBall(node: [copy])
                            armR.addChild(copy)
                            head.addChild(emitterLeaf)
                        },.wait(forDuration: 0.1)]),count: 5))
            },
            .wait(forDuration: 3)]))
            return action
        }
       
        armR.run(actionRotateArm(armR))
        armL.run((actionRotateArm(armL)))
       
        
        head.addChild(wingsL)
        head.addChild(wingsR)
        head.addChild(legL)
        head.addChild(legR)
        head.addChild(armL)
        head.addChild(armR)
        head.addChild(handL)
        head.addChild(handR)
        node.addChild(head)
        return node
    }
    
    // MARK: ANIMATION FOR ICE_QUEEN JOIN PARTS
    private func IceQueenParts()->SKNode {
       
        func line()->SKSpriteNode {
            
            let lineaction = SKAction.sequence([
                .wait(forDuration: 2),
                .sequence([
                    .scale(to: 1, duration: 1),
                    .repeat(.sequence([
                        .scaleY(to: 0.5, duration: 0.5),
                        .scaleY(to: 1, duration: 0.5),
                    ]), count: 3),
                    .wait(forDuration: 2),
                    .setTexture(SKTexture(imageNamed: "Ice_Queen_Projectile")),
                    GameInfo().mainAudio.getAction(type: .Boss_Tree_Attack),
                    .move(by: CGVector(dx: CGFloat.random(in: -200...200), dy: -screenSize.height), duration: 2),
                    .removeFromParent()
                ]),
                .wait(forDuration: 3)
                ])
            
            let line = SKSpriteNode(imageNamed: "Sprite_Projectile")
                line.name = "Enemy_Ball_Ice_Queen"
                line.blendMode = .add
                line.position.y = -10
                line.setScale(0.75)
                line.zPosition = +1
                line.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                line.run(lineaction)
                return line
            }

        
      
        let node = SKNode()
        node.name = "Node"
        
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Head")
        let wing = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Wing")
            wing.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Wing"
            wing.position = CGPoint(x: 0, y: 20)
            wing.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            wing.zPosition = -1
            wing.run(.moveWings)
      
        
        let body = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Body")
            body.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Body"
            body.position = CGPoint(x: head.position.x, y: -head.frame.height/2)
            body.zPosition = -1
        
        
        let limitLookAt = SKConstraint.zRotation(SKRange(lowerLimit:   -3 * .pi / 4,
                                                         upperLimit:   2 * .pi / 3))
        
        let armR = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Arm")
            armR.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_ArmR"
            armR.position = CGPoint(x: -10, y: -25)
            armR.zPosition = -2
            armR.anchorPoint = CGPoint(x: 1, y: 1)
            armR.constraints = [limitLookAt]
        
        let hand = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Hand")
            hand.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_HandR"
            hand.position.y = -armR.frame.height+10
            hand.position.x = -armR.frame.width
            armR.addChild(hand)
    
        
        let armL = armR.copy() as! SKSpriteNode
            armL.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_ArmL"
            armL.xScale = -1
            armL.constraints = [limitLookAt]
        
        let skrit = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt")
            skrit.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt"
            skrit.position = CGPoint(x: 0, y: -body.frame.height-35)
            skrit.zPosition = +1

        let actionRotateArm = { (node:SKSpriteNode) -> (SKAction) in
            
            let isArmR =  node.name?.contains("_ArmR")
            
            let action =
            SKAction.sequence([
                
                .run {
                    let nodeBallHand = SKNode()
                     nodeBallHand.name = "nodeBall"
                     nodeBallHand.name = self.typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_ballHandR"
                     nodeBallHand.position =  CGPoint(x: hand.position.x ,y: hand.position.y-15)
                     nodeBallHand.zPosition = -2
                     nodeBallHand.addChild(self.getEmitter(nodePosition: hand).copy() as! SKEmitterNode)
                     node.addChild(nodeBallHand)
                },
                .rotate(toAngle: CGFloat(isArmR! ? -45 : 45).toRadians(), duration: 0.5, shortestUnitArc: true),
                .rotate(toAngle: CGFloat(isArmR! ? 10 : -10).toRadians(), duration: 0.1, shortestUnitArc: false),
                .run {
              
                    node.run(SKAction.repeat(SKAction.sequence([
                    .run {
                        
                                                           
                        let copy = self.addBallMoster(nodePosition: node,
                                                      path: UIBezierPath.pathMoster(CGPoint(x: screenSize.height*2, y: 0), screenSize.height*2, .pi,
                                                        .pi / 180, true))
                        self.addPhysicsBall(node: [copy])
                        node.addChild(copy)
                    },
                    .wait(forDuration: 0.1)]),count: 4))
                  },
                GameInfo().mainAudio.getAction(type: .Boss_Tree_Attack),
                .wait(forDuration: 2)
                ])
            
            return action
        }
       
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { time in
            switch Int.random(in: 0..<3) {
                case 0:
                    armR.run(actionRotateArm(armR))
                case 1:
                    armL.run(actionRotateArm(armL))
                default  :
                    armR.run(actionRotateArm(armR))
                    armL.run(actionRotateArm(armL))
                    skrit.addChild(line())
            }
        }
        
        node.addChild(head)
        node.addChild(wing)
        node.addChild(body)
        node.addChild(armR)
        node.addChild(armL)
        node.addChild(skrit)

        
        return node
    }
    

}


extension CGFloat {
    
    func toRadians() -> CGFloat {
        return self * .pi / 180
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}


extension UIBezierPath {
    
    // MARK: PATH THAT THE BALL FOLLOWS IN THE HAND OF ALL THE MONSTERS
    static var pathMoster = { (withCenter: CGPoint, radius: CGFloat, startAngle: CGFloat  , endAngle:  CGFloat, clockwise: Bool) -> (CGPath) in
       
     
        let path = UIBezierPath()
      
        
        let center = CGPoint(x: withCenter.x +  radius ,y: withCenter.y + radius)
        
        path.move(to: center)
        
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: clockwise)
        return path.cgPath
    }
    
    
}
